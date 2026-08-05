# doctor-validator.ps1
# Validator cho Phase 8 — Doctor v2 (Framework Diagnostics Platform)
# Checks DOC-001..006 (cấu trúc doctor/)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate Doctor v2 structure + schema + rules.
.DESCRIPTION
  Kiểm tra doctor.schema.yaml, rules/rules.yaml, analyzers/, scoring/,
  validators/ và các module tồn tại đủ. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$docDir = Join-Path $root 'doctor'

if (-not (Test-Path $docDir)) { Write-Error "doctor/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- DOC-001: schema ----------
foreach ($f in @('doctor.schema.yaml')) {
  if (-not (Test-Path (Join-Path $docDir $f))) {
    $errors += "DOC-001: missing $f"
  }
}

# ---------- DOC-002: schema required fields ----------
$schemaFile = Join-Path $docDir 'doctor.schema.yaml'
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  foreach ($req in @('id','timestamp','mode','scores','recommendation')) {
    if ($sText -notmatch "(?m)^  - $req\b") {
      $errors += "DOC-002: doctor.schema.yaml thieu required field '$req'"
    }
  }
  if ($sText -notmatch 'technical_debt') { $warnings += "DOC-002: schema thieu technical_debt" }
  if ($sText -notmatch 'readiness') { $warnings += "DOC-002: schema thieu readiness" }
}

# ---------- DOC-003: modules ----------
$modules = @('README.md','architecture.md','engine.md','health.md','behavior.md',
  'coverage.md','metrics.md')

foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $docDir $m))) {
    $errors += "DOC-003: missing module $m"
  }
}

# ---------- DOC-004: analyzers ----------
$analyzers = @('static','behavioral','runtime','coverage')
foreach ($a in $analyzers) {
  if (-not (Test-Path (Join-Path $docDir "analyzers\$a.md"))) {
    $errors += "DOC-004: missing analyzer $a.md"
  }
}

# ---------- DOC-005: rules ----------
$rulesFile = Join-Path $docDir 'rules\rules.yaml'
if (-not (Test-Path $rulesFile)) {
  $errors += "DOC-005: missing rules/rules.yaml"
} else {
  $rText = Get-Content -LiteralPath $rulesFile -Raw
  $ruleCount = @([regex]::Matches($rText, '(?m)^  - id:')).Count
  if ($ruleCount -eq 0) { $errors += "DOC-005: rules.yaml khong co rule nao" }
  $rulesCount = $ruleCount
}

# ---------- DOC-006: scoring + validators + reports ----------
foreach ($d in @('scoring','validators','reports')) {
  if (-not (Test-Path (Join-Path $docDir $d))) {
    $errors += "DOC-006: missing dir $d/"
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Doctor v2 Validation (Phase 8) ==="
  "rules: $($rulesCount) | analyzers: $($analyzers.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }