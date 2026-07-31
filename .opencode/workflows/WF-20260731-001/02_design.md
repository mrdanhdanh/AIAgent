---
phase: 02_design
agent: planner
workflow_id: WF-20260731-001
status: READY
schema_version: "3.2"
---

# 02 — Design: Doctor Command Architecture

## 1. Architecture

```
                /doctor [mode]
                    │
        opencode.json (command → general agent)
                    │
        .opencode/commands/doctor.md   (hướng dẫn + output contract)
                    │
        .opencode/scripts/doctor.ps1   (orchestrator — parse mode, dot-source modules, dispatch)
                    │
    ┌───────────────┼─────────────────────────────────┐
    │               │                                 │
 Environment    System Pillar                    Runtime & Capability
 Pillar          ├─ agents.ps1                     ├─ runtime.ps1
 ├─ environment.ps1 ├─ commands.ps1                ├─ simulation.ps1
 │                ├─ skills.ps1                    └─ benchmark.ps1
 │                └─ workflows.ps1 (workflow +
 │                   knowledge + contracts)
    │               │                                 │
    └───────────────┼─────────────────────────────────┘
                    ▼
         .opencode/scripts/doctor/report.ps1
         (aggregate → Health Score → Suggested Actions)
                    │
         .opencode/scripts/doctor/repair.ps1  (chỉ khi --repair)
                    ▼
              Doctor Report (console + JSON)
```

**Nguyên tắc thiết kế:**
- Mỗi module script định nghĩa **hàm `Get-Doctor*`** trả về object chuẩn:
  `{ group, checks[], issues[], score }`
- `doctor.ps1` dot-source 10 modules, dispatch theo mode → collection các results
- `report.ps1` nhận collection → tính Health Score (9 categories, weighted) + Suggested Actions
- `repair.ps1` nhận issues → áp dụng safe repairs (dry-run/force)
- **Fail-safe**: mọi check bọc try/catch; thiếu tool → WARNING, không bao giờ throw
- Output: console (formatted) + optional JSON file `.opencode/scripts/doctor/reports/`

## 2. Components

| # | Action | Path | Mô tả |
|---|--------|------|-------|
| C1 | CREATE | `.opencode/commands/doctor.md` | Command doc chính: modes, flags, checks, output contract, Doctor vs SyncDocs |
| C2 | CREATE | `.opencode/commands/team-doctor.md` | Alias doc, trỏ về doctor.md |
| C3 | CREATE | `.opencode/scripts/doctor.ps1` | Orchestrator: param Mode/Force/DryRun/Json, dot-source modules, dispatch |
| C4 | CREATE | `.opencode/scripts/doctor/environment.ps1` | `Get-DoctorEnvironment` — OpenCode, folders, PS, Python, Git, model, API, permissions, contract registry |
| C5 | CREATE | `.opencode/scripts/doctor/agents.ps1` | `Get-DoctorAgents` — frontmatter, contract, permission, prompt size, deprecated, missing, circular |
| C6 | CREATE | `.opencode/scripts/doctor/commands.ps1` | `Get-DoctorCommands` — frontmatter, agent mapping, flags, workflow, contract |
| C7 | CREATE | `.opencode/scripts/doctor/skills.ps1` | `Get-DoctorSkills` — SKILL.md, schema_version, deps, missing files, deprecated |
| C8 | CREATE | `.opencode/scripts/doctor/workflows.ps1` | `Get-DoctorWorkflows` (workflow contract), `Get-DoctorKnowledge` (knowledge + learning), `Get-DoctorContracts` (contract registry) |
| C9 | CREATE | `.opencode/scripts/doctor/runtime.ps1` | `Get-DoctorRuntime` — giả lập 1 fake task qua 13 bước workflow |
| C10 | CREATE | `.opencode/scripts/doctor/simulation.ps1` | `Invoke-DoctorSimulation` — 6 scenario types, success rate |
| C11 | CREATE | `.opencode/scripts/doctor/benchmark.ps1` | `Get-DoctorBenchmark` — capability score theo domain/agent |
| C12 | CREATE | `.opencode/scripts/doctor/repair.ps1` | `Invoke-DoctorRepair` — safe repairs, backup, dry-run, force gate |
| C13 | CREATE | `.opencode/scripts/doctor/report.ps1` | `New-DoctorReport` — aggregate, health score, suggestions, output |
| C14 | MODIFY | `opencode.json` | Đăng ký command `doctor` + `team-doctor` (agent: general) |
| C15 | MODIFY | `.opencode/agents/general.md` | Thêm `/doctor` vào bảng command của General Agent |
| C16 | MODIFY | `AGENTS.md` | Thêm mục `/doctor` vào `.opencode conventions` |
| C17 | MODIFY | `.opencode/SYSTEM_MAP.md` | Đồng bộ qua sync-system-docs.ps1 |

## 3. Data Flow

1. User gõ `/doctor --full`
2. OpenCode match command `doctor` trong opencode.json → gọi `general` agent với template
3. General agent đọc `doctor.md` → xác định mode `full` → chạy:
   `& .opencode\scripts\doctor.ps1 -Mode full`
4. `doctor.ps1` dot-source 10 modules → dispatch theo mode:
   - quick → environment + agents + commands
   - full → environment, agents, commands, skills, workflows, knowledge, contracts, runtime, simulation, benchmark
   - runtime → environment + runtime
   - workflow → workflows
   - agent → agents; skill → skills; command → commands
   - knowledge → knowledge section; contracts → contracts section
   - simulation → simulation; benchmark → benchmark
   - repair → full scan + repair (dry-run/force)
5. Mỗi module trả object `{ group, score, status, checks[], issues[] }`
6. `report.ps1` aggregate → Health Score (9 categories) + Suggested Actions (HIGH/MEDIUM/LOW)
7. Nếu `--repair`: `repair.ps1` nhận issues → backup → sửa lỗi an toàn
8. Output: Doctor Report console + JSON `reports/doctor-report-<ts>.json`

## 4. Security Concerns

| # | Severity | Concern | Mitigation |
|---|----------|---------|------------|
| S1 | MEDIUM | `--repair` sửa file hệ thống | Backup trước mỗi fix (backup-utility.ps1), chỉ sửa safe targets, `--dry-run` mặc định hiển thị plan |
| S2 | LOW | Scripts đọc opencode.json (model/API config) | Chỉ đọc, không in secret; exclude pattern `secret|key|token` |
| S3 | LOW | Environment check chạy `git/python/dotnet --version` | Read-only commands, không chạy lệnh ghi |
| S4 | LOW | Doctor report lưu JSON chứa đường dẫn nội bộ | File nằm trong `.opencode/scripts/doctor/reports/`, không commit (thêm vào gitignore nếu cần) |
| S5 | LOW | Dot-source module paths sai → script chạy nhầm file | Resolve path tương đối theo `$PSScriptRoot`, kiểm tra Test-Path từng module |

## 5. Edge Cases

| # | Case | Handling |
|---|------|----------|
| E1 | Python/Git/dotnet không cài | WARNING + note, không fail |
| E2 | `.opencode/agents/` rỗng hoặc không tồn tại | Agent score = 0, status ERROR, issue ghi rõ |
| E3 | `opencode.json` thiếu hoặc sai JSON | Parse lỗi → WARNING, doctor vẫn chạy các check khác |
| E4 | Module dot-source thiếu | Doctor báo missing module, skip category đó, vẫn output phần còn lại |
| E5 | `--repair` không có gì để sửa | Output "No safe repairs needed" |
| E6 | Mode `knowledge`/`contracts` yêu cầu workflows.ps1 | Doctor chỉ report subsection tương ứng |
| E7 | File rất lớn (SKILL.md prompt size) | Đọc bằng stream/Get-Content -Raw với try/catch, size check |
| E8 | Benchmark không có knowledge để đo | Dùng heuristic: description keywords + skill presence → score 0-100 |

## 6. Issues

### blocking_issues
- Không có

### non_blocking_issues
- N1: `--force` không thực sự tự sửa agent prompts/skills — chỉ cho phép sửa thêm cross-reference
  inconsistencies có fix xác định; phần còn lại ghi vào "manual review required"
- N2: Benchmark mang tính heuristic (không phải đo lường thực tế)
- N3: Runtime check giả lập workflow dựa trên sự tồn tại của file/contract — không chạy agent thật

### open_questions
- Q1: Doctor có nên tự cập nhật SYSTEM_MAP không? → Quyết định: không; báo "run /team-syncdocs" trong
  Suggested Actions. Doctor chẩn đoán, SyncDocs chữa/tiến hóa.

## 7. Effort

**LARGE** — 11 scripts mới + 2 command docs + 4 file sửa + validation/test.
Plan strategy: nhiều chunks (config → logic → docs → test).

## Output Schema (Planner — Design)

```yaml
design:
  architecture: "Mô tả kiến trúc (section 1)"
  components:
    - id: C1
      action: CREATE
      path: ".opencode/commands/doctor.md"
      description: "..."
  data_flow:
    - "1. ..."
  security_concerns:
    - id: S1
      severity: MEDIUM
      concern: "..."
      mitigation: "..."
  edge_cases:
    - id: E1
      case: "..."
      handling: "..."
  issues:
    blocking_issues: []
    non_blocking_issues: [...]
    open_questions: [...]
  effort: LARGE
```
