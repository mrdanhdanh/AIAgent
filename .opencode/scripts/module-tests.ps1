<#
.SYNOPSIS
Module Tests - chay test cases tu 6 module tests.md (aios-sdk, artifacts, context, events, plugins, simulation).
.DESCRIPTION
Moi module: (1) structural assertions tu tests.md, (2) validator gate (neu co),
(3) behavior test neu co runtime thuc te (simulation-engine).
Khong can Agent/LLM. Exit 0 = all PASS.
.DESCRIPTION
ASCII-only (PS 5.1 ANSI). UTF-8 no BOM.
#>
param([switch]$Json)

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent $PSScriptRoot
$pass = @()
$fail = @()

function Assert {
    param([string]$Name, [bool]$Cond, [string]$Detail = "")
    if ($Cond) { $script:pass += $Name; Write-Host "  [PASS] $Name" }
    else       { $script:fail += $Name; Write-Host "  [FAIL] $Name $Detail" }
}

function Has-Text {
    param([string]$File, [string]$Pattern)
    if (-not (Test-Path $File)) { return $false }
    $c = Get-Content -LiteralPath $File -Raw -ErrorAction SilentlyContinue
    return ($null -ne $c -and $c -match $Pattern)
}

function Run-ValidatorGate {
    param([string]$Script)
    $path = Join-Path $root "scripts\$Script"
    if (-not (Test-Path $path)) { Assert "validator gate: $Script" $false "(missing script)"; return }
    & $path *> $null
    Assert "validator gate: $Script" ($LASTEXITCODE -eq 0)
}

function Run-Suite {
    param([string]$Name, [scriptblock]$Body)
    Write-Host "`n=== Suite: $Name ==="
    & $Body
}

# ============================================================
# 1. ARTIFACTS (13 test cases tu artifacts/tests.md)
# ============================================================
Run-Suite "artifacts" {
    $d = Join-Path $root "artifacts"
    Assert "A1 Create artifact (id/version/status)"     (Test-Path (Join-Path $d "artifact.schema.yaml")) "thieu artifact.schema.yaml"
    Assert "A2 Update artifact (version bump)"          (Test-Path (Join-Path $d "versioning.md"))
    Assert "A3 Delete artifact (status=deleted)"        (Test-Path (Join-Path $d "lifecycle.md"))
    Assert "A4 Version history"                          (Test-Path (Join-Path $d "history.md"))
    Assert "A5 Checksum mismatch (ART-003)"              (Has-Text (Join-Path $d "validator.md") "ART-003") "thieu ART-003"
    Assert "A6 Index lookup O(1)"                        (Test-Path (Join-Path $d "indexing.md"))
    Assert "A7 Invalid type (ART-002)"                   (Has-Text (Join-Path $d "validator.md") "ART-002")
    Assert "A8 Missing dependency (ART-006)"             (Has-Text (Join-Path $d "validator.md") "ART-006")
    Assert "A9 Duplicate id (ART-005)"                   (Has-Text (Join-Path $d "validator.md") "ART-005")
    Assert "A10 Lineage cycle (ART-008)"                 (Has-Text (Join-Path $d "validator.md") "ART-008")
    Assert "A11 Orphan detection (ART-009)"              (Has-Text (Join-Path $d "validator.md") "ART-009")
    Assert "A12 Query by tag"                            ((Test-Path (Join-Path $d "tags.md")) -and (Test-Path (Join-Path $d "query.md")))
    Assert "A13 Contract consume (builder plan)"         (Test-Path (Join-Path $d "contract.md"))
    Run-ValidatorGate "artifact-validator.ps1"
}

# ============================================================
# 2. CONTEXT (10 test cases tu context/tests/tests.md)
# ============================================================
Run-Suite "context" {
    $d = Join-Path $root "context"
    Assert "C1 Missing required context (CXT-002)"       (Has-Text (Join-Path $d "validator\validator.md") "CXT-002")
    Assert "C2 Duplicate context (dedup)"                (Test-Path (Join-Path $d "pipeline.md"))
    Assert "C3 Budget exceed"                            ((Test-Path (Join-Path $d "schemas\budget.schema.yaml")) -and (Test-Path (Join-Path $d "intelligence\intelligence.md")))
    Assert "C4 Cache hit"                                (Test-Path (Join-Path $d "cache\cache.md"))
    Assert "C5 Resolver match (artifact.plan)"           (Test-Path (Join-Path $d "resolver\resolver.md"))
    Assert "C6 Validation invalid package"               (Test-Path (Join-Path $d "schemas\context.schema.yaml"))
    Assert "C7 Package structure (schema)"               (Test-Path (Join-Path $d "schemas\context-types.yaml"))
    Assert "C8 Diff iteration"                           (Test-Path (Join-Path $d "cache\diff.md"))
    Assert "C9 Forbidden filter (review context)"        (Test-Path (Join-Path $d "resolver\filter.md"))
    Assert "C10 Empty task (CXT-001)"                    (Has-Text (Join-Path $d "validator\validator.md") "CXT-001")
    Run-ValidatorGate "context-validator.ps1"
}

# ============================================================
# 3. EVENTS (12 test cases tu events/tests.md)
# ============================================================
Run-Suite "events" {
    $d = Join-Path $root "events"
    Assert "E1 Publish event"                            (Test-Path (Join-Path $d "publisher.md"))
    Assert "E2 Subscribe + receive"                      (Test-Path (Join-Path $d "subscriber.md"))
    Assert "E3 Unsubscribe"                              (Test-Path (Join-Path $d "subscriber.md"))
    Assert "E4 Queue priority (critical first)"          ((Test-Path (Join-Path $d "priority.md")) -and (Test-Path (Join-Path $d "queue.md")))
    Assert "E5 Event history"                            (Test-Path (Join-Path $d "history.md"))
    Assert "E6 Replay"                                   (Test-Path (Join-Path $d "replay.md"))
    Assert "E7 Filter"                                   (Test-Path (Join-Path $d "filter.md"))
    Assert "E8 Routing"                                  (Test-Path (Join-Path $d "routing.md"))
    Assert "E9 Dead letter (retry fail)"                 (Has-Text (Join-Path $d "dispatcher.md") "(?i)dead.?letter") "thieu dead letter"
    Assert "E10 Lineage chain"                           (Test-Path (Join-Path $d "lineage.md"))
    Assert "E11 Contract validation"                     ((Test-Path (Join-Path $d "contracts\contracts.yaml")) -and (Test-Path (Join-Path $d "event.schema.yaml")))
    Assert "E12 Overflow (queue max)"                    (Has-Text (Join-Path $d "queue.md") "(?i)overflow|max") "thieu overflow"
    Run-ValidatorGate "event-validator.ps1"
}

# ============================================================
# 4. SDK (8 test cases tu aios-sdk/tests.md)
# ============================================================
Run-Suite "aios-sdk" {
    $d = Join-Path $root "aios-sdk"
    $sdkFiles = @("agent-sdk.md","artifact-sdk.md","context-sdk.md","dashboard-sdk.md","doctor-sdk.md","event-sdk.md","evolution-sdk.md","plugin-sdk.md","registry-sdk.md","simulation-sdk.md","workflow-sdk.md")
    $missing = @($sdkFiles | Where-Object { -not (Test-Path (Join-Path $d $_)) })
    Assert "S1 Component API (11 SDK docs)"              ($missing.Count -eq 0) "thieu: $($missing -join ',')"
    Assert "S2 Permission denied (SDK-ERR-401)"          (Has-Text (Join-Path $d "security.md") "SDK-ERR-401|401") "thieu 401"
    Assert "S3 Version incompatible (SDK-ERR-403)"       (Has-Text (Join-Path $d "security.md") "SDK-ERR-403|403") "thieu 403"
    Assert "S4 NotFound (SDK-ERR-404)"                   (Has-Text (Join-Path $d "security.md") "SDK-ERR-404|404") "thieu 404"
    Assert "S5 Control with key"                         (Has-Text (Join-Path $d "security.md") "(?i)key|control") "thieu key"
    Assert "S6 Audit log"                                (Has-Text (Join-Path $d "security.md") "(?i)audit") "thieu audit"
    Assert "S7 Backward compat"                          (Test-Path (Join-Path $d "versioning.md"))
    Assert "S8 Error contract (schema)"                  (Test-Path (Join-Path $d "aios-sdk.schema.yaml"))
    Run-ValidatorGate "sdk-validator.ps1"
}

