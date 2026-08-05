# principles-validator.ps1
# Validator cho Principles (D003 + D003.5)
# Checks PRN-001..008 (20 files, template executable, policy engine files)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Constitution Principles.
.DESCRIPTION
  Kiem tra 20 principle files P001-P020, template Policy Engine, INDEX/registry/
  categories/dependencies/enforcement.yaml. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$prinDir = Join-Path $root '..\docs\principles'

if (-not (Test-Path $prinDir)) { Write-Error "principles/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- PRN-001: 20 principle files ----------
$principles = @(
  @{ id='P001'; file='P001-runtime-first.md' },
  @{ id='P002'; file='P002-contract-first.md' },
  @{ id='P003'; file='P003-metadata-first.md' },
  @{ id='P004'; file='P004-everything-is-versioned.md' },
  @{ id='P005'; file='P005-event-driven.md' },
  @{ id='P006'; file='P006-stateless-agent.md' },
  @{ id='P007'; file='P007-capability-driven.md' },
  @{ id='P008'; file='P008-single-responsibility.md' },
  @{ id='P009'; file='P009-single-source-of-truth.md' },
  @{ id='P010'; file='P010-immutable-artifact.md' },
  @{ id='P011'; file='P011-explicit-dependency.md' },
  @{ id='P012'; file='P012-plugin-first.md' },
  @{ id='P013'; file='P013-simulation-before-execution.md' },
  @{ id='P014'; file='P014-observability-first.md' },
  @{ id='P015'; file='P015-fail-safe.md' },
  @{ id='P016'; file='P016-human-approval.md' },
  @{ id='P017'; file='P017-ai-native.md' },
  @{ id='P018'; file='P018-evolvable.md' },
  @{ id='P019'; file='P019-open-extension-closed-core.md' },
  @{ id='P020'; file='P020-constitution-first.md' }
)
foreach ($p in $principles) {
  if (-not (Test-Path (Join-Path $prinDir $p.file))) {
    $errors += "PRN-001: missing $($p.file)"
  }
}

# ---------- PRN-002: template executable fields ----------
$template = @('id','name','status','version','since','category','priority','normative',
  'breaking_change','owner','requires_adr','lifecycle','rationale_type','affects',
  'verification','violation','formal_rule','decision','requires','conflicts',
  'strengthens','enforced_by','implemented_in','related','statement','rationale',
  'rules','implications','anti_patterns','exceptions','examples','references')
foreach ($p in $principles) {
  $f = Join-Path $prinDir $p.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in $template) {
    if ($text -notmatch "(?m)^$field\s*:") { $errors += "PRN-002: $($p.file) thieu field '$field'" }
  }
  if ($text -notmatch "(?m)^id:\s*$($p.id)\b") { $errors += "PRN-002: $($p.file) id phai la $($p.id)" }
  if ($text -notmatch '(?m)^formal_rule:') { $warnings += "PRN-002: $($p.file) thieu formal_rule" }
}

# ---------- PRN-003: decision + violation ----------
foreach ($p in $principles) {
  $f = Join-Path $prinDir $p.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  if ($text -notmatch '(?m)^decision:\s*$') { $errors += "PRN-003: $($p.file) thieu decision" }
  if ($text -notmatch '(?m)^  mandatory:') { $errors += "PRN-003: $($p.file) thieu decision.mandatory" }
  if ($text -notmatch '(?m)^violation:\s*$') { $errors += "PRN-003: $($p.file) thieu violation" }
  if ($text -notmatch '(?m)^  level:') { $errors += "PRN-003: $($p.file) thieu violation.level" }
}

# ---------- PRN-004: policy engine files ----------
foreach ($f in @('INDEX.yaml','registry.yaml','categories.yaml','dependencies.yaml','enforcement.yaml')) {
  if (-not (Test-Path (Join-Path $prinDir $f))) { $errors += "PRN-004: thieu $f" }
}

# ---------- PRN-005: INDEX co 20 P ----------
$index = Join-Path $prinDir 'INDEX.yaml'
if (Test-Path $index) {
  $it = Get-Content -LiteralPath $index -Raw -Encoding utf8
  foreach ($p in $principles) {
    if ($it -notmatch [regex]::Escape($p.id)) { $errors += "PRN-005: INDEX.yaml thieu $($p.id)" }
  }
  if ($it -notmatch '(?m)^principles:') { $errors += "PRN-005: INDEX.yaml thieu 'principles:'" }
}

# ---------- PRN-006: registry + categories + dependencies + enforcement ----------
$reg = Get-Content -LiteralPath (Join-Path $prinDir 'registry.yaml') -Raw -Encoding utf8
if ($reg -notmatch '(?m)^principles:') { $errors += "PRN-006: registry.yaml thieu 'principles:'" }
foreach ($p in $principles) { if ($reg -notmatch [regex]::Escape($p.id)) { $warnings += "PRN-006: registry.yaml thieu $($p.id)" } }

$cat = Get-Content -LiteralPath (Join-Path $prinDir 'categories.yaml') -Raw -Encoding utf8
if ($cat -notmatch '(?m)^categories:') { $errors += "PRN-006: categories.yaml thieu 'categories:'" }

$dep = Get-Content -LiteralPath (Join-Path $prinDir 'dependencies.yaml') -Raw -Encoding utf8
if ($dep -notmatch '(?m)^requires:') { $errors += "PRN-006: dependencies.yaml thieu 'requires:'" }
if ($dep -notmatch '(?m)^conflicts:') { $errors += "PRN-006: dependencies.yaml thieu 'conflicts:'" }
if ($dep -notmatch '(?m)^strengthens:') { $errors += "PRN-006: dependencies.yaml thieu 'strengthens:'" }

$enf = Get-Content -LiteralPath (Join-Path $prinDir 'enforcement.yaml') -Raw -Encoding utf8
if ($enf -notmatch '(?m)^doctor:') { $errors += "PRN-006: enforcement.yaml thieu 'doctor:'" }
if ($enf -notmatch '(?m)^runtime:') { $errors += "PRN-006: enforcement.yaml thieu 'runtime:'" }
if ($enf -notmatch '(?m)^validator:') { $errors += "PRN-006: enforcement.yaml thieu 'validator:'" }

# ---------- PRN-007: README + schema + changelog ----------
foreach ($f in @('README.md','principles.schema.json','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $prinDir $f))) { $errors += "PRN-007: thieu $f" }
}

# ---------- PRN-008: frontmatter ----------
foreach ($p in $principles) {
  $f = Join-Path $prinDir $p.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  if ($text -notmatch '^---\r?\n') { $warnings += "PRN-008: $($p.file) thieu frontmatter" }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Principles Validation (D003 + D003.5 Policy Engine) ==="
  "principle files: $($principles.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
