<#
.SYNOPSIS
Doctor v2.0 - System health checker for AI Agent Framework
.DESCRIPTION
Scans the whole .opencode/ ecosystem across 4 pillars:
- Environment: OpenCode, PowerShell, Python, Git, config, folders
- System: Agents, Commands, Skills, Knowledge, Workflow, Contracts
- Runtime: fake task simulation + 6 scenario types + Simulation Engine (runtime validation)
- Capability: agent capability benchmark (doctor heuristic + evolution engine)
v2.0 adds evolution-engine integration (semantic diff, compatibility, migration,
knowledge migration, stress test) reusing .opencode/scripts/evolution/*.ps1.
Supports health score, suggested actions, self-repair (safe only), DOCTOR_REPORT.md.
.EXAMPLE
& ".opencode\scripts\doctor.ps1" -Mode quick
& ".opencode\scripts\doctor.ps1" -Mode full -Json
& ".opencode\scripts\doctor.ps1" -Mode evolve -Markdown
& ".opencode\scripts\doctor.ps1" -Mode repair -Force
& ".opencode\scripts\doctor.ps1" -Mode stress -StressCount 20
& ".opencode\scripts\doctor.ps1" -Mode compatibility
.NOTES
Modes: quick|full|runtime|workflow|agent|skill|command|knowledge|contracts|
simulation|benchmark|repair|compatibility|semanticdiff|migration|knowledgemigrate|
stress|health|report|evolve
Flags: -Force -DryRun -Json -Markdown -StressCount -StressSeed
#>

[CmdletBinding()]
param(
    [ValidateSet("quick", "full", "runtime", "workflow", "agent", "skill", "command", "knowledge", "contracts", "simulation", "benchmark", "repair", "compatibility", "semanticdiff", "migration", "knowledgemigrate", "stress", "health", "report", "evolve")]
    [string]$Mode = "quick",

    [switch]$Force,
    [switch]$DryRun,
    [switch]$Json,
    [switch]$Markdown,

    # Stress test params (mode: stress / evolve)
    [int]$StressCount = 20,
    [string]$StressSeed = "fixed"
)

$ErrorActionPreference = "Continue"
$toolVersion = "2.0.0"
$root = (Resolve-Path -LiteralPath (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path | Split-Path -Parent | Split-Path -Parent
$moduleDir = Join-Path $root ".opencode/scripts/doctor"

Write-Host "Doctor v$toolVersion - mode: $Mode" -ForegroundColor Cyan

# --- Dot-source all modules --------------------------------------
$modules = @(
    "environment.ps1", "agents.ps1", "commands.ps1", "skills.ps1",
    "workflows.ps1", "runtime.ps1", "simulation.ps1", "benchmark.ps1",
    "repair.ps1", "report.ps1", "evolution.ps1"
)

$loaded = @()
foreach ($mod in $modules) {
    $modPath = Join-Path $moduleDir $mod
    if (Test-Path -LiteralPath $modPath) {
        . $modPath
        $loaded += $mod
    }
    else {
        Write-Warning "Missing doctor module: $mod"
    }
}

# --- Dispatch by mode --------------------------------------------
$results = @()

switch ($Mode) {
    "quick" {
        $results += Get-DoctorEnvironment -Root $root
        $results += Get-DoctorAgents -Root $root
        $results += Get-DoctorCommands -Root $root
    }
    "full" {
        $results += Get-DoctorEnvironment -Root $root
        $results += Get-DoctorAgents -Root $root
        $results += Get-DoctorCommands -Root $root
        $results += Get-DoctorSkills -Root $root
        $results += Get-DoctorWorkflows -Root $root
        $results += Get-DoctorKnowledge -Root $root
        $results += Get-DoctorContracts -Root $root
        $results += Get-DoctorRuntime -Root $root
        $results += Invoke-DoctorSimulation -Root $root
        $results += Get-DoctorBenchmark -Root $root
        # Evolution engines (v2.0)
        $results += Invoke-DoctorCompatibility -Root $root
        $results += Invoke-DoctorSemanticDiff -Root $root
        $results += Invoke-DoctorMigration -Root $root
        $results += Invoke-DoctorKnowledgeMigrate -Root $root
        $results += Invoke-DoctorSimulationEngine -Root $root
        $results += Invoke-DoctorBenchmarkEngine -Root $root
        $results += Invoke-DoctorStressTest -Root $root -Count $StressCount -Seed $StressSeed
    }
    "runtime" {
        $results += Get-DoctorEnvironment -Root $root
        $results += Get-DoctorRuntime -Root $root
        $results += Invoke-DoctorSimulationEngine -Root $root
    }
    "workflow" {
        $results += Get-DoctorWorkflows -Root $root
        $results += Get-DoctorKnowledge -Root $root
        $results += Get-DoctorContracts -Root $root
    }
    "agent" {
        $results += Get-DoctorAgents -Root $root
    }
    "skill" {
        $results += Get-DoctorSkills -Root $root
    }
    "command" {
        $results += Get-DoctorCommands -Root $root
    }
    "knowledge" {
        $results += Get-DoctorKnowledge -Root $root
    }
    "contracts" {
        $results += Get-DoctorContracts -Root $root
    }
    "simulation" {
        $results += Invoke-DoctorSimulation -Root $root
        $results += Invoke-DoctorSimulationEngine -Root $root
    }
    "benchmark" {
        $results += Get-DoctorBenchmark -Root $root
        $results += Invoke-DoctorBenchmarkEngine -Root $root
    }
    "compatibility" {
        $results += Invoke-DoctorCompatibility -Root $root
        $results += Invoke-DoctorSemanticDiff -Root $root
    }
    "semanticdiff" {
        $results += Invoke-DoctorSemanticDiff -Root $root
    }
    "migration" {
        $results += Invoke-DoctorMigration -Root $root
    }
    "knowledgemigrate" {
        $results += Invoke-DoctorKnowledgeMigrate -Root $root
    }
    "stress" {
        $results += Invoke-DoctorStressTest -Root $root -Count $StressCount -Seed $StressSeed
    }
    "health" {
        $results += Invoke-DoctorEvolutionHealth -Root $root
    }
    "report" {
        # Read-only: regenerate DOCTOR_REPORT.md from latest doctor JSON report
        $report = Get-DoctorReportFromCache -Root $root
        exit 0
    }
    "evolve" {
        # Full evolution pipeline: doctor checks + all 9 evolution engines
        $results += Get-DoctorEnvironment -Root $root
        $results += Get-DoctorAgents -Root $root
        $results += Get-DoctorCommands -Root $root
        $results += Get-DoctorSkills -Root $root
        $results += Get-DoctorWorkflows -Root $root
        $results += Get-DoctorKnowledge -Root $root
        $results += Get-DoctorContracts -Root $root
        $results += Invoke-DoctorCompatibility -Root $root
        $results += Invoke-DoctorSemanticDiff -Root $root
        $results += Invoke-DoctorMigration -Root $root
        $results += Invoke-DoctorKnowledgeMigrate -Root $root
        $results += Invoke-DoctorSimulationEngine -Root $root
        $results += Invoke-DoctorBenchmarkEngine -Root $root
        $results += Invoke-DoctorStressTest -Root $root -Count $StressCount -Seed $StressSeed
        $results += Invoke-DoctorEvolutionHealth -Root $root
    }
    "repair" {
        $results += Get-DoctorEnvironment -Root $root
        $results += Get-DoctorAgents -Root $root
        $results += Get-DoctorCommands -Root $root
        $results += Get-DoctorSkills -Root $root
        $results += Get-DoctorWorkflows -Root $root
        $results += Get-DoctorKnowledge -Root $root
        $results += Get-DoctorContracts -Root $root
        $results += Get-DoctorRuntime -Root $root
        $results += Invoke-DoctorSimulation -Root $root
        $results += Invoke-DoctorCompatibility -Root $root
        $repair = Invoke-DoctorRepair -Results $results -Root $root -Force:$Force -DryRun:$DryRun
        $results += $repair
    }
    default {
        Write-Error "Unknown mode: $Mode"
        exit 1
    }
}

# --- Report ------------------------------------------------------
if ($Mode -eq "repair") {
    # Repair mode: show repair summary primarily
    $repairResult = $results | Where-Object { $_.group -eq "Repair" } | Select-Object -First 1
    if ($repairResult) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host " Doctor Repair Report" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "  status: $($repairResult.status) | dry_run: $($repairResult.dry_run) | force: $($repairResult.force)"
        Write-Host "  repairs: $($repairResult.repair_count) | manual review required: $($repairResult.manual_count)"
        Write-Host ""
        Write-Host "  Repairs:" -ForegroundColor Cyan
        foreach ($r in $repairResult.repairs) {
            $rColor = if ($r.status -eq "FIXED") { "Green" } elseif ($r.status -eq "DRY-RUN") { "Yellow" } else { "Red" }
            Write-Host ("    {0,-18} {1,-22} {2,-10} {3}" -f $r.category, $r.target, $r.action, $r.status) -ForegroundColor $rColor
        }
        if ($repairResult.skipped.Count -gt 0) {
            Write-Host ""
            Write-Host "  Skipped:" -ForegroundColor Yellow
            foreach ($s in $repairResult.skipped) { Write-Host "    - $s" -ForegroundColor Gray }
        }
        if ($repairResult.manual_review.Count -gt 0) {
            Write-Host ""
            Write-Host "  Manual review required:" -ForegroundColor Yellow
            foreach ($m in ($repairResult.manual_review | Select-Object -First 20)) { Write-Host "    - $m" -ForegroundColor Gray }
            if ($repairResult.manual_count -gt 20) { Write-Host "    ... and $($repairResult.manual_count - 20) more" -ForegroundColor Gray }
        }
    }
}
else {
    $report = New-DoctorReport -Results $results -Mode $Mode -Root $root -Json:$Json -Markdown:$Markdown
}

Write-Host ""
Write-Host "Doctor scan complete." -ForegroundColor Green
exit 0
