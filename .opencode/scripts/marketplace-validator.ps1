# marketplace-validator.ps1
# Validator cho Phase 25 — AI Marketplace
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'marketplace'
if (-not (Test-Path $dir)) { Write-Error "marketplace/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'marketplace.schema.yaml'))) { $errors += "MKT-001: missing marketplace.schema.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "MKT-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== AI Marketplace Validation (Phase 25) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }