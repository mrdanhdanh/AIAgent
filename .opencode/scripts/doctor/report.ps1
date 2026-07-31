<#
.SYNOPSIS
Doctor Module: Report
.DESCRIPTION
Aggregates all module check results -> Health Score (9 categories)
+ Suggested Actions (HIGH/MEDIUM/LOW) + Doctor Report output.
#>

function New-DoctorReport {
    param(
        [object]$Results,
        [string]$Mode = "quick",
        [string]$Root = ".",
        [switch]$Json
    )

    $timestamp = Get-Date -Format "o"
    $toolVersion = "1.0.0"

    # --- Health score categories --------------------------------
    # Map: group -> (score, category label)
    $groups = @{}
    foreach ($r in $Results) {
        if ($r.group) { $groups[$r.group] = $r }
    }

    $categories = @()
    $weights = @{
        "Environment"  = 10
        "Agents"       = 15
        "Commands"     = 10
        "Skills"       = 15
        "Knowledge"    = 10
        "Workflow"     = 10
        "Contracts"    = 5
        "Runtime"      = 10
        "Simulation"   = 5
        "Benchmark"    = 5
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

    # Compatibility = contracts (khi c?) - map category
    $overall = if ($weightTotal -gt 0) { [Math]::Round($weightedSum / $weightTotal) } else { 0 }

    # --- Issues aggregation -------------------------------------
    $allIssues = @()
    foreach ($r in $Results) {
        if ($r.issues) { $allIssues += $r.issues }
    }

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

    # Doctor-specific suggestions
    if ($Mode -eq "quick" -and $overall -lt 80) {
        $medium += "Quick scan shows gaps - run /doctor --full for complete diagnosis"
    }
    if ($groups.ContainsKey("Contracts") -and $groups["Contracts"].score -lt 80) {
        $medium += "Contract registry gaps - run /doctor --contracts, then /team-syncdocs --compatibility"
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
            system      = @($groups.GetEnumerator() | Where-Object { $_.Key -in @("Agents","Commands","Skills","Workflow","Knowledge","Contracts") } | ForEach-Object { $_.Value })
            runtime     = if ($groups.ContainsKey("Runtime")) { $groups["Runtime"] } else { $null }
            simulation  = if ($groups.ContainsKey("Simulation")) { $groups["Simulation"] } else { $null }
            capability  = if ($groups.ContainsKey("Benchmark")) { $groups["Benchmark"] } else { $null }
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

    return $report
}
