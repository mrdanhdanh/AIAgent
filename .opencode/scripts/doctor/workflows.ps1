<#
.SYNOPSIS
Doctor Module: Workflow / Knowledge / Contracts Check
.DESCRIPTION
- Get-DoctorWorkflows: checks workflow contract (steps, transitions, missing step,
  dependency, contract mismatch, output mismatch, version mismatch, loop).
- Get-DoctorKnowledge: knowledge coverage, learning maturity, pending items,
  deprecated frameworks.
- Get-DoctorContracts: contract registry (input/output schema, dependencies, versions).
#>

# --- Workflow Check ----------------------------------------------
function Get-DoctorWorkflows {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $wfContract = Join-Path $Root ".opencode/system/contracts/workflow.yaml"
    $cmdsDir = Join-Path $Root ".opencode/commands"
    $agentsDir = Join-Path $Root ".opencode/agents"
    $teamMd = Join-Path $Root ".opencode/commands/team.md"

    $checks = @()
    $issues = @()
    $score = 100

    # 1. Contract exists
    if (-not (Test-Path -LiteralPath $wfContract)) {
        return @{
            group  = "Workflow"
            score  = 30
            status = "ERROR"
            checks = @(@{ name = "Workflow contract"; status = "ERROR"; detail = "workflow.yaml missing" })
            issues = @(@{ severity = "CRITICAL"; group = "Workflow"; message = "Missing workflow contract" })
        }
    }

    $wfContent = Get-Content -LiteralPath $wfContract -Raw -Encoding utf8 -ErrorAction SilentlyContinue

    # 2. Steps present
    $stepCount = [regex]::Matches($wfContent, '(?m)^\s*-\s*order:\s*\d+').Count
    if ($stepCount -ge 10) {
        $checks += @{ name = "Steps"; status = "PASS"; detail = "$stepCount workflow steps" }
    }
    else {
        $score -= 20
        $checks += @{ name = "Steps"; status = "ERROR"; detail = "Only $stepCount steps found" }
        $issues += @{ severity = "CRITICAL"; group = "Workflow"; message = "Workflow has too few steps ($stepCount)" }
    }

    # 3. Transitions present
    if ($wfContent -match '(?m)^transitions\s*:') {
        $transCount = [regex]::Matches($wfContent, '(?m)^\s+\w+_to_\w+\s*:').Count
        $checks += @{ name = "Transitions"; status = "PASS"; detail = "$transCount transitions defined" }
    }
    else {
        $score -= 20
        $checks += @{ name = "Transitions"; status = "ERROR"; detail = "missing transitions block" }
        $issues += @{ severity = "CRITICAL"; group = "Workflow"; message = "Workflow missing transitions" }
    }

    # 4. Command references exist (contract mismatch)
    $referencedCmds = @($wfContent | Select-String -Pattern 'command:\s*([\w-]+)' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value } | Where-Object { $_ -and $_ -ne "null" } | Select-Object -Unique)
    $missingCmds = @($referencedCmds | Where-Object { -not (Test-Path -LiteralPath (Join-Path $cmdsDir "$_.md")) })
    if ($missingCmds.Count -gt 0) {
        $score -= 15
        $checks += @{ name = "Contract mismatch"; status = "WARNING"; detail = "missing commands: $($missingCmds -join ', ')" }
        $issues += @{ severity = "MAJOR"; group = "Workflow"; message = "Workflow references missing commands: $($missingCmds -join ', ')" }
    }
    else {
        $checks += @{ name = "Contract mismatch"; status = "PASS"; detail = "all commands exist" }
    }

    # 5. Agent references exist
    $referencedAgents = @($wfContent | Select-String -Pattern 'agent:\s*([\w-]+)' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value } | Where-Object { $_ -and $_ -ne "orchestrator" } | Select-Object -Unique)
    $missingAgents = @($referencedAgents | Where-Object { -not (Test-Path -LiteralPath (Join-Path $agentsDir "$_.md")) })
    if ($missingAgents.Count -gt 0) {
        $score -= 15
        $checks += @{ name = "Dependency"; status = "WARNING"; detail = "missing agents: $($missingAgents -join ', ')" }
        $issues += @{ severity = "MAJOR"; group = "Workflow"; message = "Workflow references missing agents: $($missingAgents -join ', ')" }
    }
    else {
        $checks += @{ name = "Dependency"; status = "PASS"; detail = "all agents exist" }
    }

    # 6. Missing step vs team.md state machine
    $expectedSteps = @("analyze","design","plan","review","guardrail","backup","build","static_analysis","ui_audit","testplan","test","skill_validation","complete")
    $declaredSteps = @($wfContent | Select-String -Pattern 'name:\s*([\w_]+)' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value } | Where-Object { $_ })
    $missingSteps = @($expectedSteps | Where-Object { $_ -notin $declaredSteps })
    if ($missingSteps.Count -gt 0) {
        $score -= 10
        $checks += @{ name = "Missing step"; status = "WARNING"; detail = "missing: $($missingSteps -join ', ')" }
        $issues += @{ severity = "WARNING"; group = "Workflow"; message = "Workflow missing steps: $($missingSteps -join ', ')" }
    }
    else {
        $checks += @{ name = "Missing step"; status = "PASS"; detail = "all 13 steps declared" }
    }

    # 7. Version mismatch
    $supported = @($wfContent | Select-String -Pattern '(?m)^\s*-\s*"(\d+\.\d+)"' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value })
    if ($supported.Count -gt 0) {
        $checks += @{ name = "Version"; status = "PASS"; detail = "supported: $($supported -join ', ')" }
    }
    else {
        $checks += @{ name = "Version"; status = "WARNING"; detail = "no supported_versions declared" }
        $issues += @{ severity = "WARNING"; group = "Workflow"; message = "workflow.yaml missing supported_versions" }
    }

    # 8. Loop detection (transitions pointing to earlier steps is OK for review/test loops)
    if ($wfContent -match 'review_to_plan|test_to_build') {
        $checks += @{ name = "Loop"; status = "PASS"; detail = "retry loops defined (review->plan, test->build)" }
    }
    else {
        $checks += @{ name = "Loop"; status = "WARNING"; detail = "no retry loops detected" }
        $issues += @{ severity = "WARNING"; group = "Workflow"; message = "No retry loops in transitions" }
    }

    $score = [Math]::Max(0, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Workflow"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}

# --- Knowledge Check ---------------------------------------------
function Get-DoctorKnowledge {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $knowledgeDir = Join-Path $Root ".opencode/knowledge"
    $memoryDir = Join-Path $Root ".opencode/memory"
    $lessonsMd = Join-Path $knowledgeDir "lessons.md"
    $skillsLearned = Join-Path $knowledgeDir "skills-learned.md"

    $checks = @()
    $issues = @()
    $score = 100

    # 1. Knowledge files
    $kbFiles = @(Get-ChildItem -Path $knowledgeDir -Recurse -File -ErrorAction SilentlyContinue)
    if ($kbFiles.Count -gt 0) {
        $checks += @{ name = "Knowledge base"; status = "PASS"; detail = "$($kbFiles.Count) files" }
    }
    else {
        $score -= 30
        $checks += @{ name = "Knowledge base"; status = "ERROR"; detail = "empty" }
        $issues += @{ severity = "CRITICAL"; group = "Knowledge"; message = "Knowledge base empty" }
    }

    # 2. Coverage - per framework/topic folder
    $topicDirs = @(Get-ChildItem -Path $knowledgeDir -Directory -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^framework$|^project$|^skills$|^workflow$' })
    $topicNames = @($topicDirs | ForEach-Object { $_.Name })
    if ($topicNames.Count -gt 0) {
        $checks += @{ name = "Coverage"; status = "PASS"; detail = "topics: $($topicNames -join ', ')" }
    }

    # 3. Learning maturity (memory)
    $lessons = @(Get-ChildItem -Path (Join-Path $memoryDir "lessons") -Recurse -File -ErrorAction SilentlyContinue)
    $patterns = @(Get-ChildItem -Path (Join-Path $memoryDir "patterns") -Recurse -File -ErrorAction SilentlyContinue)
    $failures = @(Get-ChildItem -Path (Join-Path $memoryDir "failures") -Recurse -File -ErrorAction SilentlyContinue)

    if (Test-Path -LiteralPath $lessonsMd) { $maturity = "lessons.md present" } else { $score -= 10; $issues += @{ severity = "WARNING"; group = "Knowledge"; message = "lessons.md missing" } }
    if (Test-Path -LiteralPath $skillsLearned) { } else { $score -= 5; $issues += @{ severity = "WARNING"; group = "Knowledge"; message = "skills-learned.md missing" } }

    $checks += @{ name = "Learning maturity"; status = "PASS"; detail = "$($lessons.Count) lesson file(s), $($patterns.Count) pattern(s), $($failures.Count) failure record(s)" }

    # 4. Pending learning items
    $pending = 0
    $buckets = @("blazor","react","angular","oracle","sql","python","git","dotnet","powerapps")
    $covered = @($topicNames | ForEach-Object { $_.ToLower() })
    $missingTopics = @($buckets | Where-Object { $_ -notin $covered -and $_ -notin @(($kbFiles | ForEach-Object { $_.Directory.Name.ToLower() })) })
    if ($missingTopics.Count -gt 0) {
        $pending = $missingTopics.Count
        $issues += @{ severity = "WARNING"; group = "Knowledge"; message = "Missing topic coverage: $($missingTopics -join ', ')" }
        $checks += @{ name = "Pending learning"; status = "WARNING"; detail = "missing topics: $($missingTopics -join ', ')" }
    }
    else {
        $checks += @{ name = "Pending learning"; status = "PASS"; detail = "no missing core topics" }
    }

    # 5. Deprecated frameworks
    $deprecatedHit = @($kbFiles | Where-Object {
        $c = Get-Content -LiteralPath $_.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        $c -match '(?i)(MudBlazor|\.NET [5-9]|deprecated)'
    })
    if ($deprecatedHit.Count -gt 0) {
        $score -= 10
        $issues += @{ severity = "WARNING"; group = "Knowledge"; message = "$($deprecatedHit.Count) file(s) reference deprecated frameworks" }
        $checks += @{ name = "Deprecated frameworks"; status = "WARNING"; detail = "$($deprecatedHit.Count) file(s)" }
    }
    else {
        $checks += @{ name = "Deprecated frameworks"; status = "PASS"; detail = "none detected" }
    }

    $score = [Math]::Max(0, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Knowledge"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}

# --- Contracts Check ---------------------------------------------
function Get-DoctorContracts {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $contractsDir = Join-Path $Root ".opencode/system/contracts"
    $contractFiles = @(Get-ChildItem -Path $contractsDir -Filter "*.yaml" -ErrorAction SilentlyContinue)

    $checks = @()
    $issues = @()
    $score = 100

    if ($contractFiles.Count -eq 0) {
        return @{
            group  = "Contracts"
            score  = 0
            status = "ERROR"
            checks = @(@{ name = "Contracts"; status = "ERROR"; detail = "no contract files" })
            issues = @(@{ severity = "CRITICAL"; group = "Contracts"; message = "Contract registry empty" })
        }
    }

    $schemaCount = 0
    foreach ($cf in $contractFiles) {
        $name = $cf.BaseName
        $content = Get-Content -LiteralPath $cf.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        $cIssues = @()

        if ($content -match 'contract_version\s*:\s*"?\d+\.\d+"?') { $schemaCount++ }
        else { $cIssues += @{ severity = "WARNING"; group = "Contracts"; message = "$($name): missing contract_version" } }

        # Workflow contract uses steps/transitions instead of input/output
        if ($name -eq "workflow") {
            if ($content -notmatch '(?m)^steps\s*:') { $cIssues += @{ severity = "WARNING"; group = "Contracts"; message = "$($name): missing steps schema" } }
            if ($content -notmatch '(?m)^transitions\s*:') { $cIssues += @{ severity = "WARNING"; group = "Contracts"; message = "$($name): missing transitions schema" } }
            if ($content -notmatch '(?m)^supported_versions\s*:') { $cIssues += @{ severity = "WARNING"; group = "Contracts"; message = "$($name): missing supported_versions" } }
        }
        else {
            if ($content -notmatch '(?im)^input\s*:') { $cIssues += @{ severity = "WARNING"; group = "Contracts"; message = "$($name): missing input schema" } }
            if ($content -notmatch '(?im)^output\s*:') { $cIssues += @{ severity = "WARNING"; group = "Contracts"; message = "$($name): missing output schema" } }
            if ($content -notmatch '(?im)^dependencies\s*:') { $cIssues += @{ severity = "WARNING"; group = "Contracts"; message = "$($name): missing dependencies" } }
        }

        if ($cIssues.Count -gt 0) { $score -= [Math]::Min(20, $cIssues.Count * 4) }

        $checks += @{
            name   = $name
            status = if ($cIssues.Count -eq 0) { "PASS" } else { "WARNING" }
            detail = "$($cIssues.Count) issue(s)"
            items  = $cIssues
        }
        $issues += $cIssues
    }

    $checks += @{ name = "Registry"; status = "PASS"; detail = "$($contractFiles.Count) contract(s), $schemaCount with version" }

    $score = [Math]::Max(0, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Contracts"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}
