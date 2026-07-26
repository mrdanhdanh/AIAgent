<#
.SYNOPSIS
    Backup Utility cho Dev Agent Team — backup file trước khi sửa, sinh manifest JSON.
.DESCRIPTION
    Nhận danh sách file + workflow_id, backup từng file vào .opencode/backup/<WF-ID>/,
    tính SHA256 hash (12 ký tự), ghi manifest 05_backup_manifest.json.
.PARAMETER files
    Danh sách đường dẫn file cần backup (relative hoặc absolute).
.PARAMETER workflowId
    Workflow ID (ví dụ: WF-20260726-001).
.PARAMETER projectRoot
    Thư mục gốc dự án (mặc định: thư mục hiện tại).
.PARAMETER excludePatterns
    Pattern file cần loại trừ (mặc định: *.exe, *.dll, *.pdb, .env, *secret*, *key*).
.PARAMETER outputManifest
    Đường dẫn ghi manifest (mặc định: .opencode/backup/<WF-ID>/05_backup_manifest.json).
.EXAMPLE
    .\backup-utility.ps1 -files @("src/Program.cs", "src/Pages/Home.razor") -workflowId "WF-20260726-001"
#>

param(
    [Parameter(Mandatory = $true)]
    [string[]]$files,

    [Parameter(Mandatory = $true)]
    [string]$workflowId,

    [Parameter(Mandatory = $false)]
    [string]$projectRoot = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [string[]]$excludePatterns = @("*.exe", "*.dll", "*.pdb", ".env", "*secret*", "*key*"),

    [Parameter(Mandatory = $false)]
    [string]$outputManifest = $null
)

function Write-Report {
    param([string]$status, [int]$total, [int]$succeeded, [int]$skipped, [int]$failed, [array]$details)
    $report = @{
        status = $status
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        workflow_id = $workflowId
        summary = @{
            total = $total
            succeeded = $succeeded
            skipped = $skipped
            failed = $failed
        }
        files = $details
    }
    return $report
}

# --- Validate project root ---
if (-not (Test-Path -LiteralPath $projectRoot)) {
    $report = Write-Report -status "ERROR" -total 0 -succeeded 0 -skipped 0 -failed 0 -details @()
    $report.error = "Project root not found: $projectRoot"
    return $report
}

# --- Setup backup root ---
$backupRoot = Join-Path -Path $projectRoot -ChildPath ".opencode\backup\$workflowId"
if (-not (Test-Path -LiteralPath $backupRoot)) {
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
}

# --- Resolve output manifest path ---
if (-not $outputManifest) {
    $outputManifest = Join-Path -Path $backupRoot -ChildPath "05_backup_manifest.json"
}
$manifestParent = Split-Path $outputManifest -Parent
if (-not (Test-Path -LiteralPath $manifestParent)) {
    New-Item -ItemType Directory -Path $manifestParent -Force | Out-Null
}

# --- Process each file ---
$manifestFiles = @()
$total = $files.Count
$succeeded = 0
$skipped = 0
$failed = 0
$details = @()

foreach ($file in $files) {
    $entry = @{
        original_path = ""
        backup_path = ""
        relative_path = ""
        hash = ""
        size = 0
        status = ""
        error = $null
    }

    # Resolve path
    $resolvedPath = $null
    if ([System.IO.Path]::IsPathRooted($file)) {
        $resolvedPath = $file
    } else {
        $resolvedPath = Join-Path -Path $projectRoot -ChildPath $file
    }

    $entry.original_path = $resolvedPath

    # Check file tồn tại
    if (-not (Test-Path -LiteralPath $resolvedPath)) {
        $entry.status = "SKIPPED"
        $entry.error = "File not found"
        $skipped++
        $details += $entry
        continue
    }

    # Check exclude patterns
    $fileName = Split-Path $resolvedPath -Leaf
    $shouldExclude = $false
    foreach ($pattern in $excludePatterns) {
        if ($fileName -like $pattern) {
            $shouldExclude = $true
            break
        }
    }
    if ($shouldExclude) {
        $entry.status = "SKIPPED"
        $entry.error = "Excluded by pattern"
        $skipped++
        $details += $entry
        continue
    }

    # Tính relative path
    $relativePath = $resolvedPath.Substring($projectRoot.Length).TrimStart('\').TrimStart('/')
    $entry.relative_path = $relativePath

    # Destination path
    $destPath = Join-Path -Path $backupRoot -ChildPath $relativePath
    $destParent = Split-Path $destPath -Parent
    if (-not (Test-Path -LiteralPath $destParent)) {
        New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }

    try {
        # Copy file
        Copy-Item -LiteralPath $resolvedPath -Destination $destPath -Force

        # Tính hash
        $hash = (Get-FileHash -LiteralPath $resolvedPath -Algorithm SHA256).Hash.Substring(0, 12)
        $entry.hash = $hash
        $entry.size = (Get-Item -LiteralPath $resolvedPath).Length
        $entry.backup_path = $destPath
        $entry.status = "SUCCESS"
        $succeeded++

        Write-Output "  [OK] $relativePath -> $destPath ($hash)"
    } catch {
        $entry.status = "FAILED"
        $entry.error = $_.Exception.Message
        $failed++
        Write-Output "  [FAIL] $relativePath -> FAILED: $($_.Exception.Message)"
    }

    $details += $entry
    $manifestFiles += @{
        original_path = $resolvedPath
        backup_path = $destPath
        relative_path = $relativePath
        hash = $entry.hash
        size = $entry.size
    }
}

# --- Build manifest ---
$manifest = @{
    schema_version = "2.0"
    workflow_id = $workflowId
    created_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    project_root = $projectRoot
    total_files = $total
    succeeded = $succeeded
    skipped = $skipped
    failed = $failed
    files = $manifestFiles
}

# Ghi manifest
$manifestJson = $manifest | ConvertTo-Json -Depth 10
$manifestJson | Out-File -FilePath $outputManifest -Encoding UTF8
Write-Output "  [MANIFEST] $outputManifest"

# Output báo cáo
$report = Write-Report -status "COMPLETE" -total $total -succeeded $succeeded -skipped $skipped -failed $failed -details $details
$report | ConvertTo-Json -Depth 5
