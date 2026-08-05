# workspaces-validator.ps1
# Validator cho Phase 23 — Multi Workspace
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'workspaces'
if (-not (Test-Path $dir)) { Write-Error "workspaces/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'workspaces.schema.yaml'))) { $errors += "WSP-001: missing workspaces.schema.yaml" }
foreach ($m in @('README.md','workspace-manager.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "WSP-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Multi Workspace Validation (Phase 23) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }