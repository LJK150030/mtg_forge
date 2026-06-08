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

# Keep console output UTF-8 too (helps Write-Host); the real capture below does
# NOT depend on this — see Invoke-ClaudeJson.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Single-instance lock. Two concurrent runs race on the same notes: the read /
# check-heading / write is not atomic, so both insert and you get DOUBLE
# "## Design Description" sections. A named mutex makes a second run bow out.
$mutex = New-Object System.Threading.Mutex($false, "Global\ForgeUmlAnnotate")
$haveLock = $false
try { $haveLock = $mutex.WaitOne(0) }
catch [System.Threading.AbandonedMutexException] { $haveLock = $true }  # prior run died; we inherit
if (-not $haveLock) {
  Write-Host "Another instance of this annotator is already running. Exiting to avoid races." -ForegroundColor Yellow
  exit 3
}

if (-not (Test-Path -LiteralPath $VaultPath -PathType Container)) {
  Write-Error "Vault folder not found: $VaultPath"; exit 1
}
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Error "The 'claude' CLI is not on your PATH. Install Claude Code first."; exit 1
}
$ClaudeExe = (Get-Command claude).Source

$vault = (Resolve-Path -LiteralPath $VaultPath).Path
$log   = Join-Path $vault "design-descriptions.log"

# --- deterministic "already done?" guards -------------------------------------
# Line-ending-agnostic heading test. The old (?m)^...[ \t]*$ regex did NOT match a
# heading on a CRLF file: [ \t] excludes the trailing \r, so re-runs failed to see
# an existing "## Design Description" and appended a DUPLICATE. Splitting on \r?\n
# and trimming is immune to CRLF/LF and stray whitespace.
function Test-HasHeading {
  param([string]$Text, [string]$Heading)
  foreach ($line in ($Text -split '\r?\n')) {
    if ($line.Trim() -eq $Heading) { return $true }
  }
  return $false
}

# Second guard (belt and suspenders): every file already recorded OK in the log is
# skipped even if its heading somehow isn't detected. The HashSet dedupes the log.
$processed = New-Object 'System.Collections.Generic.HashSet[string]'
if (Test-Path -LiteralPath $log) {
  foreach ($line in (Get-Content -LiteralPath $log -ErrorAction SilentlyContinue)) {
    if ($line -match '\bOK\s+(\S+\.md)\s*$') { [void]$processed.Add($Matches[1]) }
  }
}

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

# Run headless claude and capture stdout/stderr as guaranteed UTF-8.
# Using the .NET process API with StandardOutputEncoding = UTF8 is reliable even
# in a detached/background process with no console attached -- unlike piping
# through PowerShell, which decodes native output via [Console]::OutputEncoding
# and silently mangles em-dashes / curly quotes when that isn't honored.
function Invoke-ClaudeJson {
  param([string]$PromptText, [string]$ModelId, [string]$StdinText)

  # Windows arg-escaping for the (multi-line) prompt: backslashes first, then quotes.
  $esc = ($PromptText -replace '\\', '\\') -replace '"', '\"'

  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName               = $ClaudeExe
  $psi.Arguments              = '-p "' + $esc + '" --model "' + $ModelId + '" --allowedTools "Read" --output-format json'
  $psi.UseShellExecute        = $false
  $psi.CreateNoWindow         = $true
  $psi.RedirectStandardInput  = $true
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError  = $true
  $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
  $psi.StandardErrorEncoding  = [System.Text.Encoding]::UTF8

  $proc = [System.Diagnostics.Process]::Start($psi)
  # Feed the note to stdin as real UTF-8 bytes (don't rely on console input encoding).
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($StdinText)
  $proc.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
  $proc.StandardInput.BaseStream.Flush()
  $proc.StandardInput.Close()
  # Read both streams async to avoid a pipe-buffer deadlock on large output.
  $outTask = $proc.StandardOutput.ReadToEndAsync()
  $errTask = $proc.StandardError.ReadToEndAsync()
  $proc.WaitForExit()
  return [pscustomobject]@{ Out = $outTask.Result; Err = $errTask.Result; Code = $proc.ExitCode }
}

# Messages Claude Code emits when a usage / rate / credit limit is hit.
$limitRe = '(?i)hit your (session|weekly|opus|usage) limit|rate.?limit|\(429\)|credit balance is too low|usage limit'

