# glossary-validator.ps1
# Validator cho Glossary (D002)
# Checks GLS-001..006 (16 term files, template, RULES.md, relationships)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Glossary.
.DESCRIPTION
  Kiem tra docs/glossary/ co du 16 term files, template D002, RULES.md.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$glossaryDir = Join-Path $root '..\docs\glossary'

if (-not (Test-Path $glossaryDir)) { Write-Error "glossary/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- GLS-001: 16 term files ----------
$terms = @('runtime','workflow','phase','task','capability','agent',
  'skill','command','artifact','context','memory','knowledge',
  'event','registry','plugin','contract')
foreach ($t in $terms) {
  if (-not (Test-Path (Join-Path $glossaryDir "$t.md"))) {
    $errors += "GLS-001: missing term file $t.md"
  }
}

# ---------- GLS-002: template fields per file ----------
$template = @('id','name','status','category','summary','definition','purpose',
  'responsibilities','does_not_responsible','owned_by','used_by',
  'inputs','outputs','lifecycle','related','examples','references')
foreach ($t in $terms) {
  $f = Join-Path $glossaryDir "$t.md"
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in $template) {
    if ($text -notmatch "(?m)^$field\s*:") { $errors += "GLS-002: $t.md thieu field '$field'" }
  }
}

# ---------- GLS-003: owned_by / used_by / related day du ----------
foreach ($t in $terms) {
  $f = Join-Path $glossaryDir "$t.md"
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in @('owned_by','used_by','related')) {
    if ($text -notmatch "(?m)^$field\s*:\s*\S") { $warnings += "GLS-003: $t.md field '$field' trong (mo ta quan he)" }
  }
}

# ---------- GLS-004: RULES.md ----------
if (-not (Test-Path (Join-Path $glossaryDir 'RULES.md'))) {
  $errors += "GLS-004: missing RULES.md"
}

# ---------- GLS-005: README.md ----------
if (-not (Test-Path (Join-Path $glossaryDir 'README.md'))) {
  $errors += "GLS-005: missing README.md"
}

# ---------- GLS-006: frontmatter ----------
foreach ($t in $terms) {
  $f = Join-Path $glossaryDir "$t.md"
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  if ($text -notmatch '^---\r?\n') { $warnings += "GLS-006: $t.md thieu frontmatter '---'" }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Glossary Validation (D002) ==="
  "term files: $($terms.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
