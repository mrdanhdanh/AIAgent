<#
.SYNOPSIS
Knowledge Migration v1.0 — Phát hiện knowledge deprecated và đề xuất cập nhật
.DESCRIPTION
Kiểm tra:
- Knowledge có còn phù hợp với project config không?
- Skill references có còn đúng không?
- Framework versions có còn hợp lệ không?
- Knowledge có bị thiếu so với project không?
#>

param(
    [string]$knowledgeDir = ".opencode/knowledge",
    [string]$agentsDir = ".opencode/agents",
    [string]$projectDir = ".",  # Root project dir for config detection
    [string]$outputDir = ".opencode/scripts/evolution/reports"
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

$results = @{
    tool = "knowledge-migration.ps1"
    version = $toolVersion
    timestamp = $timestamp
    knowledge_files = @()
    deprecated_knowledge = @()
    missing_knowledge = @()
    pending_updates = @()
    score = 100
    summary = ""
}

# Scan all knowledge files
Write-Host "Scanning knowledge base..." -ForegroundColor Cyan
$knowledgeFiles = Get-ChildItem -Path "$knowledgeDir\*" -Recurse -File -ErrorAction SilentlyContinue

foreach ($kf in $knowledgeFiles) {
    $baseDir = (Get-Item $knowledgeDir).FullName
    $relPath = $kf.FullName.Substring($baseDir.Length + 1)
    $size = $kf.Length
    $content = Get-Content -LiteralPath $kf.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
    
    $entry = @{
        file = ("knowledge/" + $relPath) -replace '\\', '/'
        size = $size
        has_frontmatter = ($content -match '^---')
        lines = ($content -split '\r?\n').Count
    }
    $results.knowledge_files += $entry
    
    # Check for deprecated frameworks
    $lowerContent = $content.ToLower()
    
    # Check 1: MudBlazor reference (project uses FluentUI)
    # Skip nếu nội dung đã đánh dấu rõ là historical/deprecated (pre-FluentUI migration)
    if ($lowerContent -match 'mudblazor') {
        if ($lowerContent -match '(historical|deprecated|migrated\s*to\s*fluent)' -and $lowerContent -match '(mudblazor|fluentu)') {
            $results.pending_updates += "NOTE: $($entry.file) - historical MudBlazor knowledge marked deprecated (pre-FluentUI)"
        } else {
            $results.deprecated_knowledge += @{
                file = $entry.file
                type = "DEPRECATED_FRAMEWORK"
                old = "MudBlazor"
                current = "FluentUI 4.14.3"
                severity = "MAJOR"
                detail = "Knowledge references MudBlazor but project uses FluentUI"
                suggestion = "Update to FluentUI patterns"
            }
            $results.score -= 15
        }
    }
    
    # Check 2: Old .NET references (skip negative context: "khong dung .NET 5-9" = historical note)
    $negativePattern = '(khong dung|kh\u00F4ng d\u00F9ng|khong phai|kh\u01A1ng ph\u1EA3i|khong ap dung|kh\u00F4ng \u00E1p d\u1EE5ng|tranh|tr\u00E1nh|not use|don''t use|no longer|replaced|avoid|legacy)'
    foreach ($cline in ($content -split '\r?\n')) {
        $cl = $cline.ToLower()
        if ($cl -match '\.net\s*(5|6|7|8|9)\b' -and $cl -notmatch $negativePattern) {
            $results.deprecated_knowledge += @{
                file = $entry.file
                type = "DEPRECATED_VERSION"
                old = $Matches[0]
                current = ".NET 10"
                severity = "MINOR"
                detail = "Knowledge references $($Matches[0]) but project uses .NET 10"
                suggestion = "Update to .NET 10 patterns"
            }
            $results.score -= 5
            break
        }
    }
    
    # Check 3: Old Blazor patterns
    if ($lowerContent -match '(blazor\s*wasm\s*5|blazor\s*wasm\s*6|blazor\s*wasm\s*7|blazor\s*wasm\s*8)') {
        $results.deprecated_knowledge += @{
            file = $entry.file
            type = "DEPRECATED_PATTERN"
            old = $Matches[0]
            current = ".NET 10 Blazor WebAssembly"
            severity = "MINOR"
            detail = "Knowledge may have outdated Blazor patterns"
            suggestion = "Review and update Blazor patterns"
        }
        $results.score -= 5
    }
}

# Check 4: Missing knowledge topics
Write-Host "Checking for missing knowledge topics..." -ForegroundColor Cyan

# Scan agent files for topics that should have KB entries
$agentFiles = Get-ChildItem -Path "$agentsDir\*.md" -ErrorAction SilentlyContinue
$topicsMentioned = @()
foreach ($af in $agentFiles) {
    $content = Get-Content -LiteralPath $af.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
    
    # Detect topics from agent descriptions/usage
    if ($content -match '(?i)(fluentu|fluent\s*ui|blazor|dark\s*mode|localstorage|a11y|accessibility)') {
        $topicsMentioned += $Matches[1]
    }
}

$knowledgeTopics = @()
foreach ($kf2 in $knowledgeFiles) {
    $rel = $kf2.FullName.Substring((Get-Item $knowledgeDir).Parent.FullName.Length + 1)
    $knowledgeTopics += $rel.ToLower()
}

# Check specific topics
$requiredTopics = @(
    @{topic = "fluentu"; pattern = "fluentu"; category = "framework"},
    @{topic = "fluentui-design-tokens"; pattern = "fluentu|design.token"; category = "framework"},
    @{topic = "blazor-component-lifecycle"; pattern = "component.lifecycle|blazor.lifecycle"; category = "framework"},
    @{topic = "local-storage-patterns"; pattern = "localstorage|blazored.localstorage"; category = "pattern"},
    @{topic = "xunit-bunit-testing"; pattern = "xunit|bunit|testing"; category = "testing"},
    @{topic = "playwright-e2e"; pattern = "playwright|e2e"; category = "testing"},
    @{topic = "fluentui-components"; pattern = "fluentui.component|fluentbutton|fluentselect"; category = "ui"},
    @{topic = "dark-mode-theming"; pattern = "dark.mode|theming|themeservice"; category = "ui"},
    @{topic = "seed-data-patterns"; pattern = "seed.data|first.load|cache.first"; category = "pattern"},
    @{topic = "tri-state-rendering"; pattern = "tri.state|loading.empty.data|isloading"; category = "ui"}
)

foreach ($rt in $requiredTopics) {
    $found = $false
    foreach ($kt in $knowledgeTopics) {
        if ($kt -match $rt.pattern) { $found = $true; break }
    }
    if (-not $found) {
        $results.missing_knowledge += @{
            topic = $rt.topic
            category = $rt.category
            reason = "Topic '$($rt.topic)' used in project but no KB entry found"
            suggestion = "Create knowledge/$($rt.category)/$($rt.topic).md"
        }
        $results.score -= 10
    }
}

$results.score = [Math]::Max(0, $results.score)
$totalIssues = $results.deprecated_knowledge.Count + $results.missing_knowledge.Count
$results.summary = "Knowledge migration: " + $results.knowledge_files.Count + " files, " + $results.deprecated_knowledge.Count + " deprecated, " + $results.missing_knowledge.Count + " missing (score: " + $results.score + "/100)"

# Add pending updates
$updateList = @()
foreach ($dk in $results.deprecated_knowledge) {
    $updateList += "UPDATE: " + $dk.file + " - " + $dk.detail
}
foreach ($mk in $results.missing_knowledge) {
    $updateList += "CREATE: " + $mk.topic + " - " + $mk.reason
}
$results.pending_updates = $updateList

# Write report
$reportPath = "$outputDir/knowledge-migration-$timestamp.json"
$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportPath -Encoding utf8

Write-Host "=== Knowledge Migration Report ===" -ForegroundColor Cyan
Write-Host "  Knowledge files:  $($results.knowledge_files.Count)" -ForegroundColor White
Write-Host "  Deprecated:       $($results.deprecated_knowledge.Count)" -ForegroundColor Yellow
Write-Host "  Missing topics:   $($results.missing_knowledge.Count)" -ForegroundColor $(if ($results.missing_knowledge.Count -eq 0) { "Green" } else { "Red" })
Write-Host "  Score:            $($results.score)/100" -ForegroundColor $(if ($results.score -ge 80) { "Green" } elseif ($results.score -ge 50) { "Yellow" } else { "Red" })
Write-Host "  Report:           $reportPath" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

return $results
