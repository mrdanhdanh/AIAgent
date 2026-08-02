# model-router-validator.ps1
# Validator cho Phase 17 — Model Router
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'model-router'
if (-not (Test-Path $dir)) { Write-Error "model-router/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'model-router.schema.yaml'))) { $errors += "MRT-001: missing model-router.schema.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "MRT-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Model Router Validation (Phase 17) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }