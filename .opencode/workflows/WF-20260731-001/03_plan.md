---
phase: 03_plan
agent: planner
workflow_id: WF-20260731-001
status: READY
schema_version: "3.2"
---

# 03 — Plan: Doctor Command Implementation

## Strategy

**LARGE** — chia 7 steps, 4 chunks (1=config, 2=logic, 3=docs, 4=test).
Thứ tự: config (thư mục) → logic (scripts) → docs (command md) → registration → validation → test.

## Steps

```yaml
steps:
  - order: 1
    description: "Tạo thư mục scripts/doctor + reports + workflow artifacts"
    file: ".opencode/scripts/doctor/"
    action: CREATE
    logic: "New-Item -ItemType Directory .opencode/scripts/doctor/reports -Force"
    expected_result: "Thư mục tồn tại"
    check: "Test-Path .opencode/scripts/doctor/reports"
    chunk: 1
    risk_level: LOW
    requires_backup: false

  - order: 2
    description: "Tạo 6 module check cơ bản: environment, agents, commands, skills, workflows"
    file: ".opencode/scripts/doctor/environment.ps1"
    action: CREATE
    logic: "Viết module PowerShell: hàm Get-DoctorEnvironment, Get-DoctorAgents, Get-DoctorCommands, Get-DoctorSkills, Get-DoctorWorkflows (workflow+knowledge+contracts)"
    expected_result: "5 file .ps1 tồn tại, parse không lỗi syntax"
    check: "Dot-source từng module qua PowerShell Parser: [System.Management.Automation.Language.Parser]::ParseFile"
    chunk: 2
    risk_level: MEDIUM
    requires_backup: false

  - order: 3
    description: "Tạo 5 module nâng cao: runtime, simulation, benchmark, repair, report"
    file: ".opencode/scripts/doctor/runtime.ps1"
    action: CREATE
    logic: "Viết module: Get-DoctorRuntime (fake task qua 13 bước), Invoke-DoctorSimulation (6 scenarios), Get-DoctorBenchmark (capability), Invoke-DoctorRepair (safe fixes), New-DoctorReport (health score + suggestions)"
    expected_result: "5 file .ps1 tồn tại, parse không lỗi"
    check: "PowerShell Parser parse OK + dot-source test"
    chunk: 2
    risk_level: MEDIUM
    requires_backup: false

  - order: 4
    description: "Tạo orchestrator doctor.ps1"
    file: ".opencode/scripts/doctor.ps1"
    action: CREATE
    logic: "Main script: param(Mode, Force, DryRun, Json), dot-source modules từ $PSScriptRoot/doctor/, dispatch theo mode, gọi report.ps1, repair nếu --repair"
    expected_result: "doctor.ps1 chạy được: & .opencode\scripts\doctor.ps1 -Mode quick"
    check: "Chạy thử -Mode quick, exit code 0"
    chunk: 2
    risk_level: MEDIUM
    requires_backup: false

  - order: 5
    description: "Tạo command docs: doctor.md + team-doctor.md"
    file: ".opencode/commands/doctor.md"
    action: CREATE
    logic: "Viết command doc theo convention (frontmatter description+agent, HELP section, modes, output contract, Doctor vs SyncDocs)"
    expected_result: "2 file .md có frontmatter YAML hợp lệ"
    check: "Frontmatter parse OK + internal links có section tương ứng"
    chunk: 3
    risk_level: LOW
    requires_backup: false

  - order: 6
    description: "Đăng ký commands trong opencode.json + cập nhật general.md + AGENTS.md"
    file: "opencode.json"
    action: MODIFY
    logic: "Thêm command doctor + team-doctor vào block command (agent: general). Cập nhật general.md bảng command, AGENTS.md mục conventions"
    expected_result: "opencode.json parse OK (ConvertFrom-Json), 2 command mới có trong JSON"
    check: "ConvertFrom-Json không throw + grep 'doctor' opencode.json >= 2"
    chunk: 1
    risk_level: HIGH
    requires_backup: true

  - order: 7
    description: "Validation: parse scripts, chạy doctor test matrix, đồng bộ SYSTEM_MAP, ghi báo cáo"
    file: ".opencode/scripts/doctor.ps1"
    action: MODIFY
    logic: "Chạy validation: 1) Parse tất cả scripts bằng Parser API, 2) Chạy doctor.ps1 -Mode quick/full/knowledge/contracts/simulation/benchmark/repair --dry-run, 3) Validate JSON output, 4) Chạy sync-system-docs.ps1 cập nhật SYSTEM_MAP"
    expected_result: "Tất cả scripts parse OK, doctor chạy các mode không lỗi, SYSTEM_MAP có doctor, report JSON hợp lệ"
    check: "Exit codes + Test-Path SYSTEM_MAP + grep doctor trong SYSTEM_MAP"
    chunk: 4
    risk_level: MEDIUM
    requires_backup: false
```

## Rollback Strategy

```yaml
rollback_strategy:
  enabled: true
  tool: ".opencode/scripts/rollback-utility.ps1"
  trigger_conditions:
    - "doctor.ps1 chạy lỗi critical trong validation"
    - "opencode.json sai cú pháp sau khi modify"
    - "SYSTEM_MAP bị hỏng sau sync"
  restore_order:
    - "opencode.json"
    - "AGENTS.md"
    - ".opencode/agents/general.md"
    - "Xóa các file doctor mới tạo (scripts/doctor/*, doctor.ps1, doctor.md, team-doctor.md)"
  requires_user_confirmation: true
```

## Validate

```yaml
validate:
  per_step_validation:
    - "Mỗi step chạy xong kiểm tra check tương ứng"
  per_chunk_validate:
    - "Chunk 1 (config): thư mục tồn tại, JSON parse OK"
    - "Chunk 2 (logic): Parser API không lỗi cho 11 scripts, dot-source OK"
    - "Chunk 3 (docs): frontmatter + links OK"
    - "Chunk 4 (test): test matrix chạy PASS"
  final_validation:
    - "& .opencode\scripts\doctor.ps1 -Mode quick  → exit 0"
    - "& .opencode\scripts\doctor.ps1 -Mode full   → exit 0"
    - "& .opencode\scripts\doctor.ps1 -Mode repair -DryRun → exit 0"
    - "Get-Content opencode.json | ConvertFrom-Json → OK"
    - "grep doctor .opencode/SYSTEM_MAP.md → >= 1"
```

## Chunk Rules

- **Chunk 1 = config**: tạo thư mục, sửa opencode.json, general.md, AGENTS.md
- **Chunk 2 = logic**: 11 scripts PowerShell
- **Chunk 3 = docs**: doctor.md, team-doctor.md
- **Chunk 4 = test**: validation matrix, SYSTEM_MAP sync

## Output Schema (Planner — Plan)

```yaml
plan:
  strategy: LARGE
  steps: [...]
  rollback_strategy: {...}
  validate: {...}
```
