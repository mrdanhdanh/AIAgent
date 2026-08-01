<#
.SYNOPSIS
Backup Utility — backup, list và verify snapshot trước khi sửa file.
.DESCRIPTION
Lưu snapshot files với SHA256 manifest vào .opencode/backup/{workflowId}/. Hỗ trợ: save, list, verify.
#>
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("save", "list", "verify")]
    [string]$action,

    [Parameter(Mandatory = $false)]
    [string[]]$files,

    [Parameter(Mandatory = $false)]
    [string]$workflowId,

    [Parameter(Mandatory = $false)]
    [string]$manifestPath,

    [Parameter(Mandatory = $false)]
    [int]$maxFileSizeMB = 50
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$toolVersion = "2.0.0"

# ─── Exclude rules ───────────────────────────────────────────────
$excludePatterns = @(
    '\.exe$', '\.dll$', '\.pdb$', '\.zip$', '\.tar\.gz$',
    'node_modules', '\\bin\\', '\\obj\\', '\\dist\\',
    '\.env', 'secret', 'key', '\.log$'
)

function Test-Excluded {
    param([string]$Path)
    foreach ($pattern in $excludePatterns) {
        if ($Path -match $pattern) { return $true }
    }
    return $false
}

function Test-MaxSize {
    param([string]$Path, [int]$MaxMB)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $sizeBytes = (Get-Item -LiteralPath $Path).Length
    return ($sizeBytes -gt ($MaxMB * 1MB))
}

# ─── Action: save ────────────────────────────────────────────────
function Invoke-SaveAction {
    param([string[]]$FileList, [string]$WfId)

    if (-not $WfId) { throw "-workflowId is required for action 'save'" }
    if (-not $FileList -or $FileList.Count -eq 0) { throw "-files is required for action 'save'" }

    $backupRoot = ".opencode\backup\$WfId"
    $manifestPath = "$backupRoot\backup_manifest.json"
    $manifest = @{
        workflow_id  = $WfId
        created_at   = (Get-Date -Format "o")
        tool_version = $toolVersion
        files        = @()
    }

    $summary = @{
        total             = 0
        succeeded         = 0
        skipped_sensitive = 0
        skipped_size      = 0
        skipped_other     = 0
        failed            = 0
        backup_created    = @()
    }

    foreach ($file in $FileList) {
        $summary.total++

        # Check file exists
        if (-not (Test-Path -LiteralPath $file)) {
            $entry = @{
                original_path = $file
                status        = "FAILED"
                skip_reason   = $null
                error         = "File not found"
                hash          = $null
                size_bytes    = $null
            }
            $manifest.files += $entry
            $summary.failed++
            continue
        }

        # Check exclude rules
        if (Test-Excluded -Path $file) {
            $entry = @{
                original_path = $file
                status        = "SKIPPED"
                skip_reason   = "SENSITIVE"
                error         = $null
                hash          = $null
                size_bytes    = (Get-Item -LiteralPath $file).Length
            }
            $manifest.files += $entry
            $summary.skipped_sensitive++
            continue
        }

        # Check max size
        if (Test-MaxSize -Path $file -MaxMB $maxFileSizeMB) {
            $entry = @{
                original_path = $file
                status        = "SKIPPED"
                skip_reason   = "MAX_SIZE_EXCEEDED"
                error         = $null
                hash          = $null
                size_bytes    = (Get-Item -LiteralPath $file).Length
            }
            $manifest.files += $entry
            $summary.skipped_size++
            continue
        }

        # Backup the file
        $dest = Join-Path $backupRoot $file
        $parent = Split-Path $dest -Parent
        New-Item -ItemType Directory -Path $parent -Force | Out-Null

        try {
            Copy-Item -LiteralPath $file -Destination $dest -Force -ErrorAction Stop

            $fullHash = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
            $shortHash = $fullHash.Substring(0, 12)
            $size = (Get-Item -LiteralPath $file).Length

            $entry = @{
                original_path = $file
                status        = "SUCCESS"
                skip_reason   = $null
                error         = $null
                hash          = $shortHash
                sha256        = $fullHash
                size_bytes    = $size
                source_path   = (Resolve-Path -LiteralPath $file).Path
                backup_path   = (Resolve-Path -LiteralPath $dest).Path
            }
            $manifest.files += $entry
            $summary.succeeded++
            $summary.backup_created += $file

            Write-Host "[OK] $file -> $dest ($shortHash)"
        }
        catch {
            $entry = @{
                original_path = $file
                status        = "FAILED"
                skip_reason   = $null
                error         = $_.Exception.Message
                hash          = $null
                size_bytes    = $null
            }
            $manifest.files += $entry
            $summary.failed++
            Write-Error "[FAIL] $file : $_"
        }
    }

    $manifestJson = $manifest | ConvertTo-Json -Depth 10
    $manifestJson | Out-File -FilePath $manifestPath -Encoding utf8

    $output = @{
        action      = "save"
        workflow_id = $WfId
        status      = if ($summary.failed -eq 0 -and $summary.succeeded -gt 0) { "SUCCESS" } elseif ($summary.failed -gt 0 -and $summary.succeeded -gt 0) { "PARTIAL" } elseif ($summary.failed -gt 0) { "FAILED" } else { "NO_CHANGE" }
        summary     = $summary
        details     = $manifest.files
        manifest    = $manifestPath
    }

    Write-Host "[DONE] Backup manifest: $manifestPath"
    return $output | ConvertTo-Json -Depth 10
}

# ─── Action: list ────────────────────────────────────────────────
function Invoke-ListAction {
    param([string]$WfId)

    $backupRoot = ".opencode\backup"

    if ($WfId) {
        $targetDir = "$backupRoot\$WfId"
        if (-not (Test-Path -LiteralPath $targetDir)) {
            return @{
                action      = "list"
                workflow_id = $WfId
                status      = "FAILED"
                summary     = @{ total = 0; error = "Workflow not found: $WfId" }
                workflows   = @()
            } | ConvertTo-Json -Depth 10
        }

        $manifestPath = "$targetDir\backup_manifest.json"
        if (Test-Path -LiteralPath $manifestPath) {
            $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
            return @{
                action      = "list"
                workflow_id = $WfId
                status      = "SUCCESS"
                summary     = @{ total = $manifest.files.Count }
                workflows   = @($manifest)
            } | ConvertTo-Json -Depth 10
        }

        $files = Get-ChildItem -Path "$targetDir\*" -File -Recurse
        return @{
            action      = "list"
            workflow_id = $WfId
            status      = "SUCCESS"
            summary     = @{ total = $files.Count }
            workflows   = @($files.FullName)
        } | ConvertTo-Json -Depth 10
    }

    $workflowDirs = Get-ChildItem -Path $backupRoot -Directory | Sort-Object LastWriteTime -Descending
    $workflows = @()
    foreach ($dir in $workflowDirs) {
        $mp = "$($dir.FullName)\backup_manifest.json"
        if (Test-Path -LiteralPath $mp) {
            $m = Get-Content -LiteralPath $mp -Raw | ConvertFrom-Json
            $workflows += @{
                workflow_id = $m.workflow_id
                created_at  = $m.created_at
                file_count  = $m.files.Count
                path        = $dir.FullName
            }
        }
        else {
            $workflows += @{
                workflow_id = $dir.Name
                created_at  = $dir.LastWriteTime.ToString("o")
                file_count  = "?"
                path        = $dir.FullName
            }
        }
    }

    return @{
        action      = "list"
        workflow_id = $WfId
        status      = "SUCCESS"
        summary     = @{ total = $workflows.Count }
        workflows   = $workflows
    } | ConvertTo-Json -Depth 10
}

# ─── Action: verify ──────────────────────────────────────────────
function Invoke-VerifyAction {
    param([string]$WfId, [string]$ManPath)

    if (-not $WfId -and -not $ManPath) { throw "Either -workflowId or -manifestPath is required for action 'verify'" }

    if ($ManPath -and (Test-Path -LiteralPath $ManPath)) {
        $manifestPath = $ManPath
    }
    elseif ($WfId) {
        $manifestPath = ".opencode\backup\$WfId\backup_manifest.json"
    }
    else {
        throw "Manifest not found"
    }

    if (-not (Test-Path -LiteralPath $manifestPath)) {
        return @{
            action      = "verify"
            workflow_id = $WfId
            status      = "FAILED"
            summary     = @{ total = 0; integrity_ok = 0; integrity_failed = 0; error = "Manifest not found: $manifestPath" }
        } | ConvertTo-Json -Depth 10
    }

    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $integrityOk = 0
    $integrityFailed = 0
    $details = @()

    foreach ($entry in $manifest.files) {
        $backupPath = $entry.backup_path
        $expectedHash = $entry.hash

        if (-not (Test-Path -LiteralPath $backupPath)) {
            $details += @{
                file            = $entry.original_path
                status          = "FAILED"
                error           = "Backup file not found"
                skip_reason     = $null
                expected_hash   = $expectedHash
                actual_hash     = $null
            }
            $integrityFailed++
            continue
        }

        $actualFullHash = (Get-FileHash -LiteralPath $backupPath -Algorithm SHA256).Hash
        $actualShortHash = $actualFullHash.Substring(0, 12)

        if ($actualShortHash -eq $expectedHash) {
            $details += @{
                file          = $entry.original_path
                status        = "PASS"
                error         = $null
                skip_reason   = $null
                expected_hash = $expectedHash
                actual_hash   = $actualShortHash
            }
            $integrityOk++
        }
        else {
            $details += @{
                file          = $entry.original_path
                status        = "FAILED"
                error         = "Hash mismatch"
                skip_reason   = $null
                expected_hash = $expectedHash
                actual_hash   = $actualShortHash
            }
            $integrityFailed++
        }
    }

    return @{
        action      = "verify"
        workflow_id = $manifest.workflow_id
        status      = if ($integrityFailed -eq 0) { "SUCCESS" } else { "FAILED" }
        summary     = @{
            total            = $manifest.files.Count
            integrity_ok     = $integrityOk
            integrity_failed = $integrityFailed
        }
        details     = $details
        manifest    = $manifestPath
    } | ConvertTo-Json -Depth 10
}

# ─── Main routing ────────────────────────────────────────────────
try {
    switch ($action) {
        "save" {
            $output = Invoke-SaveAction -FileList $files -WfId $workflowId
            Write-Output $output
        }
        "list" {
            $output = Invoke-ListAction -WfId $workflowId
            Write-Output $output
        }
        "verify" {
            $output = Invoke-VerifyAction -WfId $workflowId -ManPath $manifestPath
            Write-Output $output
        }
    }
}
catch {
    $errorResult = @{
        action      = $action
        workflow_id = $workflowId
        status      = "FAILED"
        summary     = @{ total = 0; succeeded = 0; failed = 1; error = $_.Exception.Message }
        details     = @()
    }
    Write-Error ($errorResult | ConvertTo-Json -Depth 10)
    exit 1
}
