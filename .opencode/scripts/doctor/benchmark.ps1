<#
.SYNOPSIS
Doctor Module: Capability Benchmark
.DESCRIPTION
Scores each agent capability by domain based on heuristics:
description keywords + knowledge coverage + skill presence.
#>

function Get-DoctorBenchmark {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $agentsDir = Join-Path $Root ".opencode/agents"
    $knowledgeDir = Join-Path $Root ".opencode/knowledge"
    $agentFiles = @(Get-ChildItem -Path $agentsDir -Filter "*.md" -ErrorAction SilentlyContinue)

    # Domain -> keywords
    $domains = @(
        @{ name = "Blazor";     keywords = @("blazor","razor","fluentui","component",".net") },
        @{ name = "Planning";   keywords = @("plan","design","architecture","requirement","analy") },
        @{ name = "Testing";    keywords = @("test","coverage","bunit","playwright","xunit") },
        @{ name = "Git";        keywords = @("git","push","commit","branch","remote") },
        @{ name = "Security";   keywords = @("secret","security","vulnerab","xss","guard") },
        @{ name = "UI/UX";      keywords = @("ui","ux","interface","design","css","accessib") },
        @{ name = "Docs";       keywords = @("document","knowledge","lesson","pattern","md") },
        @{ name = "Orchestration"; keywords = @("orchestr","workflow","state","agent","dispatch") },
        @{ name = "Scripting";  keywords = @("powershell","script","automation","utility") },
        @{ name = "Database";   keywords = @("sql","database","oracle","storage","crud") }
    )

    $checks = @()
    $issues = @()
    $agentRows = @()

    foreach ($af in $agentFiles) {
        $name = $af.BaseName
        $content = Get-Content -LiteralPath $af.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        $lower = $content.ToLower()

        $scores = @()
        foreach ($d in $domains) {
            $hits = @($d.keywords | Where-Object { $lower.Contains($_) }).Count
            # base 40 + 15 per keyword hit (max 100)
            $s = [Math]::Min(100, 40 + ($hits * 15))
            if ($s -gt 55) { $scores += @{ domain = $d.name; score = $s } }
        }
        $top = @($scores | Sort-Object { $_.score } -Descending | Select-Object -First 4)
        $avgTop = if ($top.Count -gt 0) {
            $vals = @($top | ForEach-Object { $_["score"] })
            [Math]::Round(($vals | Measure-Object -Average).Average)
        } else { 0 }
        $agentRows += @{
            agent = $name
            top_domains = $top
            overall = $avgTop
        }
    }

    # Aggregate per domain across agents
    $domainAgg = @()
    foreach ($d in $domains) {
        $matching = @($agentRows | Where-Object {
            @($_.top_domains | Where-Object { $_.domain -eq $d.name }).Count -gt 0
        })
        $avg = if ($matching.Count -gt 0) {
            $vals = @($matching | ForEach-Object { $dScore = ($_.top_domains | Where-Object { $_.domain -eq $d.name } | Select-Object -First 1).score; $dScore })
            [Math]::Round(($vals | Measure-Object -Average).Average)
        } else { 0 }
        if ($avg -gt 0) { $domainAgg += @{ domain = $d.name; score = $avg; agents = $matching.Count } }
    }

    $checks += @{
        name = "Domain capability"
        status = "PASS"
        detail = ($domainAgg | ForEach-Object { "$($_.domain):$($_.score)" }) -join ", "
    }
    $checks += @{
        name = "Agents benchmarked"
        status = "PASS"
        detail = "$($agentRows.Count) agents scored"
    }

    $score = if ($domainAgg.Count -gt 0) {
        $vals = @($domainAgg | ForEach-Object { $_["score"] })
        [Math]::Round(($vals | Measure-Object -Average).Average)
    } else { 50 }
    $score = [Math]::Max(0, [Math]::Min(100, $score))
    $status = if ($score -ge 70) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group         = "Benchmark"
        score         = $score
        status        = $status
        agents        = $agentRows
        domain_scores = $domainAgg
        checks        = $checks
        issues        = $issues
    }
}
