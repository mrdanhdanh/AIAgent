# distributed-validator.ps1
# Validator cho Phase 24 — Distributed Runtime
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'distributed'
if (-not (Test-Path $dir)) { Write-Error "distributed/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'distributed.schema.yaml'))) { $errors += "DST-001: missing distributed.schema.yaml" }
foreach ($m in @('README.md','nodes.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "DST-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Distributed Runtime Validation (Phase 24) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }