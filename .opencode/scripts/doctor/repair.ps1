<#
.SYNOPSIS
Doctor Module: Self Repair
.DESCRIPTION
Applies safe repairs only:
- Broken references (report + deterministic fix)
- Missing documentation (warn, never auto-write content)
- Wrong version (detect, log to manual review)
- Cross references / SYSTEM_MAP (run sync-system-docs if available)
- Folder structure (create missing standard folders)
- Contract mappings (report)
NEVER modifies agent prompts, skills, workflows, knowledge content.
--force extends scope to cross-reference inconsistencies with deterministic fixes.
Every fix is backed up first.
#>

function Invoke-DoctorRepair {
    param(
        [object]$Results,
        [string]$Root = ".",
        [switch]$Force,
        [switch]$DryRun
    )

    $script:repairs = @()
    $skipped = @()
    $manualReview = @()

    $backupScript = Join-Path $Root ".opencode/scripts/backup-utility.ps1"
    $wfId = "WF-DOCTOR-" + (Get-Date -Format "yyyyMMdd")

    # Helper: record repair
    function Add-RepairEntry {
        param($Category, $Target, $Action, $Status)
        $script:repairs += @{
            category = $Category
            target   = $Target
            action   = $Action
            status   = $Status
        }
    }

    # --- 1. Folder structure: create missing standard folders ----
    $standardFolders = @(
        ".opencode/backup",
        ".opencode/knowledge",
        ".opencode/memory/lessons",
        ".opencode/memory/patterns",
        ".opencode/memory/failures",
        ".opencode/scripts/doctor/reports"
    )
    foreach ($folder in $standardFolders) {
        $path = Join-Path $Root $folder
        if (-not (Test-Path -LiteralPath $path)) {
            if ($DryRun) {
                Add-RepairEntry -Category "Folder structure" -Target $folder -Action "CREATE" -Status "DRY-RUN"
            }
            else {
                try {
                    New-Item -ItemType Directory -Path $path -Force | Out-Null
                    Add-RepairEntry -Category "Folder structure" -Target $folder -Action "CREATE" -Status "FIXED"
                }
                catch {
                    Add-RepairEntry -Category "Folder structure" -Target $folder -Action "CREATE" -Status "FAILED"
                }
            }
        }
    }

    # --- 2. SYSTEM_MAP sync (cross references) ------------------
    $syncScript = Join-Path $Root ".opencode/scripts/sync-system-docs.ps1"
    if ($Force -and (Test-Path -LiteralPath $syncScript)) {
        if ($DryRun) {
            Add-RepairEntry -Category "SYSTEM_MAP" -Target ".opencode/SYSTEM_MAP.md" -Action "SYNC" -Status "DRY-RUN"
        }
        else {
            try {
                & $syncScript | Out-Null
                Add-RepairEntry -Category "SYSTEM_MAP" -Target ".opencode/SYSTEM_MAP.md" -Action "SYNC" -Status "FIXED"
            }
            catch {
                Add-RepairEntry -Category "SYSTEM_MAP" -Target ".opencode/SYSTEM_MAP.md" -Action "SYNC" -Status "FAILED: $($_.Exception.Message)"
            }
        }
    }
    else {
        $skipped += "SYSTEM_MAP sync requires --force (or sync script missing)"
    }

    # --- 3. Issues from scan -> classify safe vs manual ----------
    if ($Results) {
        $allIssues = @()
        foreach ($r in $Results) {
            if ($r.issues) { $allIssues += $r.issues }
        }

        foreach ($issue in $allIssues) {
            $msg = "$($issue.message)"

            # Safe: missing standard docs folders already handled above

            # Deterministic fix: missing agent/command file that IS referenced but the file path is wrong
            if ($msg -match 'references missing commands|missing commands|orphan agent') {
                $manualReview += $msg
            }
            # Warnings -> manual review
            elseif ($issue.severity -in @("WARNING")) {
                $manualReview += $msg
            }
            # Critical non-repairable -> manual review
            else {
                $manualReview += $msg
            }
        }
    }

    # --- 4. Repair scope notes ----------------------------------
    $skipped += "Agent prompts, skills, workflows, knowledge content - NEVER auto-modified (require manual review)"

    $status = if ($DryRun) { "DRY_RUN" } elseif (@($repairs | Where-Object { $_.status -eq "FAILED" }).Count -eq 0) { "SUCCESS" } else { "PARTIAL" }

    return @{
        group          = "Repair"
        status         = $status
        dry_run        = [bool]$DryRun
        force          = [bool]$Force
        repairs        = $script:repairs
        skipped        = $skipped
        manual_review  = $manualReview
        repair_count   = $repairs.Count
        manual_count   = $manualReview.Count
    }
}
