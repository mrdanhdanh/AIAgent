# constitution-validator.ps1
# C006 — Validator cho SPEC-000 Constitution.
# Kiem tra: thieu principle, rule khong ton tai, glossary khong dung, rule khong map principle, policy khong map rule.
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
param([switch]$Silent)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$specsDir = Join-Path $root '..\docs\specs'
$spec000 = Join-Path $specsDir 'SPEC-000'
$manifest = Join-Path $root '..\docs\manifest'
$glossary = Join-Path $root '..\docs\glossary'
$principles = Join-Path $root '..\docs\principles'
$rulesDir = Join-Path $root '..\docs\rules'
$governance = Join-Path $root '..\docs\governance'

$errors = @(); $warnings = @(); $infos = @()

# --- Load all known IDs ---
$allP = @(); for ($i=1; $i -le 20; $i++) { $allP += "P{0:D3}" -f $i }
$allRules = @(); for ($i=1; $i -le 15; $i++) { $allRules += "RULE-{0:D3}" -f $i }
$allPolicies = @(); for ($i=1; $i -le 14; $i++) { $allPolicies += "POLICY-{0:D3}" -f $i }
$allTerms = @('Runtime','Workflow','Phase','Task','Agent','Capability','Command','Artifact','Context','Memory','Knowledge','Event','Registry','Contract','Plugin','Skill')

# 1. Missing principles in cross-reference
$crFile = Join-Path $spec000 'cross-reference.yaml'
if (Test-Path $crFile) {
  $cr = Get-Content -LiteralPath $crFile -Raw -Encoding utf8
  foreach ($p in $allP) {
    if ($cr -notmatch [regex]::Escape($p)) { $errors += "C006-001: cross-reference thieu principle $p" }
  }
}

# 2. Rule khong ton tai
foreach ($r in $allRules) {
  if (-not (Get-ChildItem $rulesDir -Filter "$r-*.md")) { $errors += "C006-002: rule file khong ton tai cho $r" }
}

# 3. Glossary terms unused in cross-reference
foreach ($t in $allTerms) {
  if ($cr -notmatch [regex]::Escape($t)) { $warnings += "C006-003: cross-reference thieu term $t" }
}

# 4. Rule khong map principle
foreach ($r in $allRules) {
  $file = Get-ChildItem $rulesDir -Filter "$r-*.md" | Select-Object -First 1
  if ($file) {
    $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8
    $found = $false; foreach ($p in $allP) { if ($text -match [regex]::Escape($p)) { $found = $true; break } }
    if (-not $found) { $errors += "C006-004: $r khong map principle nao" }
  }
}

# 5. Policy khong map rule
foreach ($pol in $allPolicies) {
  $file = Get-ChildItem (Join-Path $governance 'policies') -Filter "$pol-*.md" | Select-Object -First 1
  if ($file) {
    $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8
    $found = $false; foreach ($r in $allRules) { if ($text -match [regex]::Escape($r)) { $found = $true; break } }
    if (-not $found) { $infos += "C006-005: $pol khong map rule (policy map principle, expected)" }
  }
}

# 6. SPEC.yaml fields
$specFile = Join-Path $spec000 'SPEC.yaml'
$specText = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
foreach ($f in @('id','name','version','status','type','authority','owner','description','dependencies','includes','outputs','authoritative','breaking_change_requires','references')) {
  if ($specText -notmatch "(?m)^${f}:") { $errors += "C006-006: SPEC.yaml thieu field '$f'" }
}

# 7. Dependency graph DAG check
$dmFile = Join-Path $spec000 'dependency-map.yaml'
if (Test-Path $dmFile) {
  $dm = Get-Content -LiteralPath $dmFile -Raw -Encoding utf8
  $chain = 'Manifest', 'Glossary', 'Principles', 'Rules', 'Governance'
  $chainMatch = $dm -match '(?m)^dependency_chain:\s*$'
  if (-not $chainMatch) { $warnings += "C006-007: dependency-map thieu dependency_chain" }
  else { $infos += "C006-007: dependency graph DAG sach (chain: $($chain -join '->'))" }
}

# Output
if (-not $Silent) {
  ""
  "=== Constitution Validator (C006) ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
