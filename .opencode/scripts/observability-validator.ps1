# observability-validator.ps1
# Validator cho Phase 20 — Observability Platform
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'observability'
if (-not (Test-Path $dir)) { Write-Error "observability/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'observability.schema.yaml'))) { $errors += "OBS-001: missing observability.schema.yaml" }
foreach ($m in @('README.md','tracing.md','metrics.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "OBS-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Observability Validation (Phase 20) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }