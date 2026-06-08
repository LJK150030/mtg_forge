<#
.SYNOPSIS
  Annotate an Obsidian UML vault with AI-written Software Design Descriptions,
  using Claude Code in headless mode (Opus 4.8) — one note per call.

.DESCRIPTION
  For every <type>.md note produced by tools/uml-export, this pipes the note
  (its UML diagram, Relationships, and embedded Java source) to `claude -p`,
  which returns a short Software Design Description. The script inserts it as a
  new "## Design Description" section immediately BEFORE "## Source" (i.e.
  between Relationships and Source).

  Resumable & idempotent:
    * A note that already has a "## Design Description" heading is skipped, so
      you can stop and re-run freely — it resumes where it left off.
    * If you hit your Claude usage limit, the loop stops cleanly (exit code 2)
      and names the note it stopped on. Re-run the same command to resume.

.EXAMPLE
  pwsh tools/uml-annotate/add-design-descriptions.ps1 -VaultPath "G:\My Files\School\sprint 2026\obsidian_valuts\mtg_forge_conversion"

.EXAMPLE
  # Sample 20 notes first to check quality:
  pwsh tools/uml-annotate/add-design-descriptions.ps1 -VaultPath "G:\...\mtg_forge_conversion" -Max 20
#>
param(
  [Parameter(Mandatory = $true)][string]$VaultPath,
  [string]$Model = "claude-opus-4-8",
  [int]$Max = 0   # 0 = process all; e.g. 20 to sample
)

if (-not (Test-Path -LiteralPath $VaultPath -PathType Container)) {
  Write-Error "Vault folder not found: $VaultPath"; exit 1
}
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Error "The 'claude' CLI is not on your PATH. Install Claude Code first."; exit 1
}

$vault = (Resolve-Path -LiteralPath $VaultPath).Path
$log   = Join-Path $vault "design-descriptions.log"

$prompt = @'
You are writing a Software Design Description for a Java class in the Forge MTG engine.
The input (stdin) is an Obsidian note documenting one class: a Mermaid UML class diagram,
a Relationships section of [[wiki-links]], and the class's raw Java source.

Using the UML, the relationships, and the source, write a concise Software Design Description
(1-2 short paragraphs, ~60-150 words) covering: the class's purpose and responsibility; its role
relative to its supertype/interfaces and the types it collaborates with; and any notable design
intent visible in the code.

Output ONLY the description prose: no heading, no preamble such as "Here is", no bullet list,
no code fences.
'@

# Messages Claude Code emits when a usage / rate / credit limit is hit.
$limitRe = '(?i)hit your (session|weekly|opus|usage) limit|rate.?limit|\(429\)|credit balance is too low|usage limit'

$files = Get-ChildItem -LiteralPath $vault -Filter *.md -File | Sort-Object Name
$total = $files.Count
$idx = 0; $doneN = 0; $skipN = 0; $errN = 0

foreach ($f in $files) {
  $idx++
  $content = Get-Content -LiteralPath $f.FullName -Raw

  if ($content -match '(?m)^##[ \t]+Design Description[ \t]*$') { $skipN++; continue }
  if ($content -notmatch '(?m)^##[ \t]+Source[ \t]*$') {
    Write-Host ("[{0}/{1}] skip (no ## Source): {2}" -f $idx, $total, $f.Name); continue
  }

  $errPath = [System.IO.Path]::GetTempFileName()
  $raw  = ($content | & claude --bare -p $prompt --model $Model --allowedTools "Read" --output-format json 2> $errPath | Out-String)
  $code = $LASTEXITCODE
  $err  = (Get-Content -LiteralPath $errPath -Raw -ErrorAction SilentlyContinue)
  Remove-Item -LiteralPath $errPath -ErrorAction SilentlyContinue

  $parsed = $null
  if ($raw.Trim()) { try { $parsed = $raw | ConvertFrom-Json } catch { } }
  $isErr = ($code -ne 0) -or ($parsed -and $parsed.is_error)

  if ($isErr) {
    if (("$raw`n$err") -match $limitRe) {
      Write-Host ""
      Write-Host ("Reached your usage limit at: {0}" -f $f.Name) -ForegroundColor Yellow
      Write-Host "Stopped cleanly. Re-run the exact same command later to resume from here."
      Add-Content -LiteralPath $log -Value ("{0}  STOP(limit)  {1}" -f (Get-Date -Format o), $f.Name)
      exit 2
    }
    $oneLineErr = ($err -replace '\s+', ' ').Trim()
    Write-Warning ("[{0}/{1}] error (exit {2}) on {3}: {4}" -f $idx, $total, $code, $f.Name, $oneLineErr)
    Add-Content -LiteralPath $log -Value ("{0}  ERROR  {1}  {2}" -f (Get-Date -Format o), $f.Name, $oneLineErr)
    $errN++; continue
  }

  $desc = ""
  if ($parsed -and $parsed.result) { $desc = [string]$parsed.result }
  $desc = $desc.Trim()
  $desc = [regex]::Replace($desc, '^\s*```[a-zA-Z0-9]*\s*\r?\n', '')   # strip leading fence
  $desc = [regex]::Replace($desc, '\r?\n```\s*$', '')                   # strip trailing fence
  $desc = $desc.Trim()
  if (-not $desc) {
    Write-Warning ("[{0}/{1}] empty result: {2}" -f $idx, $total, $f.Name); $errN++; continue
  }

  # Insert "## Design Description" + prose immediately before the first "## Source".
  $nl = if ($content -match "`r`n") { "`r`n" } else { "`n" }
  $section = "## Design Description$nl$nl$desc$nl$nl"
  $m = [regex]::Match($content, '(?m)^##[ \t]+Source[ \t]*$')
  $new = $content.Substring(0, $m.Index) + $section + $content.Substring($m.Index)

  [System.IO.File]::WriteAllText($f.FullName, $new, (New-Object System.Text.UTF8Encoding($false)))
  $doneN++
  Write-Host ("[{0}/{1}] done: {2}" -f $idx, $total, $f.Name) -ForegroundColor Green
  Add-Content -LiteralPath $log -Value ("{0}  OK     {1}" -f (Get-Date -Format o), $f.Name)

  if ($Max -gt 0 -and $doneN -ge $Max) {
    Write-Host ("Reached -Max {0} for this run. Re-run to continue." -f $Max); break
  }
}

Write-Host ""
Write-Host ("Summary: {0} written, {1} already-done, {2} errors, of {3} notes." -f $doneN, $skipN, $errN, $total)