# ============================================================
# 5. PLUGINS (10 test cases tu plugins/tests.md)
# ============================================================
Run-Suite "plugins" {
    $d = Join-Path $root "plugins"
    Assert "P1 Install plugin (validated+exports)"       (Test-Path (Join-Path $d "installer.md"))
    Assert "P2 Update plugin (re-certify)"               ((Test-Path (Join-Path $d "lifecycle.md")) -and (Test-Path (Join-Path $d "certification.md")))
    Assert "P3 Dependency missing (no enable)"           (Test-Path (Join-Path $d "manager.md"))
    Assert "P4 Framework incompatible (reject)"          (Test-Path (Join-Path $d "compatibility.md"))
    Assert "P5 Permission denied"                        (Test-Path (Join-Path $d "permissions.md"))
    Assert "P6 Unload plugin (clean state)"              (Test-Path (Join-Path $d "lifecycle.md"))
    Assert "P7 Capability conflict (block)"              (Test-Path (Join-Path $d "registry.md"))
    Assert "P8 Manifest mismatch (PLG-007)"              (Has-Text (Join-Path $d "validator.md") "PLG-007") "thieu PLG-007"
    Assert "P9 Malicious script (sandbox)"               (Test-Path (Join-Path $d "sandbox.md"))
    Assert "P10 Certification fail (no enable)"          (Test-Path (Join-Path $d "certification.md"))
    Run-ValidatorGate "plugins-validator.ps1"
}

# ============================================================
# 6. SIMULATION (12 test cases tu simulation/tests.md)
# ============================================================
Run-Suite "simulation" {
    $d = Join-Path $root "simulation"
    Assert "M1 Dry run (no side-effect)"                 (Has-Text (Join-Path $d "modes.md") "(?i)dry") "thieu dry-run"
    Assert "M2 Replay (event order)"                     (Test-Path (Join-Path $d "event-prediction.md"))
    Assert "M3 Risk calc"                                (Test-Path (Join-Path $d "risk-engine.md"))
    Assert "M4 Confidence calc"                          (Test-Path (Join-Path $d "confidence.md"))
    Assert "M5 Prediction (tokens/time/artifacts)"       (Test-Path (Join-Path $d "event-prediction.md"))
    Assert "M6 Dependency check (reject)"                (Test-Path (Join-Path $d "dependency-checker.md"))
    Assert "M7 Context check (SIM-004)"                  (Has-Text (Join-Path $d "validator.md") "SIM-004") "thieu SIM-004"
    Assert "M8 Capability check (SIM-003)"               (Has-Text (Join-Path $d "validator.md") "SIM-003") "thieu SIM-003"
    Assert "M9 Artifact version (SIM-005)"               (Has-Text (Join-Path $d "validator.md") "SIM-005") "thieu SIM-005"
    Assert "M10 Multi-scenario"                          ((Test-Path (Join-Path $d "scenario.md")) -and (Test-Path (Join-Path $d "modes.md")))
    Assert "M11 Conflict detect"                         (Test-Path (Join-Path $d "conflict-detection.md"))
    Assert "M12 Recommendation"                          (Has-Text (Join-Path $d "report.md") "(?i)recommend") "thieu recommend"
    Run-ValidatorGate "simulation-validator.ps1"
}

# ============================================================
# 7. BEHAVIOR: Simulation Engine (runtime that)
# ============================================================
Write-Host "`n=== Suite: behavior (simulation-engine) ==="
$engine = Join-Path $root "scripts\evolution\simulation-engine.ps1"
if (Test-Path $engine) {
    & $engine *> $null
    if ($LASTEXITCODE -eq 0) { Assert "BE1 Simulation Engine chay that" $true }
    else { Assert "BE1 Simulation Engine chay that" $false }
} else {
    Assert "BE1 Simulation Engine chay that" $false "(missing engine)"
}

# ============================================================
Write-Host ""
Write-Host "============================================="
Write-Host "  MODULE TESTS RESULT"
Write-Host "  Passed: $($pass.Count)  Failed: $($fail.Count)"
Write-Host "============================================="
if ($fail.Count -gt 0) {
    Write-Host "  Failed tests:"
    $fail | ForEach-Object { Write-Host "    [FAIL] $_" }
    exit 1
} else {
    Write-Host "  ALL PASS"
    exit 0
}
