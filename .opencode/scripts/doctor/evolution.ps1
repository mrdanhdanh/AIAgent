<#
.SYNOPSIS
Doctor Module v2.0: Evolution Engine Bridge
.DESCRIPTION
Wraps the System Evolution engines (.opencode/scripts/evolution/*.ps1) and normalizes
their JSON reports into the Doctor result format. Reuses the SAME engines as
/team-syncdocs so Doctor and SyncDocs share a single source of truth:
- Invoke-DoctorCompatibility     -> compatibility-checker.ps1
- Invoke-DoctorSemanticDiff      -> semantic-diff.ps1 (per contract)
- Invoke-DoctorMigration         -> migration-system.ps1
- Invoke-DoctorKnowledgeMigrate  -> knowledge-migration.ps1
- Invoke-DoctorSimulationEngine  -> simulation-engine.ps1 (runtime validation)
- Invoke-DoctorBenchmarkEngine   -> capability-benchmark.ps1
- Invoke-DoctorStressTest        -> sync-system-docs.ps1 -stressTest
- Invoke-DoctorEvolutionHealth   -> health-score.ps1
Read-only: KHONG sua file he thong (except evolution engines khi co -Apply).
#>

# --- Helper: find the newest evolution report JSON -----------------
function Get-LatestEvolutionReport {
    param([string]$Root, [string]$Pattern)
    $dir = Join-Path $Root ".opencode/scripts/evolution/reports"
    if (-not (Test-Path -LiteralPath $dir)) { return $null }
    $file = Get-ChildItem -Path $dir -Filter $Pattern -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $file) { return $null }
    try {
        return Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8 | ConvertFrom-Json
    }
    catch { return $null }
}

# --- Helper: run an evolution script with absolute dirs -------------
function Invoke-EvolutionScript {
    param([string]$Root, [string]$Name, [hashtable]$ScriptArgs)
    $scriptPath = Join-Path $Root ".opencode/scripts/evolution/$Name"
    if (-not (Test-Path -LiteralPath $scriptPath)) {
        return @{ ok = $false; error = "$Name not found" }
    }
    try {
        $null = & $scriptPath @ScriptArgs 2>&1
        return @{ ok = $true }
    }
    catch {
        return @{ ok = $false; error = $_.Exception.Message }
    }
}

# --- Normalize an evolution issue into doctor issue format ---------
function Convert-EvolutionIssue {
    param($Issue, [string]$Group)
    $sev = "WARNING"
    if ($Issue.severity -eq "CRITICAL") { $sev = "CRITICAL" }
    elseif ($Issue.severity -eq "MAJOR") { $sev = "MAJOR" }
    elseif ($Issue.severity -eq "ERROR" -or $Issue.severity -eq "FAIL") { $sev = "MAJOR" }
    $msg = "$($Issue.type): $($Issue.description)"
    if (-not $Issue.description) { $msg = "$($Issue.type): $($Issue.detail)" }
    if (-not $Issue.type) { $msg = "$($Issue.message)" }
    return @{ severity = $sev; group = $Group; message = $msg }
}

# --- Compatibility Checker ------------------------------------------
function Invoke-DoctorCompatibility {
    param([string]$Root = ".")
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"
    $res = Invoke-EvolutionScript -Root $Root -Name "compatibility-checker.ps1" @{
        contractDir = Join-Path $Root ".opencode/system/contracts"
        agentsDir   = Join-Path $Root ".opencode/agents"
        outputDir   = $reportsDir
    }
    $data = Get-LatestEvolutionReport -Root $Root -Pattern "compatibility-checker-*.json"
    if (-not $res.ok -or -not $data) {
        return @{
            group = "Compatibility"; score = 50; status = "WARNING"
            checks = @()
            issues = @(@{ severity = "WARNING"; group = "Compatibility"; message = "Compatibility checker unavailable ($($res.error))" })
        }
    }
    $score = [int]$data.compatibility_score
    $checks = @()
    foreach ($c in $data.checks) {
        $st = "WARNING"
        if ($c.status -eq "PASS") { $st = "PASS" }
        elseif ($c.status -eq "FAIL") { $st = "ERROR" }
        $checks += @{ name = $c.check; status = $st; detail = $c.detail }
    }
    $issues = @()
    foreach ($i in $data.issues) { $issues += Convert-EvolutionIssue -Issue $i -Group "Compatibility" }
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }
    return @{
        group = "Compatibility"; score = $score; status = $status
        checks = $checks; issues = $issues
        data = $data; summary = $data.summary
    }
}

# --- Semantic Diff (per contract) -----------------------------------
function Invoke-DoctorSemanticDiff {
    param([string]$Root = ".")
    $contractsDir = Join-Path $Root ".opencode/system/contracts"
    $contracts = @(Get-ChildItem -Path $contractsDir -Filter "*.yaml" -ErrorAction SilentlyContinue)
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"

    if ($contracts.Count -eq 0) {
        return @{
            group = "SemanticDiff"; score = 0; status = "ERROR"
            checks = @(@{ name = "Semantic diff"; status = "ERROR"; detail = "No contracts found" })
            issues = @(@{ severity = "CRITICAL"; group = "SemanticDiff"; message = "Contract registry empty - cannot diff" })
        }
    }

    $totalChanges = 0
    $breakingChanges = 0
    $checks = @()
    $issues = @()

    foreach ($ac in $contracts) {
        $agentName = $ac.BaseName
        $res = Invoke-EvolutionScript -Root $Root -Name "semantic-diff.ps1" @{
            agentName = $agentName
            outputDir = $reportsDir
        }
        if (-not $res.ok) {
            $issues += @{ severity = "WARNING"; group = "SemanticDiff"; message = "Semantic diff failed for $agentName" }
            continue
        }
        $sd = Get-LatestEvolutionReport -Root $Root -Pattern "semantic-diff-*.json"
        if (-not $sd) { continue }

        $agentChanges = @($sd.changes | Where-Object { $_.type -ne "contract_change" })
        $agentBreaking = @($agentChanges | Where-Object { $_.severity -eq "BREAKING" })
        $totalChanges += $agentChanges.Count
        $breakingChanges += $agentBreaking.Count

        $st = "PASS"
        $detail = "no schema/workflow changes"
        if ($agentBreaking.Count -gt 0) { $st = "ERROR"; $detail = "$($agentBreaking.Count) breaking change(s)" }
        elseif ($agentChanges.Count -gt 0) { $st = "WARNING"; $detail = "$($agentChanges.Count) change(s)" }
        $checks += @{ name = $agentName; status = $st; detail = $detail }

        if ($agentBreaking.Count -gt 0) {
            foreach ($b in $agentBreaking) {
                $issues += @{ severity = "CRITICAL"; group = "SemanticDiff"; message = "${agentName}: $($b.description)" }
            }
        }
    }

    $score = [Math]::Max(0, 100 - ($breakingChanges * 25) - ($totalChanges * 5))
    $score = [Math]::Min(100, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }
    return @{
        group = "SemanticDiff"; score = $score; status = $status
        checks = $checks; issues = $issues
        summary = "Semantic diff: $totalChanges changes ($breakingChanges breaking)"
    }
}

# --- Migration System ------------------------------------------------
function Invoke-DoctorMigration {
    param([string]$Root = ".")
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"
    $res = Invoke-EvolutionScript -Root $Root -Name "migration-system.ps1" @{
        contractDir = Join-Path $Root ".opencode/system/contracts"
        outputDir   = $reportsDir
    }
    $data = Get-LatestEvolutionReport -Root $Root -Pattern "migration-system-*.json"
    if (-not $res.ok -or -not $data) {
        return @{
            group = "Migration"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "Migration"; message = "Migration system unavailable" })
        }
    }
    $taskCount = @($data.tasks).Count
    $affectedCount = @($data.affected_agents).Count
    $score = [Math]::Max(0, 100 - ($taskCount * 10))
    $status = if ($taskCount -eq 0) { "PASS" } elseif ($taskCount -le 3) { "WARNING" } else { "ERROR" }
    $issues = @()
    if ($taskCount -gt 0) {
        $issues += @{ severity = "MAJOR"; group = "Migration"; message = "$taskCount migration task(s), $affectedCount affected agent(s)" }
    }
    return @{
        group = "Migration"; score = $score; status = $status
        checks = @(@{ name = "Migration tasks"; status = if ($taskCount -eq 0) { "PASS" } else { "WARNING" }; detail = "$taskCount task(s), $affectedCount affected" })
        issues = $issues; data = $data; summary = $data.summary
    }
}

# --- Knowledge Migration ---------------------------------------------
function Invoke-DoctorKnowledgeMigrate {
    param([string]$Root = ".")
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"
    $res = Invoke-EvolutionScript -Root $Root -Name "knowledge-migration.ps1" @{
        knowledgeDir = Join-Path $Root ".opencode/knowledge"
        agentsDir    = Join-Path $Root ".opencode/agents"
        projectDir   = Join-Path $Root "."
        outputDir    = $reportsDir
    }
    $data = Get-LatestEvolutionReport -Root $Root -Pattern "knowledge-migration-*.json"
    if (-not $res.ok -or -not $data) {
        return @{
            group = "KnowledgeMigrate"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "KnowledgeMigrate"; message = "Knowledge migration unavailable" })
        }
    }
    $deprecatedCount = @($data.deprecated_knowledge).Count
    $missingCount = @($data.missing_knowledge).Count
    $score = [Math]::Max(0, [int]$data.score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }
    $issues = @()
    if ($deprecatedCount -gt 0) { $issues += @{ severity = "WARNING"; group = "KnowledgeMigrate"; message = "$deprecatedCount deprecated knowledge file(s)" } }
    if ($missingCount -gt 0) { $issues += @{ severity = "WARNING"; group = "KnowledgeMigrate"; message = "$missingCount missing knowledge topic(s)" } }
    return @{
        group = "KnowledgeMigrate"; score = $score; status = $status
        checks = @(
            @{ name = "Deprecated"; status = if ($deprecatedCount -eq 0) { "PASS" } else { "WARNING" }; detail = "$deprecatedCount file(s)" }
            @{ name = "Missing topics"; status = if ($missingCount -eq 0) { "PASS" } else { "WARNING" }; detail = "$missingCount topic(s)" }
        )
        issues = $issues; data = $data; summary = $data.summary
    }
}

# --- Simulation Engine (runtime validation) --------------------------
function Invoke-DoctorSimulationEngine {
    param([string]$Root = ".")
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"
    $res = Invoke-EvolutionScript -Root $Root -Name "simulation-engine.ps1" @{
        agentsDir    = Join-Path $Root ".opencode/agents"
        skillsDir    = Join-Path $Root ".opencode/skills"
        commandsDir  = Join-Path $Root ".opencode/commands"
        contractDir  = Join-Path $Root ".opencode/system/contracts"
        knowledgeDir = Join-Path $Root ".opencode/knowledge"
        outputDir    = $reportsDir
    }
    $data = Get-LatestEvolutionReport -Root $Root -Pattern "simulation-engine-*.json"
    if (-not $res.ok -or -not $data) {
        return @{
            group = "RuntimeEngine"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "RuntimeEngine"; message = "Simulation engine unavailable" })
        }
    }
    $runtimeHealth = [int]$data.runtime_health
    $runtimeErrors = @($data.runtime_errors).Count
    $integrationIssues = @($data.integration_issues).Count
    $checks = @()
    foreach ($c in $data.checks) {
        $st = "WARNING"
        if ($c.status -eq "PASS") { $st = "PASS" }
        elseif ($c.status -eq "FAIL") { $st = "ERROR" }
        $checks += @{ name = "$($c.group)_$($c.check)"; status = $st; detail = $c.detail }
    }
    $issues = @()
    foreach ($e in $data.runtime_errors) {
        $sev = if ($e.severity -eq "CRITICAL" -or $e.severity -eq "ERROR") { "CRITICAL" } else { "MAJOR" }
        $issues += @{ severity = $sev; group = "RuntimeEngine"; message = "$($e.type): $($e.detail)" }
    }
    foreach ($ii in $data.integration_issues) {
        $issues += @{ severity = "CRITICAL"; group = "RuntimeEngine"; message = "INTEGRATION_BREAK: $ii" }
    }
    $status = if ($runtimeHealth -ge 90) { "PASS" } elseif ($runtimeHealth -ge 70) { "WARNING" } else { "ERROR" }
    return @{
        group = "RuntimeEngine"; score = $runtimeHealth; status = $status
        checks = $checks; issues = $issues; data = $data
        runtime_health = $runtimeHealth
        verdict = $data.verdict
        suggested_actions = @($data.suggested_actions | Select-Object -Unique)
        summary = $data.summary
    }
}

# --- Capability Benchmark Engine -------------------------------------
function Invoke-DoctorBenchmarkEngine {
    param([string]$Root = ".")
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"
    $res = Invoke-EvolutionScript -Root $Root -Name "capability-benchmark.ps1" @{
        agentsDir    = Join-Path $Root ".opencode/agents"
        knowledgeDir = Join-Path $Root ".opencode/knowledge"
        contractDir  = Join-Path $Root ".opencode/system/contracts"
        outputDir    = $reportsDir
    }
    $data = Get-LatestEvolutionReport -Root $Root -Pattern "capability-benchmark-*.json"
    if (-not $res.ok -or -not $data) {
        return @{
            group = "CapabilityEngine"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "CapabilityEngine"; message = "Capability benchmark unavailable" })
        }
    }
    $capScore = [int]$data.capability_score
    $taskRate = [int]$data.task_success_rate
    $checks = @(
        @{ name = "Capability score"; status = if ($capScore -ge 80) { "PASS" } elseif ($capScore -ge 60) { "WARNING" } else { "ERROR" }; detail = "$capScore/100" }
        @{ name = "Task simulation"; status = if ($taskRate -ge 80) { "PASS" } else { "WARNING" }; detail = "$taskRate% pass" }
    )
    foreach ($d in $data.domains) {
        $checks += @{ name = "Domain $($d.domain)"; status = if ($d.score -ge 80) { "PASS" } elseif ($d.score -ge 60) { "WARNING" } else { "ERROR" }; detail = "$($d.score)/100 ($($d.agents) agents)" }
    }
    $status = if ($capScore -ge 80) { "PASS" } elseif ($capScore -ge 60) { "WARNING" } else { "ERROR" }
    return @{
        group = "CapabilityEngine"; score = $capScore; status = $status
        checks = $checks; issues = @(); data = $data
        capability_score = $capScore
        verdict = $data.verdict
        task_success_rate = $taskRate
        summary = $data.summary
    }
}

# --- Stress Test ------------------------------------------------------
function Invoke-DoctorStressTest {
    param([string]$Root = ".", [int]$Count = 20, [string]$Seed = "fixed")
    $syncScript = Join-Path $Root ".opencode/scripts/sync-system-docs.ps1"
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"

    if (-not (Test-Path -LiteralPath $syncScript)) {
        return @{
            group = "Stress"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "Stress"; message = "Stress test engine unavailable" })
        }
    }
    Push-Location $Root
    try {
        $null = & $syncScript -stressTest -stressCount $Count -stressSeed $Seed 2>&1
    }
    catch { }
    finally { Pop-Location }

    $data = Get-LatestEvolutionReport -Root $Root -Pattern "stress-test-*.json"
    if (-not $data) {
        return @{
            group = "Stress"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "Stress"; message = "Stress test produced no report" })
        }
    }
    $successRate = [int]$data.stress_test.success_rate
    $total = [int]$data.stress_test.total_tasks
    $health = [int]$data.stress_test.health_score
    $verdict = $data.stress_test.verdict
    $checks = @(
        @{ name = "Success rate"; status = if ($successRate -ge 90) { "PASS" } elseif ($successRate -ge 70) { "WARNING" } else { "ERROR" }; detail = "$successRate% ($total tasks)" }
        @{ name = "Health score"; status = if ($health -ge 90) { "PASS" } elseif ($health -ge 70) { "WARNING" } else { "ERROR" }; detail = "$health/100" }
    )
    foreach ($w in $data.stress_test.weakest_steps) {
        $checks += @{ name = "Weak step $($w.step)"; status = "WARNING"; detail = "$($w.failure_rate)% failure" }
    }
    $issues = @()
    if ($successRate -lt 90) { $issues += @{ severity = "MAJOR"; group = "Stress"; message = "Stress test success rate $successRate% (verdict $verdict)" } }
    return @{
        group = "Stress"; score = $health; status = if ($verdict -eq "STABLE") { "PASS" } elseif ($verdict -eq "WARNING") { "WARNING" } else { "ERROR" }
        checks = $checks; issues = $issues; data = $data
        success_rate = $successRate
        verdict = $verdict
        summary = "Stress test: $successRate% success ($total tasks), verdict $verdict"
    }
}

# --- Evolution Health Score (reuses health-score.ps1) ----------------
function Invoke-DoctorEvolutionHealth {
    param([string]$Root = ".")
    $reportsDir = Join-Path $Root ".opencode/scripts/evolution/reports"

    # Gather latest engine reports to feed health-score
    $lastCompat = Get-ChildItem -Path $reportsDir -Filter "compatibility-checker-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $lastKnowledge = Get-ChildItem -Path $reportsDir -Filter "knowledge-migration-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $lastMigration = Get-ChildItem -Path $reportsDir -Filter "migration-system-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $lastSimulation = Get-ChildItem -Path $reportsDir -Filter "simulation-engine-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $lastBenchmark = Get-ChildItem -Path $reportsDir -Filter "capability-benchmark-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    $hsScript = Join-Path $Root ".opencode/scripts/evolution/health-score.ps1"
    if (-not (Test-Path -LiteralPath $hsScript)) {
        return @{
            group = "HealthScore"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "HealthScore"; message = "health-score.ps1 not found" })
        }
    }
    $hsArgs = @{
        contractDir = Join-Path $Root ".opencode/system/contracts"
        agentsDir   = Join-Path $Root ".opencode/agents"
        commandsDir = Join-Path $Root ".opencode/commands"
        skillsDir   = Join-Path $Root ".opencode/skills"
        scriptsDir  = Join-Path $Root ".opencode/scripts"
        outputDir   = $reportsDir
    }
    if ($lastCompat) { $hsArgs.compatibilityReport = $lastCompat.FullName }
    if ($lastKnowledge) { $hsArgs.knowledgeReport = $lastKnowledge.FullName }
    if ($lastMigration) { $hsArgs.migrationReport = $lastMigration.FullName }
    if ($lastSimulation) { $hsArgs.simulationReport = $lastSimulation.FullName }
    if ($lastBenchmark) { $hsArgs.benchmarkReport = $lastBenchmark.FullName }

    Push-Location $Root
    try {
        $null = & $hsScript @hsArgs 2>&1
    }
    catch { }
    finally { Pop-Location }

    $data = Get-LatestEvolutionReport -Root $Root -Pattern "health-score-*.json"
    if (-not $data) {
        return @{
            group = "HealthScore"; score = 50; status = "WARNING"
            checks = @(); issues = @(@{ severity = "WARNING"; group = "HealthScore"; message = "Health score unavailable" })
        }
    }
    $overall = [int]$data.overall
    $checks = @()
    foreach ($cat in ($data.categories.PSObject.Properties | Sort-Object Name)) {
        $checks += @{ name = $cat.Name; status = if ([int]$cat.Value -ge 80) { "PASS" } elseif ([int]$cat.Value -ge 50) { "WARNING" } else { "ERROR" }; detail = "$($cat.Value)/100" }
    }
    $status = if ($overall -ge 80) { "PASS" } elseif ($overall -ge 50) { "WARNING" } else { "ERROR" }
    return @{
        group = "HealthScore"; score = $overall; status = $status
        checks = $checks; issues = @(); data = $data
        categories = $data.categories
        summary = $data.summary
        recommendations = @($data.recommendations)
    }
}
