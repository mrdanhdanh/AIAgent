<#
.SYNOPSIS
Doctor Module: Skill Check
.DESCRIPTION
Checks each skill package (.opencode/skills/*/SKILL.md):
SKILL.md exists, schema_version, dependencies, knowledge, compatibility,
missing files, deprecated contents.
#>

function Get-DoctorSkills {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $skillsDir = Join-Path $Root ".opencode/skills"
    $skillDirs = @(Get-ChildItem -Path $skillsDir -Directory -ErrorAction SilentlyContinue)

    $checks = @()
    $issues = @()
    $score = 100

    if ($skillDirs.Count -eq 0) {
        return @{
            group  = "Skills"
            score  = 0
            status = "ERROR"
            checks = @(@{ name = "Skills"; status = "ERROR"; detail = "No skill packages found" })
            issues = @(@{ severity = "CRITICAL"; group = "Skills"; message = "No skills installed" })
        }
    }

    foreach ($sd in $skillDirs) {
        $skillName = $sd.Name
        $skillMd = Join-Path $sd.FullName "SKILL.md"
        $skillIssues = @()
        $sub = @()

        # --- SKILL.md exists ---
        if (Test-Path -LiteralPath $skillMd) {
            $content = Get-Content -LiteralPath $skillMd -Raw -Encoding utf8 -ErrorAction SilentlyContinue
            $sub += @{ name = "SKILL.md"; status = "PASS"; detail = "present" }

            # --- Frontmatter / schema_version ---
            if ($content -match 'schema_version\s*:\s*"?(\d+\.\d+)"?') {
                $ver = $Matches[1]
                $sub += @{ name = "Schema version"; status = "PASS"; detail = $ver }
                if ([version]$ver -lt [version]"1.0") {
                    $skillIssues += @{ severity = "WARNING"; group = "Skills"; message = "$($skillName): schema version $ver below 1.0" }
                }
            }
            else {
                $sub += @{ name = "Schema version"; status = "WARNING"; detail = "missing" }
                $skillIssues += @{ severity = "WARNING"; group = "Skills"; message = "$($skillName): missing schema_version" }
            }

            # --- Description ---
            if ($content -match 'description\s*:\s*\S') {
                $sub += @{ name = "Description"; status = "PASS"; detail = "present" }
            }
            else {
                $skillIssues += @{ severity = "MAJOR"; group = "Skills"; message = "$($skillName): missing description" }
            }

            # --- Deprecated contents ---
            if ($content -match '(?i)(outdated|deprecated|legacy)') {
                $skillIssues += @{ severity = "WARNING"; group = "Skills"; message = "$($skillName): contains deprecated/outdated markers" }
            }

            # --- Missing file references ---
            $refs = @($content | Select-String -Pattern '(?i)(?:\.opencode|\.\.)\\[^\s`]+\.(ps1|md|mjs|json)' -AllMatches)
            $missingRefs = @()
            foreach ($m in $refs.Matches) {
                $refPath = $m.Value -replace '[`"]', ''
                $candidate = Join-Path $Root $refPath
                if (-not (Test-Path -LiteralPath $candidate -ErrorAction SilentlyContinue)) {
                    # try relative to skill dir
                    $candidate2 = Join-Path $sd.FullName ($refPath -replace '.*\\', '')
                    if (-not (Test-Path -LiteralPath $candidate2 -ErrorAction SilentlyContinue)) {
                        $missingRefs += $refPath
                    }
                }
            }
            if ($missingRefs.Count -gt 0) {
                $skillIssues += @{ severity = "MAJOR"; group = "Skills"; message = "$($skillName): broken file refs: $($missingRefs | Select-Object -First 3) ..." }
            }
        }
        else {
            $skillIssues += @{ severity = "CRITICAL"; group = "Skills"; message = "$($skillName): missing SKILL.md" }
        }

        # --- Compatibility: referenced agents/commands exist ---
        if ($content) {
            $cmdRefs = @($content | Select-String -Pattern '/(team-[\w-]+|doctor)' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value })
            $cmdsDir = Join-Path $Root ".opencode/commands"
            $brokenCmds = @($cmdRefs | Where-Object { $name = $_.TrimStart('/'); -not (Test-Path -LiteralPath (Join-Path $cmdsDir "$name.md")) } | Select-Object -Unique)
            if ($brokenCmds.Count -gt 0) {
                $skillIssues += @{ severity = "WARNING"; group = "Skills"; message = "$($skillName): references missing commands: $($brokenCmds -join ', ')" }
            }
        }

        $checks += @{
            name   = $skillName
            status = if ($skillIssues.Count -eq 0) { "PASS" } elseif (($skillIssues | Where-Object { $_.severity -eq "CRITICAL" }).Count -gt 0) { "ERROR" } elseif (($skillIssues | Where-Object { $_.severity -eq "MAJOR" }).Count -gt 0) { "WARNING" } else { "PASS" }
            detail = "$($skillIssues.Count) issue(s)"
            items  = $skillIssues
        }
        $issues += $skillIssues
    }

    $criticalCount = @($issues | Where-Object { $_.severity -eq "CRITICAL" }).Count
    $majorCount = @($issues | Where-Object { $_.severity -eq "MAJOR" }).Count
    $warnCount = @($issues | Where-Object { $_.severity -eq "WARNING" }).Count
    $score -= [Math]::Min(40, $criticalCount * 20 + $majorCount * 5 + $warnCount * 2)
    $score = [Math]::Max(0, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Skills"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}
