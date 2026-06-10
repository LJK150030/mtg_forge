<#
.SYNOPSIS
  STAGE 4 — port each vault note's Java class into the LIVE Python project,
  codebase-aware and verified, in dependency order. Headless Claude Code (Opus 4.8).

.DESCRIPTION
  For each FQN in <OrderFile> (produced by build_order.py), this runs `claude -p`
  FROM the Python project so the agent can Read/Grep/Glob the already-ported
  dependency files and match their real snake_case signatures, then Edit/Write the
  target file and verify it (ruff/mypy/residual-camelCase) until clean.

  Differs from add-python-port.ps1 (which only writes a ## Python draft in the note):
    * cwd = the real project; agent gets Read,Grep,Glob,Edit,Write,Bash.
    * worklist is dependency-ordered (build_order.py), not directory order.
    * output is snake_case + remapped imports, written to the PROJECT path.
    * reconcile mode: if the target already has a draft, the agent UPDATES it.
    * a final ruff gate runs in this harness after each file.

  Resumable/idempotent via integrate-port.log; clean stops on usage limit (exit 2),
  auth loss (exit 4), a not-yet-ported dependency (MISSING, exit 5), or a failed
  verification gate (exit 3).

.EXAMPLE
  # 1) order the work, 2) integrate (sample 5 first)
  python tools\python-port\build_order.py "G:\...\mtg_forge_conversion" > order.txt
  pwsh tools\python-port\integrate-python-port.ps1 -VaultPath "G:\...\mtg_forge_conversion" -ProjectRoot "C:\code\pyforge" -OrderFile order.txt -Max 5
#>
param(
  [Parameter(Mandatory = $true)][string]$VaultPath,
  [Parameter(Mandatory = $true)][string]$ProjectRoot,
  [Parameter(Mandatory = $true)][string]$OrderFile,
  [string]$Model = "claude-opus-4-8",
  [int]$Max = 0
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

foreach ($p in @($VaultPath, $ProjectRoot)) {
  if (-not (Test-Path -LiteralPath $p -PathType Container)) { Write-Error "Folder not found: $p"; exit 1 }
}
if (-not (Test-Path -LiteralPath $OrderFile -PathType Leaf)) { Write-Error "Order file not found: $OrderFile"; exit 1 }
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { Write-Error "'claude' CLI not on PATH."; exit 1 }

$vault   = (Resolve-Path -LiteralPath $VaultPath).Path
$project = (Resolve-Path -LiteralPath $ProjectRoot).Path
$log     = Join-Path $vault "integrate-port.log"

$limitRe = '(?i)hit your (session|weekly|opus|usage) limit|rate.?limit|\(429\)|credit balance is too low|usage limit'
$authRe  = '(?i)not logged in|please run /login|/login\b|unauthorized|authentication_error|invalid (x-)?api key|(oauth |session |token )(has )?expired|please (re-?)?log ?in'

# forge FQN -> live project file path. ADJUST the three roots to your real layout.
function Convert-FqnToPath {
  param([string]$Fqn)
  if     ($Fqn -like 'forge.ai.*')   { $rest = $Fqn.Substring('forge.ai.'.Length);   $dir = 'pyforge_ai' }
  elseif ($Fqn -like 'forge.game.*') { $rest = $Fqn.Substring('forge.game.'.Length); $dir = 'pyforge_game/game' }
  elseif ($Fqn -like 'forge.*')      { $rest = $Fqn.Substring('forge.'.Length);      $dir = 'pyforge_core' }
  else                               { $rest = $Fqn;                                 $dir = '.' }
  $parts = $rest -split '\.'
  $cls   = $parts[-1]
  $pkg   = if ($parts.Count -gt 1) { ($parts[0..($parts.Count - 2)] -join '/') } else { '' }
  $snake = [regex]::Replace($cls, '([a-z0-9])([A-Z])', '$1_$2')
  $snake = ([regex]::Replace($snake, '([A-Z]+)([A-Z][a-z])', '$1_$2')).ToLower()
  $rel   = if ($pkg) { "$dir/$pkg/$snake.py" } else { "$dir/$snake.py" }
  return ($rel -replace '/{2,}', '/')
}

$promptTemplate = @'
You are porting ONE Java class from the Forge MTG engine into the LIVE Python project
(your current working directory), which uses snake_case and the pyforge_ai /
pyforge_game / pyforge_core namespaces. You have Read, Grep, Glob, Edit, Write, and
Bash on the project -- USE THEM. This codebase-awareness is the whole point.

stdin is the class's vault note: a UML diagram, a Relationships section of
[[forge.x.y.Name|...]] wiki-links (Extends / Uses), a Design Description, the original
Java source, and a rough first-draft Python port. Treat the draft as UNTRUSTED -- it
was written in isolation and contains wrong method names and leftover camelCase.

TARGET FILE: __DEST__
Create it if missing; if it already exists, treat it as the current draft and
reconcile/update it in place.

Procedure:
1. The Java source in the note is the source of truth for LOGIC. Read it.
2. Read __DEST__ if it exists -- that is the current project draft to update.
3. For the base class (Extends) and every collaborator (Uses), find its REAL
   already-ported file (Grep/Glob by class name; imports map forge.ai.X ->
   pyforge_ai.x, forge.game.<s>.Y -> pyforge_game.game.<s>.y) and read its real
   snake_case method names and signatures. Match the style of sibling files.
   - If a dependency has NOT been ported yet (no real file exists), output exactly
     "MISSING: <its.fully.qualified.Name>" on its own line and STOP. Do not guess.
4. Write/Edit __DEST__ so it is: logically identical to the Java; snake_case for all
   methods/params/locals; class names PascalCase; constants/enums as-is; imports and
   method names that ACTUALLY EXIST in the files you opened (fix draft guesses such as
   get_trigger -> get_targets); null -> None; super().method(...). Idiomatic Python.
5. Verify with Bash and FIX until clean (re-run after each edit):
     ruff check __DEST__
     grep -nE '\.[a-z]+[A-Z][A-Za-z]*\(' __DEST__     (must print nothing)
   Also run `mypy __DEST__` if available and address real signature mismatches
   (import-resolution noise is acceptable to note rather than fix).
6. Output a short report: the file written, each method/import you corrected against
   the real API, and any missing dependency.
'@

# --- preflight (no --bare; matches a working `claude -p`) ---
$pfErr = [System.IO.Path]::GetTempFileName()
("ping" | & claude -p "Reply with exactly: OK" --model $Model --allowedTools "Read" --output-format json 2> $pfErr | Out-String) | Out-Null
$pfCode = $LASTEXITCODE
$pfMsg = ((Get-Content -LiteralPath $pfErr -ErrorAction SilentlyContinue) -join ' ')
Remove-Item -LiteralPath $pfErr -ErrorAction SilentlyContinue
if ($pfCode -ne 0) {
  Write-Host ("Preflight failed (exit {0}): {1}" -f $pfCode, $pfMsg.Trim()) -ForegroundColor Red
  Write-Host "Fix auth: 'claude setup-token' + set CLAUDE_CODE_OAUTH_TOKEN, or run 'claude' and /login. Then re-run."
  exit 1
}
$ruff = [bool](Get-Command ruff -ErrorAction SilentlyContinue)
Write-Host ("Preflight OK. Project: {0}  (final ruff gate: {1})" -f $project, $(if ($ruff) { 'on' } else { 'ruff not found - skipped' })) -ForegroundColor Green

# log guard
$processed = New-Object 'System.Collections.Generic.HashSet[string]'
if (Test-Path -LiteralPath $log) {
  foreach ($line in (Get-Content -LiteralPath $log -ErrorAction SilentlyContinue)) {
    if ($line -match '\bOK\s+(\S+)\s*$') { [void]$processed.Add($Matches[1]) }
  }
}

$fqns = Get-Content -LiteralPath $OrderFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }
$total = $fqns.Count
$idx = 0; $doneN = 0; $skipN = 0; $errN = 0

foreach ($fqn in $fqns) {
  $idx++
  if ($processed.Contains($fqn)) { $skipN++; continue }

  $note = Join-Path $vault ($fqn + ".md")
  if (-not (Test-Path -LiteralPath $note)) {
    Write-Host ("[{0}/{1}] no note for {2}" -f $idx, $total, $fqn) -ForegroundColor DarkYellow; continue
  }
  $rel  = Convert-FqnToPath -Fqn $fqn
  $dest = Join-Path $project $rel
  $content = Get-Content -LiteralPath $note -Raw
  $prompt = $promptTemplate.Replace('__DEST__', $rel)

  Push-Location -LiteralPath $project
  $errPath = [System.IO.Path]::GetTempFileName()
  $raw  = ($content | & claude -p $prompt --model $Model --allowedTools "Read,Grep,Glob,Edit,Write,Bash" --output-format json 2> $errPath | Out-String)
  $code = $LASTEXITCODE
  $err  = ((Get-Content -LiteralPath $errPath -ErrorAction SilentlyContinue) -join "`n")
  Remove-Item -LiteralPath $errPath -ErrorAction SilentlyContinue
  Pop-Location

  $parsed = $null
  if (([string]$raw).Trim()) { try { $parsed = $raw | ConvertFrom-Json } catch { } }
  $result = if ($parsed -and $parsed.result) { [string]$parsed.result } else { "" }
  $diag = ((([string]$err) + " " + ([string]$raw)) -replace '\s+', ' ').Trim()

  if (($code -ne 0) -or ($parsed -and $parsed.is_error)) {
    if ($diag -match $limitRe) {
      Write-Host ("`nUsage limit at: {0} - re-run to resume." -f $fqn) -ForegroundColor Yellow
      Add-Content -LiteralPath $log -Value ("{0}  STOP(limit)  {1}" -f (Get-Date -Format o), $fqn); exit 2
    }
    if ($diag -match $authRe) {
      Write-Host ("`nAuth lost at: {0} - re-authenticate, then re-run." -f $fqn) -ForegroundColor Yellow
      Add-Content -LiteralPath $log -Value ("{0}  STOP(auth)  {1}" -f (Get-Date -Format o), $fqn); exit 4
    }
    Write-Warning ("[{0}/{1}] ERROR on {2}: {3}" -f $idx, $total, $fqn, ($diag.Substring(0, [Math]::Min(200, $diag.Length))))
    Add-Content -LiteralPath $log -Value ("{0}  ERROR  {1}" -f (Get-Date -Format o), $fqn); $errN++; continue
  }

  if ($result -match '(?m)^\s*MISSING:\s*(\S+)') {
    Write-Host ("`n[{0}/{1}] {2} needs dependency {3} ported first. Stopping - check ordering." -f $idx, $total, $fqn, $Matches[1]) -ForegroundColor Yellow
    Add-Content -LiteralPath $log -Value ("{0}  MISSING  {1}  needs {2}" -f (Get-Date -Format o), $fqn, $Matches[1]); exit 5
  }

  if (-not (Test-Path -LiteralPath $dest)) {
    Write-Warning ("[{0}/{1}] agent did not produce {2}" -f $idx, $total, $rel)
    Add-Content -LiteralPath $log -Value ("{0}  ERROR  {1}  (no output file)" -f (Get-Date -Format o), $fqn); $errN++; continue
  }

  # final deterministic gate
  if ($ruff) {
    Push-Location -LiteralPath $project
    & ruff check $rel 2>&1 | Out-Null
    $ruffCode = $LASTEXITCODE
    Pop-Location
    if ($ruffCode -ne 0) {
      Write-Host ("[{0}/{1}] VERIFY FAILED (ruff) on {2} - stopping for review." -f $idx, $total, $rel) -ForegroundColor Red
      Add-Content -LiteralPath $log -Value ("{0}  VERIFY  {1}" -f (Get-Date -Format o), $fqn); exit 3
    }
  }

  $doneN++
  Write-Host ("[{0}/{1}] done: {2} -> {3}" -f $idx, $total, $fqn, $rel) -ForegroundColor Green
  Add-Content -LiteralPath $log -Value ("{0}  OK     {1}" -f (Get-Date -Format o), $fqn)
  [void]$processed.Add($fqn)

  if ($Max -gt 0 -and $doneN -ge $Max) { Write-Host ("Reached -Max {0}. Re-run to continue." -f $Max); break }
}

Write-Host ""
Write-Host ("Summary: {0} ported, {1} skipped/done, {2} errors, of {3} classes." -f $doneN, $skipN, $errN, $total)
