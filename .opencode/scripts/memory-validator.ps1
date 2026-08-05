# memory-validator.ps1
# Validator cho Phase 19 — Memory Engine
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'memory'
if (-not (Test-Path $dir)) { Write-Error "memory/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'memory.schema.yaml'))) { $errors += "MEM-001: missing memory.schema.yaml" }
foreach ($m in @('README.md','architecture.md','working.md','knowledge-failure.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "MEM-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Memory Engine Validation (Phase 19) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }