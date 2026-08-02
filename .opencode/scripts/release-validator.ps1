# release-validator.ps1
# Validator cho Phase 22 — Release Manager
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'release'
if (-not (Test-Path $dir)) { Write-Error "release/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'release.schema.yaml'))) { $errors += "REL-001: missing release.schema.yaml" }
foreach ($m in @('README.md','canary.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "REL-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Release Manager Validation (Phase 22) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }