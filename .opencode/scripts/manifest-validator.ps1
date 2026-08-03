# manifest-validator.ps1
# Validator cho Manifest (Sprint -1)
# Checks MNF-001..003 (manifest.yaml fields)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Manifest.
.DESCRIPTION
  Kiem tra manifest.yaml co du fields chinh. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$manifestFile = Join-Path $root '..\docs\manifest\AIOS_MANIFEST.yaml'

if (-not (Test-Path $manifestFile)) { Write-Error "AIOS_MANIFEST.yaml not found"; exit 1 }

$errors   = @()
$warnings = @()

$text = Get-Content -LiteralPath $manifestFile -Raw -Encoding utf8

# ---------- MNF-001: fields chinh ----------
foreach ($f in @('id','name','version','status','mission','vision','scope','goals',
  'non_goals','quality_attributes','core_principles','owners','license','created','updated')) {
  if ($text -notmatch "(?m)^$f\s*:") { $errors += "MNF-001: thieu field '$f'" }
}

# ---------- MNF-002: principles P001-P015 ----------
for ($i = 1; $i -le 15; $i++) {
  $p = "P{0:D3}" -f $i
  if ($text -notmatch [regex]::Escape($p)) { $warnings += "MNF-002: thieu principle $p trong manifest" }
}

# ---------- MNF-003: id la AIOS ----------
if ($text -notmatch '(?m)^id:\s*AIOS') { $errors += "MNF-003: id phai la AIOS" }

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Manifest Validation (Sprint -1) ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }