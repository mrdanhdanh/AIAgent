<#
.SYNOPSIS
Doctor Module: Report v2.0
.DESCRIPTION
Aggregates all module check results -> Health Score (13 categories, evolution-aligned)
+ Suggested Actions (HIGH/MEDIUM/LOW) + Doctor Report output.
v2.0:
- Adds evolution-engine groups to health score (Compatibility, SemanticDiff, Migration,
  KnowledgeMigrate, RuntimeEngine, CapabilityEngine, Stress, HealthScore)
- Aligns weights with health-score.ps1 (Runtime/Capability low weight, fallback 50)
- -Markdown generates DOCTOR_REPORT.md
- Get-DoctorReportFromCache regenerates the MD report from the latest JSON report
#>

function New-DoctorReport {
    param(
        [object]$Results,
        [string]$Mode = "quick",
        [string]$Root = ".",
        [switch]$Json,
        [switch]$Markdown
    )

    $timestamp = Get-Date -Format "o"
    $toolVersion = "2.0.0"

    # --- Health score categories --------------------------------
    $groups = @{}
    foreach ($r in $Results) {
        if ($r.group) { $groups[$r.group] = $r }
    }

    $categories = @()
    $weights = @{
        "Environment"     = 10
        "Agents"          = 12
        "Commands"        = 8
        "Skills"          = 12
        "Knowledge"       = 8
        "Workflow"        = 10
        "Contracts"       = 5
        "Runtime"         = 8
        "Simulation"      = 4
        "Benchmark"       = 3
        "Compatibility"   = 6
        "SemanticDiff"    = 3
        "Migration"       = 3
        "KnowledgeMigrate"= 3
        "RuntimeEngine"   = 2
        "CapabilityEngine"= 2
        "Stress"          = 2
        "HealthScore"     = 2
    }

    $weightTotal = 0
    $weightedSum = 0
    $usedGroups = @()

    foreach ($g in $weights.Keys) {
        if ($groups.ContainsKey($g)) {
            $score = [int]$groups[$g].score
            $w = $weights[$g]
            $weightedSum += $score * $w
            $weightTotal += $w
            $usedGroups += $g
            $categories += @{
                category = $g
                score    = $score
                status   = $groups[$g].status
                weight   = $w
            }
        }
    }

    # RuntimeEngine (evolution simulation) and CapabilityEngine (evolution benchmark)
    # override/feed the classic Runtime/Benchmark if the classic groups are absent.
    # If Runtime/Benchmark are missing but engine groups exist, add them as their category.
    $runtimeFallback = 50
    $capabilityFallback = 50

    # --- Issues aggregation -------------------------------------
    $allIssues = @()
    foreach ($r in $Results) {
        if ($r.issues) { $allIssues += $r.issues }
    }

    $overall = if ($weightTotal -gt 0) { [Math]::Round($weightedSum / $weightTotal) } else { 0 }

    # --- Suggested actions by priority --------------------------
    $high = @()
    $medium = @()
    $low = @()

    foreach ($cat in $categories) {
        if ($cat.score -lt 50) { $high += "$($cat.category) score low ($($cat.score)/100)" }
        elseif ($cat.score -lt 80) { $medium += "$($cat.category) score moderate ($($cat.score)/100)" }
        elseif ($cat.score -lt 100) { $low += "$($cat.category) minor gaps ($($cat.score)/100)" }
    }

    foreach ($issue in $allIssues) {
        $msg = $issue.message
        if ($issue.severity -eq "CRITICAL") { $high += $msg }
        elseif ($issue.severity -eq "MAJOR") { $medium += $msg }
        else { $low += $msg }
    }

    # Runtime Engine verdict suggestion
    if ($groups.ContainsKey("RuntimeEngine")) {
        $rt = $groups["RuntimeEngine"]
        if ($rt.runtime_health -lt 70) { $high += "Runtime health $($rt.runtime_health)/100 ($($rt.verdict)) - fix runtime errors before running /team" }
        elseif ($rt.runtime_health -lt 90) { $medium += "Runtime health $($rt.runtime_health)/100 ($($rt.verdict))" }
        foreach ($sa in @($rt.suggested_actions | Select-Object -Unique)) { $low += "Runtime suggestion: $sa" }
    }
    if ($groups.ContainsKey("CapabilityEngine")) {
        $ce = $groups["CapabilityEngine"]
        if ($ce.capability_score -lt 60) { $medium += "Capability score $($ce.capability_score)/100 ($($ce.verdict)) - consider adding skills/knowledge" }
    }

    # Doctor-specific suggestions
    if ($Mode -eq "quick" -and $overall -lt 80) {
        $medium += "Quick scan shows gaps - run /doctor --full for complete diagnosis"
    }
    if ($groups.ContainsKey("Contracts") -and $groups["Contracts"].score -lt 80) {
        $medium += "Contract registry gaps - run /doctor --contracts, then /team-syncdocs --compatibility"
    }
    if ($groups.ContainsKey("Compatibility") -and $groups["Compatibility"].score -lt 80) {
        $medium += "Compatibility issues - run /team-syncdocs --compatibility for details"
    }
    if ($groups.ContainsKey("Migration") -and $groups["Migration"].status -eq "ERROR") {
        $high += "Migration tasks required - run /team-syncdocs --migration"
    }
    if ($Mode -in @("full", "evolve") -and -not $groups.ContainsKey("HealthScore")) {
        $low += "Run /doctor --health for evolution-aligned Health Score"
    }
    $high = @($high | Select-Object -Unique)
    $medium = @($medium | Select-Object -Unique)
    $low = @($low | Select-Object -Unique)

    # --- Report object ------------------------------------------
    $report = @{
        doctor = @{
            version   = $toolVersion
            mode      = $Mode
            timestamp = $timestamp
            root      = $Root
        }
        pillars = @{
            environment = if ($groups.ContainsKey("Environment")) { $groups["Environment"] } else { $null }
            system      = @($groups.GetEnumerator() | Where-Object { $_.Key -in @("Agents","Commands","Skills","Workflow","Knowledge","Contracts","Compatibility","SemanticDiff","Migration","KnowledgeMigrate") } | ForEach-Object { $_.Value })
            runtime     = if ($groups.ContainsKey("RuntimeEngine")) { $groups["RuntimeEngine"] } else { if ($groups.ContainsKey("Runtime")) { $groups["Runtime"] } else { $null } }
            simulation  = if ($groups.ContainsKey("Simulation")) { $groups["Simulation"] } else { $null }
            capability  = if ($groups.ContainsKey("CapabilityEngine")) { $groups["CapabilityEngine"] } else { if ($groups.ContainsKey("Benchmark")) { $groups["Benchmark"] } else { $null } }
            stress      = if ($groups.ContainsKey("Stress")) { $groups["Stress"] } else { $null }
            health      = if ($groups.ContainsKey("HealthScore")) { $groups["HealthScore"] } else { $null }
        }
        health_score = @{
            overall    = $overall
            categories = $categories
        }
        suggestions = @{
            high   = $high
            medium = $medium
            low    = $low
        }
        issues      = $allIssues
        repair      = if ($groups.ContainsKey("Repair")) { $groups["Repair"] } else { $null }
    }

    # --- Console output -----------------------------------------
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " Doctor Report v$toolVersion  [mode: $Mode]" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    foreach ($cat in ($categories | Sort-Object category)) {
        $color = if ($cat.score -ge 80) { "Green" } elseif ($cat.score -ge 50) { "Yellow" } else { "Red" }
        $padded = $cat.category.PadRight(16)
        Write-Host ("  {0} {1}" -f $padded, $cat.score) -ForegroundColor $color
    }
    Write-Host ("  " + ("-" * 24))
    $overallColor = if ($overall -ge 80) { "Green" } elseif ($overall -ge 50) { "Yellow" } else { "Red" }
    Write-Host ("  {0} {1}/100" -f "OVERALL".PadRight(16), $overall) -ForegroundColor $overallColor
    Write-Host ""

    # Runtime/Capability verdict banner
    if ($groups.ContainsKey("RuntimeEngine")) {
        $rt = $groups["RuntimeEngine"]
        $rtColor = if ($rt.runtime_health -ge 90) { "Green" } elseif ($rt.runtime_health -ge 70) { "Yellow" } else { "Red" }
        Write-Host ("  Runtime Health:  {0}/100  ({1})" -f $rt.runtime_health, $rt.verdict) -ForegroundColor $rtColor
    }
    if ($groups.ContainsKey("CapabilityEngine")) {
        $ce = $groups["CapabilityEngine"]
        $ceColor = if ($ce.capability_score -ge 80) { "Green" } elseif ($ce.capability_score -ge 60) { "Yellow" } else { "Red" }
        Write-Host ("  Capability:     {0}/100  ({1}, task sim {2}%)" -f $ce.capability_score, $ce.verdict, $ce.task_success_rate) -ForegroundColor $ceColor
    }
    if ($groups.ContainsKey("Stress")) {
        $st = $groups["Stress"]
        $stColor = if ($st.success_rate -ge 90) { "Green" } elseif ($st.success_rate -ge 70) { "Yellow" } else { "Red" }
        Write-Host ("  Stress test:    {0}% success  ({1})" -f $st.success_rate, $st.verdict) -ForegroundColor $stColor
    }
    if ($groups.ContainsKey("HealthScore")) {
        $hs = $groups["HealthScore"]
        Write-Host ("  Evolution Health: {0}/100" -f $hs.score) -ForegroundColor $(if ($hs.score -ge 80) { "Green" } elseif ($hs.score -ge 50) { "Yellow" } else { "Red" })
    }
    if ($groups.ContainsKey("RuntimeEngine") -or $groups.ContainsKey("CapabilityEngine") -or $groups.ContainsKey("Stress") -or $groups.ContainsKey("HealthScore")) { Write-Host "" }

    # Per-group detail
    foreach ($r in $Results) {
        if ($r.group -and $r.group -ne "Repair") {
            Write-Host "  [$($r.group)]" -ForegroundColor Cyan
            foreach ($c in $r.checks) {
                $cColor = if ($c.status -eq "PASS") { "Green" } elseif ($c.status -eq "WARNING") { "Yellow" } else { "Red" }
                Write-Host ("    {0,-28} {1,-9} {2}" -f $c.name, $c.status, $c.detail) -ForegroundColor $cColor
            }
            Write-Host ""
        }
    }

    # Suggestions
    if ($high.Count -gt 0) {
        Write-Host "  HIGH PRIORITY" -ForegroundColor Red
        foreach ($h in $high) { Write-Host "    - $h" -ForegroundColor Yellow }
        Write-Host ""
    }
    if ($medium.Count -gt 0) {
        Write-Host "  MEDIUM PRIORITY" -ForegroundColor Yellow
        foreach ($m in $medium) { Write-Host "    - $m" -ForegroundColor Gray }
        Write-Host ""
    }
    if ($low.Count -gt 0) {
        Write-Host "  LOW PRIORITY" -ForegroundColor Gray
        foreach ($l in $low) { Write-Host "    - $l" -ForegroundColor Gray }
        Write-Host ""
    }

    # Repair summary
    if ($groups.ContainsKey("Repair")) {
        $rp = $groups["Repair"]
        Write-Host "  REPAIR" -ForegroundColor Cyan
        Write-Host "    status: $($rp.status) | repairs: $($rp.repair_count) | manual review: $($rp.manual_count)" -ForegroundColor Gray
        Write-Host ""
    }

    # --- JSON file output ---------------------------------------
    if ($Json) {
        $outDir = Join-Path $Root ".opencode/scripts/doctor/reports"
        if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }
        $reportPath = Join-Path $outDir ("doctor-report-" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".json")
        $report | ConvertTo-Json -Depth 8 | Out-File -LiteralPath $reportPath -Encoding utf8
        Write-Host "  Report saved: $reportPath" -ForegroundColor Gray
    }

    # --- Markdown report (DOCTOR_REPORT.md) ---------------------
    if ($Markdown) {
        $mdPath = Join-Path $Root ".opencode/DOCTOR_REPORT.md"
        $md = New-DoctorMarkdown -Report $report -Results $Results -Groups $groups
        $md | Out-File -LiteralPath $mdPath -Encoding utf8
        Write-Host "  Markdown report: $mdPath" -ForegroundColor Gray
    }

    return $report
}

# --- Build DOCTOR_REPORT.md ----------------------------------------
function New-DoctorMarkdown {
    param(
        [object]$Report,
        [object]$Results,
        [object]$Groups
    )

    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $L = New-Object System.Collections.ArrayList
    $null = $L.Add("# Doctor Report")
    $null = $L.Add("")
    $null = $L.Add("**Generated:** $now")
    $null = $L.Add("**Mode:** $($Report.doctor.mode)")
    $null = $L.Add("**Doctor:** v$($Report.doctor.version)")
    $null = $L.Add("")
    $null = $L.Add("---")
    $null = $L.Add("")
    $null = $L.Add("## Health Score")
    $null = $L.Add("")
    $null = $L.Add("| Category | Score | Status |")
    $null = $L.Add("|----------|-------|--------|")
    foreach ($cat in ($Report.health_score.categories | Sort-Object category)) {
        $null = $L.Add("| $($cat.category) | $($cat.score)/100 | $($cat.status) |")
    }
    $null = $L.Add("| **OVERALL** | **$($Report.health_score.overall)/100** | |")
    $null = $L.Add("")

    # Runtime / Capability / Stress verdicts
    if ($Groups.ContainsKey("RuntimeEngine")) {
        $rt = $Groups["RuntimeEngine"]
        $null = $L.Add("## Runtime Health (Simulation Engine)")
        $null = $L.Add("")
        $null = $L.Add("| Metric | Value |")
        $null = $L.Add("|--------|-------|")
        $null = $L.Add("| Runtime Health | $($rt.runtime_health)/100 |")
        $null = $L.Add("| Verdict | $($rt.verdict) |")
        $null = $L.Add("")
        foreach ($sa in @($rt.suggested_actions | Select-Object -Unique)) { $null = $L.Add("- $sa") }
        $null = $L.Add("")
        $null = $L.Add("---")
        $null = $L.Add("")
    }
    if ($Groups.ContainsKey("CapabilityEngine")) {
        $ce = $Groups["CapabilityEngine"]
        $null = $L.Add("## Capability Benchmark")
        $null = $L.Add("")
        $null = $L.Add("| Metric | Value |")
        $null = $L.Add("|--------|-------|")
        $null = $L.Add("| Capability Score | $($ce.capability_score)/100 |")
        $null = $L.Add("| Verdict | $($ce.verdict) |")
        $null = $L.Add("| Task simulation pass | $($ce.task_success_rate)% |")
        $null = $L.Add("")
        $null = $L.Add("### Domain Capabilities")
        $null = $L.Add("")
        $null = $L.Add("| Domain | Score | Agents |")
        $null = $L.Add("|--------|-------|--------|")
        if ($ce.data.domains) {
            foreach ($d in ($ce.data.domains | Sort-Object { $_.score } -Descending)) {
                $null = $L.Add("| $($d.domain) | $($d.score)/100 | $($d.agents) |")
            }
        }
        $null = $L.Add("")
        $null = $L.Add("---")
        $null = $L.Add("")
    }
    if ($Groups.ContainsKey("Stress")) {
        $st = $Groups["Stress"]
        $null = $L.Add("## Stress Test")
        $null = $L.Add("")
        $null = $L.Add("| Metric | Value |")
        $null = $L.Add("|--------|-------|")
        $null = $L.Add("| Tasks | $($st.data.stress_test.total_tasks) |")
        $null = $L.Add("| Success rate | $($st.success_rate)% |")
        $null = $L.Add("| Verdict | $($st.verdict) |")
        $null = $L.Add("")
        if ($st.data.stress_test.weakest_steps.Count -gt 0) {
            $null = $L.Add("### Weakest steps")
            $null = $L.Add("")
            foreach ($w in $st.data.stress_test.weakest_steps) {
                $null = $L.Add("- $($w.step): $($w.failure_rate)% failure ($($w.failure_count)x)")
            }
            $null = $L.Add("")
        }
        $null = $L.Add("---")
        $null = $L.Add("")
    }
    if ($Groups.ContainsKey("HealthScore")) {
        $hs = $Groups["HealthScore"]
        $null = $L.Add("## Evolution Health Score")
        $null = $L.Add("")
        $null = $L.Add("| Category | Score |")
        $null = $L.Add("|----------|-------|")
        foreach ($cat in ($hs.categories.PSObject.Properties | Sort-Object Name)) {
            $null = $L.Add("| $($cat.Name) | $($cat.Value)/100 |")
        }
        $null = $L.Add("| **Overall** | **$($hs.score)/100** |")
        $null = $L.Add("")
        foreach ($rec in @($hs.recommendations | Select-Object -Unique)) { $null = $L.Add("- $rec") }
        $null = $L.Add("")
        $null = $L.Add("---")
        $null = $L.Add("")
    }

    # Suggestions
    $null = $L.Add("## Suggested Actions")
    $null = $L.Add("")
    if ($Report.suggestions.high.Count -gt 0) {
        $null = $L.Add("### HIGH")
        $null = $L.Add("")
        foreach ($h in $Report.suggestions.high) { $null = $L.Add("- $h") }
        $null = $L.Add("")
    }
    if ($Report.suggestions.medium.Count -gt 0) {
        $null = $L.Add("### MEDIUM")
        $null = $L.Add("")
        foreach ($m in $Report.suggestions.medium) { $null = $L.Add("- $m") }
        $null = $L.Add("")
    }
    if ($Report.suggestions.low.Count -gt 0) {
        $null = $L.Add("### LOW")
        $null = $L.Add("")
        foreach ($item in $Report.suggestions.low) { $null = $L.Add("- $item") }
        $null = $L.Add("")
    }
    $null = $L.Add("---")
    $null = $L.Add("")

    # Issues
    $null = $L.Add("## Issues")
    $null = $L.Add("")
    if ($Report.issues.Count -eq 0) {
        $null = $L.Add("No issues detected.")
    }
    else {
        foreach ($issue in ($Report.issues | Select-Object -First 40)) {
            $null = $L.Add("- [$($issue.severity)] $($issue.group): $($issue.message)")
        }
        if ($Report.issues.Count -gt 40) { $null = $L.Add("- ... and $($Report.issues.Count - 40) more") }
    }
    $null = $L.Add("")
    $null = $L.Add("---")
    $null = $L.Add("")
    $null = $L.Add("> Generated by Doctor v$($Report.doctor.version) | Run `/doctor --full --markdown` to refresh")

    return ($L -join "`r`n")
}

# --- Regenerate DOCTOR_REPORT.md from latest JSON cache -------------
function Get-DoctorReportFromCache {
    param([string]$Root = ".")
    $outDir = Join-Path $Root ".opencode/scripts/doctor/reports"
    $latest = Get-ChildItem -Path $outDir -Filter "doctor-report-*.json" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $latest) {
        Write-Host "No cached doctor report found. Run /doctor --full --json first." -ForegroundColor Yellow
        return $null
    }
    Write-Host "Loading cached report: $($latest.Name)" -ForegroundColor Cyan
    $json = Get-Content -LiteralPath $latest.FullName -Raw -Encoding utf8
    $data = $json | ConvertFrom-Json

    # Rebuild a groups hashtable for the markdown generator
    $groups = @{}
    if ($data.pillars.system) {
        foreach ($g in $data.pillars.system) { if ($g.group) { $groups[$g.group] = $g } }
    }
    if ($data.pillars.environment) { $groups[$data.pillars.environment.group] = $data.pillars.environment }
    if ($data.pillars.runtime) { $groups[$data.pillars.runtime.group] = $data.pillars.runtime }
    if ($data.pillars.simulation) { $groups[$data.pillars.simulation.group] = $data.pillars.simulation }
    if ($data.pillars.capability) { $groups[$data.pillars.capability.group] = $data.pillars.capability }
    if ($data.pillars.stress) { $groups[$data.pillars.stress.group] = $data.pillars.stress }
    if ($data.pillars.health) { $groups[$data.pillars.health.group] = $data.pillars.health }

    $mdPath = Join-Path $Root ".opencode/DOCTOR_REPORT.md"
    $md = New-DoctorMarkdown -Report $data -Results @() -Groups $groups
    $md | Out-File -LiteralPath $mdPath -Encoding utf8
    Write-Host "Markdown report regenerated: $mdPath" -ForegroundColor Green
    return $data
}
