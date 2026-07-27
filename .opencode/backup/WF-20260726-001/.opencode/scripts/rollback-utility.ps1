param(
    [Parameter(Mandatory = $true)]
    [string]$workflowId,

    [switch]$force
)

$backupRoot = ".opencode\backup\$workflowId"
$manifestPath = "$backupRoot\backup_manifest.json"

if (-not (Test-Path -LiteralPath $manifestPath)) {
    Write-Error "Manifest not found: $manifestPath"
    exit 1
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json

if (-not $force) {
    Write-Host "=== ROLLBACK PREVIEW ==="
    Write-Host "Workflow: $workflowId"
    Write-Host "Files to restore: $($manifest.files.Count)"
    Write-Host ""
    foreach ($entry in $manifest.files) {
        Write-Host "  $($entry.original_path)  ←  $($entry.backup_path)  ($($entry.hash))"
    }
    Write-Host ""
    $confirm = Read-Host "Restore these files? (Y/N)"
    if ($confirm -ne "Y") {
        Write-Host "Rollback cancelled."
        exit 0
    }
}

function Test-TimestampConflict {
    param([string]$BackupPath, [string]$OriginalPath)
    if (-not (Test-Path -LiteralPath $OriginalPath)) { return $false }
    $backupTime = (Get-Item -LiteralPath $BackupPath).LastWriteTime
    $originalTime = (Get-Item -LiteralPath $OriginalPath).LastWriteTime
    return $originalTime -gt $backupTime
}

$restored = 0
$errors = @()

foreach ($entry in $manifest.files) {
    $backupPath = $entry.backup_path
    $originalPath = $entry.original_path

    if (-not (Test-Path -LiteralPath $backupPath)) {
        $errors += "Backup not found: $backupPath"
        continue
    }

    if (Test-TimestampConflict -BackupPath $backupPath -OriginalPath $originalPath) {
        $msg = "Original file is newer than backup: $originalPath"
        if (-not $force) {
            $confirm = Read-Host "$msg. Overwrite anyway? (Y/N)"
            if ($confirm -ne "Y") {
                Write-Output "[SKIPPED] $originalPath"
                continue
            }
        }
        else {
            Write-Output "[WARN] $msg (force, overwriting)"
        }
    }

    try {
        Copy-Item -LiteralPath $backupPath -Destination $originalPath -Force
        Write-Output "[RESTORED] $originalPath"
        $restored++
    }
    catch {
        $errors += "Failed to restore $originalPath : $_"
    }
}

Write-Host ""
Write-Host "=== ROLLBACK SUMMARY ==="
Write-Host "Restored: $restored / $($manifest.files.Count)"
if ($errors.Count -gt 0) {
    Write-Host "Errors:"
    foreach ($err in $errors) {
        Write-Host "  ! $err"
    }
}