# Preflight: confirm headless claude works (auth + flags + model) before looping
# over ~1,300 files. Fails fast with the real reason instead of erroring on every note.
$pf = Invoke-ClaudeJson -PromptText "Reply with exactly: OK" -ModelId $Model -StdinText "ping"
$pfOut = $pf.Out
$pfCode = $pf.Code
$pfE = $pf.Err
if ($pfCode -ne 0) {
  $pfDiag = ((([string]$pfE) + " " + ([string]$pfOut)) -replace '\s+', ' ').Trim()
  Write-Host ""
  Write-Host ("Preflight failed: 'claude -p' exited {0} and can't run headless yet." -f $pfCode) -ForegroundColor Red
  Write-Host ("Details: {0}" -f $pfDiag)
  Write-Host ""
  Write-Host "Common fixes:"
  Write-Host "  - Sign in: run 'claude' once interactively, finish the browser login, then retry."
  Write-Host "  - Model:   if it says the model is invalid/unknown, re-run with  -Model opus"
  Write-Host "  - Flags:   run 'claude --help'; tell me which of --bare/--allowedTools/--output-format differ."
  exit 1
}
Write-Host "Preflight OK - claude headless is working. Starting..." -ForegroundColor Green

$files = Get-ChildItem -LiteralPath $vault -Filter *.md -File | Sort-Object Name
$total = $files.Count
$idx = 0; $doneN = 0; $skipN = 0; $errN = 0

foreach ($f in $files) {
  $idx++
  $content = Get-Content -LiteralPath $f.FullName -Raw

  # Skip if the log already recorded this file, or it already has the section.
  if ($processed.Contains($f.Name)) { $skipN++; continue }
  if (Test-HasHeading -Text $content -Heading '## Design Description') { $skipN++; continue }
  if (-not (Test-HasHeading -Text $content -Heading '## Source')) {
    Write-Host ("[{0}/{1}] skip (no ## Source): {2}" -f $idx, $total, $f.Name); continue
  }

  $call = Invoke-ClaudeJson -PromptText $prompt -ModelId $Model -StdinText $content
  $raw  = $call.Out
  $code = $call.Code
  $err  = $call.Err

  $rawText = [string]$raw
  $errText = [string]$err

  $parsed = $null
  if ($rawText.Trim()) { try { $parsed = $rawText | ConvertFrom-Json } catch { } }
  $isErr = ($code -ne 0) -or ($parsed -and $parsed.is_error)

  if ($isErr) {
    $diag = (($errText + "`n" + $rawText) -replace '\s+', ' ').Trim()
    if ($diag -match $limitRe) {
      Write-Host ""
      Write-Host ("Reached your usage limit at: {0}" -f $f.Name) -ForegroundColor Yellow
      Write-Host "Stopped cleanly. Re-run the exact same command later to resume from here."
      Add-Content -LiteralPath $log -Value ("{0}  STOP(limit)  {1}" -f (Get-Date -Format o), $f.Name)
      exit 2
    }
    if ($diag.Length -gt 300) { $diag = $diag.Substring(0, 300) }
    Write-Warning ("[{0}/{1}] error (exit {2}) on {3}: {4}" -f $idx, $total, $code, $f.Name, $diag)
    Add-Content -LiteralPath $log -Value ("{0}  ERROR  {1}  {2}" -f (Get-Date -Format o), $f.Name, $diag)
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
  $m = [regex]::Match($content, '(?m)^[ \t]*##[ \t]+Source[ \t]*\r?$')   # \r? handles CRLF
  if (-not $m.Success) {
    Write-Warning ("[{0}/{1}] no ## Source anchor: {2}" -f $idx, $total, $f.Name); $errN++; continue
  }
  $new = $content.Substring(0, $m.Index) + $section + $content.Substring($m.Index)

  [System.IO.File]::WriteAllText($f.FullName, $new, (New-Object System.Text.UTF8Encoding($false)))
  $doneN++
  Write-Host ("[{0}/{1}] done: {2}" -f $idx, $total, $f.Name) -ForegroundColor Green
  Add-Content -LiteralPath $log -Value ("{0}  OK     {1}" -f (Get-Date -Format o), $f.Name)
  [void]$processed.Add($f.Name)   # never reprocess within this run

  if ($Max -gt 0 -and $doneN -ge $Max) {
    Write-Host ("Reached -Max {0} for this run. Re-run to continue." -f $Max); break
  }
}

Write-Host ""
Write-Host ("Summary: {0} written, {1} already-done, {2} errors, of {3} notes." -f $doneN, $skipN, $errN, $total)
