# evaluation-validator.ps1
# Validator cho Phase 21 — AI Evaluation Platform
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'evaluation'
if (-not (Test-Path $dir)) { Write-Error "evaluation/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'evaluation.schema.yaml'))) { $errors += "EVL-001: missing evaluation.schema.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "EVL-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== AI Evaluation Validation (Phase 21) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }