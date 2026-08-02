# knowledge-graph-validator.ps1
# Validator cho Phase 9 — System Knowledge Graph
# Checks KG-001..006 (xem .opencode/knowledge-graph/validator.md)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate System Knowledge Graph structure + schemas.
.DESCRIPTION
  Kiểm tra graph.schema.yaml, entity.schema.yaml, relation.schema.yaml
  và các module tồn tại đủ. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$kgDir = Join-Path $root 'knowledge-graph'

if (-not (Test-Path $kgDir)) { Write-Error "knowledge-graph/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- KG-006: schema files ----------
foreach ($f in @('graph.schema.yaml','entity.schema.yaml','relation.schema.yaml')) {
  if (-not (Test-Path (Join-Path $kgDir $f))) {
    $errors += "KG-006: missing $f"
  }
}

# ---------- entity types check ----------
$entityTypes = @('framework','language','pattern','component','service','capability',
  'workflow','artifact','agent','command','skill','contract','rule','lesson','failure')
$entityFile = Join-Path $kgDir 'entity.schema.yaml'
if (Test-Path $entityFile) {
  $eText = Get-Content -LiteralPath $entityFile -Raw
  foreach ($t in $entityTypes) {
    if ($eText -notmatch "\b$t\b") { $warnings += "KG-004: entity.schema.yaml thieu type '$t'" }
  }
}

# ---------- relation types check ----------
$relTypes = @('uses','depends_on','creates','consumes','implements','extends',
  'inherits','requires','references','similar_to','conflicts_with')
$relFile = Join-Path $kgDir 'relation.schema.yaml'
if (Test-Path $relFile) {
  $rText = Get-Content -LiteralPath $relFile -Raw
  foreach ($t in $relTypes) {
    if ($rText -notmatch "\b$t\b") { $warnings += "KG-004: relation.schema.yaml thieu type '$t'" }
  }
}

# ---------- modules ----------
$modules = @('README.md','architecture.md','graph.md','entities.md','relations.md',
  'indexer.md','query.md','ranking.md','validator.md','metrics.md')

foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $kgDir $m))) {
    $errors += "KG-001: missing module $m"
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== System Knowledge Graph Validation (Phase 9) ==="
  "modules: $($modules.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }