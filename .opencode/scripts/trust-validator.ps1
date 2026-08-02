# trust-validator.ps1
# Validator cho Phase 27 — Trust & Safety
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'trust'
if (-not (Test-Path $dir)) { Write-Error "trust/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'trust.schema.yaml'))) { $errors += "TST-001: missing trust.schema.yaml" }
foreach ($m in @('README.md','approval.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "TST-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Trust & Safety Validation (Phase 27) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }