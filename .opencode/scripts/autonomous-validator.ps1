# autonomous-validator.ps1
# Validator cho Phase 30 — Autonomous Mode
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'autonomous'
if (-not (Test-Path $dir)) { Write-Error "autonomous/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'autonomous.schema.yaml'))) { $errors += "AUT-001: missing autonomous.schema.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "AUT-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Autonomous Mode Validation (Phase 30) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }