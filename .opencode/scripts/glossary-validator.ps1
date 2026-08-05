# glossary-validator.ps1
# Validator cho Glossary (D002 Domain Model)
# Checks GLS-001..009 (16 term files, template DM, taxonomy, relationships, catalog)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Glossary.
.DESCRIPTION
  Kiem tra docs/glossary/ co du 16 term files trong terms/, template DM, 
  taxonomy.yaml, relationships.yaml, CATALOG.md. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$glossaryDir = Join-Path $root '..\docs\glossary'
$termsDir = Join-Path $glossaryDir 'terms'

if (-not (Test-Path $glossaryDir)) { Write-Error "glossary/ not found"; exit 1 }
if (-not (Test-Path $termsDir)) { Write-Error "glossary/terms/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- GLS-001: 16 term files trong terms/ ----------
$terms = @('runtime','workflow','phase','task','capability','agent',
  'skill','command','artifact','context','memory','knowledge',
  'event','registry','plugin','contract')
foreach ($t in $terms) {
  if (-not (Test-Path (Join-Path $termsDir "$t.md"))) {
    $errors += "GLS-001: missing term file terms/$t.md"
  }
}

# ---------- GLS-002: template DM fields ----------
$template = @('id','name','version','since','status','category','owner','stability',
  'tags','aliases','deprecated_aliases','summary','definition','purpose',
  'entity_type','normative','responsibilities','does_not_responsible',
  'owned_by','used_by','depends_on','inputs','outputs','lifecycle',
  'states','invariants','related','examples','references')
foreach ($t in $terms) {
  $f = Join-Path $termsDir "$t.md"
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in $template) {
    if ($text -notmatch "(?m)^$field\s*:") { $errors += "GLS-002: $t.md thieu field '$field'" }
  }
  if ($text -notmatch '(?m)^id:\s*TERM-\d{3}') { $errors += "GLS-002: $t.md id phai la TERM-###" }
  if ($text -notmatch '(?m)^  MUST:') { $errors += "GLS-002: $t.md thieu normative MUST" }
  if ($text -notmatch '(?m)^  MUST NOT:') { $errors += "GLS-002: $t.md thieu normative MUST NOT" }
}

# ---------- GLS-003: invariants ----------
foreach ($t in $terms) {
  $f = Join-Path $termsDir "$t.md"
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  if ($text -notmatch '(?m)^invariants:\s*$') { $errors += "GLS-003: $t.md thieu invariants" }
}

# ---------- GLS-004: taxonomy.yaml ----------
$tax = Join-Path $glossaryDir 'taxonomy.yaml'
if (-not (Test-Path $tax)) {
  $errors += "GLS-004: missing taxonomy.yaml"
} else {
  $tt = Get-Content -LiteralPath $tax -Raw -Encoding utf8
  if ($tt -notmatch '(?m)^categories:') { $errors += "GLS-004: taxonomy thieu categories" }
  foreach ($c in @('Core','Execution','EntryPoint','Data','Knowledge','Platform','Extension')) {
    if ($tt -notmatch [regex]::Escape($c)) { $warnings += "GLS-004: taxonomy thieu category '$c'" }
  }
}

# ---------- GLS-005: relationships.yaml ----------
$rel = Join-Path $glossaryDir 'relationships.yaml'
if (-not (Test-Path $rel)) {
  $errors += "GLS-005: missing relationships.yaml"
} else {
  $rt = Get-Content -LiteralPath $rel -Raw -Encoding utf8
  if ($rt -notmatch '(?m)^ownership:') { $errors += "GLS-005: relationships thieu ownership" }
  if ($rt -notmatch '(?m)^relationships:') { $errors += "GLS-005: relationships thieu relationships" }
  if ($rt -notmatch '(?m)^main_flow:') { $errors += "GLS-005: relationships thieu main_flow" }
}

# ---------- GLS-006: CATALOG.md + README + RULES ----------
foreach ($f in @('CATALOG.md','README.md','RULES.md')) {
  if (-not (Test-Path (Join-Path $glossaryDir $f))) { $errors += "GLS-006: thieu $f" }
}

# ---------- GLS-007: schema + changelog ----------
foreach ($f in @('glossary.schema.json','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $glossaryDir $f))) { $errors += "GLS-007: thieu $f" }
}

# ---------- GLS-008: frontmatter ----------
foreach ($t in $terms) {
  $f = Join-Path $termsDir "$t.md"
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  if ($text -notmatch '^---\r?\n') { $warnings += "GLS-008: $t.md thieu frontmatter" }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Glossary Validation (D002 Domain Model) ==="
  "term files: $($terms.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
