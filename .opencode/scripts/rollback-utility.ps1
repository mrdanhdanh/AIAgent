<#
.SYNOPSIS
    Rollback Utility cho Dev Agent Team -- restore file tu backup manifest.
.DESCRIPTION
    Doc 05_backup_manifest.json cua workflow_id, restore tung file ve vi tri cu.
    Kiem tra timestamp de tranh ghi de file moi hon.
.PARAMETER workflowId
    Workflow ID (VD: WF-20260726-001).
.PARAMETER files
    Danh sach file can restore (optional - neu null thi restore tat ca).
.PARAMETER projectRoot
    Thu muc goc du an (mac dinh: thu muc hien tai).
.PARAMETER force
    Force restore ngay ca khi file dich moi hon (mac dinh: $false).
.EXAMPLE
    .\rollback-utility.ps1 -workflowId "WF-20260726-001"
    .\rollback-utility.ps1 -workflowId "WF-20260726-001" -files @("src/Program.cs")
    .\rollback-utility.ps1 -workflowId "WF-20260726-001" -force
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$workflowId,

    [Parameter(Mandatory = $false)]
    [string[]]$files = $null,

    [Parameter(Mandatory = $false)]
    [string]$projectRoot = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [switch]$force = $false
)

function Write-Report {
    param([string]$status, [int]$total, [int]$restored, [int]$skipped, [int]$failed, [array]$details)
    $report = @{
        status = $status
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        workflow_id = $workflowId
        summary = @{
            total = $total
            restored = $restored
            skipped = $skipped
            failed = $failed
        }
        files = $details
    }
    return $report
}

# --- Validate project root ---
if (-not (Test-Path -LiteralPath $projectRoot)) {
    $report = Write-Report -status "ERROR" -total 0 -restored 0 -skipped 0 -failed 0 -details @()
    $report.error = "Project root not found: $projectRoot"
    return $report
}

# --- Find manifest ---
$possibleManifests = @(
    Join-Path -Path $projectRoot -ChildPath ".opencode\backup\$workflowId\05_backup_manifest.json"
    Join-Path -Path $projectRoot -ChildPath ".opencode\backup\$workflowId\05_backup_manifest.json"
)

$manifestPath = $null
foreach ($p in $possibleManifests) {
    if (Test-Path -LiteralPath $p) {
        $manifestPath = $p
        break
    }
}

if (-not $manifestPath) {
    $report = Write-Report -status "ERROR" -total 0 -restored 0 -skipped 0 -failed 0 -details @()
    $report.error = "Backup manifest not found for workflow: $workflowId"
    return $report
}

# --- Parse manifest ---
try {
    $manifestContent = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8
    $manifest = $manifestContent | ConvertFrom-Json
} catch {
    $report = Write-Report -status "ERROR" -total 0 -restored 0 -skipped 0 -failed 0 -details @()
    $report.error = "Failed to parse manifest: $($_.Exception.Message)"
    return $report
}

if (-not $manifest.files -or $manifest.files.Count -eq 0) {
    $report = Write-Report -status "COMPLETE" -total 0 -restored 0 -skipped 0 -failed 0 -details @()
    $report.message = "No files in manifest to restore"
    return $report
}

# --- Filter files if specified ---
$manifestFiles = @($manifest.files)
if ($files) {
    $normalizedRequested = @()
    foreach ($f in $files) {
        if ([System.IO.Path]::IsPathRooted($f)) {
            $normalizedRequested += $f
        } else {
            $normalizedRequested += (Join-Path -Path $projectRoot -ChildPath $f)
        }
    }
    $manifestFiles = $manifestFiles | Where-Object { $normalizedRequested -contains $_.original_path }
}

# --- Restore each file ---
$total = $manifestFiles.Count
$restored = 0
$skipped = 0
$failed = 0
$details = @()

foreach ($entry in $manifestFiles) {
    $detail = @{
        original_path = $entry.original_path
        backup_path = $entry.backup_path
        hash = $entry.hash
        status = ""
        error = $null
    }

    # Check backup file exists
    if (-not (Test-Path -LiteralPath $entry.backup_path)) {
        $detail.status = "SKIPPED"
        $detail.error = "Backup file not found: $($entry.backup_path)"
        $skipped++
        $details += $detail
        Write-Output "  [WARN] $($entry.relative_path) - backup file missing"
        continue
    }

    # Check timestamp conflict (unless force)
    if (-not $force -and (Test-Path -LiteralPath $entry.original_path)) {
        $backupTime = (Get-Item -LiteralPath $entry.backup_path).LastWriteTime
        $originalTime = (Get-Item -LiteralPath $entry.original_path).LastWriteTime
        if ($originalTime -gt $backupTime) {
            $detail.status = "SKIPPED"
            $detail.error = "Original file is newer than backup (backup: $backupTime, original: $originalTime)"
            $skipped++
            $details += $detail
            Write-Output "  [WARN] $($entry.relative_path) - original is newer, use -force to override"
            continue
        }
    }

    # Create parent directory if needed
    $parent = Split-Path $entry.original_path -Parent
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    try {
        Copy-Item -LiteralPath $entry.backup_path -Destination $entry.original_path -Force

        # Verify hash
        if ($entry.hash) {
            $newHash = (Get-FileHash -LiteralPath $entry.original_path -Algorithm SHA256).Hash.Substring(0, 12)
            if ($newHash -ne $entry.hash) {
                $detail.status = "RESTORED_HASH_MISMATCH"
                $detail.error = "Hash mismatch after restore (expected: $($entry.hash), got: $newHash)"
                $failed++
                $details += $detail
                Write-Output "  [FAIL] $($entry.relative_path) - hash mismatch (expected $($entry.hash), got $newHash)"
                continue
            }
        }

        $detail.status = "RESTORED"
        $restored++
        Write-Output "  [OK] $($entry.original_path) - restored"
    } catch {
        $detail.status = "FAILED"
        $detail.error = $_.Exception.Message
        $failed++
        $details += $detail
        Write-Output "  [FAIL] $($entry.original_path) - FAILED: $($_.Exception.Message)"
    }

    $details += $detail
}

# Output report
$report = Write-Report -status "COMPLETE" -total $total -restored $restored -skipped $skipped -failed $failed -details $details
$report | ConvertTo-Json -Depth 5
