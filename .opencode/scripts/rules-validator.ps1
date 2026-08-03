# rules-validator.ps1
# Validator cho Rules (D004)
# Checks RUL-001..007 (13 rule files, template, architecture.yaml, INDEX)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Architecture Rules.
.DESCRIPTION
  Kiem tra docs/rules/ co du 13 rule files, template D004, architecture.yaml,
  INDEX.yaml, schema, changelog. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$rulesDir = Join-Path $root '..\docs\rules'

if (-not (Test-Path $rulesDir)) { Write-Error "rules/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- RUL-001: 13 rule files ----------
$rules = @(
  @{ id='RULE-001'; file='RULE-001-layering.md' },
  @{ id='RULE-002'; file='RULE-002-dependency.md' },
  @{ id='RULE-003'; file='RULE-003-communication.md' },
  @{ id='RULE-004'; file='RULE-004-execution.md' },
  @{ id='RULE-005'; file='RULE-005-state.md' },
  @{ id='RULE-006'; file='RULE-006-data-flow.md' },
  @{ id='RULE-007'; file='RULE-007-event.md' },
  @{ id='RULE-008'; file='RULE-008-security.md' },
  @{ id='RULE-009'; file='RULE-009-versioning.md' },
  @{ id='RULE-010'; file='RULE-010-extension.md' },
  @{ id='RULE-011'; file='RULE-011-resource-ownership.md' },
  @{ id='RULE-012'; file='RULE-012-failure-isolation.md' },
  @{ id='RULE-013'; file='RULE-013-deterministic-execution.md' }
)
foreach ($r in $rules) {
  if (-not (Test-Path (Join-Path $rulesDir $r.file))) {
    $errors += "RUL-001: missing rule file $($r.file)"
  }
}

# ---------- RUL-002: template ----------
$template = @('id','name','status','version','category','statement','purpose',
  'rules','constraints','examples','related_principles','related_rules','verification')
foreach ($r in $rules) {
  $f = Join-Path $rulesDir $r.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in $template) {
    if ($text -notmatch "(?m)^$field\s*:") { $errors += "RUL-002: $($r.file) thieu field '$field'" }
  }
  if ($text -notmatch "(?m)^id:\s*$($r.id)\b") { $errors += "RUL-002: $($r.file) id phai la $($r.id)" }
  if ($text -notmatch '(?m)^  allowed:') { $errors += "RUL-002: $($r.file) thieu constraints.allowed" }
  if ($text -notmatch '(?m)^  forbidden:') { $errors += "RUL-002: $($r.file) thieu constraints.forbidden" }
}

# ---------- RUL-003: architecture.yaml ----------
$arch = Join-Path $rulesDir 'architecture.yaml'
if (-not (Test-Path $arch)) {
  $errors += "RUL-003: missing architecture.yaml"
} else {
  $at = Get-Content -LiteralPath $arch -Raw -Encoding utf8
  if ($at -notmatch '(?m)^layers:') { $errors += "RUL-003: architecture.yaml thieu 'layers:'" }
  foreach ($layer in @('Presentation','Command','Workflow','Runtime','Capability','Registry','Agent','Skill','Infrastructure')) {
    if ($at -notmatch [regex]::Escape($layer)) { $errors += "RUL-003: architecture.yaml thieu layer '$layer'" }
  }
  if ($at -notmatch '(?m)^layer_order:') { $warnings += "RUL-003: thieu layer_order" }
  if ($at -notmatch '(?m)^term_layer:') { $warnings += "RUL-003: thieu term_layer" }
}

# ---------- RUL-004: INDEX.yaml ----------
$index = Join-Path $rulesDir 'INDEX.yaml'
if (-not (Test-Path $index)) {
  $errors += "RUL-004: missing INDEX.yaml"
} else {
  $it = Get-Content -LiteralPath $index -Raw -Encoding utf8
  if ($it -notmatch '(?m)^rules:') { $errors += "RUL-004: INDEX.yaml thieu 'rules:'" }
  if ($it -notmatch '(?m)^dependencies:') { $errors += "RUL-004: INDEX.yaml thieu 'dependencies:'" }
  foreach ($r in $rules) {
    if ($it -notmatch [regex]::Escape($r.id)) { $warnings += "RUL-004: INDEX.yaml thieu $($r.id)" }
  }
}

# ---------- RUL-005: README + schema + changelog ----------
foreach ($f in @('README.md','rules.schema.json','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $rulesDir $f))) { $errors += "RUL-005: thieu $f" }
}

# ---------- RUL-006: frontmatter ----------
foreach ($r in $rules) {
  $f = Join-Path $rulesDir $r.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  if ($text -notmatch '^---\r?\n') { $warnings += "RUL-006: $($r.file) thieu frontmatter" }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Rules Validation (D004) ==="
  "rule files: $($rules.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
