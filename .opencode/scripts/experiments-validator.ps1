# experiments-validator.ps1
# Validator cho Phase 29 — Experiment Platform
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'experiments'
if (-not (Test-Path $dir)) { Write-Error "experiments/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'experiment.schema.yaml'))) { $errors += "EXP-001: missing experiment.schema.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "EXP-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Experiment Platform Validation (Phase 29) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }