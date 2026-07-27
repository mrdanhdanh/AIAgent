param(
    [Parameter(Mandatory = $true)]
    [string[]]$files,

    [Parameter(Mandatory = $true)]
    [string]$workflowId
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = ".opencode\backup\$workflowId"
$manifestPath = "$backupRoot\backup_manifest.json"
$manifest = @{
    workflow_id = $workflowId
    created_at  = (Get-Date -Format "o")
    files       = @()
}

foreach ($file in $files) {
    if (-not (Test-Path -LiteralPath $file)) {
        Write-Warning "File not found: $file"
        continue
    }

    $dest = Join-Path $backupRoot $file
    $parent = Split-Path $dest -Parent
    New-Item -ItemType Directory -Path $parent -Force | Out-Null

    Copy-Item -LiteralPath $file -Destination $dest -Force

    $hash = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.Substring(0, 12)
    $size = (Get-Item -LiteralPath $file).Length

    $entry = @{
        original_path = $file
        backup_path   = $dest
        hash          = $hash
        size_bytes    = $size
    }
    $manifest.files += $entry

    Write-Output "[OK] $file -> $dest ($hash)"
}

$manifestJson = $manifest | ConvertTo-Json -Depth 10
$manifestJson | Out-File -FilePath $manifestPath -Encoding utf8

Write-Output "[DONE] Backup manifest: $manifestPath"
Write-Output ($manifest | ConvertTo-Json -Depth 10)
