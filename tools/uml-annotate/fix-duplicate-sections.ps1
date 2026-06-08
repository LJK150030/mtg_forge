<#
.SYNOPSIS
  Remove DUPLICATE "## <Heading>" sections from vault notes, keeping the first.
  One-time cleanup for notes that an earlier (CRLF-buggy) run double-annotated.

.DESCRIPTION
  For each note that contains the heading more than once, keeps the first section
  (heading + body up to the next "## " heading) and deletes every later copy.
  Line-ending-agnostic; writes back only files that change.

.EXAMPLE
  # Preview what would change (no writes):
  pwsh tools/uml-annotate/fix-duplicate-sections.ps1 -VaultPath "G:\...\mtg_forge_conversion" -WhatIf

.EXAMPLE
  pwsh tools/uml-annotate/fix-duplicate-sections.ps1 -VaultPath "G:\...\mtg_forge_conversion"
  pwsh tools/uml-annotate/fix-duplicate-sections.ps1 -VaultPath "G:\...\mtg_forge_conversion" -Heading "## Python"
#>
param(
  [Parameter(Mandatory = $true)][string]$VaultPath,
  [string]$Heading = "## Design Description",
  [switch]$WhatIf
)

if (-not (Test-Path -LiteralPath $VaultPath -PathType Container)) { Write-Error "Vault not found: $VaultPath"; exit 1 }
$vault = (Resolve-Path -LiteralPath $VaultPath).Path
$files = Get-ChildItem -LiteralPath $vault -Filter *.md -File | Sort-Object Name
$scanned = 0; $fixed = 0

foreach ($f in $files) {
  $scanned++
  $content = Get-Content -LiteralPath $f.FullName -Raw
  $nl = if ($content -match "`r`n") { "`r`n" } else { "`n" }
  $lines = $content -split '\r?\n'

  $count = 0
  foreach ($l in $lines) { if ($l.Trim() -eq $Heading) { $count++ } }
  if ($count -le 1) { continue }

  $out = New-Object System.Collections.Generic.List[string]
  $seen = $false; $dropping = $false
  foreach ($l in $lines) {
    $t = $l.Trim()
    if ($t -eq $Heading) {
      if (-not $seen) { $seen = $true; $dropping = $false; $out.Add($l); continue }
      else { $dropping = $true; continue }          # duplicate heading -> drop it and its body
    }
    if ($dropping) {
      if ($t -match '^##\s') {                       # next H2 heading ends the dropped section
        $dropping = $false
        while ($out.Count -gt 0 -and $out[$out.Count - 1].Trim() -eq '') { $out.RemoveAt($out.Count - 1) }
        $out.Add('')                                 # exactly one blank line before the kept heading
        $out.Add($l)
      }
      continue
    }
    $out.Add($l)
  }

  $new = ($out -join $nl)
  if ($new -ne $content) {
    $removed = $count - 1
    if ($WhatIf) {
      Write-Host ("[would fix] {0}: remove {1} duplicate '{2}' section(s)" -f $f.Name, $removed, $Heading)
    } else {
      [System.IO.File]::WriteAllText($f.FullName, $new, (New-Object System.Text.UTF8Encoding($false)))
      Write-Host ("[fixed] {0}: removed {1} duplicate '{2}' section(s)" -f $f.Name, $removed, $Heading) -ForegroundColor Green
    }
    $fixed++
  }
}

Write-Host ""
$mode = if ($WhatIf) { "(preview only)" } else { "(fixed)" }
Write-Host ("Scanned {0} notes; {1} had duplicate '{2}' sections {3}." -f $scanned, $fixed, $Heading, $mode)
