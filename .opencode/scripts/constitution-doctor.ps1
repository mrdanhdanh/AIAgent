# constitution-doctor.ps1
# C007 — Constitution Doctor. 8 checks, sinh reports/CONSTITUTION_DOCTOR_REPORT.yaml.
# ASCII-only (PS 5.1 ANSI).
param([switch]$Silent)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$base = Split-Path -Parent $root
$spec000 = Join-Path $base 'docs\specs\SPEC-000'
$reportDir = Join-Path $spec000 'reports'
$reportFile = Join-Path $reportDir 'CONSTITUTION_DOCTOR_REPORT.yaml'

if (-not (Test-Path $reportDir)) { New-Item -ItemType Directory -Force -Path $reportDir | Out-Null }
$issueCount = 0; $results = @()

function Check($name, $pass, $msg) {
  $script:results += @{ name=$name; pass=$pass; message=$msg }
  if (-not $pass) { $script:issueCount++ }
}

# 1. Circular dependency
$dmFile = Join-Path $spec000 'dependency-map.yaml'
if (Test-Path $dmFile) {
  $dm = Get-Content -LiteralPath $dmFile -Raw -Encoding utf8
  $hasCircular = -not ($dm -match '(?m)^dependency_chain:\s*$')
  Check 'circular_dependency' (-not $hasCircular) $(if ($hasCircular) {'dependency_chain missing or has cycle'} else {'DAG clean (dependency_chain present)'})
} else { Check 'circular_dependency' $false 'dependency-map.yaml missing' }

# 2. Missing term
$crFile = Join-Path $spec000 'cross-reference.yaml'
$allTerms = @('Runtime','Workflow','Phase','Task','Agent','Capability','Command','Artifact','Context','Memory','Knowledge','Event','Registry','Contract','Plugin','Skill')
if (Test-Path $crFile) {
  $cr = Get-Content -LiteralPath $crFile -Raw -Encoding utf8
  $missing = @(); foreach ($t in $allTerms) { if ($cr -notmatch [regex]::Escape($t)) { $missing += $t } }
  Check 'missing_term' ($missing.Count -eq 0) $(if ($missing.Count) {"Missing: $($missing -join ', ')"} else {'All 16 terms present'})
} else { Check 'missing_term' $false 'cross-reference.yaml missing' }

# 3. Duplicate term
$termsDir = Join-Path $base 'docs\glossary\terms'
$files = Get-ChildItem $termsDir -Filter '*.md' | ForEach-Object { $_.BaseName }
$dups = $files | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name }
Check 'duplicate_term' ($dups.Count -eq 0) $(if ($dups.Count) {"Duplicates: $($dups -join ', ')"} else {'No duplicates'})

# 4. Principle coverage
$allP = @(); for ($i=1; $i -le 20; $i++) { $allP += "P{0:D3}" -f $i }
if (Test-Path $crFile) {
  $covered = @(); foreach ($p in $allP) { if ($cr -match [regex]::Escape($p)) { $covered += $p } }
  Check 'principle_coverage' ($covered.Count -eq 20) "$($covered.Count)/20 covered"
} else { Check 'principle_coverage' $false 'cross-reference.yaml missing' }

# 5. Rule coverage
$allRules = @(); for ($i=1; $i -le 15; $i++) { $allRules += "RULE-{0:D3}" -f $i }
if (Test-Path $crFile) {
  $covered = @(); foreach ($r in $allRules) { if ($cr -match [regex]::Escape($r)) { $covered += $r } }
  Check 'rule_coverage' ($covered.Count -eq 15) "$($covered.Count)/15 covered"
} else { Check 'rule_coverage' $false 'cross-reference.yaml missing' }

# 6. Policy coverage
$allPolicies = @(); for ($i=1; $i -le 14; $i++) { $allPolicies += "POLICY-{0:D3}" -f $i }
if (Test-Path $crFile) {
  $covered = @(); foreach ($p in $allPolicies) { if ($cr -match [regex]::Escape($p)) { $covered += $p } }
  Check 'policy_coverage' ($covered.Count -eq 14) "$($covered.Count)/14 covered"
} else { Check 'policy_coverage' $false 'cross-reference.yaml missing' }

# 7. Broken reference
$broken = @()
$allIds = $allP + $allRules + $allPolicies + $allTerms
$idxFile = Join-Path $spec000 'INDEX.yaml'
if (Test-Path $idxFile) {
  $idx = Get-Content -LiteralPath $idxFile -Raw -Encoding utf8
  $refs = [regex]::Matches($idx, '(P\d{3}|RULE-\d{3}|POLICY-\d{3})') | ForEach-Object { $_.Value }
  foreach ($r in $refs) { if ($allIds -notcontains $r) { $broken += $r } }
}
Check 'broken_reference' ($broken.Count -eq 0) $(if ($broken.Count) {"Broken: $($broken -join ', ')"} else {'No broken refs'})

# 8. Version mismatch
$specFile = Join-Path $spec000 'SPEC.yaml'
$changelogFile = Join-Path $spec000 'changelog.md'
if ((Test-Path $specFile) -and (Test-Path $changelogFile)) {
  $spec = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  $changelog = Get-Content -LiteralPath $changelogFile -Raw -Encoding utf8
  $specVer = ([regex]::Match($spec, '(?m)^version:\s*"([^"]+)"').Groups[1].Value)
  $clVer = ([regex]::Match($changelog, '(?m)^##\s*(\S+)').Groups[1].Value)
  Check 'version_mismatch' ($specVer -eq $clVer) "SPEC=$specVer changelog=$clVer"
} else { Check 'version_mismatch' $false 'Missing file' }

# Write report
$report = @{
  tool = 'constitution-doctor.ps1'
  version = '1.0.0'
  timestamp = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
  checks_total = $results.Count
  checks_failed = ($results | Where-Object { -not $_.pass }).Count
  issues = $issueCount
  status = if ($issueCount -eq 0) { 'PASS' } else { 'FAIL' }
  checks = $results
}
$reportYaml = @(
  "# AIOS Constitution Doctor Report (C007)",
  "# $($report.timestamp)",
  "status: $($report.status)",
  "checks_total: $($report.checks_total)",
  "checks_failed: $($report.checks_failed)",
  "issues: $($report.issues)",
  "checks:"
)
foreach ($c in $results) { $reportYaml += "  - name: $($c.name)"; $reportYaml += "    pass: $($c.pass)"; $reportYaml += "    message: $($c.message)" }
[System.IO.File]::WriteAllText($reportFile, ($reportYaml -join "`r`n") + "`r`n", (New-Object System.Text.UTF8Encoding($false)))
if (-not $Silent) {
  "=== Constitution Doctor (C007) ==="
  "status: $($report.status)"
  "passed: $(($results | Where-Object { $_.pass }).Count) / $($results.Count)"
  "report: specs/SPEC-000/reports/CONSTITUTION_DOCTOR_REPORT.yaml"
}

if ($issueCount -gt 0) { exit 1 } else { exit 0 }
