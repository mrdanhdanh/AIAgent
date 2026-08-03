# manifest-validator.ps1
# Validator cho Manifest v1.0 Enterprise
# Checks MNF-001..006 (top-level fields, schema.json, architecture_style, scope, goals)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Manifest.
.DESCRIPTION
  Kiem tra AIOS_MANIFEST.yaml co du fields chinh, schema.json ton tai.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$manifestDir   = Join-Path $root '..\docs\manifest'
$manifestFile  = Join-Path $manifestDir 'AIOS_MANIFEST.yaml'
$schemaFile    = Join-Path $manifestDir 'manifest.schema.json'

if (-not (Test-Path $manifestFile)) { Write-Error "AIOS_MANIFEST.yaml not found"; exit 1 }

$errors   = @()
$warnings = @()

$text = Get-Content -LiteralPath $manifestFile -Raw -Encoding utf8

# ---------- MNF-001: top-level fields ----------
$top = @('id','name','identity','kind','apiVersion','manifestVersion','specVersion',
  'constitution','version','status','maturity','mission','vision','scope','goals',
  'design_values','quality_attributes','architecture_style','source_of_truth',
  'deliverables','core_principles','repository','lifecycle','compatibility',
  'governance','owners','license','created','updated')
foreach ($f in $top) {
  if ($text -notmatch "(?m)^$f\s*:") { $errors += "MNF-001: thieu field '$f'" }
}

# ---------- MNF-002: principles P001-P020 ----------
for ($i = 1; $i -le 20; $i++) {
  $p = "P{0:D3}" -f $i
  if ($text -notmatch [regex]::Escape($p)) { $warnings += "MNF-002: thieu principle $p trong manifest" }
}

# ---------- MNF-003: id la AIOS ----------
if ($text -notmatch '(?m)^id:\s*AIOS') { $errors += "MNF-003: id phai la AIOS" }

# ---------- MNF-004: architecture_style ----------
if ($text -notmatch '(?m)^architecture_style:') { $errors += "MNF-004: thieu architecture_style" }
foreach ($style in @('Layered','Event Driven','Metadata Driven','Capability Driven','Plugin Oriented','Contract First')) {
  if ($text -notmatch [regex]::Escape($style)) { $warnings += "MNF-004: thieu style '$style'" }
}

# ---------- MNF-005: scope included/excluded ----------
if ($text -notmatch '(?m)^scope:\s*$') { $errors += "MNF-005: scope phai la object" }
if ($text -notmatch '(?m)^\s+included:') { $errors += "MNF-005: scope thieu 'included'" }
if ($text -notmatch '(?m)^\s+excluded:') { $errors += "MNF-005: scope thieu 'excluded'" }

# ---------- MNF-006: goals khong tham chieu P0xx ----------
$goalsSection = $text -split '(?m)^goals:'
if ($goalsSection.Count -ge 2) {
  $goalsText = ($goalsSection[1] -split '(?m)^design_values:')[0]
  if ($goalsText -match '\bP\d{3}\b') { $errors += "MNF-006: goals khong duoc tham chieu Principle" }
}

# ---------- MNF-007: schema.json + README + CHANGELOG ----------
foreach ($f in @('manifest.schema.json','README.md','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $manifestDir $f))) { $errors += "MNF-007: thieu $f" }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Manifest Validation (v1.0 Enterprise) ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
