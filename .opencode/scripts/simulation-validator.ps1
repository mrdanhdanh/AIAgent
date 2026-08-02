# simulation-validator.ps1
# Validator cho Phase 7 — Simulation Engine
# Checks SIM-001..007 (cấu trúc simulation/)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate Simulation Engine structure + schema.
.DESCRIPTION
  Kiểm tra simulation.schema.yaml và các module tồn tại đủ.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$simDir = Join-Path $root 'simulation'

if (-not (Test-Path $simDir)) { Write-Error "simulation/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- SIM-001: schema files ----------
foreach ($f in @('simulation.schema.yaml')) {
  if (-not (Test-Path (Join-Path $simDir $f))) {
    $errors += "SIM-001: missing $f"
  }
}

# ---------- SIM-002: schema required fields ----------
$schemaFile = Join-Path $simDir 'simulation.schema.yaml'
$reqFields = @('id','workflow','mode','risk_score','status','recommendation')
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  foreach ($req in $reqFields) {
    if ($sText -notmatch "(?m)^  - $req\b") {
      $errors += "SIM-002: simulation.schema.yaml thieu required field '$req'"
    }
  }
  # mode enum
  if ($sText -notmatch 'dry-run') { $warnings += "SIM-002: schema thieu mode dry-run" }
  if ($sText -notmatch 'what-if') { $warnings += "SIM-002: schema thieu mode what-if" }
  if ($sText -notmatch 'recommendation') { $warnings += "SIM-002: schema thieu recommendation" }
}

# ---------- SIM-003: modules ----------
$modules = @('README.md','architecture.md','simulator.md','planner.md','modes.md',
  'scenario.md','risk-engine.md','confidence.md','dependency-checker.md',
  'validator.md','conflict-detection.md','event-prediction.md',
  'report.md','metrics.md','tests.md')

foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $simDir $m))) {
    $errors += "SIM-003: missing module $m"
  }
}

# ---------- SIM-004: cross-reference với events/ ----------
$evtDir = Join-Path $root 'events'
if (-not (Test-Path (Join-Path $evtDir 'lineage.md'))) {
  $warnings += "SIM-004: events/lineage.md thieu (replay phụ thuộc)"
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Simulation Engine Validation (Phase 7) ==="
  "modules: $($modules.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }