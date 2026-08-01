<#
.SYNOPSIS
Schema Validator — validate YAML schema của agent definitions.
.DESCRIPTION
Kiểm tra frontmatter YAML và schema consistency của các file trong .opencode/agents. Hỗ trợ -fix.
#>
param(
    [Parameter(Mandatory = $false)]
    [string]$targetDir = ".opencode/agents",

    [Parameter(Mandatory = $false)]
    [switch]$fix
)

$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$results = @()
$allPass = $true

function Test-YamlFrontmatter {
    param([string]$Path)
    $content = Get-Content -LiteralPath $Path -Raw
    if ($content -match '^---\r?\n(.*?)\r?\n---') {
        $yaml = $Matches[1]
        $lines = $yaml -split "`r?`n"
        $errors = @()
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "`t") {
                $errors += "Line $($i+1): TAB character found (use spaces)"
            }
        }
        if ($yaml -match ':\s+[|>]') {
            $errors += "Literal block scalar (|/>) detected - ensure proper indentation"
        }
        $requiredFields = @("name", "description")
        foreach ($field in $requiredFields) {
            if ($yaml -notmatch "^${field}:") {
                $errors += "Missing required field: $field"
            }
        }
        return $errors
    }
    return @("No YAML frontmatter found (--- ... ---)")
}

function Test-InternalLinks {
    param([string]$Path)
    $content = Get-Content -LiteralPath $Path -Raw
    $links = [regex]::Matches($content, '#(\w+(?:-\w+)*)')
    $errors = @()
    foreach ($link in $links) {
        $target = $link.Groups[1].Value
        $pattern = "(?i)^##+\s+.*$target"
        if ($content -notmatch $pattern) {
            $errors += "Broken internal link: #$target"
        }
    }
    return $errors
}

function Test-CodeBlockBalance {
    param([string]$Path)
    $content = Get-Content -LiteralPath $Path -Raw
    $opens = [regex]::Matches($content, '(?<!`)```')
    if ($opens.Count % 2 -ne 0) {
        return @("Unbalanced code blocks: $($opens.Count) backtick-triples (expected even)")
    }
    return @()
}

function Test-YamlSamples {
    param([string]$Path)
    $content = Get-Content -LiteralPath $Path -Raw
    $errors = @()
    $yamlBlocks = [regex]::Matches($content, '```yaml\r?\n(.*?)```', 'Singleline')
    for ($i = 0; $i -lt $yamlBlocks.Count; $i++) {
        try {
            $null = $yamlBlocks[$i].Groups[1].Value | ConvertFrom-Yaml
        } catch {
            $errors += "YAML sample block $($i+1): parse error - $($_.Exception.Message)"
        }
    }
    if (-not (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue)) {
        return @("WARNING: ConvertFrom-Yaml not available (install powershell-yaml module)")
    }
    return $errors
}

$files = Get-ChildItem -LiteralPath $targetDir -Filter "*.md" -Recurse
foreach ($file in $files) {
    $fileErrors = @()
    $fileErrors += Test-YamlFrontmatter -Path $file.FullName | ForEach-Object { "FRONTMATTER: $_" }
    $fileErrors += Test-InternalLinks -Path $file.FullName | ForEach-Object { "LINK: $_" }
    $fileErrors += Test-CodeBlockBalance -Path $file.FullName | ForEach-Object { "CODEBLOCK: $_" }
    $fileErrors += Test-YamlSamples -Path $file.FullName | ForEach-Object { "YAML: $_" }

    $status = if ($fileErrors.Count -eq 0) { "PASS" } else { "FAIL" }
    if ($status -eq "FAIL") { $allPass = $false }

    $results += [PSCustomObject]@{
        File   = $file.FullName
        Status = $status
        Errors = $fileErrors -join "; "
    }

    if ($fileErrors.Count -gt 0) {
        Write-Host "[$status] $($file.Name)" -ForegroundColor $(if ($status -eq "PASS") { "Green" } else { "Red" })
        foreach ($e in $fileErrors) { Write-Host "  - $e" -ForegroundColor Yellow }
    } else {
        Write-Host "[$status] $($file.Name)" -ForegroundColor Green
    }
}

$summary = [PSCustomObject]@{
    tool         = "schema-validator.ps1"
    version      = $toolVersion
    timestamp    = $timestamp
    target_dir   = $targetDir
    files_scanned = $files.Count
    files_passed  = ($results | Where-Object { $_.Status -eq "PASS" }).Count
    files_failed  = ($results | Where-Object { $_.Status -eq "FAIL" }).Count
    all_pass     = $allPass
    results      = $results
}

$summary | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath ".opencode/scripts/schema-validator-report.json"
Write-Host "`nReport: .opencode/scripts/schema-validator-report.json" -ForegroundColor Cyan
exit $(if ($allPass) { 0 } else { 1 })
