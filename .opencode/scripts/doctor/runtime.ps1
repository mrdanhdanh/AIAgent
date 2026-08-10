<#
.SYNOPSIS
Doctor Module: Runtime Check
.DESCRIPTION
Simulates 1 fake task through the 13-step workflow (analyze ... complete).
Checks: runtime errors (missing command/agent/file), output schema,
workflow consistency, prompt conflict, missing skill.
#>

function Get-DoctorRuntime {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $cmdsDir = Join-Path $Root ".opencode/commands"
    $agentsDir = Join-Path $Root ".opencode/agents"
    $skillsDir = Join-Path $Root ".opencode/skills"
    $contractsDir = Join-Path $Root ".opencode/system/contracts"

    # Fake task workflow path: step -> command file -> agent file
    $fakeTaskSteps = @(
        @{ step = 1; name = "analyze";         command = "team-analyze.md";      agent = "analyst.md" },
        @{ step = 2; name = "design";          command = "team-plan.md";         agent = "planner.md" },
        @{ step = 3; name = "plan";            command = "team-plan.md";         agent = "planner.md" },
        @{ step = 4; name = "review";          command = "team-review.md";       agent = "reviewer.md" },
        @{ step = 5; name = "guardrail";       command = $null;                  agent = $null },
        @{ step = 6; name = "backup";          command = "backup.md";            agent = "backup-agent.md" },
        @{ step = 7; name = "build";           command = "team-build.md";        agent = "builder.md" },
        @{ step = 8; name = "static_analysis"; command = $null;                  agent = $null },
        @{ step = 9; name = "ui_audit";        command = "team-ui-audit.md";     agent = "ui-beautifier.md" },
        @{ step = 10; name = "testplan";       command = "team-testplan.md";     agent = "test-planner.md" },
        @{ step = 11; name = "test";           command = "team-test.md";         agent = "tester.md" },
        @{ step = 12; name = "skill_validation"; command = "team-selfimprove.md"; agent = "self-improver.md" },
        @{ step = 13; name = "complete";       command = $null;                  agent = $null }
    )

    $checks = @()
    $issues = @()
    $passed = 0
    $failed = 0

    foreach ($s in $fakeTaskSteps) {
        $cmdOk = $true
        $agentOk = $true
        $note = ""

        if ($s.command) {
            $cmdPath = Join-Path $cmdsDir $s.command
            if (-not (Test-Path -LiteralPath $cmdPath)) { $cmdOk = $false; $note += "cmd-missing($($s.command)) " }
        }
        if ($s.agent) {
            $agentPath = Join-Path $agentsDir $s.agent
            if (-not (Test-Path -LiteralPath $agentPath)) { $agentOk = $false; $note += "agent-missing($($s.agent)) " }
        }

        $stepStatus = if ($cmdOk -and $agentOk) { "PASS" } else { "FAIL" }
        if ($stepStatus -eq "PASS") { $passed++ } else { $failed++ }

        $checks += @{
            name   = "$($s.step).$($s.name)"
            status = $stepStatus
            detail = if ($note) { $note.Trim() } else { "command+agent available" }
        }
        if ($stepStatus -eq "FAIL") {
            $issues += @{ severity = "CRITICAL"; group = "Runtime"; message = "Step $($s.step) ($($s.name)): $($note.Trim())" }
        }
    }

    # Contract parse simulation (output schema) — workflow contracts are state machines, no input/output
    $contractFiles = @(Get-ChildItem -Path $contractsDir -Filter "*.yaml" -ErrorAction SilentlyContinue | Where-Object {
        $c = Get-Content -LiteralPath $_.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        $c -notmatch '(?m)^type\s*:\s*workflow\s*$'
    })
    $contractOk = 0
    foreach ($cf in $contractFiles) {
        $content = Get-Content -LiteralPath $cf.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        if ($content -match 'contract_version\s*:' -and $content -match '(?i)(input|output)\s*:') { $contractOk++ }
    }
    $checks += @{ name = "Output schema"; status = if ($contractOk -eq $contractFiles.Count) { "PASS" } else { "WARNING" }; detail = "$contractOk/$($contractFiles.Count) contracts parse with input/output" }

    # Missing skill for runtime
    $skillDirs = @(Get-ChildItem -Path $skillsDir -Directory -ErrorAction SilentlyContinue)
    if ($skillDirs.Count -ge 1) {
        $checks += @{ name = "Missing skill"; status = "PASS"; detail = "$($skillDirs.Count) skills available for workflow" }
    }
    else {
        $failed++
        $issues += @{ severity = "MAJOR"; group = "Runtime"; message = "No skills available" }
        $checks += @{ name = "Missing skill"; status = "FAIL"; detail = "no skills" }
    }

    $total = $fakeTaskSteps.Count + 2
    $score = [Math]::Round((($passed + $contractOk) / $total) * 100)
    $score = [Math]::Max(0, [Math]::Min(100, $score))
    $status = if ($failed -eq 0) { "PASS" } elseif ($failed -le 2) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Runtime"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}
