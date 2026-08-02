# prompts-validator.ps1
# Validator cho Phase 18 — Prompt Registry
param([switch]$Silent)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'prompts'
if (-not (Test-Path $dir)) { Write-Error "prompts/ not found"; exit 1 }
$errors = @(); $warnings = @()
if (-not (Test-Path (Join-Path $dir 'prompt-registry.yaml'))) { $errors += "PRM-001: missing prompt-registry.yaml" }
foreach ($m in @('README.md','architecture.md')) { if (-not (Test-Path (Join-Path $dir $m))) { $errors += "PRM-002: missing module $m" } }
if (-not $Silent) {
  ""
  "=== Prompt Registry Validation (Phase 18) ==="
  if ($errors.Count) { ""; "ERRORS ($($errors.Count)):"; $errors | ForEach-Object { "  [E] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }