# cost-validator.ps1
# Validator cho Phase 28 — AI Cost Manager
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'cost'
if (-not (Test-Path $dir)) { Write-Error "cost/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'cost.schema.yaml'))) { $errors += "CST-001: missing cost.schema.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "CST-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== AI Cost Manager Validation (Phase 28) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }