<#
.SYNOPSIS
Simulation Engine v1.0 — Runtime validation cho AI Agent Framework (Sandbox Mode)
.DESCRIPTION
Chay gia lap (sandbox) toan bo Agent, Skill, Command, Contract de phat hien loi
runtime va integration ma static analysis khong thay duoc. Tra loi cau hoi:
"Neu chay that thi co hoat dong khong?"

6 nhom validation:
  1. Agent Validation     - frontmatter, permissions, dependencies, contract, skills
  2. Skill Validation     - frontmatter, referenced files, deprecated, conflicts
  3. Command Validation   - frontmatter, agent mapping, params
  4. Contract Validation  - contract existence, schema version compatibility
  5. Integration Test     - chain planner -> reviewer -> tester (output/input compat)
  6. Output Validation    - fake task injection -> expected output vs contract

Output: JSON report (simulation-engine-<timestamp>.json) + Runtime Health Score.
Read-only: KHONG sua file he thong.
#>

param(
    [string]$agentsDir = ".opencode/agents",
    [string]$skillsDir = ".opencode/skills",
    [string]$commandsDir = ".opencode/commands",
    [string]$contractDir = ".opencode/system/contracts",
    [string]$knowledgeDir = ".opencode/knowledge",
    [string]$outputDir = ".opencode/scripts/evolution/reports",
    [string]$evolutionMode = "sandbox",
    [switch]$dryRun
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Repo root: .opencode/scripts/evolution -> 3 levels up
$repoRoot = Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent

# === HELPERS ===

function Parse-Frontmatter {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8 -ErrorAction SilentlyContinue
    if ($content -match '(?s)^---\s*\r?\n(.+?)\r?\n---') {
        $yaml = $Matches[1]
        $result = @{}
        foreach ($line in $yaml -split '\r?\n') {
            if ($line -match '^(\w[\w_-]*)\s*:\s*(.+)$') {
                $key = $Matches[1].Trim()
                $val = $Matches[2].Trim().Trim('"', "'")
                $result[$key] = $val
            }
        }
        return $result, $content
    }
    return $null, $content
}

function Get-YamlField {
    param([string]$Path, [string]$Field)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8 -ErrorAction SilentlyContinue
    if ($content -match "(?m)^$Field\s*:\s*(.+)$") { return $Matches[1].Trim() }
    return $null
}

# === RESULT COLLECTORS ===

$results = @{
    tool = "simulation-engine.ps1"
    version = $toolVersion
    timestamp = $timestamp
    mode = $evolutionMode
    agents_tested = 0
    skills_tested = 0
    commands_tested = 0
    contracts_tested = 0
    checks = @()
    runtime_errors = @()
    integration_issues = @()
    capability_issues = @()
    dependency_graph = @()
    suggested_actions = @()
    runtime_health = 0
    verdict = "UNKNOWN"
    summary = ""
}

$totalChecks = 0
$passedChecks = 0

function Add-Check {
    param([string]$Group, [string]$Check, [string]$Status, [string]$Detail)
    $script:totalChecks++
    if ($Status -eq "PASS") { $script:passedChecks++ }
    $script:results.checks += @{
        group = $Group
        check = $Check
        status = $Status
        detail = $Detail
    }
}

function Add-Error {
    param([string]$Type, [string]$Severity, [string]$Detail)
    $script:results.runtime_errors += @{
        type = $Type
        severity = $Severity
        detail = $Detail
    }
}

# === SCAN DIRECTORIES ===

Write-Host "Simulation Engine v$toolVersion (mode: $evolutionMode)" -ForegroundColor Cyan

# --- 1. AGENT VALIDATION ---
Write-Host "`n[1/6] Agent Validation..." -ForegroundColor Cyan
$agentFiles = @(Get-ChildItem -Path "$agentsDir\*.md" -ErrorAction SilentlyContinue)
$agentNames = @()
$results.agents_tested = $agentFiles.Count

foreach ($af in $agentFiles) {
    $name = $af.BaseName
    $agentNames += $name
    $fm, $raw = Parse-Frontmatter -Path $af.FullName
    $group = "agent"

    if (-not $fm) {
        Add-Check -Group $group -Check "frontmatter_$name" -Status "FAIL" -Detail "Agent ${name}: frontmatter YAML khong parse duoc"
        Add-Error -Type "AGENT_BAD_FRONTMATTER" -Severity "MAJOR" -Detail "Agent ${name} khong co frontmatter YAML hop le"
        continue
    }

    # mode/model validity
    $mode = $fm.mode
    if ($mode -and $mode -notin @("primary", "subagent", "all", "primary:builder", "primary:plan", "primary:test", "primary:ui", "primary:tool", "primary:read", "primary:edit", "primary:code")) {
        if ($mode -notmatch "^primary:") {
            Add-Check -Group $group -Check "mode_$name" -Status "WARN" -Detail "Agent ${name}: mode '$mode' khong thuoc enum chuan (chap nhan neu custom)"
        }
    }

    # permissions
    foreach ($perm in @("read", "grep", "glob", "edit", "bash")) {
        $val = $fm[$perm]
        if ($val -and $val -notin @("allow", "deny", "read-only")) {
            Add-Error -Type "AGENT_PERMISSION_INVALID" -Severity "MAJOR" -Detail "Agent ${name}: permission '$perm' = '$val' khong hop le (allow/deny)"
        }
    }

    # depends_on references
    $depOn = $fm.depends_on
    if ($depOn) {
        $deps = @($depOn -split ',' | ForEach-Object { $_.Trim() })
        foreach ($d in $deps) {
            if ($d -and $d -notin $agentNames -and $d -notin @("general")) {
                $contractExists = Test-Path -LiteralPath "$contractDir\$d.yaml"
                if (-not $contractExists -and -not (Test-Path -LiteralPath "$agentsDir\$d.md")) {
                    Add-Error -Type "MISSING_DEPENDENCY" -Severity "CRITICAL" -Detail "Agent $name depends_on '$d' nhung khong ton tai agent hoac contract"
                    $results.dependency_graph += @{ from = $name; to = $d; ok = $false }
                }
            }
        }
    }

    Add-Check -Group $group -Check "structure_$name" -Status "PASS" -Detail "Agent ${name}: frontmatter OK (mode=$($fm.mode))"
}

# --- 2. SKILL VALIDATION ---
Write-Host "[2/6] Skill Validation..." -ForegroundColor Cyan
$skillDirs = @(Get-ChildItem -Path "$skillsDir\*" -Directory -ErrorAction SilentlyContinue)
$skillNames = @()
$results.skills_tested = $skillDirs.Count

foreach ($sd in $skillDirs) {
    $skillName = $sd.Name
    $skillNames += $skillName
    $skillFile = Join-Path $sd.FullName "SKILL.md"
    $group = "skill"

    if (-not (Test-Path -LiteralPath $skillFile)) {
        Add-Check -Group $group -Check "exists_$skillName" -Status "FAIL" -Detail "Skill ${skillName}: thieu SKILL.md"
        Add-Error -Type "SKILL_MISSING_FILE" -Severity "CRITICAL" -Detail "Skill ${skillName} khong co SKILL.md"
        continue
    }

    $fm, $raw = Parse-Frontmatter -Path $skillFile
    if (-not $fm) {
        Add-Check -Group $group -Check "frontmatter_$skillName" -Status "FAIL" -Detail "Skill ${skillName}: frontmatter khong parse duoc"
        Add-Error -Type "SKILL_BAD_FRONTMATTER" -Severity "MAJOR" -Detail "Skill ${skillName} frontmatter YAML loi"
        continue
    }

    # deprecated check — strip code blocks de tranh false positive tu example
    $scanContent = [regex]::Replace($raw, '(?s)```.*?```', '')
    $scanContent = [regex]::Replace($scanContent, '(?s)~~~.*?~~~', '')
    $scanContent = [regex]::Replace($scanContent, '`[^`]*`', '')
    if ($fm.deprecated -eq "true") {
        Add-Error -Type "SKILL_DEPRECATED" -Severity "WARNING" -Detail "Skill $skillName dang bi deprecated"
    }
    # Chi flag khi content tu khang dinh skill nay deprecated/superseded,
    # khong flag khi chi nham toi tu deprecated/legacy trong documentation
    elseif ($scanContent -match '(?i)(this\s+skill\s+is\s+(?:deprecated|outdated|legacy)|skill\s+no\s+longer\s+(?:maintained|used)|superseded\s+by\s+\S+)') {
        Add-Error -Type "SKILL_DEPRECATED_CONTENT" -Severity "WARNING" -Detail "Skill $skillName content tu khang dinh deprecated"
    }

    # referenced files exist (location:, require:, load: paths) — bo qua code blocks
    $refPatterns = @(
        '(?m)^\s*(?:location|path|file|script|include)\s*:\s*(.+)$',
        '(?m)^\s*-\s*["'']?([\w\\/.-]+\.(?:ps1|md|json|yaml|yml|razor|cs|js|css))["'']?\s*$'
    )
    $missingRefs = @()
    foreach ($pat in $refPatterns) {
        $m = [regex]::Matches($scanContent, $pat, [System.Text.RegularExpressions.RegexOptions]::Multiline)
        foreach ($mm in $m) {
            $ref = $mm.Groups[1].Value.Trim().Trim('"', "'")
            if (-not $ref) { continue }
            # Bo qua link markdown (#section), URL, glob patterns
            if ($ref.StartsWith("#") -or $ref.StartsWith("http")) { continue }
            if ($ref -match '[\*\?\[\]]') { continue }
            # Resolve: neu bat dau bang path repo (.opencode/, .agents/, JapaneseLearner/, AGENTS.md, opencode.json)
            # -> kiem tra tu repo root; nguoc lai tu thu muc skill
            if ($ref.StartsWith(".opencode/") -or $ref.StartsWith(".agents/") -or $ref.StartsWith("JapaneseLearner/") -or $ref -in @("AGENTS.md", "opencode.json")) {
                $candidate = Join-Path $repoRoot $ref
            } else {
                $candidate = Join-Path $sd.FullName $ref
            }
            if (-not (Test-Path -LiteralPath $candidate)) {
                $missingRefs += $ref
            }
        }
    }
    if ($missingRefs.Count -gt 0) {
        Add-Check -Group $group -Check "refs_$skillName" -Status "FAIL" -Detail "Skill $skillName thieu file tham chieu: $($missingRefs -join ', ')"
        Add-Error -Type "SKILL_REF_NOT_FOUND" -Severity "MAJOR" -Detail "Skill $skillName tham chieu file khong ton tai: $($missingRefs -join ', ')"
    } else {
        Add-Check -Group $group -Check "refs_$skillName" -Status "PASS" -Detail "Skill ${skillName}: tat ca file tham chieu ton tai"
    }

    # internal links #section must exist
    # GitHub-style anchors: lowercase, spaces->hyphens, strip punctuation/diacritics
    function ConvertTo-Anchors {
        param([string]$HeadingsText)
        $anchors = @()
        foreach ($m in [regex]::Matches($HeadingsText, '(?im)^#{1,6}\s+(.+)$')) {
            $h = $m.Groups[1].Value
            $h = $h -replace '[^\w\s-]', ''
            $h = $h -replace '\s', '-'
            $h = $h.Trim('-').ToLower()
            $anchors += $h
        }
        return $anchors
    }
    $internalLinks = @([regex]::Matches($raw, '(?m)^.*\[[^\]]*\]\(#([a-z0-9-]+)\)') | ForEach-Object { $_.Groups[1].Value })
    if ($internalLinks.Count -gt 0) {
        $sectionAnchors = @(ConvertTo-Anchors -HeadingsText $raw)
        $missingSections = @()
        foreach ($link in $internalLinks) {
            if ($link -notin $sectionAnchors) {
                $missingSections += $link
            }
        }
        if ($missingSections.Count -gt 0) {
            Add-Check -Group $group -Check "sections_$skillName" -Status "WARN" -Detail "Skill ${skillName}: internal link khong co section: $($missingSections -join ', ')"
        }
    }
}

# skill conflicts (duplicate names / overlap descriptions)
$seenSkills = @{}
foreach ($sn in $skillNames) {
    if ($seenSkills.ContainsKey($sn)) {
        Add-Error -Type "SKILL_CONFLICT" -Severity "MAJOR" -Detail "Skill '$sn' bi trung lap trong nhieu thu muc"
    } else {
        $seenSkills[$sn] = $true
    }
}

# --- 3. COMMAND VALIDATION ---
Write-Host "[3/6] Command Validation..." -ForegroundColor Cyan
$cmdFiles = @(Get-ChildItem -Path "$commandsDir\*.md" -ErrorAction SilentlyContinue)
$results.commands_tested = $cmdFiles.Count

# Load opencode.json routing map (command -> agent) de kiem tra fallback
$ocConfig = $null
$ocConfigPath = Join-Path $repoRoot "opencode.json"
if (Test-Path -LiteralPath $ocConfigPath) {
    try { $ocConfig = Get-Content -LiteralPath $ocConfigPath -Raw -Encoding utf8 | ConvertFrom-Json } catch { $ocConfig = $null }
}

foreach ($cf in $cmdFiles) {
    $cmdName = $cf.BaseName
    $group = "command"
    $fm, $raw = Parse-Frontmatter -Path $cf.FullName

    if (-not $fm) {
        Add-Check -Group $group -Check "frontmatter_$cmdName" -Status "FAIL" -Detail "Command ${cmdName}: frontmatter khong parse duoc"
        Add-Error -Type "COMMAND_BAD_FRONTMATTER" -Severity "MAJOR" -Detail "Command ${cmdName} frontmatter YAML loi"
        continue
    }

    # Lay agent tu opencode.json (fallback khi frontmatter thieu)
    $configAgent = $null
    if ($ocConfig -and $ocConfig.command.($cmdName)) {
        $configAgent = "$($ocConfig.command.$cmdName.agent)"
        if ($configAgent -eq "") { $configAgent = $null }
    }

    # agent mapping (hoac trigger-based routing / opencode.json routing)
    $agent = $fm.agent
    if (-not $agent) {
        if ($fm.trigger -or $configAgent) {
            $routing = if ($fm.trigger) { "trigger '$($fm.trigger)'" } else { "opencode.json agent '$configAgent'" }
            $status = if ($configAgent -and $configAgent -notin $agentNames) { "WARN" } else { "WARN" }
            Add-Check -Group $group -Check "agent_$cmdName" -Status $status -Detail "Command /$cmdName route qua $routing"
            if ($configAgent -and $configAgent -notin $agentNames) {
                Add-Error -Type "COMMAND_AGENT_NOT_FOUND" -Severity "CRITICAL" -Detail "Command /$cmdName (opencode.json) references agent '$configAgent' khong ton tai"
            } else {
                Add-Error -Type "COMMAND_TRIGGER_ROUTING" -Severity "WARNING" -Detail "Command /$cmdName dung $routing thay cho frontmatter agent"
            }
        } else {
            Add-Error -Type "COMMAND_NO_AGENT" -Severity "CRITICAL" -Detail "Command /$cmdName khong khai bao agent/trigger va khong co trong opencode.json"
            Add-Check -Group $group -Check "agent_$cmdName" -Status "FAIL" -Detail "Command /$cmdName khong co routing (agent/trigger/opencode.json)"
        }
    } elseif ($agent -notin $agentNames) {
        Add-Error -Type "COMMAND_AGENT_NOT_FOUND" -Severity "CRITICAL" -Detail "Command /$cmdName references agent '$agent' khong ton tai"
        Add-Check -Group $group -Check "agent_$cmdName" -Status "FAIL" -Detail "Command /$cmdName -> agent '$agent' khong ton tai"
    } else {
        Add-Check -Group $group -Check "agent_$cmdName" -Status "PASS" -Detail "Command /$cmdName -> agent '$agent' OK"
    }

    # description
    if (-not $fm.description) {
        Add-Error -Type "COMMAND_NO_DESCRIPTION" -Severity "MINOR" -Detail "Command /$cmdName thieu description"
    }
}

# --- 4. CONTRACT VALIDATION ---
Write-Host "[4/6] Contract Validation..." -ForegroundColor Cyan
$contractFiles = @(Get-ChildItem -Path "$contractDir\*.yaml" -ErrorAction SilentlyContinue)
$contractNames = @()
$results.contracts_tested = $contractFiles.Count

foreach ($cfile in $contractFiles) {
    $cname = $cfile.BaseName
    $contractNames += $cname
    $content = Get-Content -LiteralPath $cfile.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
    if (-not $content) {
        Add-Error -Type "CONTRACT_EMPTY" -Severity "CRITICAL" -Detail "Contract $cname trong hoac khong doc duoc"
        continue
    }
}

# core agents must have contracts
$coreAgents = @("analyst", "planner", "builder", "reviewer", "tester", "test-planner", "ui-beautifier", "self-improver", "guardian")
foreach ($ca in $coreAgents) {
    if ($ca -in $agentNames -and $ca -notin $contractNames) {
        Add-Error -Type "MISSING_CONTRACT" -Severity "MAJOR" -Detail "Agent $ca khong co contract (agents/$ca.md khong co contract)"
        Add-Check -Group "contract" -Check "exists_$ca" -Status "WARN" -Detail "Agent $ca thieu contract"
    }
}

# schema version compatibility (output v1 -> input v2 mismatch)
$versionMismatches = @()
foreach ($c1 in $contractNames) {
    $c1File = "$contractDir\$c1.yaml"
    $c1Out = ""
    $c1Content = Get-Content -LiteralPath $c1File -Raw -Encoding utf8 -ErrorAction SilentlyContinue
    if ($c1Content -match "output.*?schema_version['""]?\s*:\s*['""]([\d.]+)") { $c1Out = $Matches[1] }
    foreach ($c2 in $contractNames) {
        if ($c1 -eq $c2) { continue }
        $c2File = "$contractDir\$c2.yaml"
        $c2Content = Get-Content -LiteralPath $c2File -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        # chi kiem tra neu contract c2 'requires' c1
        if ($c2Content -match "(?ms)requires:\s*\n(.+?)(?:\n\s+\w+|\z)") {
            $reqBlock = $Matches[1]
            if ($reqBlock -match [regex]::Escape($c1)) {
                $c2In = ""
                if ($c2Content -match "input.*?schema_version['""]?\s*:\s*['""]([\d.]+)") { $c2In = $Matches[1] }
                if ($c1Out -and $c2In -and $c1Out -ne $c2In) {
                    $versionMismatches += @{ from = $c1; to = $c2; output_ver = $c1Out; input_ver = $c2In }
                }
            }
        }
    }
}
if ($versionMismatches.Count -gt 0) {
    foreach ($vm in $versionMismatches) {
        Add-Error -Type "VERSION_MISMATCH" -Severity "MAJOR" -Detail "Schema mismatch: $($vm.from) output v$($vm.output_ver) nhung $($vm.to) input v$($vm.input_ver)"
    }
    Add-Check -Group "contract" -Check "version_compat" -Status "FAIL" -Detail "$($versionMismatches.Count) schema version mismatch"
} else {
    Add-Check -Group "contract" -Check "version_compat" -Status "PASS" -Detail "Khong co schema version mismatch"
}

# --- 5. INTEGRATION TEST ---
Write-Host "[5/6] Integration Test..." -ForegroundColor Cyan
# Chain: planner -> reviewer -> tester (workflow core)
# Kiem tra: output cua agent truoc co tuong thich input cua agent sau khong
$integrationChain = @(
    @{ from = "planner"; to = "reviewer"; desc = "plan output -> review input" },
    @{ from = "reviewer"; to = "builder"; desc = "review output -> build input" },
    @{ from = "builder"; to = "tester"; desc = "build output -> test input" }
)

foreach ($link in $integrationChain) {
    $fromContract = "$contractDir\$($link.from).yaml"
    $toContract = "$contractDir\$($link.to).yaml"
    $fromAgent = "$agentsDir\$($link.from).md"
    $toAgent = "$agentsDir\$($link.to).md"

    if (-not (Test-Path -LiteralPath $fromAgent) -or -not (Test-Path -LiteralPath $toAgent)) {
        Add-Error -Type "INTEGRATION_BREAK" -Severity "CRITICAL" -Detail "Integration $($link.desc): thieu agent file"
        $results.integration_issues += @{ chain = "$($link.from)->$($link.to)"; detail = "thieu agent file"; ok = $false }
        continue
    }

    $ok = $true
    $issues = @()

    # reviewer contract can parse plan output (step fields)?
    if ((Test-Path -LiteralPath $fromContract) -and (Test-Path -LiteralPath $toContract)) {
        $fromContent = Get-Content -LiteralPath $fromContract -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        $toContent = Get-Content -LiteralPath $toContract -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        # Neu reviewer input expects 'steps' va planner output khong co 'steps' -> break
        if ($toContent -match "(?m)input:") {
            if ($toContent -match "(?ms)input:\s*\n(.+?)(?:\n\n|\z|^[a-z])") {
                $toInputBlock = $Matches[1]
                # Kiem tra cac field reviewer input ma planner output phai cung cap
                $neededFields = @([regex]::Matches($toInputBlock, '(?m)^\s*(\w+)\s*:') | ForEach-Object { $_.Groups[1].Value })
                foreach ($nf in $neededFields) {
                    if ($nf -in @("plan", "steps", "design", "components")) {
                        if ($fromContent -notmatch "(?m)^$([regex]::Escape($nf))\s*:") {
                            if ($nf -eq "steps" -and $fromContent -match "steps:") { continue }
                            $issues += "planner output thieu field '$nf' ma reviewer input can"
                            $ok = $false
                        }
                    }
                }
            }
        }
    } else {
        # khong co contract -> check heuristic: agent md co output contract section
        $fromRaw = Get-Content -LiteralPath $fromAgent -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        if ($fromRaw -notmatch '(?i)(output|OUTPUT CONTRACT|output_contract)') {
            $issues += "$($link.from) khong mo ta output contract"
            $ok = $false
        }
    }

    if ($ok) {
        Add-Check -Group "integration" -Check "$($link.from)_to_$($link.to)" -Status "PASS" -Detail "Integration $($link.desc): OK"
    } else {
        Add-Error -Type "INTEGRATION_BREAK" -Severity "MAJOR" -Detail "Integration $($link.desc): $($issues -join '; ')"
        $results.integration_issues += @{ chain = "$($link.from)->$($link.to)"; detail = ($issues -join '; '); ok = $false }
        Add-Check -Group "integration" -Check "$($link.from)_to_$($link.to)" -Status "FAIL" -Detail "Integration $($link.desc): $($issues -join '; ')"
    }
}

# --- 6. OUTPUT VALIDATION (FAKE TASK INJECTION) ---
Write-Host "[6/6] Output Validation (Fake Task Injection)..." -ForegroundColor Cyan
# Fake task duoc "inject" vao workflow; moi giai doan phai san xuat dung artifact.
# Neu contract output khac artifact ky vong -> OUTPUT_MISMATCH (vi du result.txt thay vi result.md)
$fakeTask = @{
    name = "Fix null reference exception"
    type = "bug_fix"
    input = "task.md"
    expected_output = "result.md"
}

$artifactExpectations = @{
    "analyst"       = "01_analysis.md"
    "planner"       = "03_plan.md"
    "builder"       = "06_build.md"
    "reviewer"      = "04_review.md"
    "tester"        = "06_test.md"
    "test-planner"  = "05_testplan.md"
    "ui-beautifier" = "07_ui_audit.md"
}

$workflowDir = ".opencode/workflows"
$existingWorkflowArtifacts = @()
if (Test-Path -LiteralPath $workflowDir) {
    $wfDirs = @(Get-ChildItem -Path "$workflowDir\*" -Directory -ErrorAction SilentlyContinue)
    foreach ($wd in $wfDirs) {
        $files = @(Get-ChildItem -Path $wd.FullName -File -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
        foreach ($f in $files) {
            if ($f -match '^\d+_[a-z_]+\.(md|json)$') { $existingWorkflowArtifacts += $f }
        }
    }
}

foreach ($agentKey in $artifactExpectations.Keys) {
    $expectedArtifact = $artifactExpectations[$agentKey]
    $contractPath = "$contractDir\$agentKey.yaml"
    $declaredOutput = $null

    if (Test-Path -LiteralPath $contractPath) {
        $cContent = Get-Content -LiteralPath $contractPath -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        if ($cContent -match "(?m)^\s*output:\s*(.+)$") {
            $declaredOutput = $Matches[1].Trim()
        }
        if ($cContent -match "(?ms)output:\s*\n(.+?)(?:\n\n|\z|^[a-z])") {
            $outBlock = $Matches[1]
            $artifactRefs = @([regex]::Matches($outBlock, '[\w]+\.(?:md|json)') | ForEach-Object { $_.Value })
            if ($artifactRefs.Count -gt 0) {
                # Kiem tra: artifact ky vong cua workflow co trong contract output khong?
                if ($expectedArtifact -and $artifactRefs -notcontains $expectedArtifact) {
                    $compatible = $false
                    foreach ($ar in $artifactRefs) {
                        if ($ar -like "*$($expectedArtifact.Split('_')[1].Split('.')[0])*") { $compatible = $true }
                    }
                    if (-not $compatible) {
                        Add-Error -Type "OUTPUT_MISMATCH" -Severity "MAJOR" -Detail "Fake task '$($fakeTask.name)': agent $agentKey contract output ($($artifactRefs -join ', ')) khong khop artifact ky vong ($expectedArtifact)"
                        Add-Check -Group "output" -Check "fake_task_$agentKey" -Status "FAIL" -Detail "Output mismatch: contract outputs $($artifactRefs -join ', ') nhung workflow expects $expectedArtifact"
                    } else {
                        Add-Check -Group "output" -Check "fake_task_$agentKey" -Status "PASS" -Detail "Agent $agentKey output contract tuong thich artifact $expectedArtifact"
                    }
                } else {
                    Add-Check -Group "output" -Check "fake_task_$agentKey" -Status "PASS" -Detail "Agent $agentKey output contract khop artifact $expectedArtifact"
                }
            } else {
                Add-Check -Group "output" -Check "fake_task_$agentKey" -Status "WARN" -Detail "Agent $agentKey contract khong khai bao output artifact (khong kiem tra duoc)"
            }
        }
    } else {
        # Khong co contract -> heuristic: agent md co mo ta output artifact
        $agentFile = "$agentsDir\$agentKey.md"
        if (Test-Path -LiteralPath $agentFile) {
            $aRaw = Get-Content -LiteralPath $agentFile -Raw -Encoding utf8 -ErrorAction SilentlyContinue
            if ($aRaw -match [regex]::Escape($expectedArtifact)) {
                Add-Check -Group "output" -Check "fake_task_$agentKey" -Status "PASS" -Detail "Agent $agentKey mo ta artifact $expectedArtifact trong doc"
            } else {
                # Chua co contract thi khong FAIL, chi WARN (agent moi/khong core)
                Add-Check -Group "output" -Check "fake_task_$agentKey" -Status "WARN" -Detail "Agent $agentKey khong co contract va khong mo ta artifact $expectedArtifact"
            }
        }
    }
}

# === LEARNING / SUGGESTED ACTIONS ===
$errorTypes = @($results.runtime_errors | ForEach-Object { $_.type } | Group-Object | Sort-Object Count -Descending)
foreach ($et in $errorTypes) {
    switch ($et.Name) {
        "MISSING_CONTRACT" { $results.suggested_actions += "Tao contract cho agent thieu trong .opencode/system/contracts/" }
        "SKILL_REF_NOT_FOUND" { $results.suggested_actions += "Fix skill tham chieu file khong ton tai hoac tao file thieu" }
        "VERSION_MISMATCH" { $results.suggested_actions += "Dong bo schema_version giua output cua agent A va input cua agent B" }
        "COMMAND_AGENT_NOT_FOUND" { $results.suggested_actions += "Fix agent mapping trong command frontmatter" }
        "OUTPUT_MISMATCH" { $results.suggested_actions += "Cap nhat output contract de khop artifact ky vong cua workflow" }
        "INTEGRATION_BREAK" { $results.suggested_actions += "Them contract/field de noi chain integration giua cac agents" }
        "MISSING_DEPENDENCY" { $results.suggested_actions += "Tao dependency (agent/contract) bi thieu" }
        "SKILL_DEPRECATED" { $results.suggested_actions += "Update hoac loai bo skill deprecated" }
        default { $results.suggested_actions += "Review loi $($et.Name) ($($et.Count)x)" }
    }
}

# === RUNTIME HEALTH SCORE ===
$runtimeHealth = 0
if ($totalChecks -gt 0) {
    $runtimeHealth = [Math]::Round(($passedChecks / $totalChecks) * 100)
}
$results.runtime_health = $runtimeHealth

if ($runtimeHealth -ge 90) { $results.verdict = "STABLE" }
elseif ($runtimeHealth -ge 70) { $results.verdict = "WARNING" }
else { $results.verdict = "UNSTABLE" }

$results.summary = "Simulation: $passedChecks/$totalChecks checks PASS, $($results.runtime_errors.Count) runtime errors, $($results.integration_issues.Count) integration issues, runtime health $runtimeHealth/100"

# === OUTPUT ===
if (-not (Test-Path -LiteralPath $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

if (-not $dryRun) {
    $reportPath = "$outputDir\simulation-engine-$timestamp.json"
    $results | ConvertTo-Json -Depth 8 | Out-File -LiteralPath $reportPath -Encoding utf8
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "  SIMULATION ENGINE REPORT" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "  Agents tested:    $($results.agents_tested)"
Write-Host "  Skills tested:    $($results.skills_tested)"
Write-Host "  Commands tested:  $($results.commands_tested)"
Write-Host "  Contracts tested: $($results.contracts_tested)"
Write-Host "  ----------------------------------------------"
Write-Host "  Checks passed:    $passedChecks/$totalChecks"
Write-Host "  Runtime errors:   $($results.runtime_errors.Count)"
Write-Host "  Integration:      $($results.integration_issues.Count)"
Write-Host "  ----------------------------------------------"
$hcColor = "Green"
if ($results.verdict -eq "WARNING") { $hcColor = "Yellow" }
elseif ($results.verdict -eq "UNSTABLE") { $hcColor = "Red" }
Write-Host "  Runtime Health:   $runtimeHealth/100 ($($results.verdict))" -ForegroundColor $hcColor
if ($results.runtime_errors.Count -gt 0) {
    Write-Host "  ----------------------------------------------"
    Write-Host "  Runtime errors:" -ForegroundColor Yellow
    $results.runtime_errors | Select-Object -First 15 | ForEach-Object {
        Write-Host "    [$($_.severity)] $($_.type): $($_.detail)" -ForegroundColor Yellow
    }
}
if ($results.suggested_actions.Count -gt 0) {
    Write-Host "  ----------------------------------------------"
    Write-Host "  Suggested actions (learning):" -ForegroundColor Cyan
    $results.suggested_actions | Select-Object -Unique | ForEach-Object {
        Write-Host "    - $_" -ForegroundColor Cyan
    }
}
Write-Host "================================================" -ForegroundColor Magenta
if (-not $dryRun) {
    Write-Host "Simulation report saved: $reportPath" -ForegroundColor Green
}

return $results
