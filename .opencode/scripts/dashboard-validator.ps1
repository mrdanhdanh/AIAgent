# dashboard-validator.ps1
# Validator cho Phase 12 — System Dashboard
# Checks DSH-001..005 (cấu trúc dashboard/)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate Dashboard structure + schema.
.DESCRIPTION
  Kiểm tra dashboard.schema.yaml và các module (projection, api, monitor, control...).
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$dshDir = Join-Path $root 'dashboard'

if (-not (Test-Path $dshDir)) { Write-Error "dashboard/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- DSH-001: schema ----------
if (-not (Test-Path (Join-Path $dshDir 'dashboard.schema.yaml'))) {
  $errors += "DSH-001: missing dashboard.schema.yaml"
}

# ---------- DSH-002: schema fields ----------
$schemaFile = Join-Path $dshDir 'dashboard.schema.yaml'
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  foreach ($req in @('version','snapshot_id','updated_at','health')) {
    if ($sText -notmatch "(?m)^  - $req\b") {
      $errors += "DSH-002: schema thieu required field '$req'"
    }
  }
  foreach ($mod in @('overview','runtime','workflows','agents','capabilities','context','artifacts','events')) {
    if ($sText -notmatch "(?m)^  $mod\b") { $warnings += "DSH-002: schema thieu field '$mod'" }
  }
}

# ---------- DSH-003: modules ----------
$modules = @('README.md','architecture.md','security.md')
foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $dshDir $m))) {
    $errors += "DSH-003: missing module $m"
  }
}

# ---------- DSH-004: dirs ----------
$dirs = @('projection','api','monitor','control','widgets','metrics','reports')
foreach ($d in $dirs) {
  if (-not (Test-Path (Join-Path $dshDir $d))) {
    $errors += "DSH-004: missing dir $d/"
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== System Dashboard Validation (Phase 12) ==="
  "dirs: $($dirs.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }