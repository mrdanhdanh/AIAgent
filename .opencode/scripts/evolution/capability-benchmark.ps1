<#
.SYNOPSIS
Capability Benchmark v1.0 — Danh gia nang luc cua tung Agent theo domain nhiem vu
.DESCRIPTION
Cham diem kha nang cua moi agent theo cac domain (Blazor, Planning, Testing, Git,
Security, UI/UX, Docs, Orchestration, Scripting, Database) dua tren:
- Mo ta trong agent file (frontmatter description + noi dung)
- Knowledge coverage (.opencode/knowledge)
- Contract presence (.opencode/system/contracts)
- Task-type simulation: voi moi domain, mo phong 1 task -> PASS neu agent >= 60

Output: JSON report (capability-benchmark-<timestamp>.json) + capability_score.
Read-only: KHONG sua file he thong.
#>

param(
    [string]$agentsDir = ".opencode/agents",
    [string]$knowledgeDir = ".opencode/knowledge",
    [string]$contractDir = ".opencode/system/contracts",
    [string]$outputDir = ".opencode/scripts/evolution/reports",
    [switch]$dryRun
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# === DOMAIN POOL ===
$domains = @(
    @{ name = "Blazor";       keywords = @("blazor","razor","fluentui","component",".net","wasm","c#");  task = "Fix Blazor bug";              task_type = "bug_fix" },
    @{ name = "Planning";     keywords = @("plan","design","architecture","requirement","analy","roadmap"); task = "Design new feature";        task_type = "design" },
    @{ name = "Testing";      keywords = @("test","coverage","bunit","playwright","xunit","assert");       task = "Write unit tests";            task_type = "testing" },
    @{ name = "Git";          keywords = @("git","push","commit","branch","remote","pr");                  task = "Review and push code";        task_type = "git" },
    @{ name = "Security";     keywords = @("secret","security","vulnerab","xss","guard","token");          task = "Security audit";              task_type = "security" },
    @{ name = "UI/UX";        keywords = @("ui","ux","interface","css","accessib","design","audit");       task = "UI audit and polish";         task_type = "ui_audit" },
    @{ name = "Docs";         keywords = @("document","knowledge","lesson","pattern","skill");             task = "Write documentation";         task_type = "docs" },
    @{ name = "Orchestration"; keywords = @("orchestr","workflow","state","agent","dispatch","loop");      task = "Orchestrate team workflow";   task_type = "orchestration" },
    @{ name = "Scripting";    keywords = @("powershell","script","automation","utility","ps1");            task = "Write automation script";     task_type = "scripting" },
    @{ name = "Database";     keywords = @("sql","database","storage","crud","entity","model");            task = "Database migration";          task_type = "migration" }
)

# === LOAD KNOWLEDGE ===
$knowledgeText = ""
if (Test-Path -LiteralPath $knowledgeDir) {
    $kbFiles = @(Get-ChildItem -Path "$knowledgeDir\*" -Recurse -File -ErrorAction SilentlyContinue)
    foreach ($kf in $kbFiles) {
        $knowledgeText += " " + (Get-Content -LiteralPath $kf.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue)
    }
}
$knowledgeLower = $knowledgeText.ToLower()

# === LOAD CONTRACTS ===
$contractNames = @(Get-ChildItem -Path "$contractDir\*.yaml" -ErrorAction SilentlyContinue | ForEach-Object { $_.BaseName })

# === SCAN AGENTS ===
$agentFiles = @(Get-ChildItem -Path "$agentsDir\*.md" -ErrorAction SilentlyContinue)
$agentRows = @()

foreach ($af in $agentFiles) {
    $name = $af.BaseName
    $content = Get-Content -LiteralPath $af.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
    $lower = $content.ToLower()

    # Knowledge bonus: neu domain keyword xuat hien trong knowledge base -> +5 (toi da +15)
    $scores = @()
    foreach ($d in $domains) {
        $hits = @($d.keywords | Where-Object { $lower.Contains($_) }).Count
        $s = [Math]::Min(100, 40 + ($hits * 15))

        # Contract bonus: neu agent co contract -> +5
        if ($name -in $contractNames) { $s = [Math]::Min(100, $s + 5) }

        # Knowledge bonus
        $kbHits = @($d.keywords | Where-Object { $knowledgeLower.Contains($_) }).Count
        if ($kbHits -gt 0) { $s = [Math]::Min(100, $s + 5) }

        if ($s -gt 55) { $scores += @{ domain = $d.name; score = $s } }
    }

    $top = @($scores | Sort-Object { $_["score"] } -Descending | Select-Object -First 4)
    $avgTop = 0
    if ($top.Count -gt 0) {
        $vals = @($top | ForEach-Object { $_["score"] })
        $avgTop = [Math]::Round(($vals | Measure-Object -Average).Average)
    }

    $agentRows += @{
        agent = $name
        top_domains = $top
        overall = $avgTop
        has_contract = ($name -in $contractNames)
    }
}

# === DOMAIN AGGREGATION ===
$domainAgg = @()
foreach ($d in $domains) {
    $matching = @($agentRows | Where-Object {
        @($_.top_domains | Where-Object { $_.domain -eq $d.name }).Count -gt 0
    })
    $avg = 0
    if ($matching.Count -gt 0) {
        $vals = @($matching | ForEach-Object {
            ($_.top_domains | Where-Object { $_.domain -eq $d.name } | Select-Object -First 1).score
        })
        $avg = [Math]::Round(($vals | Measure-Object -Average).Average)
    }
    if ($avg -gt 0) {
        $domainAgg += @{ domain = $d.name; score = $avg; agents = $matching.Count }
    }
}

# === TASK-TYPE SIMULATION ===
# Voi moi domain, "chay thu" 1 task: PASS neu co it nhat 1 agent >= 60 capability
$taskSims = @()
foreach ($d in $domains) {
    $best = @($agentRows | Where-Object {
        @($_.top_domains | Where-Object { $_.domain -eq $d.name -and $_.score -ge 60 }).Count -gt 0
    })
    $bestScore = 0
    $candidates = @($agentRows | ForEach-Object {
        $ds = $_.top_domains | Where-Object { $_.domain -eq $d.name } | Select-Object -First 1
        if ($ds) { $ds.score } else { 0 }
    })
    if ($candidates.Count -gt 0) { $bestScore = ($candidates | Measure-Object -Maximum).Maximum }

    $status = if ($bestScore -ge 60) { "PASS" } else { "FAIL" }
    $taskSims += @{
        domain = $d.name
        task = $d.task
        task_type = $d.task_type
        status = $status
        best_score = $bestScore
        capable_agents = $best.Count
    }
}

# === SCORES ===
$capScore = 0
if ($domainAgg.Count -gt 0) {
    $vals = @($domainAgg | ForEach-Object { $_["score"] })
    $capScore = [Math]::Round(($vals | Measure-Object -Average).Average)
}
$capScore = [Math]::Max(0, [Math]::Min(100, $capScore))

$passTasks = @($taskSims | Where-Object { $_.status -eq "PASS" }).Count
$taskRate = if ($taskSims.Count -gt 0) { [Math]::Round(($passTasks / $taskSims.Count) * 100) } else { 0 }

if ($capScore -ge 80 -and $taskRate -ge 80) { $verdict = "STRONG" }
elseif ($capScore -ge 60 -or $taskRate -ge 60) { $verdict = "MODERATE" }
else { $verdict = "WEAK" }

$results = @{
    tool = "capability-benchmark.ps1"
    version = $toolVersion
    timestamp = $timestamp
    agents_benchmarked = $agentRows.Count
    domains = $domainAgg
    agent_capabilities = $agentRows
    task_simulations = $taskSims
    capability_score = $capScore
    task_success_rate = $taskRate
    verdict = $verdict
    summary = "Benchmark: $capScore/100 capability, $taskRate% task simulation pass, verdict $verdict"
}

# === OUTPUT ===
if (-not (Test-Path -LiteralPath $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

if (-not $dryRun) {
    $reportPath = "$outputDir\capability-benchmark-$timestamp.json"
    $results | ConvertTo-Json -Depth 8 | Out-File -LiteralPath $reportPath -Encoding utf8
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "  CAPABILITY BENCHMARK REPORT" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "  Agents benchmarked: $($agentRows.Count)"
Write-Host "  ----------------------------------------------"
Write-Host "  Capability score:   $capScore/100"
Write-Host "  Task sim pass rate: $taskRate% ($passTasks/$($taskSims.Count))"
$vColor = "Green"
if ($verdict -eq "MODERATE") { $vColor = "Yellow" }
elseif ($verdict -eq "WEAK") { $vColor = "Red" }
Write-Host "  Verdict:            $verdict" -ForegroundColor $vColor
Write-Host "  ----------------------------------------------"
if ($domainAgg.Count -gt 0) {
    Write-Host "  Domain capabilities:" -ForegroundColor Cyan
    $domainAgg | Sort-Object { $_.score } -Descending | ForEach-Object {
        $pad = $_.domain.PadRight(15)
        $c = if ($_.score -ge 70) { "Green" } elseif ($_.score -ge 50) { "Yellow" } else { "Red" }
        Write-Host "    $pad $($_.score)%  (agents: $($_.agents))" -ForegroundColor $c
    }
}
if ($taskSims.Count -gt 0) {
    Write-Host "  ----------------------------------------------"
    Write-Host "  Task simulations:" -ForegroundColor Cyan
    $taskSims | ForEach-Object {
        $tc = if ($_.status -eq "PASS") { "Green" } else { "Red" }
        Write-Host "    [$($_.status)] $($_.task) (best score: $($_.best_score))" -ForegroundColor $tc
    }
}
Write-Host "================================================" -ForegroundColor Magenta
if (-not $dryRun) {
    Write-Host "Benchmark report saved: $reportPath" -ForegroundColor Green
}

return $results
