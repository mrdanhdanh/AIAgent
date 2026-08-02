# resources-validator.ps1
# Validator cho Phase 16 — Resource Manager
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'resources'
if (-not (Test-Path $dir)) { Write-Error "resources/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'resources.schema.yaml'))) { $errors += "RSC-001: missing resources.schema.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "RSC-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Resource Manager Validation (Phase 16) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }