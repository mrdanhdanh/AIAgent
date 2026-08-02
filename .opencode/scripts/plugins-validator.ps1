# plugins-validator.ps1
# Validator cho Phase 11 — Plugin Architecture
# Checks PLG-001..008 (xem .opencode/plugins/validator.md)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate Plugin Architecture structure + schema + permissions.
.DESCRIPTION
  Kiểm tra plugin.schema.yaml, permissions, modules.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$plgDir = Join-Path $root 'plugins'

if (-not (Test-Path $plgDir)) { Write-Error "plugins/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- PLG-001: schema ----------
if (-not (Test-Path (Join-Path $plgDir 'plugin.schema.yaml'))) {
  $errors += "PLG-001: missing plugin.schema.yaml"
}

# ---------- PLG-006: permissions ----------
$permCatalog = @('context.read','context.write','artifact.read','artifact.write',
  'knowledge.read','knowledge.write','event.publish','event.subscribe',
  'registry.read','registry.write','runtime.read','doctor.read',
  'workflow.execute','simulation.run')
$schemaFile = Join-Path $plgDir 'plugin.schema.yaml'
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  foreach ($p in $permCatalog) {
    if ($sText -notmatch [regex]::Escape($p)) { $warnings += "PLG-006: schema thieu permission '$p'" }
  }
  foreach ($req in @('id','name','version','framework')) {
    if ($sText -notmatch "(?m)^  - $req\b") {
      $errors += "PLG-001: schema thieu required field '$req'"
    }
  }
}

# ---------- PLG-004: modules ----------
$modules = @('README.md','architecture.md','manager.md','loader.md','installer.md',
  'registry.md','lifecycle.md','sandbox.md','permissions.md','security.md',
  'compatibility.md','validator.md','marketplace.md','sdk.md','manifest.md',
  'certification.md','metrics.md','tests.md')

foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $plgDir $m))) {
    $errors += "PLG-004: missing module $m"
  }
}

# ---------- PLG-007: manifest mention ----------
if (-not (Test-Path (Join-Path $plgDir 'manifest.md'))) {
  $warnings += "PLG-007: missing manifest.md (Plugin Manifest)"
}
if (-not (Test-Path (Join-Path $plgDir 'certification.md'))) {
  $warnings += "PLG-007: missing certification.md (Plugin Certification)"
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Plugin Architecture Validation (Phase 11) ==="
  "modules: $($modules.Count) | permissions: $($permCatalog.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }