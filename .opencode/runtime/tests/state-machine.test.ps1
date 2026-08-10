<#
.SYNOPSIS
State Machine tests - 12 test cases: states, transition guard, checkpoint
(day du artifacts + log file), error history, retry.
Chay boi scripts/runtime-tests.ps1.
#>

Describe "state-machine"

Import-Module (Join-Path $PSScriptRoot "..\state-machine.psm1") -Force
Reset-StateMachine

# S1: Khoi tao state machine
$sm = New-StateMachine -WorkflowId "TEST-WF-001" -Request "test"
Assert "S1 Khoi tao" ($sm.workflow_id -eq "TEST-WF-001" -and $sm.status -eq "pending" -and $sm.phase_index -eq 0)

# S2: Set phase running
$null = Set-PhaseState -PhaseId "analyze" -Status "running"
Assert "S2 Phase running" ((Get-RuntimeState).status -eq "running" -and (Get-RuntimeState).current_phase -eq "analyze")

# S3: Completed -> phase_index tang
$null = Set-PhaseState -PhaseId "analyze" -Status "completed"
Assert "S3 Completed tang index" ((Get-RuntimeState).phase_index -eq 1 -and (Get-RuntimeState).status -eq "completed")

# S4: Transition hop le: completed -> running (phase moi)
$null = Set-PhaseState -PhaseId "design" -Status "running"
Assert "S4 Transition completed->running OK" ((Get-RuntimeState).current_phase -eq "design")

# S5: Guard kiem tra transition bat hop le (running -> skipped)
$guard = Test-Transition "running" "skipped"
Assert "S5 Guard kiem tra transition" (-not $guard)

# S6: Transition bat hop le -> throw STM-003
$null = Set-PhaseState -PhaseId "design" -Status "completed"
Assert-Throw "S6 Invalid transition throw" {
    Set-PhaseState -PhaseId "x" -Status "aborted"   # completed -> aborted khong hop le
} "STM-003"

# S7: Failed -> retry_count + error_history
$null = Set-PhaseState -PhaseId "build" -Status "running"
$null = Set-PhaseState -PhaseId "build" -Status "failed" -ErrorCode "WF-ERR-008" -ErrorDetail "output khong hop le"
$st = Get-RuntimeState
Assert "S7 Failed ghi error" ($st.retry_count -eq 1 -and $st.error_history.Count -eq 1 -and $st.error_history[0].code -eq "WF-ERR-008")

# S8: Cung loi lap lai -> same_error_count tang
$null = Set-PhaseState -PhaseId "build" -Status "running"
$null = Set-PhaseState -PhaseId "build" -Status "failed" -ErrorCode "WF-ERR-008"
Assert "S8 Same error dem" ((Get-RuntimeState).same_error_count -eq 2)

# S9: Loi khac -> same_error_count reset ve 1
$null = Set-PhaseState -PhaseId "build" -Status "running"
$null = Set-PhaseState -PhaseId "build" -Status "failed" -ErrorCode "WF-ERR-009"
Assert "S9 Error khac reset dem" ((Get-RuntimeState).same_error_count -eq 1)

# S10: Checkpoint ghi state.json day du artifacts (fix loi WF-20260810-001)
$tmp = Join-Path $env:TEMP "opencode\runtime-state-test"
if (Test-Path $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force }
$null = Add-Checkpoint -ContextRoot $tmp -ArtifactFiles @("01_analyze.md", "02_design.md", "14_complete.md")
$stateFile = Join-Path $tmp "TEST-WF-001\state.json"
Assert "S10 Checkpoint tao state.json" (Test-Path $stateFile)
if (Test-Path $stateFile) {
    $js = Get-Content -LiteralPath $stateFile -Raw | ConvertFrom-Json
    Assert "S10b Artifact cuoi co trong state.json" ($js.artifacts -contains "14_complete.md") "THIEU 14_complete.md (loi cu)"
    Assert "S10c Toan bo 3 artifacts" ($js.artifacts.Count -eq 3)
    $logDir = Join-Path $tmp "TEST-WF-001\logs"
    $logExists = Test-Path (Join-Path $logDir "runtime.log")
    Assert "S10d Log file duoc ghi (fix logs rong)" $logExists
}

# S11: Checkpoint 2 lan - artifact khong trung lap
$null = Add-Checkpoint -ContextRoot $tmp -ArtifactFiles @("02_design.md", "03_plan.md")
$js2 = Get-Content -LiteralPath (Join-Path $tmp "TEST-WF-001\state.json") -Raw | ConvertFrom-Json
Assert "S11 Checkpoint khong trung lap artifact" ($js2.artifacts.Count -eq 4)

# S12: Chua khoi tao -> throw STM-001
Reset-StateMachine
Assert-Throw "S12 Chua khoi tao throw" { Set-PhaseState -PhaseId "a" -Status "running" } "STM-001"
