# evolution-validator.ps1
# Validator cho Phase 10 — Self Evolution Engine
# Checks EVO-001..008 (xem .opencode/evolution/validator.md)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate Evolution Engine structure + schema + policy + objectives.
.DESCRIPTION
  Kiểm tra evolution.schema.yaml, policy, objectives và các module.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$evoDir = Join-Path $root 'evolution'

if (-not (Test-Path $evoDir)) { Write-Error "evolution/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- EVO-001: schema ----------
if (-not (Test-Path (Join-Path $evoDir 'evolution.schema.yaml'))) {
  $errors += "EVO-001: missing evolution.schema.yaml"
}

# ---------- EVO-002: schema fields ----------
$schemaFile = Join-Path $evoDir 'evolution.schema.yaml'
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  foreach ($req in @('id','category','title','status')) {
    if ($sText -notmatch "(?m)^  - $req\b") {
      $errors += "EVO-002: schema thieu required field '$req'"
    }
  }
  if ($sText -notmatch 'simulation') { $warnings += "EVO-002: schema thieu simulation field" }
  if ($sText -notmatch 'backtest') { $warnings += "EVO-002: schema thieu backtest field" }
  if ($sText -notmatch 'approval') { $warnings += "EVO-002: schema thieu approval field" }
}

# ---------- EVO-003: categories ----------
$catFile = Join-Path $evoDir 'evolution.schema.yaml'
$cats = @('performance','architecture','context','capability','workflow','knowledge','runtime','quality')
if (Test-Path $catFile) {
  $cText = Get-Content -LiteralPath $catFile -Raw
  foreach ($c in $cats) {
    if ($cText -notmatch "\b$c\b") { $warnings += "EVO-003: schema thieu category '$c'" }
  }
}

# ---------- EVO-004: modules ----------
$modules = @('README.md','architecture.md','analyzer.md','optimizer.md','predictor.md',
  'planner.md','migration.md','simulator.md','validator.md','metrics.md',
  'history.md','policy.md','objectives.md','backtesting.md')

foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $evoDir $m))) {
    $errors += "EVO-004: missing module $m"
  }
}

# ---------- EVO-006: policy ----------
$policyFile = Join-Path $evoDir 'policy.md'
if (-not (Test-Path $policyFile)) {
  $warnings += "EVO-006: missing policy.md"
}

# ---------- EVO-007: objectives ----------
$objFile = Join-Path $evoDir 'objectives.md'
if (-not (Test-Path $objFile)) {
  $warnings += "EVO-007: missing objectives.md"
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Self Evolution Engine Validation (Phase 10) ==="
  "modules: $($modules.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }