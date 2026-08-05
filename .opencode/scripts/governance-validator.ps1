# governance-validator.ps1
# Validator cho Phase 26 — Governance Engine
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'governance'
if (-not (Test-Path $dir)) { Write-Error "governance/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'governance.schema.yaml'))) { $errors += "GOV-001: missing governance.schema.yaml" }
foreach ($m in @('README.md','architecture.md','audit.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "GOV-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Governance Engine Validation (Phase 26) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }