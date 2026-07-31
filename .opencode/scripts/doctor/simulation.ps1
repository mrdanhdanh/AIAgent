<#
.SYNOPSIS
Doctor Module: Simulation Check
.DESCRIPTION
Simulates 6 scenario types (Bug Fix, New Feature, Migration, Review, Testing,
Refactoring) through the workflow. Computes success rate and common issues.
#>

function Invoke-DoctorSimulation {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $cmdsDir = Join-Path $Root ".opencode/commands"
    $agentsDir = Join-Path $Root ".opencode/agents"
    $skillsDir = Join-Path $Root ".opencode/skills"

    # Scenario -> required commands + agents + skills
    $scenarios = @(
        @{
            type = "Bug Fix"
            path = @("team-analyze", "team-plan", "team-review", "team-build", "team-test")
            skills = @("dev-team")
        },
        @{
            type = "New Feature"
            path = @("team-analyze", "team-plan", "team-review", "team-build", "team-ui-audit", "team-testplan", "team-test")
            skills = @("dev-team", "impeccable")
        },
        @{
            type = "Migration"
            path = @("team-analyze", "team-plan", "team-review", "team-build", "team-test")
            skills = @("dev-team")
        },
        @{
            type = "Review"
            path = @("team-review", "team-gitguard")
            skills = @("dev-team", "gitguard")
        },
        @{
            type = "Testing"
            path = @("team-testplan", "team-test")
            skills = @("dev-team")
        },
        @{
            type = "Refactoring"
            path = @("team-analyze", "team-plan", "team-review", "team-build", "team-ui-audit", "team-test")
            skills = @("dev-team", "impeccable", "workspace-cleaner")
        }
    )

    $checks = @()
    $issues = @()
    $successCount = 0
    $failCount = 0
    $issueCounts = @{}

    foreach ($sc in $scenarios) {
        $simIssues = @()

        # Check commands
        foreach ($cmd in $sc.path) {
            $cmdFile = Join-Path $cmdsDir "$cmd.md"
            if (-not (Test-Path -LiteralPath $cmdFile)) {
                $simIssues += "Missing command: $cmd"
                $issueCounts["Missing command"] = $issueCounts["Missing command"] + 1
            }
        }

        # Check agents via opencode.json mapping
        $ocConfigPath = Join-Path $Root "opencode.json"
        $agentNames = @(Get-ChildItem -Path $agentsDir -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object { $_.BaseName })
        if (Test-Path -LiteralPath $ocConfigPath) {
            try {
                $ocConfig = Get-Content -LiteralPath $ocConfigPath -Raw -Encoding utf8 | ConvertFrom-Json
                foreach ($cmd in $sc.path) {
                    if ($ocConfig.command.$cmd) {
                        $a = "$($ocConfig.command.$cmd.agent)"
                        if ($a -and $a -notin $agentNames) {
                            $simIssues += "Missing agent: $a (for $cmd)"
                            $issueCounts["Missing agent"] = $issueCounts["Missing agent"] + 1
                        }
                    }
                }
            }
            catch {
                $simIssues += "opencode.json unparseable"
                $issueCounts["Config error"] = $issueCounts["Config error"] + 1
            }
        }

        # Check skills
        foreach ($sk in $sc.skills) {
            if (-not (Test-Path -LiteralPath (Join-Path $skillsDir "$sk/SKILL.md"))) {
                $simIssues += "Missing skill: $sk"
                $issueCounts["Missing skill"] = $issueCounts["Missing skill"] + 1
            }
        }

        if ($simIssues.Count -eq 0) {
            $successCount++
            $status = "SUCCESS"
        }
        else {
            $failCount++
            $status = "FAILED"
        }

        $checks += @{
            name   = $sc.type
            status = $status
            detail = if ($simIssues.Count -eq 0) { "workflow path ready" } else { ($simIssues -join "; ") }
        }
        if ($simIssues.Count -gt 0) {
            $issues += @{ severity = "MAJOR"; group = "Simulation"; message = "$($sc.type): $($simIssues -join '; ')" }
        }
    }

    $total = $scenarios.Count
    $successRate = if ($total -gt 0) { [Math]::Round(($successCount / $total) * 100) } else { 0 }
    $score = $successRate

    # Top issue types
    $topIssues = @($issueCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 3 | ForEach-Object { "$($_.Key) ($($_.Value)x)" })

    $checks += @{ name = "Success rate"; status = if ($successRate -ge 80) { "PASS" } else { "WARNING" }; detail = "$successRate% ($successCount/$total)" }

    $status = if ($successRate -ge 80) { "PASS" } elseif ($successRate -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group        = "Simulation"
        score        = $score
        status       = $status
        success_rate = $successRate
        successes    = $successCount
        failures     = $failCount
        top_issues   = $topIssues
        checks       = $checks
        issues       = $issues
    }
}
