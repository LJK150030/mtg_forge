<#
.SYNOPSIS
  Add a "## Python" section (a Python reengineering of the Java class) AFTER the
  "## Source" section of every note, using Claude Code headless mode (Opus 4.8).

.DESCRIPTION
  Run this AFTER add-design-descriptions.ps1. Each note (UML + Relationships +
  Design Description + Java source) is piped to `claude -p`, which returns a
  faithful Python port; the script appends it as a "## Python" section.

  Consistency across files is enforced by a deterministic naming rule in the
  prompt: class/method/param names stay identical to Java, and every type
  forge.x.y.Name becomes `from forge.x.y.Name import Name`. So a dependency
  imported in one note matches the class another note defines — even though
  files are processed one at a time.

  Resumable & idempotent: a note that already has a "## Python" heading is
  skipped; a usage limit stops the loop cleanly (exit 2); transient per-file
  errors are logged and skipped. Progress -> python-port.log in the vault.

.EXAMPLE
  pwsh tools/uml-annotate/add-python-port.ps1 -VaultPath "G:\...\mtg_forge_conversion" -Max 20

.EXAMPLE
  pwsh tools/uml-annotate/add-python-port.ps1 -VaultPath "G:\...\mtg_forge_conversion"
#>
param(
  [Parameter(Mandatory = $true)][string]$VaultPath,
  [string]$Model = "claude-opus-4-8",
  [int]$Max = 0
)

if (-not (Test-Path -LiteralPath $VaultPath -PathType Container)) {
  Write-Error "Vault folder not found: $VaultPath"; exit 1
}
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Error "The 'claude' CLI is not on your PATH. Install Claude Code first."; exit 1
}

$vault = (Resolve-Path -LiteralPath $VaultPath).Path
$log   = Join-Path $vault "python-port.log"

# --- deterministic "already done?" guards (line-ending-agnostic; see design script) ---
function Test-HasHeading {
  param([string]$Text, [string]$Heading)
  foreach ($line in ($Text -split '\r?\n')) {
    if ($line.Trim() -eq $Heading) { return $true }
  }
  return $false
}
$processed = New-Object 'System.Collections.Generic.HashSet[string]'
if (Test-Path -LiteralPath $log) {
  foreach ($line in (Get-Content -LiteralPath $log -ErrorAction SilentlyContinue)) {
    if ($line -match '\bOK\s+(\S+\.md)\s*$') { [void]$processed.Add($Matches[1]) }
  }
}

$prompt = @'
You are reengineering ONE Java class from the Forge MTG engine into Python. The input (stdin) is
an Obsidian note: YAML frontmatter (fqn/package/module/kind), a Mermaid UML diagram, a Relationships
section of [[wiki-links]] (Extends / Implements / Uses) with fully-qualified names, a Design
Description, and the class's raw Java source.

Produce a faithful Python port. Follow these rules EXACTLY so that ports of different classes stay
mutually consistent (another note may import what this one defines):

NAMING - keep identifiers identical to the Java (do NOT rename to snake_case):
- Class name identical to the Java class. Method, parameter, and field names identical to the Java.
- This module corresponds to the note's `fqn` (e.g. forge.ai.ability.AddPhaseAi -> the Python
  module forge/ai/ability/AddPhaseAi.py defining `class AddPhaseAi`).

IMPORTS / DEPENDENCIES - make them deterministic so files agree:
- For EVERY dependency type with fully-qualified name forge.x.y.Name (taken from the Java `import`
  statements and the Relationships section), import it as exactly:
        from forge.x.y.Name import Name
  i.e. the module path is the type's FQN and the imported symbol is its simple name.
- For Java wildcard imports (e.g. `import forge.ai.*;`), do NOT use a wildcard; import the specific
  symbols actually used - their fully-qualified names are listed in the Relationships section.
- Extend the same supertype(s) shown under Extends. Do NOT stub or redefine dependency classes -
  assume their Python ports already exist at those module paths.
- Map JDK types idiomatically: String->str, boolean->bool, int->int, List<X>->list[X] (or
  typing.List[X]), Map<K,V>->dict[K,V]. If you add type hints, keep them consistent throughout.

FAITHFULNESS:
- Translate method bodies to equivalent Python, preserving control flow and intent.
- Java @Override methods become ordinary Python method overrides (no decorator). Keep constructors
  as __init__. Preserve TODO comments.

OUTPUT:
- Output ONLY the Python source code. No markdown, no code fences, no prose, no explanation.
'@

$limitRe = '(?i)hit your (session|weekly|opus|usage) limit|rate.?limit|\(429\)|credit balance is too low|usage limit'
# Messages that mean the session expired / not authenticated (stop, re-login, resume).
$authRe  = '(?i)not logged in|please run /login|/login\b|unauthorized|authentication_error|invalid (x-)?api key|(oauth |session |token )(has )?expired|please (re-?)?log ?in'

# Preflight: confirm headless claude works before looping over ~1,300 files.
$pfErr = [System.IO.Path]::GetTempFileName()
$pfOut = ("ping" | & claude --bare -p "Reply with exactly: OK" --model $Model --allowedTools "Read" --output-format json 2> $pfErr | Out-String)
$pfCode = $LASTEXITCODE
$pfE = ((Get-Content -LiteralPath $pfErr -ErrorAction SilentlyContinue) -join "`n")
Remove-Item -LiteralPath $pfErr -ErrorAction SilentlyContinue
if ($pfCode -ne 0) {
  $pfDiag = ((([string]$pfE) + " " + ([string]$pfOut)) -replace '\s+', ' ').Trim()
  Write-Host ""
  Write-Host ("Preflight failed: 'claude -p' exited {0} and can't run headless yet." -f $pfCode) -ForegroundColor Red
  Write-Host ("Details: {0}" -f $pfDiag)
  Write-Host ""
  Write-Host "Common fixes:"
  Write-Host "  - Sign in (quick):   run 'claude' once interactively, finish the browser login, then retry."
  Write-Host "  - Sign in (durable): run 'claude setup-token', then set CLAUDE_CODE_OAUTH_TOKEN so it survives expiry."
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

  if ($processed.Contains($f.Name)) { $skipN++; continue }
  if (Test-HasHeading -Text $content -Heading '## Python') { $skipN++; continue }
  if (-not (Test-HasHeading -Text $content -Heading '## Source')) {
    Write-Host ("[{0}/{1}] skip (no ## Source): {2}" -f $idx, $total, $f.Name); continue
  }

  $errPath = [System.IO.Path]::GetTempFileName()
  $raw  = ($content | & claude --bare -p $prompt --model $Model --allowedTools "Read" --output-format json 2> $errPath | Out-String)
  $code = $LASTEXITCODE
  $err  = ((Get-Content -LiteralPath $errPath -ErrorAction SilentlyContinue) -join "`n")
  Remove-Item -LiteralPath $errPath -ErrorAction SilentlyContinue

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
    if ($diag -match $authRe) {
      Write-Host ""
      Write-Host ("Lost authentication at: {0}" -f $f.Name) -ForegroundColor Yellow
      Write-Host "Your Claude session expired. Re-authenticate, then re-run to resume:"
      Write-Host "  durable:  claude setup-token   then set CLAUDE_CODE_OAUTH_TOKEN"
      Write-Host "  quick:    run 'claude' interactively and /login"
      Add-Content -LiteralPath $log -Value ("{0}  STOP(auth)  {1}" -f (Get-Date -Format o), $f.Name)
      exit 4
    }
    if ($diag.Length -gt 300) { $diag = $diag.Substring(0, 300) }
    Write-Warning ("[{0}/{1}] error (exit {2}) on {3}: {4}" -f $idx, $total, $code, $f.Name, $diag)
    Add-Content -LiteralPath $log -Value ("{0}  ERROR  {1}  {2}" -f (Get-Date -Format o), $f.Name, $diag)
    $errN++; continue
  }

  $codePy = ""
  if ($parsed -and $parsed.result) { $codePy = [string]$parsed.result }
  $codePy = $codePy.Trim()
  $codePy = [regex]::Replace($codePy, '^\s*```[a-zA-Z0-9]*\s*\r?\n', '')   # strip leading fence
  $codePy = [regex]::Replace($codePy, '\r?\n```\s*$', '')                   # strip trailing fence
  $codePy = $codePy.Trim()
  if (-not $codePy) {
    Write-Warning ("[{0}/{1}] empty result: {2}" -f $idx, $total, $f.Name); $errN++; continue
  }

  # Suggested python path from the note's FQN (filename without .md): a.b.C -> a/b/C.py
  $fqn = $f.BaseName
  $pypath = ($fqn -replace '\.', '/') + '.py'

  # Fence longer than any backtick run in the code.
  $maxTicks = 0
  foreach ($mm in [regex]::Matches($codePy, '`+')) { if ($mm.Value.Length -gt $maxTicks) { $maxTicks = $mm.Value.Length } }
  $fence = '`' * ([Math]::Max(3, $maxTicks + 1))

  $nl = if ($content -match "`r`n") { "`r`n" } else { "`n" }
  $body = $content.TrimEnd()
  $new = $body + $nl + $nl + "## Python" + $nl + '`' + $pypath + '`' + $nl + $nl +
         $fence + "python" + $nl + $codePy + $nl + $fence + $nl

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
