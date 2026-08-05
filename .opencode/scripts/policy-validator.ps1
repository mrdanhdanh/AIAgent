# policy-validator.ps1
# Validator cho Phase 15 — Policy Engine
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'policy'
if (-not (Test-Path $dir)) { Write-Error "policy/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'policy.schema.yaml'))) { $errors += "POL-001: missing policy.schema.yaml" }
foreach ($m in @('README.md','architecture.md','evaluator.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "POL-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Policy Engine Validation (Phase 15) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }