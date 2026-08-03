# rules-validator.ps1
# Validator cho Rules (D004)
# Checks RUL-001..005 (6 rule files, INDEX.yaml, schema, changelog)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Architecture Rules.
.DESCRIPTION
  Kiem tra docs/rules/ co du 6 rule files, INDEX.yaml, schema, changelog.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$rulesDir = Join-Path $root '..\docs\rules'

if (-not (Test-Path $rulesDir)) { Write-Error "rules/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- RUL-001: 6 rule files ----------
$rules = @('layering','dependency','communication','versioning','state','security')
foreach ($r in $rules) {
  if (-not (Test-Path (Join-Path $rulesDir "$r.md"))) {
    $errors += "RUL-001: missing rule file $r.md"
  }
}

# ---------- RUL-002: frontmatter ----------
foreach ($r in $rules) {
  $f = Join-Path $rulesDir "$r.md"
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  if ($text -notmatch '^---\r?\n') { $warnings += "RUL-002: $r.md thieu frontmatter" }
  if ($text -notmatch "(?m)^name:\s*rule-") { $warnings += "RUL-002: $r.md thieu name 'rule-*'" }
}

# ---------- RUL-003: README.md ----------
if (-not (Test-Path (Join-Path $rulesDir 'README.md'))) {
  $errors += "RUL-003: missing README.md"
}

# ---------- RUL-004: INDEX.yaml ----------
$index = Join-Path $rulesDir 'INDEX.yaml'
if (-not (Test-Path $index)) {
  $errors += "RUL-004: missing INDEX.yaml"
} else {
  $it = Get-Content -LiteralPath $index -Raw -Encoding utf8
  if ($it -notmatch '(?m)^rules:') { $errors += "RUL-004: INDEX.yaml thieu 'rules:'" }
  foreach ($r in @('R-LAYER','R-DEP','R-COMM','R-VER','R-STATE','R-SEC')) {
    if ($it -notmatch [regex]::Escape($r)) { $warnings += "RUL-004: INDEX.yaml thieu $r" }
  }
}

# ---------- RUL-005: schema + changelog ----------
foreach ($f in @('rules.schema.json','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $rulesDir $f))) { $errors += "RUL-005: thieu $f" }
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
