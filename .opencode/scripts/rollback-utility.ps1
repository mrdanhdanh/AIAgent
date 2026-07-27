param(
    [Parameter(Mandatory = $true)]
    [string]$workflowId,

    [switch]$force,

    [switch]$skipSnapshot,

    [string]$manifestName = "backup_manifest.json"
)

$toolVersion = "2.0.0"
$backupRoot = ".opencode\backup\$workflowId"
$manifestPath = "$backupRoot\$manifestName"

# ─── Validate manifest ───────────────────────────────────────────
if (-not (Test-Path -LiteralPath $manifestPath)) {
    $errorResult = @{
        action      = "rollback"
        workflow_id = $workflowId
        status      = "FAILED"
        summary     = @{
            total            = 0
            restored         = 0
            skipped_newer    = 0
            skipped_notfound = 0
            failed           = 1
            error            = "Manifest not found: $manifestPath"
        }
        details     = @()
    }
    Write-Error ($errorResult | ConvertTo-Json -Depth 10)
    exit 1
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json

Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗"
Write-Host "║        ROLLBACK UTILITY v$toolVersion             ║"
Write-Host "╠══════════════════════════════════════════════╣"
Write-Host "║ Workflow: $($manifest.workflow_id)"
Write-Host "║ Created:  $($manifest.created_at)"
Write-Host "║ Files:    $($manifest.files.Count)"
Write-Host "╚══════════════════════════════════════════════╝"
Write-Host ""

# ─── Preview ─────────────────────────────────────────────────────
if (-not $force) {
    Write-Host "=== ROLLBACK PREVIEW ==="
    Write-Host ""
    $hasConflict = $false
    foreach ($entry in $manifest.files) {
        $orig = $entry.original_path
        $back = $entry.backup_path
        $hash = $entry.hash
        $status = ""

        if (-not (Test-Path -LiteralPath $orig)) {
            $status = " [NEW - will be created]"
        }
        elseif ((Get-Item -LiteralPath $orig).LastWriteTime -gt (Get-Item -LiteralPath $back).LastWriteTime) {
            $status = " [CONFLICT - file has changed since backup]"
            $hasConflict = $true
        }

        Write-Host "  $orig  ←  $(Split-Path $back -Leaf) ($hash)$status"
    }
    Write-Host ""

    if ($hasConflict) {
        Write-Host "⚠ WARNING: Some files have changed since backup."
        Write-Host "  Use -force to overwrite, or files will be SKIPPED."
        Write-Host ""
    }

    $confirm = Read-Host "Restore these files? (Y/N)"
    if ($confirm -ne "Y") {
        Write-Host "Rollback cancelled."
        exit 0
    }
}

# ─── Snapshot before rollback ───────────────────────────────────
if (-not $skipSnapshot) {
    $snapshotTimestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $snapshotDir = "$backupRoot\_pre_rollback_$snapshotTimestamp"
    New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null

    $snapshotManifest = @{
        snapshot_of   = $workflowId
        created_at    = (Get-Date -Format "o")
        tool_version  = $toolVersion
        reason        = "Pre-rollback snapshot"
        files         = @()
    }

    foreach ($entry in $manifest.files) {
        $origPath = $entry.original_path
        if (Test-Path -LiteralPath $origPath) {
            $snapDest = Join-Path $snapshotDir (Split-Path $origPath -Leaf)
            Copy-Item -LiteralPath $origPath -Destination $snapDest -Force
            $snapHash = (Get-FileHash -LiteralPath $origPath -Algorithm SHA256).Hash.Substring(0, 12)
            $snapshotManifest.files += @{
                original_path = $origPath
                snapshot_path = $snapDest
                hash          = $snapHash
            }
            Write-Host "[SNAPSHOT] $origPath -> $snapDest ($snapHash)"
        }
    }

    $snapshotManifestPath = "$snapshotDir\snapshot_manifest.json"
    ($snapshotManifest | ConvertTo-Json -Depth 10) | Out-File -FilePath $snapshotManifestPath -Encoding utf8
    Write-Host "[SNAPSHOT] Snapshot manifest: $snapshotManifestPath"
    Write-Host ""
}

# ─── Rollback ────────────────────────────────────────────────────
$restored = 0
$skippedNewer = 0
$skippedNotFound = 0
$failed = 0
$details = @()

foreach ($entry in $manifest.files) {
    $backupPath = $entry.backup_path
    $originalPath = $entry.original_path

    # Check backup file exists
    if (-not (Test-Path -LiteralPath $backupPath)) {
        $details += @{
            file        = $originalPath
            status      = "FAILED"
            error       = "Backup file not found: $backupPath"
            skip_reason = $null
        }
        $failed++
        continue
    }

    # Default safety: don't overwrite if original has changed, unless --force
    $shouldRestore = $true
    $skipReason = $null

    if (Test-Path -LiteralPath $originalPath) {
        $originalTime = (Get-Item -LiteralPath $originalPath).LastWriteTime
        $backupTime = (Get-Item -LiteralPath $backupPath).LastWriteTime

        if ($originalTime -gt $backupTime) {
            if (-not $force) {
                $shouldRestore = $false
                $skipReason = "ORIGINAL_NEWER"
                $skippedNewer++
                Write-Host "[SKIPPED] $originalPath (original is newer than backup)"
            }
            else {
                Write-Host "[WARN] $originalPath (original is newer, overwriting with -force)"
            }
        }
    }

    if ($shouldRestore) {
        try {
            $parent = Split-Path $originalPath -Parent
            if ($parent -and -not (Test-Path -LiteralPath $parent)) {
                New-Item -ItemType Directory -Path $parent -Force | Out-Null
            }

            Copy-Item -LiteralPath $backupPath -Destination $originalPath -Force -ErrorAction Stop
            $details += @{
                file        = $originalPath
                status      = "RESTORED"
                error       = $null
                skip_reason = $null
            }
            $restored++
            Write-Host "[RESTORED] $originalPath"
        }
        catch {
            $details += @{
                file        = $originalPath
                status      = "FAILED"
                error       = $_.Exception.Message
                skip_reason = $null
            }
            $failed++
            Write-Error "[FAIL] $originalPath : $_"
        }
    }
    else {
        $details += @{
            file        = $originalPath
            status      = "SKIPPED"
            error       = $null
            skip_reason = $skipReason
        }
    }
}

# ─── Summary ─────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗"
Write-Host "║           ROLLBACK SUMMARY                   ║"
Write-Host "╠══════════════════════════════════════════════╣"
Write-Host "║ Total:         $($manifest.files.Count) files"
Write-Host "║ Restored:      $restored"
Write-Host "║ Skipped (new): $skippedNewer"
Write-Host "║ Skipped (nf):  $skippedNotFound"
Write-Host "║ Failed:        $failed"
if (-not $skipSnapshot) {
    Write-Host "║ Snapshot:      Taken (see _pre_rollback_*)"
}
Write-Host "╚══════════════════════════════════════════════╝"
Write-Host ""

$output = @{
    action      = "rollback"
    workflow_id = $workflowId
    status      = if ($failed -eq 0 -and $restored -gt 0) { "SUCCESS" } elseif ($restored -gt 0) { "PARTIAL" } elseif ($failed -gt 0) { "FAILED" } else { "NO_CHANGE" }
    summary     = @{
        total            = $manifest.files.Count
        restored         = $restored
        skipped_newer    = $skippedNewer
        skipped_notfound = $skippedNotFound
        failed           = $failed
    }
    details     = $details
    manifest    = $manifestPath
}

Write-Output ($output | ConvertTo-Json -Depth 10)
