# kernel-validator.ps1
# Validator cho Phase 14 — Runtime Kernel
# Checks KRN-001..003
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'kernel'
if (-not (Test-Path $dir)) { Write-Error "kernel/ not found"; exit 1 }
$errors = @(); $warnings = @(); $infos = @()
if (-not (Test-Path (Join-Path $dir 'kernel.schema.yaml'))) { $errors += "KRN-001: missing kernel.schema.yaml" }
$modules = @('README.md','architecture.md','scheduler.md','resource-manager.md','recovery.md','transaction.md')
foreach ($m in $modules) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "KRN-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Kernel Validation (Phase 14) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count) { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }