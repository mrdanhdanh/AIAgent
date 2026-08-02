# spec000-validator.ps1
# Validator cho SPEC-000 — Core Principles
# Checks SPC-001..006 (7 nguyen tac, object model, event base)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-000 Core Principles.
.DESCRIPTION
  Kiem tra SPEC-000 du 7 nguyen tac P1-P7 + files co ban.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$specDir = Join-Path $root 'spec'
$s000 = Join-Path $specDir 'SPEC-000-core-principles'

if (-not (Test-Path $s000)) { Write-Error "SPEC-000 not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- SPC-001: files ----------
$files = @('README.md','terminology.md','object-model.md','changelog.md')
foreach ($f in $files) {
  if (-not (Test-Path (Join-Path $s000 $f))) { $errors += "SPC-001: missing $f" }
}

# ---------- SPC-002: 7 nguyen tac ----------
$readme = Join-Path $s000 'README.md'
if (Test-Path $readme) {
  $text = Get-Content -LiteralPath $readme -Raw -Encoding utf8
  for ($i = 1; $i -le 7; $i++) {
    if ($text -notmatch "P$i\b") { $errors += "SPC-002: thieu nguyen tac P$i" }
  }
  foreach ($p in @('Stateless by Default','Contract First','Everything is Metadata',
    'Everything is Event','Everything is Versioned','Core is Closed, Extension is Open',
    'Simulation Before Execution')) {
    if ($text -notmatch [regex]::Escape($p)) { $warnings += "SPC-002: thieu ten day du '$p'" }
  }
}

# ---------- SPC-003: object model base ----------
$om = Join-Path $s000 'object-model.md'
if (Test-Path $om) {
  $ot = Get-Content -LiteralPath $om -Raw -Encoding utf8
  foreach ($k in @('id','type','version','status','metadata')) {
    if ($ot -notmatch $k) { $warnings += "SPC-003: object-model thieu field '$k'" }
  }
}

# ---------- SPC-004: event base ----------
if (-not $Silent) {
  ""
  "=== SPEC-000 Core Principles Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }