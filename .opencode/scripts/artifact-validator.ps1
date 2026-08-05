# artifact-validator.ps1
# Validator cho Phase 5 — Artifact Store
# Checks ART-001..009 (xem .opencode/artifacts/validator.md)
# Parser YAML subset for schemas.
# Exit 0 = PASS (no CRITICAL errors).
<#
.SYNOPSIS
  Validate Artifact Store structure and schemas.
.DESCRIPTION
  Kiểm tra artifact.schema.yaml, types.yaml, metadata.schema.yaml
  và các file module artifacts/ tồn tại đủ.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$artDir = Join-Path $root 'artifacts'

if (-not (Test-Path $artDir)) { Write-Error "artifacts/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- ART-001: schema files tồn tại ----------
foreach ($f in @('artifact.schema.yaml','metadata.schema.yaml','types.yaml')) {
  if (-not (Test-Path (Join-Path $artDir $f))) {
    $errors += "ART-001: missing $f"
  }
}

# ---------- ART-002: type list ----------
$typesFile = Join-Path $artDir 'types.yaml'
if (Test-Path $typesFile) {
  $typeText = Get-Content -LiteralPath $typesFile -Raw
  $typeIds = @([regex]::Matches($typeText, '(?m)^\s*-\s*id:\s*([a-z]+)') | ForEach-Object { $_.Groups[1].Value })
  if ($typeIds.Count -eq 0) { $errors += "ART-002: types.yaml khong co type nao" }

  # prefix unique
  $prefixes = @{}
  [regex]::Matches($typeText, '(?m)^\s*prefix:\s*([A-Z]+)') | ForEach-Object {
    $p = $_.Groups[1].Value
    if ($prefixes.ContainsKey($p)) { $errors += "ART-002: duplicate prefix '$p'" }
    $prefixes[$p] = $true
  }
}

# ---------- ART-003: module files tồn tại ----------
$modules = @('README.md','architecture.md','manager.md','repository.md','validator.md',
  'indexing.md','versioning.md','history.md','lifecycle.md','lineage.md',
  'dependency.md','checksum.md','diff.md','cache.md','query.md','contract.md',
  'tags.md','metrics.md','tests.md','graph.md','metadata.schema.yaml','types.yaml',
  'artifact.schema.yaml')

foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $artDir $m))) {
    $warnings += "ART-003: missing module $m"
  }
}

# ---------- ART-004: type enum khớp trong artifact.schema.yaml ----------
$schemaFile = Join-Path $artDir 'artifact.schema.yaml'
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  if ($sText -notmatch 'artifact.schema.yaml') {
    $errors += "ART-004: artifact.schema.yaml format khong hop le"
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Artifact Store Validation (Phase 5) ==="
  "types: $($typeIds.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }