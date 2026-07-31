---
name: dev-team
description: Hướng dẫn sử dụng Dev Agent Team gồm 12 agents (10 core + 2 support). Dùng khi cần phân tích, lập kế hoạch, đánh giá, code, kiểm thử một yêu cầu phát triển. Tích hợp cơ chế Self-Improvement với approval gate, Failure Learning System với Root Cause Analysis và Learning Pipeline. Sử dụng câu lệnh team hoặc team-*.
schema_version: "3.2"
---

# Dev Agent Team — Orchestrator Guide

**Schema:** 3.1 (nâng cấp từ 3.0 — thêm `depends_on`, `deleted_files`, error types mới)

## 8 NÂNG CẤP CHÍNH CHO BUILDER AGENT

| # | Cải tiến | Mô tả | Áp dụng cho |
|---|----------|-------|-------------|
| 1 | **Chuẩn hóa input kế hoạch** | `$ARGUMENTS` bắt buộc có: `goal`, `approved_steps`, `allowed_files`, `validate_commands`, `backup_required`. Thiếu → trả `FAIL` sớm | Planner, Builder |
| 2 | **Rõ cấu trúc từng step** | Mỗi step có: `action`(CREATE/MODIFY/DELETE), `file`, `expected_result`, `check`(per_step_validation), `requires_backup`, `depends_on`, `validation_command` | Planner (Plan phase) |
| 3 | **Error fields chi tiết** | `error_normalized` → `error_type` + `error_normalized` + `error_hash` + `retryable` | Builder output |
| 4 | **Ràng buộc backup** | `requires_backup:true` + fail → DỪNG NGAY. File mới không cần backup. Utility không sẵn sàng → CRITICAL | Builder + Orchestrator |
| 5 | **Validate theo giai đoạn** | `per_step_validation` (sau mỗi step) + `final_validation` (cuối cùng) | Planner (Plan phase) |
| 6 | **Quy định file không tồn tại** | `MODIFY` mà file không tồn tại → không tự đổi sang `CREATE` → báo FAIL. Chỉ `CREATE` khi plan cho phép | Builder |
| 7 | **Ràng buộc chỉnh sửa file** | Chỉ sửa đúng file trong plan. File ngoài plan → báo cáo, không đụng vào. `MODIFY` không thành `CREATE`. | Builder |
| 8 | **Chuẩn hóa output** | `changed_files`, `created_files`, `deleted_files`, `backup_workflow_id`, `validation_status` | Builder output |
| 9 | **Planner contract siết chặt (v3.2)** | Input validation gates, categorized issues, enriched step schema (risk_level), chunk rules, concrete rollback strategy | Planner, Builder, Orchestrator |

---

Team gồm **General Agent (Orchestrator)** điều phối **12 agents (10 core specialists: analyst, planner, reviewer, builder, ui-beautifier, test-planner, tester, failure-agent, root-cause-agent, learning-agent + 2 support: self-improver, backup-agent)** theo quy trình phát triển phần mềm hoàn chỉnh:
**Analyze → Design → Plan → Review → Guardrail → Backup → Build → Static Analysis → UI Audit → Test Plan → Test → [FAIL → Analyze Failure → Root Cause → Learn] → Skill Validation → Complete**

Trong đó:
- **General Agent (Orchestrator)**: Workflow orchestration + State management (không tự làm backup/restore)
- **10 Core Specialists**: analyst, planner (mở rộng), reviewer, builder, ui-beautifier, test-planner, tester, failure-agent, root-cause-agent, learning-agent
- **Self-Improver** (optional): Knowledge improvement (qua approval gate)
- **backup-agent**: Backup/Restore/Diff (script riêng, orchestrator chỉ gọi lệnh) — support agent

---

## MỤC LỤC

- [MÔ HÌNH ORCHESTRATOR](#mô-hình-orchestrator)
- [WORKFLOW ID & ARTIFACT MANAGEMENT](#workflow-id--artifact-management)
- [MÁY TRẠNG THÁI (STATE MACHINE)](#máy-trạng-thái-state-machine)
- [BIẾN THEO DÕI (TRACKING VARIABLES)](#biến-theo-dõi-tracking-variables)
- [OUTPUT CONTRACT CỦA CÁC AGENT](#output-contract-của-các-agent)
- [QUY TRÌNH CHI TIẾT](#quy-trình-chi-tiết)
  - [Bước 1: Analyze](#bước-1-analyze)
  - [Bước 2: Design](#bước-2-design)
  - [Bước 3: Plan](#bước-3-plan)
  - [Bước 4: Review](#bước-4-review)
  - [Bước 5: Backup](#bước-5-backup)
  - [Bước 6: Build](#bước-6-build)
  - [Bước 7: Static Analysis](#bước-7-static-analysis)
  - [Bước 8: UI Audit](#bước-8-ui-audit)
  - [Bước 9: Test Plan](#bước-9-test-plan)
  - [Bước 10: Test](#bước-10-test)
  - [Bước 11: Skill Validation](#bước-11-skill-validation)
  - [Bước 12: Complete](#bước-12-complete)
- [BÁO CÁO KẾT THÚC](#báo-cáo-kết-thúc)
- [VALIDATION CHECKLIST PER PHASE](#validation-checklist-per-phase)
- [CHECKPOINT MECHANISM](#checkpoint-mechanism)
- [SƠ ĐỒ QUYẾT ĐỊNH (DECISION TREE)](#sơ-đồ-quyết-định-decision-tree)
- [ROLLBACK MECHANISM](#rollback-mechanism)
- [TÍCH HỢP VỚI COMMANDS RIÊNG LẺ](#tích-hợp-với-commands-riêng-lẻ)
- [XỬ LÝ NGOẠI LỆ (EXCEPTION HANDLING)](#xử-lý-ngoại-lệ-exception-handling)
- [VÍ DỤ CHẠY WORKFLOW](#ví-dụ-chạy-workflow)
- [MIGRATION PLAN](#migration-plan)
- [COMPLEXITY ESTIMATE](#complexity-estimate)
- [VALIDATION & TESTING](#validation--testing)
- [GHI CHÚ](#ghi-chú)

---

## BASE AGENT SCHEMA

Mỗi agent output theo format YAML cố định, extends từ Base Schema sau:

```yaml
# Base Schema — tất cả agent output phải có
status: "READY | FAIL | NEEDS_MORE_INFO | NO_SUGGESTIONS"
summary: "Tóm tắt ngắn (1-3 câu)"
issues: []           # [{severity, category, description, suggestion}]
next_action: "Mô tả hành động tiếp theo cần thực hiện"
artifacts: []        # Danh sách artifact đã tạo/đọc
```

**Backward compatibility**: Agent output thiếu field → mặc định:
- `status` → `READY`
- `issues` → `[]`
- `next_action` → `"Tiếp tục workflow"`
- `artifacts` → `[]`

---

## ERROR PRIORITY & ACTION MAP

| Severity | Hành động | Auto-action |
|----------|-----------|-------------|
| `CRITICAL` | STOP → Rollback → Hỏi user | Rollback tự động nếu same_error ≥ 2 |
| `MAJOR` | Log → Rebuild → Retry | Rebuild tối đa 3 lần |
| `MINOR` | Log → Tiếp tục | Warning, không block |
| `INFO` | Log → Bỏ qua | Silent |

Mỗi lỗi được gắn severity. Orchestrator dùng action map để quyết định.

---

## MÔ HÌNH ORCHESTRATOR

Bạn là **General Agent** đóng vai trò orchestrator. Trách nhiệm:

| Thành phần | Hành động |
|-----------|----------|
| **Orchestrator** | Triệu hồi đúng agent, truyền context, theo dõi trạng thái, quyết định |
| **Orchestrator** | Quản lý vòng lặp (review loop, test-fix loop), kiểm tra same_error_count |
| **backup-agent** | Backup/Restore/Diff (orchestrator chỉ gọi lệnh) |
| **Builder** | File modification, syntax validation |
| **Tester** | Test execution, coverage tracking |
| **Reviewer** | Risk assessment (Requirement + Design + Plan) |
| **UI Beautifier** | UI audit, CSS refactor, dark mode, design tokens, accessibility check |
| **Failure Agent** | Error normalization, classification, memory search |
| **Root Cause Agent** | Root cause analysis, hypothesis generation, fix suggestion |
| **Learning Agent** | Learning pipeline — auto-generate lessons/patterns từ failure records |
| **Self-Improver** | Knowledge suggestion (không ghi trực tiếp) |

Orchestrator không tự làm backup/restore/diff — gọi backup-agent qua lệnh.

---

## WORKFLOW ID & ARTIFACT MANAGEMENT

Mỗi workflow được gán một ID duy nhất:

```yaml
workflow:
  id: WF-{YYYYMMDD}-{NNN}        # Ví dụ: WF-20260723-001
  created_at: 2026-07-23T22:00:00Z
  project: JapaneseLearner
  branch: main
  user_request: "Mô tả yêu cầu"
  schema_version: "3.1"          # v3.1: depends_on, deleted_files, FileOutsidePlan, ActionMismatch, UnauthorizedFix
```

### Artifact structure

```
workflow/
  WF-20260723-001/
    01_analysis.md
    02_design.md                  # Planner — Design Phase
    03_plan.md                    # Planner — Plan Phase (nâng cấp: action, expected_result, per_step_validation, final_validation)
    04_review.md
    05_guardrail.md               # Pre-Build Guardrail (nâng cấp: step_action_check, requires_backup_check, per_step/final validation check)
    backup_manifest.json          # Backup manifest (tên do script tạo)
    07_build.md                   # Builder output (nâng cấp: error_type, error_hash, retryable, validation_status)
    08_static_analysis.md
    09_ui_audit.md
    10_test_plan.md
    11_test.md
    11a_failure_analysis.md       # Failure Agent output
    11b_root_cause.md             # Root Cause Agent output
    11c_learning.md               # Learning Agent output
    12_skill_validation.md
    13_report.md
    workflow.json
```

Mỗi agent chỉ đọc artifact của bước trước (không đọc toàn bộ lịch sử).

### Backward compatibility

```yaml
backward_compatibility:
  missing_workflow_id:
    action: auto_generate
    format: "WF-LEGACY-{timestamp}"
  missing_field:
    action: use_default
    defaults:
      retry_count: 0
      error_history: []
      backup_done: false
  artifact_schema_validation:
    v3_1_artifacts: strict        # Schema 3.1: depends_on, validation_command, deleted_files, FileOutsidePlan, ActionMismatch, UnauthorizedFix
    v3_artifacts: strict          # Schema 3.0: action, expected_result, error_type, error_hash, retryable, backup_workflow_id
    v2_artifacts: permissive      # Schema 2.0 legacy: log warning, tự động thêm field mặc định
```

---

## MÁY TRẠNG THÁI (STATE MACHINE)

```
                    ┌─────────┐
                    │  START  │
                    └────┬────┘
                         ▼
                    ┌─────────┐
                    │ANALYZE  │ ◄──── nếu cần thêm thông tin → hỏi user
                    └────┬────┘
                         ▼
                    ┌─────────┐
                    │ DESIGN  │ ←── Planner mở rộng
                    └────┬────┘
                         ▼
                    ┌─────────┐
                    │  PLAN   │
                    └────┬────┘
                         ▼
                    ┌─────────┐
                    │ REVIEW  │
                    └────┬────┘
                    ┌────┴────┐
                    │         │
                    ▼         ▼
             ┌─────────┐  ┌──────────────┐
             │APPROVED │  │CHANGES_REQ   │
             └────┬────┘  └──────┬───────┘
                  │              │ (retry < 3)
                  ▼              ▼
             ┌────────────┐  ┌─────────┐
             │ GUARDRAIL  │  │  PLAN   │
             └─────┬──────┘  └─────────┘
                   │
                   ▼
              ┌─────────┐
              │ BACKUP  │
              └────┬────┘
                   │
                   ▼
              ┌─────────┐
              │  BUILD  │ ◄──── nếu STATIC_ANALYSIS/TEST FAIL
              └────┬────┘
                  ▼
           ┌───────────────┐
           │STATIC ANALYSIS│ ←── YAML/JSON/lint validation
           └───────┬───────┘
                   ▼
              ┌───────────┐
              │ UI AUDIT  │ ←── ui-beautifier: CSS, dark mode, a11y
              └─────┬─────┘
                    ▼
              ┌─────────┐
              │ TESTPLAN│
              └────┬────┘
                   ▼
              ┌─────────┐
              │  TEST   │
             └────┬────┘
              ┌───┴───┐
               │       │
               ▼       ▼
           ┌────────┐ ┌────────┐
           │ PASS   │ │ FAIL   │ ───► Analyze Failure ──► Root Cause ──► quay lại BUILD
           └───┬────┘ └────────┘
              ▼
         ┌──────────────────┐
         │SKILL VALIDATION  │ ←── approval gate
         └────────┬─────────┘
                  │
                  ▼
         ┌────────────────┐
         │ WAITING_APPROVAL│ ←── new state
         └───────┬────────┘
                 │
          ┌──────┴──────┐
          │             │
          ▼             ▼
     ┌─────────┐   ┌──────────┐
     │APPROVED │   │ REJECTED │
     └────┬────┘   └────┬─────┘
          │              │
          ▼              ▼
     ┌─────────┐   ┌─────────┐
     │COMPLETE │   │COMPLETE │ (skip ghi knowledge)
     └─────────┘   └─────────┘
```

### Trạng thái mới bổ sung

```yaml
status:
  - running
  - blocked
  - completed
  - failed
  - waiting_user
  - cancelled
  - reviewing
  - building
  - testing
  - self_improving
  - waiting_approval     # Mới: chờ user approve suggestion
```

---

## BIẾN THEO DÕI (TRACKING VARIABLES)

Duy trì các biến sau xuyên suốt workflow:

```yaml
workflow:
  id: "WF-{YYYYMMDD}-{NNN}"        # Workflow ID
  created_at: "2026-07-23T22:00:00Z"
  project: "..."
  branch: "..."
schema_version: "3.0"
  step: 1-16                        # Bước hiện tại (1-16) — thêm 11a, 11b, 11c
  step_name: analyze|design|plan|review|guardrail|backup|build|static_analysis|ui_audit|testplan|test|analyze_failure|root_cause|learning|skill_validation|complete
  status: running|blocked|completed|failed|waiting_user|cancelled|reviewing|building|testing|self_improving|waiting_approval
  retry:
    review_count: 0-3                # Số lần review loop
    test_count: 0-3                  # Số lần test-fix loop
    max_review: 3
    max_test: 3
    skill_validation_count: 0-1
  user_intervention: false
  backup_done: false
  error_history:
    review:
      - hash: "a1b2c3d4e5f6"        # SHA256(error) lấy 12 ký tự
        error: "error message"
        error_type: "ReviewIssue"    # Phân loại lỗi
        error_normalized: "error message normalized"
        step: 3
        retryable: true              # Có thể retry không?
        severity: MAJOR              # Error Priority: CRITICAL/MAJOR/MINOR
        action_taken: "rebuild"      # Action theo Error Priority Map
    test_failures:
      - hash: "..."
        error: "..."
        error_type: "TestFailed"
        error_normalized: "..."
        step: 9
        retryable: true
        severity: CRITICAL
        action_taken: "stop"
    build_failures:
      - hash: "..."
        error: "..."
        error_type: "SyntaxError"
        error_normalized: "syntaxerror: unexpected token"
        step: 6
        retryable: true
        severity: MINOR
        action_taken: "log"
    same_error_count: 0              # Nếu ≥ 2 → STOP
  diff_snapshots:                    # Mới: Diff giữa các vòng lặp
    - loop: 1
      timestamp: "2026-07-26T14:30:00Z"
      step: "review"
      changes: ["Thêm rollback strategy", "Sửa file path"]
      old_errors: []
      new_errors: ["hash: a1b2c3..."]
      same_errors: []
  coverage:
    thresholds:
      unit: 80                       # mandatory ≥ 80%
      integration: 60                # mandatory ≥ 60%
      e2e: 50                        # khuyến nghị ≥ 50%
      overall: 70                    # weighted average ≥ 70%
    mandatory: true
  current_data:
    analysis: null
    design: null                     # Mới: output từ Design phase
    plan: null
    review_result: null
    build_result: null
    static_analysis_result: null     # Mới: kết quả static analysis
    ui_audit_result: null            # Kết quả UI audit từ ui-beautifier
    test_plan: null
    test_result: null
    failure_analysis: null        # Output từ failure-agent (Bước 11a)
    root_cause: null              # Output từ root-cause-agent (Bước 11b)
    learning_result: null         # Output từ learning-agent (Bước 11c)
    skill_validation_result: null
    final_report: null
    checkpoint_snapshots: []
```

### Diff Mechanism

Mỗi lần retry (review loop, test-fix loop), orchestrator lưu `diff_snapshot`:

```yaml
diff_snapshot:
  loop: 2                            # Lần retry thứ mấy
  timestamp: "2026-07-26T15:00:00Z"
  step: "build"
  changes:                           # Cái gì đã đổi từ lần trước
    - "Sửa file: src/handler.ts (dòng 42)"
    - "Thêm file: src/validators.ts"
  old_errors: []                     # Lỗi cũ đã hết
  new_errors:                        # Lỗi mới xuất hiện
    - hash: "b2c3d4e5f6a1"
      error: "NullReferenceException"
      severity: CRITICAL
  same_errors:                       # Lỗi cũ còn tồn tại
    - hash: "a1b2c3d4e5f6"
      error: "SyntaxError"
      severity: MAJOR
```

Cách phát hiện `same_error`:
1. Lấy error_normalized từ lần retry trước
2. So sánh hash với lần retry hiện tại
3. Nếu hash trùng → `same_errors[]`, tăng `same_error_count`
4. Nếu `same_error_count >= 2` → STOP, rollback

### Cách tính error_hash và error_type

```
error_hash:
  1. Lấy raw error message (từ stderr/exception)
  2. Normalize: loại bỏ line number, timestamp, memory address, stack trace line
  3. Trim whitespace, lowercase
  4. SHA256(string) → lấy 12 ký tự đầu

  Ví dụ:
    Raw:    "Line 42: System.NullReferenceException: Object reference at MyClass.cs:123"
    Normal: "system.nullreferenceexception: object reference"
    Hash:   "a1b2c3d4e5f6"

error_type:
  - SyntaxError: Lỗi cú pháp (unexpected token, missing bracket)
  - BuildFailed: Lỗi build (dotnet build thất bại)
  - FileNotFound: File không tồn tại khi action=MODIFY
  - NullReferenceException: Null reference runtime error
  - BackupFailed: Backup utility thất bại
  - BackupUtilityUnavailable: Backup utility script không tìm thấy
  - ValidationFailed: Per-step hoặc final validation thất bại
  - TestFailed: Test case FAIL
  - CoverageBelowThreshold: Coverage không đạt threshold
  - FileOutsidePlan: Builder đụng vào file không được liệt kê trong plan
  - ActionMismatch: Builder tự ý đổi MODIFY thành CREATE hoặc ngược lại
  - UnauthorizedFix: Builder tự sửa lỗi ngoài phạm vi plan
  - FailureAnalysisRequested: Orchestrator gọi failure-agent để phân tích lỗi
  - RootCauseFound: Root-cause-agent tìm thấy nguyên nhân gốc (có fix_suggestion)
  - NoRootCauseFound: Root-cause-agent không tìm thấy nguyên nhân (INCONCLUSIVE)
  - Unknown: Không phân loại được

retryable:
  - true: Có thể retry (syntax error, build fail, test fail)
  - false: KHÔNG thể retry (file not found, backup fail, backup utility unavailable, file outside plan, action mismatch, unauthorized fix)
```

---

## OUTPUT CONTRACT CỦA CÁC AGENT

Mỗi agent output theo format YAML cố định (extends [Base Schema](#base-agent-schema)). Orchestrator parse các field này để quyết định bước tiếp theo.

**Format chung (extends Base Schema):** `status`, `summary`, `issues` (kế thừa từ Base), cộng thêm các field riêng của từng agent.

### 1. Analyst (schema v2.0)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NEED_MORE_INFO` |
| effort | string | ✅ | `Small`, `Medium`, hoặc `Large` — dựa trên scope phân tích |
| summary | string | ✅ | Tóm tắt phân tích (3-5 dòng) |
| details | string | ✅ | Phân tích chi tiết |
| scanned_paths | string[] | ✅ | Đường dẫn đã quét |
| ignored_paths | object[] | ✅ | Đường dẫn bỏ qua + lý do: `[{path, reason}]` |
| discovered_modules | string[] | ✅ | Module/package con phát hiện |
| structure | object | ✅ | Cấu trúc dự án: `{root, language, framework, entry_points[{path, type}], main_directories[{path, description, relevance}]}` |
| requirements | object[] | ✅ | Yêu cầu: `[{id, description, priority}]` |
| risks | object[] | ✅ | Rủi ro: `[{id, description, severity, mitigation}]` |
| assumptions | object[] | ✅ | Giả định: `[{id, description}]` |
| dependencies | object[] | ✅ | Phụ thuộc có bằng chứng: `[{from, to, type, evidence_file, evidence_line, reason}]` |
| patterns | object | ✅ | Patterns: `{naming: {pattern, location, notes}, routing: {...}, state_management: {...}, testing: {framework, locations}}` |
| impact_scope | object[] | ✅ | File bị ảnh hưởng: `[{file, level: DIRECT/INDIRECT/UNRELATED, notes}]` |
| design_proposal | object | ❌ | Đề xuất thiết kế: `{approach, affected_modules, new_files, modified_files, integration_points}` |
| tasks | object[] | ✅ | Task con: `[{id, description, files, depends_on, why}]` |
| conclusion | object | ✅ | Kết luận: `{status, reason, missing_info[]}` |

**Output mẫu (v2.0):**
```yaml
status: READY
summary: "Phân tích yêu cầu, xác định 5 file cần sửa"
effort: Medium
details: "Phân tích chi tiết..."
scanned_paths:
  - "src/"
  - "tests/"
ignored_paths:
  - path: "node_modules/"
    reason: "Thư mục dependencies"
discovered_modules:
  - "Core"
  - "Services"
structure:
  root: "JapaneseLearner"
  language: "C#"
  framework: "Blazor WebAssembly"
  entry_points:
    - path: "JapaneseLearner/Program.cs"
      type: "app"
    - path: "JapaneseLearner.Tests/BunitTestBase.cs"
      type: "test"
  main_directories:
    - path: "src/"
      description: "Mã nguồn chính"
      relevance: "HIGH"
requirements:
  - id: "REQ-001"
    description: "Thêm validation email"
    priority: "HIGH"
risks:
  - id: "RISK-001"
    description: "Xung đột với validation hiện tại"
    severity: MEDIUM
    mitigation: "Kiểm tra codebase trước khi sửa"
assumptions:
  - id: "ASM-001"
    description: "Dùng Regex email tiêu chuẩn"
dependencies:
  - from: "AuthService"
    to: "IEmailValidator"
    type: "service"
    evidence_file: "src/Services/AuthService.cs"
    evidence_line: 42
    reason: "AuthService inject IEmailValidator qua constructor"
patterns:
  naming:
    pattern: "PascalCase"
    location: "src/Models/"
    notes: "Tất cả model class dùng PascalCase"
  routing:
    pattern: "FluentUI Router via @page"
    location: "src/Pages/"
    notes: ".razor files with @page directive"
  state_management:
    pattern: "DI Service + Blazored.LocalStorage"
    location: "src/Services/"
    notes: "Cache-first, localStorage persistence"
  testing:
    framework: "xUnit + bUnit"
    locations: ["JapaneseLearner.Tests/", "JapaneseLearner.E2ETests/"]
impact_scope:
  - file: "src/Services/AuthService.cs"
    level: "DIRECT"
    notes: "Cần inject IEmailValidator mới"
  - file: "src/Pages/Login.razor"
    level: "INDIRECT"
    notes: "UI form gọi AuthService"
design_proposal:
  approach: "Thêm service layer mới"
  affected_modules: ["Auth", "UI"]
  new_files: ["src/Validators/EmailValidator.cs"]
  modified_files: ["src/Services/AuthService.cs"]
  integration_points: ["DI Container trong Program.cs"]
tasks:
  - id: "TASK-001"
    description: "Tạo IEmailValidator interface"
    files: ["src/Validators/IEmailValidator.cs"]
    depends_on: []
    why: "Interface cần được định nghĩa trước khi implement"
conclusion:
  status: "READY"
  reason: "Đã xác định đầy đủ phạm vi, dependencies và impact"
  missing_info: []
```

### 2. Planner — Design Phase (v3.2)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NEEDS_MORE_INFO` |
| effort | string | ✅ | `Small`, `Medium`, hoặc `Large` — quyết định plan strategy (xem Effort Rules) |
| design | object | ✅ | Thiết kế: architecture, components, data_flow, security, edge_cases |
| blocking_issues | object[] | ❌ | Vấn đề phải giải quyết mới đi tiếp: `[{id, severity, category, description, suggestion}]` |
| non_blocking_issues | object[] | ❌ | Vấn đề có thể đi tiếp, sửa sau: `[{id, severity, category, description, suggestion}]` |
| open_questions | object[] | ❌ | Câu hỏi cần user trả lời: `[{id, description, suggestion}]` |

**Effort Rules (v3.2):**
| Effort | Strategy | Mô tả |
|--------|----------|-------|
| `Small` | 1 plan duy nhất, không chunk | 1-2 files, 1-4 steps |
| `Medium` | Chia 2 chunks (config+logic, UI+test) | 3-5 files, 5-10 steps |
| `Large` | Tách phase phụ hoặc nhiều plan riêng | >5 files, >10 steps |

**Output mẫu (Design) — v3.2:**
```yaml
status: READY
summary: "Thiết kế giải pháp với EmailValidator service"
blocking_issues: []
non_blocking_issues:
  - id: "#01"
    severity: MINOR
    category: CONSISTENCY
    description: "Cần đồng bộ IEmailValidator interface"
    suggestion: "Thêm interface trước khi implement"
open_questions:
  - id: "#Q01"
    description: "Có cần support Unicode email không?"
    suggestion: "Nếu có, thêm normalization step"
next_action: "Chuyển sang Plan phase"
artifacts: ["02_design.md"]
effort: Medium
design:
  architecture: "Thêm service layer mới"
  components:
    - name: "EmailValidator"
      path: "src/validators.ts"
      action: "CREATE"
  data_flow: "Input → Validate → Save"
  security_concerns:
    - description: "SQL injection qua email"
      severity: HIGH
      mitigation: "Parameterized queries"
  edge_cases:
    - description: "Email rỗng"
      handling: "Return false, log warning"
    - description: "Email Unicode"
      handling: "Normalize trước khi validate"
```

### 3. Planner — Plan Phase (v3.2 — SIẾT CHẶT)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NEEDS_MORE_INFO` |
| steps | object[] | ✅ | Các bước thực thi (xem Step Schema bên dưới) |
| per_step_validation | object[] | ❌ | Validate ngay sau mỗi step: `[{step, command, expected}]` |
| per_chunk_validate | object[] | ❌ | Validate sau mỗi chunk: `[{chunk, command, expected}]` — **MỚI v3.2** |
| final_validation | object[] | ❌ | Validate cuối sau tất cả steps: `[{command, expected}]` |
| rollback_strategy | object | ✅ | Chiến lược rollback (xem Rollback Strategy) |
| validate | string[] | ✅ | (Giữ lại cho backward compatibility) |
| blocking_issues | object[] | ❌ | Vấn đề phải giải quyết mới đi tiếp: `[{id, severity, category, description, suggestion}]` |
| non_blocking_issues | object[] | ❌ | Vấn đề có thể đi tiếp, sửa sau: `[{id, severity, category, description, suggestion}]` |
| open_questions | object[] | ❌ | Câu hỏi cần user trả lời: `[{id, description, suggestion}]` |

**Step Schema (v3.2) — tất cả fields:**
| Step field | Type | Bắt buộc | Mô tả |
|------------|------|----------|-------|
| order | int | ✅ | Thứ tự thực thi |
| description | string | ✅ | Mô tả bước |
| action | string | ✅ | `CREATE` / `MODIFY` / `DELETE` — **rõ ràng, không để Builder tự suy diễn** |
| file | string | ✅ | Đường dẫn file |
| logic | string | ✅ | Logic cần implement chi tiết |
| expected_result | string | ✅ **(REQUIRED v3.2)** | Kết quả mong đợi sau bước này — Builder dùng để verify |
| check | string | ✅ | Cách kiểm tra (per_step_validation) |
| chunk | int | ❌ | Nhóm thực thi (1-4), mặc định 1. Xem Chunk Rules |
| requires_backup | bool | ✅ | `true` nếu action = MODIFY/DELETE file cũ; `false` nếu CREATE |
| depends_on | int[] | ❌ | Các step phải chạy trước step này (mảng order) |
| validation_command | string | ✅ | Lệnh validate cụ thể cho step này (vd: `dotnet build`, `npm run lint`) |
| risk_level | string | ❌ | `LOW` / `MEDIUM` / `HIGH` — **MỚI v3.2**. Nếu HIGH, phải có rollback step |

**Chunk Rules (v3.2):**
| Chunk | Nội dung | Ví dụ |
|-------|----------|-------|
| 1 | Config/schema/dependencies | Model, interface, DI registration, config files |
| 2 | Core logic/services | Business logic, service implementation, algorithms |
| 3 | UI/API surface | Pages, components, endpoints, handlers |
| 4 | Tests + validation | Unit tests, integration tests, validation scripts |

**Rollback Strategy (v3.2):**
| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| enabled | bool | ✅ | `true` nếu có MODIFY/DELETE steps |
| trigger_conditions | object[] | ❌ | `[{type, description, threshold?}]` — **MỚI v3.2** |
| restore_order | object[] | ❌ | `[{step, action, file}]` — thứ tự restore **MỚI v3.2** |
| requires_user_confirmation | bool | ❌ | `true` nếu cần user confirm trước khi rollback **MỚI v3.2** |
| conditions | string[] | ❌ | (Giữ lại cho backward compatibility) |
| steps | string[] | ❌ | (Giữ lại cho backward compatibility) |

**Output mẫu (Plan) — v3.2:**
```yaml
status: READY
summary: "Kế hoạch 3 bước: config → logic → test"
blocking_issues: []
non_blocking_issues: []
open_questions: []
next_action: "Chuyển sang Review phase"
artifacts: ["03_plan.md"]
steps:
  - order: 1
    description: "Thêm validation logic cho email"
    action: MODIFY
    file: "src/validators.ts"
    logic: "Thêm hàm validateEmail() vào cuối file"
    expected_result: "File validators.ts có hàm validateEmail() — build pass"
    check: "npm run lint"
    chunk: 1
    requires_backup: true
    depends_on: []
    validation_command: "npm run lint"
    risk_level: MEDIUM
  - order: 2
    description: "Thêm unit test cho validateEmail"
    action: CREATE
    file: "tests/validators.test.ts"
    logic: "Tạo file test mới với 3 test cases"
    expected_result: "File tests/validators.test.ts tồn tại — test pass"
    check: "npm run lint"
    chunk: 4
    requires_backup: false
    depends_on: [1]
    validation_command: "npm run lint"
    risk_level: LOW
  - order: 3
    description: "Đăng ký service trong DI container"
    action: MODIFY
    file: "src/Program.cs"
    logic: "Thêm services.AddScoped<IEmailValidator, EmailValidator>()"
    expected_result: "Program.cs có DI registration — build pass"
    check: "dotnet build"
    chunk: 1
    requires_backup: true
    depends_on: [1]
    validation_command: "dotnet build"
    risk_level: HIGH
per_step_validation:
  - step: 1
    command: "npm run lint"
    expected: "Lint PASS"
  - step: 2
    command: "npm run test"
    expected: "Test PASS"
  - step: 3
    command: "dotnet build"
    expected: "Build PASS"
per_chunk_validate:
  - chunk: 1
    command: "dotnet build"
    expected: "Build PASS — chunk 1 hoàn tất"
  - chunk: 4
    command: "dotnet test"
    expected: "Test PASS — chunk 4 hoàn tất"
final_validation:
  - command: "dotnet build"
    expected: "Build thành công"
  - command: "dotnet test"
    expected: "Test PASS"
rollback_strategy:
  enabled: true
  trigger_conditions:
    - type: "catastrophic_failure"
      description: "Lỗi không recover được"
    - type: "max_retry_reached"
      description: "Retry > 3 lần"
      threshold: 3
    - type: "user_request"
      description: "User yêu cầu dừng"
  restore_order:
    - step: 3
      action: "restore"
      file: "src/Program.cs"
    - step: 1
      action: "restore"
      file: "src/validators.ts"
    - step: 2
      action: "delete"
      file: "tests/validators.test.ts"
  requires_user_confirmation: true
  conditions:                                    # backward compatibility
    - "catastrophic failure"
    - "max retry reached"
    - "user request"
  steps:                                         # backward compatibility
    - "Bước 1: restore src/validators.ts từ backup"
    - "Bước 2: xóa tests/validators.test.ts nếu tồn tại"
validate:
  - "Chạy dotnet build"
  - "Chạy unit tests"
```

### 4. Reviewer (NÂNG CẤP — v4.0: decision thresholds, score_rationale, blocking, consistency, missing_info, scoring scale, edge cases, recommendation)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| decision | string | ✅ | `APPROVED`, `CHANGES_REQUESTED`, hoặc `REJECTED` — xem Decision Thresholds |
| scores | object | ✅ | `{completeness, accuracy, safety, efficiency, testability, overall}` (0-10) — xem Scoring Scale |
| score_rationale | object | ❌ | Giải thích cho từng score nếu **dưới 7**: `{completeness: "...", accuracy: "...", safety: "...", efficiency: "...", testability: "..."}` |
| issues | object[] | ✅ | Danh sách vấn đề (xem Issue Schema mở rộng bên dưới) |
| consistency_checks | object | ❌ | Kiểm tra tính nhất quán: `{contract_match: bool, file_path_match: bool, dependency_valid: bool}` |
| missing_info | string[] | ❌ | Thông tin còn thiếu khi `decision = CHANGES_REQUESTED` |
| required_updates | string[] | ❌ | Các cập nhật bắt buộc — Planner sửa đúng chỗ, không suy luận |
| edge_cases_checked | string[] | ❌ | Các edge case đã kiểm tra |
| not_covered_risks | string[] | ❌ | Rủi ro chưa được xử lý |
| recommendation | string | ❌ | `APPROVE` / `REVISE_PLAN` / `REWORK_DESIGN` / `REJECT` — hành động cụ thể |
| next_step | string | ❌ | Bước tiếp theo cho Orchestrator (vd: "Quay lại Plan phase sửa file path") |

**Thang điểm chuẩn (Scoring Scale):**

| Điểm | Mức | Ý nghĩa |
|------|-----|---------|
| `10` | Hoàn hảo | Không thiếu sót, không cần cải thiện |
| `8-9` | Tốt | Chỉ thiếu rất nhỏ, có thể APPROVED ngay |
| `5-7` | Trung bình | Có vấn đề đáng kể, cần CHANGES_REQUESTED |
| `<5` | Kém | Sai nghiêm trọng, có thể REJECTED |

**Ngưỡng quyết định (Decision Thresholds):**

| Decision | Điều kiện | Hành động |
|----------|-----------|-----------|
| `APPROVED` | `overall >= 8.5` **và không có** issue `CRITICAL` | Chuyển sang bước kế tiếp |
| `CHANGES_REQUESTED` | Có vấn đề sửa được (overall < 8.5 hoặc có CRITICAL nhưng không fatal) | Quay lại Plan/Design, kèm `required_updates` |
| `REJECTED` | Sai hướng, thiếu nền tảng, hoặc không thể thực thi | Dừng workflow, báo user |

**Issue Schema (mở rộng — v4.0):**

| Issue Field | Type | Required | Mô tả |
|-------------|------|----------|-------|
| id | string | ✅ | Mã định danh (vd: `#01`) |
| severity | string | ✅ | `CRITICAL` / `MAJOR` / `MINOR` — dùng [Error Priority](#error-priority--action-map) |
| category | string | ✅ | `CONSISTENCY` / `DESIGN` / `SECURITY` / `PERFORMANCE` / `LOGIC` / `STYLE` |
| blocking | bool | ✅ | `true` = chặn duyệt / `false` = chỉ cần cải thiện nhẹ |
| fix_priority | int | ❌ | 1 (gấp) → 5 (có thể làm sau) |
| affected_phase | string | ❌ | `DESIGN` / `PLAN` / `BUILD` / `REVIEW` — phase cần sửa |
| description | string | ✅ | Mô tả vấn đề |
| suggestion | string | ✅ | Đề xuất giải pháp cụ thể |

**Output mẫu (v4.0):**
```yaml
status: READY
summary: "Kế hoạch cần bổ sung security validation + đồng bộ file path"
next_action: "Quay lại Plan phase để sửa"
artifacts: ["04_review.md"]
decision: CHANGES_REQUESTED
scores:
  completeness: 7
  accuracy: 8
  safety: 5
  efficiency: 7
  testability: 6
  overall: 6.6
score_rationale:
  safety: "Thiếu bước mã hóa dữ liệu nhạy cảm, không có rate limiting"
  testability: "Không có test case cho edge case null/empty input"
consistency_checks:
  contract_match: true
  file_path_match: false
  dependency_valid: true
issues:
  - id: "#01"
    severity: CRITICAL
    category: CONSISTENCY
    blocking: true
    fix_priority: 1
    affected_phase: "PLAN"
    description: "File path không khớp giữa Design và Plan: Design ghi `src/validators.ts` nhưng Plan dùng `src/utils/validators.ts`"
    suggestion: "Đồng bộ path: dùng `src/validators.ts` hoặc cập nhật Design component path"
  - id: "#02"
    severity: MAJOR
    category: SECURITY
    blocking: true
    fix_priority: 1
    affected_phase: "PLAN"
    description: "Thiếu bước mã hóa dữ liệu nhạy cảm trong luồng xử lý"
    suggestion: "Thêm step encrypt/decrypt trong data flow"
missing_info:
  - "Chưa rõ cơ chế rate limiting cho API endpoint"
  - "Thiếu thông tin về input validation format"
required_updates:
  - "Sửa file path trong Plan step 1 từ `src/utils/validators.ts` thành `src/validators.ts`"
  - "Thêm step mã hóa dữ liệu nhạy cảm"
edge_cases_checked:
  - "Email rỗng / null → Không được xử lý trong Plan hiện tại"
  - "Unicode email → Không có normalization step"
  - "Concurrent request → Chưa có locking mechanism"
not_covered_risks:
  - "SQL injection qua email input — chưa có parameterized query"
  - "ReDoS attack qua regex validation — không có timeout"
recommendation: "REVISE_PLAN"
next_step: "Quay lại Plan phase, sửa file path + thêm security steps. Reviewer chờ bản sửa."
```

### 5. Builder (NÂNG CẤP)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `PASS` hoặc `FAIL` |
| overall | string | ✅ | `PASS` / `FAIL` (đồng bộ với status) |
| backup_workflow_id | string | ❌ | Workflow ID từ backup, có nếu có backup |
| changed_files | string[] | ❌ | Danh sách file đã thay đổi (MODIFY) |
| created_files | string[] | ❌ | Danh sách file đã tạo mới |
| deleted_files | string[] | ❌ | Danh sách file đã xóa |
| steps | object[] | ✅ | `[{order, status, file, action, requires_backup, validation_command, per_step_validation, error, error_type, error_normalized, error_hash, retryable}]` |
| failure_type | string | ❌ | `MINOR` (syntax/lint) hoặc `CRITICAL` (logic, backup fail) — dùng [Error Priority](#error-priority--action-map) |
| validation_status | string | ❌ | `PASS` / `FAIL` — kết quả final_validation |
| details | string | ❌ | Chi tiết lỗi — chỉ khi FAIL |

**Error fields chi tiết trong step:**
| Error field | Type | Mô tả |
|-------------|------|-------|
| error | string | Raw error message gốc |
| error_type | string | Phân loại: `SyntaxError`, `BuildFailed`, `FileNotFound`, `NullReferenceException`, `BackupFailed`, `ValidationFailed`, ... |
| error_normalized | string | Error đã normalize (loại bỏ line number, timestamp, stack trace) |
| error_hash | string | SHA256(error_normalized) lấy 12 ký tự đầu |
| retryable | bool | Có thể retry step này không? (`false` nếu file không tồn tại, backup fail) |

**Output mẫu mới (v3.1 — contract chuẩn hóa):**
```yaml
status: PASS
overall: "PASS"
backup_workflow_id: "WF-20260726-001"
changed_files:
  - "src/validators.ts"
created_files: []
deleted_files: []
summary: "Build successful — 2/2 steps PASS"
issues: []
next_action: "Chuyển sang Static Analysis"
artifacts: ["07_build.md"]
steps:
  - order: 1
    status: PASS
    file: "src/validators.ts"
    action: MODIFY
    requires_backup: true
    validation_command: "npm run lint"
    per_step_validation:
      command: "npm run lint"
      result: "PASS"
    depends_on: []
    error: null
    error_type: null
    error_normalized: null
    error_hash: null
    retryable: false
  - order: 2
    status: FAIL
    file: "src/handler.ts"
    action: MODIFY
    requires_backup: true
    validation_command: "npm run lint"
    per_step_validation:
      command: "npm run lint"
      result: "FAIL"
    depends_on: [1]
    error: "SyntaxError: Unexpected token (42:12)"
    error_type: "SyntaxError"
    error_normalized: "syntaxerror: unexpected token"
    error_hash: "a1b2c3d4e5f6"
    retryable: true
failure_type: "MINOR"
validation_status: "FAIL"
details: "Step 2 FAIL do lỗi syntax — đã sửa và retry"
```

### 6. Test-Planner (v2.0 — NÂNG CẤP)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `INCOMPLETE` hoặc `NEEDS_MORE_INFO` |
| impact_analysis | object | ✅ | Impact analysis: `{modified_files[], dependencies[], public_api_changed[], ui_changed, database_changed, config_changed, breaking_changes, affects[], does_not_affect[]}` |
| requirements | object[] | ✅ | `[{id, description}]` — danh sách yêu cầu |
| existing | object | ✅ | `{framework, files[], already_cover[], missing[], duplicated[]}` — phân tích test hiện tại |
| risk_assessment | object | ✅ | `{risk_level, reason, coverage_target}` — risk-based testing |
| testability | object | ✅ | `{status: GOOD/WARNING/BAD, issues[], recommendations[]}` |
| coverage_matrix | object[] | ✅ | `[{requirement, test_cases[]}]` — mapping requirement → test case |
| test_cases | object[] | ✅ | `[{id, type, description, input, expected, file, priority, risk_level, coverage}]` |
| regression_scope | object | ✅ | `{direct[], indirect[], unaffected[], regression_cases[]}` — scope chi tiết |
| coverage_target | object | ✅ | `{unit, integration, e2e, overall}` — theo risk level |
| validation | object | ✅ | `{checklist[], all_pass}` — 12-item validation checklist |
| framework | string | ✅ | Framework test hiện tại |

**Output mẫu mới (v2.0):**
```yaml
status: READY
summary: "5 test cases: 2 unit, 2 edge, 1 integration — all validation PASS"
issues: []
next_action: "Thực thi test plan"
artifacts: ["10_test_plan.md"]
impact_analysis:
  modified_files:
    - "src/Services/UserService.cs"
  dependencies:
    - "IUserRepository"
  public_api_changed:
    - "UserService.Login()"
  ui_changed: true
  database_changed: false
  config_changed: false
  breaking_changes: false
  affects:
    - business_logic
    - api
  does_not_affect:
    - authentication
    - payment
requirements:
  - id: REQ-001
    description: "Login by email"
  - id: REQ-002
    description: "Validate password length"
existing:
  framework: "xUnit + bUnit"
  files:
    - "UserServiceTests.cs"
  already_cover:
    - "create user"
  missing:
    - "delete user"
  duplicated: []
risk_assessment:
  risk_level: "high"
  reason: "Authentication feature — ảnh hưởng bảo mật"
  coverage_target:
    unit: 90
    integration: 80
testability:
  status: GOOD
  issues: []
  recommendations: []
coverage_matrix:
  - requirement: REQ-001
    test_cases:
      - TC-001
      - TC-005
  - requirement: REQ-002
    test_cases:
      - TC-002
      - TC-003
test_cases:
  - id: TC-001
    type: UNIT
    description: "Username validation — positive case"
    input: "user@example.com"
    expected: "true"
    file: "tests/UserServiceTests.cs"
    priority: P0
    risk_level: high
    coverage:
      requirement: [REQ-001, REQ-002]
      component: "UserService"
  - id: TC-002
    type: UNIT
    description: "Username validation — empty input"
    input: ""
    expected: "false"
    file: "tests/UserServiceTests.cs"
    priority: P0
    risk_level: high
    coverage:
      requirement: [REQ-002]
      component: "UserService"
regression_scope:
  direct:
    - "UserService"
  indirect:
    - "LoginController"
  unaffected:
    - "PaymentModule"
  regression_cases:
    - TC-R001
    - TC-R002
coverage_target:
  unit: 90
  integration: 80
  e2e: 50
  overall: 85
validation:
  checklist:
    - item: "All requirements covered?"
      status: PASS
    - item: "Regression exists?"
      status: PASS
    - item: "Positive test exists?"
      status: PASS
    - item: "Negative test exists?"
      status: PASS
    - item: "Boundary test exists?"
      status: PASS
    - item: "Edge cases exist?"
      status: PASS
    - item: "Duplicate testcases?"
      status: PASS
    - item: "Existing tests reused?"
      status: PASS
    - item: "Coverage target satisfied?"
      status: PASS
    - item: "Risk level assigned?"
      status: PASS
    - item: "Test file path valid?"
      status: PASS
    - item: "Framework detected?"
      status: PASS
  all_pass: true
```

### 7. Tester

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `APPROVED` hoặc `NEEDS_FIX` |
| coverage | object | ✅ | `{unit: %, integration: %, e2e: %, overall: %, thresholds_met: bool}` |
| results | object[] | ✅ | `[{id, status, error, duration}]` với status: PASS/FAIL/SKIP |

Cách tính `overall`: `(unit_pass + integration_pass) / (unit_total + integration_total) × 100`

**Output mẫu:**
```yaml
status: APPROVED
summary: "6/6 PASS, coverage đạt threshold"
issues:
  - severity: MINOR
    category: PERFORMANCE
    description: "Test TC-003 chậm (2.1s)"
    suggestion: "Cân nhắc mock database"
next_action: "Chuyển sang Skill Validation"
artifacts: ["10_test.md"]
coverage:
  unit: 85
  integration: 70
  e2e: 55
  overall: 80.5
  thresholds_met: true
results:
  - id: "TC-001"
    status: PASS
    duration: "1.2s"
  - id: "TC-002"
    status: PASS
    duration: "0.8s"
```

### 8. Self-Improver

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NO_SUGGESTIONS` |
| suggestions | object[] | ✅ | `[{category, content, evidence, impact, requires_approval}]` |
| summary | string | ✅ | Tổng kết |

- `impact`: `LOW` | `MEDIUM` | `HIGH` — dùng [Error Priority](#error-priority--action-map)
- `requires_approval`: `true` | `false` (auto-approve if false + impact == LOW)

**Output mẫu:**
```yaml
status: READY
summary: "2 suggestions, 1 cần approval"
issues: []
next_action: "Chờ user approval"
artifacts: ["11_skill_validation.md"]
suggestions:
  - category: coding_pattern
    content: "Dùng FluentValidation thay vì if-else"
    evidence: "3 lần retry do validation lỗi"
    impact: MEDIUM
    requires_approval: true
  - category: workflow_improvement
    content: "Thêm step lint tự động"
    evidence: "Phát hiện 5 lỗi syntax trong build"
    impact: LOW
    requires_approval: false
```

---

### 9. Failure Agent (Failure Learning System — Module A)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NOT_FOUND` |
| summary | string | ✅ | Tóm tắt phân tích lỗi |
| input | object | ✅ | `{raw_error, context}` |
| analysis | object | ✅ | `{error_normalized, error_type, error_hash, retryable}` |
| memory_search | object | ✅ | `{found: bool, records[], confidence}` |
| suggestions | object[] | ✅ | Hành động đề xuất: `[{action, reason}]` |

**Output mẫu:**
```yaml
status: READY
summary: "Phân tích lỗi: NullReferenceException — object reference not set"
input:
  raw_error: "System.NullReferenceException: Object reference at MyClass.cs:42"
  context: "Bước 7 - Build"
analysis:
  error_normalized: "system.nullreferenceexception: object reference"
  error_type: "NullReferenceException"
  error_hash: "a1b2c3d4e5f6"
  retryable: true
memory_search:
  found: true
  records:
    - failure_id: "BUG-0001"
      similarity: 0.95
      lesson_id: "LSN-BLZ-001"
  confidence: HIGH
suggestions:
  - action: "consult_root_cause"
    reason: "Retryable error with known pattern"
```

### 10. Root Cause Agent (Failure Learning System — Module B)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `INCONCLUSIVE` |
| summary | string | ✅ | Tóm tắt: `{n} hypotheses generated` |
| input | object | ✅ | `{error_hash, error_type, context}` |
| hypotheses | object[] | ✅ | `[{id, description, mechanism, confidence, evidence[], fix_suggestion}]` |
| conclusion | object | ✅ | `{most_likely, rationale}` |

**Output mẫu:**
```yaml
status: READY
summary: "Root cause analysis: 2 hypotheses generated"
input:
  error_hash: "a1b2c3d4e5f6"
  error_type: "NullReferenceException"
  context: "Build step 2"
hypotheses:
  - id: "H-001"
    description: "Null reference từ service chưa được inject"
    mechanism: "ServiceA gọi ServiceB.Method() nhưng ServiceB chưa được đăng ký DI"
    confidence: 0.85
    evidence:
      - file: "src/Program.cs"
        line: 25
        snippet: "Thiếu AddScoped<IServiceB, ServiceB>()"
    fix_suggestion: "Thêm builder.Services.AddScoped<IServiceB, ServiceB>()"
  - id: "H-002"
    description: "Null check bị thiếu"
    confidence: 0.45
    evidence: []
    fix_suggestion: ""
conclusion:
  most_likely: "H-001"
  rationale: "ServiceB.Method() được gọi mà không có null check + DI registration thiếu"
```

---

### 11. Learning Agent (Learning Pipeline — Module C)

**Schema:** (extends [Base Schema](#base-agent-schema))

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY`, `NO_CHANGES`, hoặc `FAIL` |
| summary | string | ✅ | Tóm tắt kết quả: lessons/patterns created |
| scan | object | ✅ | `{total_failures, processed, skipped, skip_reasons[]}` |
| created | object | ✅ | `{lessons[{id, path, failure_id, summary}], patterns[{id, path, related_failures[], summary}]}` |
| updated | object[] | ❌ | `[{file, changes[]}]` — failure records đã cập nhật |
| suggestions | object[] | ❌ | Đề xuất: `[{action, content, impact, requires_approval}]` |

**Output mẫu:**
```yaml
status: READY
summary: "Đã tạo 1 lesson, 1 pattern mới"
scan:
  total_failures: 5
  processed: 1
  skipped: 4
  skip_reasons:
    - "BUG-0001: đã có lesson"
    - "BUG-0002: resolved_at missing"
created:
  lessons:
    - id: "LSN-BLZ-001"
      path: ".opencode/memory/lessons/blazor/LSN-BLZ-001.md"
      failure_id: "BUG-0004"
      summary: "Luôn kiểm tra DI registration trước khi gọi service"
  patterns:
    - id: "PAT-001"
      path: ".opencode/memory/patterns/PAT-001.md"
      related_failures: ["BUG-0004", "BUG-0005"]
      summary: "NullReferenceException do thiếu DI registration"
updated:
  - file: ".opencode/memory/failures/BUG-0004.md"
    changes: ["lesson: LSN-BLZ-001", "pattern: PAT-001", "reusable: true"]
suggestions:
  - action: "update_knowledge_base"
    content: "pattern về DI registration nên được thêm vào knowledge base"
    impact: MEDIUM
    requires_approval: true
```

---

## QUY TRÌNH CHI TIẾT

### Bước 1: Analyze
**Agent:** `analyst`

**Prompt:**
```
Bạn là Analyst Agent. Phân tích yêu cầu sau, đọc codebase, xác định phạm vi, rủi ro, task con.

Yêu cầu: {user_request}

Hãy dùng glob/grep/read để hiểu cấu trúc dự án.
Output: Contract YAML theo schema Analyst.
```

**Sau output:**
- `status: NEED_MORE_INFO` → Hỏi người dùng, set `user_intervention: true`
- `status: READY` → Lưu `current_data.analysis = output`, tăng `step = 2`, ghi artifact `01_analysis.md`

**Edge case:** Output quá ngắn (< 100 từ) → yêu cầu phân tích lại.

---

### Bước 2: Design
**Agent:** `planner` (**Design Phase** — không có agent Design riêng)

**Prompt:**
```
Bạn là Planner Agent (Design Phase). Dựa trên báo cáo phân tích, thiết kế giải pháp chi tiết.

## INPUT VALIDATION (AUTOMATIC)
Parse $ARGUMENTS:
- Nếu có `requirements[]` → Design Phase (hợp lệ)
- Nếu không có → `status: NEEDS_MORE_INFO`, missing_info: ["Cần analysis report (có requirements[]) để thực hiện Design"]

Báo cáo:
{current_data.analysis}

Yêu cầu Design (v3.2):
1. Architecture: Mô tả kiến trúc tổng thể
2. Components: Liệt kê component cần tạo/sửa (kèm đường dẫn, action: CREATE/MODIFY/DELETE)
3. Data flow: Luồng dữ liệu giữa các component (Input → Xử lý → Output)
4. Security concerns: Các rủi ro bảo mật (kèm severity, mitigation)
5. Edge cases: Các trường hợp đặc biệt (kèm handling)
6. Issues: Phân loại blocking_issues, non_blocking_issues, open_questions
7. Effort: Xác định Small/Medium/Large — dùng để quyết định Plan strategy

Output: Contract YAML v3.2 theo schema Planner — Design Phase.
artifacts: ["02_design.md"] (bắt buộc)
```

**Sau output:** Lưu `current_data.design = output`, tăng `step = 3`, ghi artifact `02_design.md`

---

### Bước 3: Plan
**Agent:** `planner` (**Plan Phase** — cùng agent, khác phase)

**Prompt:**
```
Bạn là Planner Agent (Plan Phase). Dựa trên thiết kế, lập kế hoạch thực thi chi tiết từng bước.

## INPUT VALIDATION (AUTOMATIC)
Parse $ARGUMENTS:
- Nếu có `design.components[]` → Plan Phase (hợp lệ)
- Nếu không có → `status: NEEDS_MORE_INFO`, missing_info: ["Cần design output (có design.components[]) để thực hiện Plan"]

Thiết kế:
{current_data.design}

Yêu cầu (BẮT BUỘC — v3.2):
1. Mỗi bước phải có đủ:
   - `action`: CREATE / MODIFY / DELETE (rõ ràng, không để Builder tự suy diễn)
   - `file`: Đường dẫn file
   - `logic`: Logic chi tiết
   - `expected_result`: Kết quả mong đợi (REQUIRED — Builder dùng để verify)
   - `check`: Cách kiểm tra (per_step_validation)
   - `chunk`: 1-4 (theo Chunk Rules: 1=config, 2=logic, 3=UI, 4=test)
   - `requires_backup`: true (MODIFY/DELETE) / false (CREATE)
   - `depends_on`: [] (dependency giữa các step)
   - `risk_level`: LOW/MEDIUM/HIGH (HIGH → phải có rollback step)
2. Chunk Rules v3.2:
   - Chunk 1 = Config/schema/dependencies
   - Chunk 2 = Core logic/services
   - Chunk 3 = UI/API surface
   - Chunk 4 = Tests + validation
3. Thứ tự: config → logic → test
4. **Quy tắc file không tồn tại:**
   - Nếu `action: MODIFY` → file PHẢI tồn tại trong codebase
   - Nếu `action: CREATE` → file chưa tồn tại (sẽ tạo mới)
   - Không được ghi MODIFY cho file chưa tồn tại
5. **Tách validate theo giai đoạn (v3.2):**
   - `per_step_validation`: Kiểm tra ngay sau mỗi step (lint, syntax check)
   - `per_chunk_validate`: Kiểm tra sau mỗi chunk (khuyến nghị)
   - `final_validation`: Kiểm tra tổng thể sau tất cả steps (dotnet build, test)
6. Rollback strategy mở rộng (v3.2):
   - `trigger_conditions[]`: Điều kiện kích hoạt (catastrophic_failure, max_retry_reached, user_request)
   - `restore_order[]`: Thứ tự restore các file
   - `requires_user_confirmation`: Cần user confirm trước rollback?
7. Effort-based strategy:
   - Small → 1 plan, không chunk
   - Medium → chia 2 chunks
   - Large → tách phase phụ hoặc nhiều plan
8. Issues: Phân loại blocking_issues, non_blocking_issues, open_questions

Output: Contract YAML v3.2 theo schema Planner — Plan Phase.
artifacts: ["03_plan.md"] (bắt buộc)
```

**Sau output:** Lưu `current_data.plan = output`, tăng `step = 4`, ghi artifact `03_plan.md`

**Kiểm tra:** Kế hoạch phải có ít nhất 1 bước — nếu không → yêu cầu làm lại.

---

### Bước 4: Review (NÂNG CẤP — v4.0)
**Agent:** `reviewer`

**Prompt:**
```
Bạn là Reviewer Agent (v4.0). Đánh giá kế hoạch sau một cách nghiêm túc.

## INPUT
Thiết kế:
{current_data.design}

Kế hoạch:
{current_data.plan}

## TIÊU CHÍ ĐÁNH GIÁ

| # | Tiêu chí | Trọng số | Câu hỏi cần trả lời |
|---|----------|----------|---------------------|
| 1 | **Đầy đủ (Completeness)** | 20% | Có bao quát toàn bộ yêu cầu? Thiếu task/file/edge case nào? |
| 2 | **Chính xác (Accuracy)** | 20% | Logic đúng? Tên file, đường dẫn chính xác? |
| 3 | **An toàn (Safety/Security)** | 20% | Có rủi ro bảo mật? Có bước backup? Có rollback? |
| 4 | **Hiệu quả (Efficiency)** | 15% | Có cách tối ưu hơn? Over-engineering? |
| 5 | **Kiểm thử (Testability)** | 15% | Có bước verify/validate? Có test cho edge cases? |
| 6 | **Edge cases** | 10% | Xử lý null/empty/timeout/concurrent? |

## THANG ĐIỂM CHUẨN
- `10`: Hoàn hảo, không thiếu sót
- `8-9`: Tốt, chỉ thiếu rất nhỏ
- `5-7`: Có vấn đề đáng kể, cần sửa
- `<5`: Sai nghiêm trọng

## NGƯỠNG QUYẾT ĐỊNH
- `APPROVED`: overall >= 8.5 và KHÔNG có issue CRITICAL
- `CHANGES_REQUESTED`: có vấn đề sửa được
- `REJECTED`: sai hướng, thiếu nền tảng, không thể thực thi

## KIỂM TRA TÍNH NHẤT QUÁN
Kiểm tra các mục sau và ghi vào `consistency_checks`:
1. **contract_match**: Input/output contract giữa Design và Plan có khớp không?
2. **file_path_match**: File/path có nhất quán giữa Design.components và Plan.steps không?
3. **dependency_valid**: Dependencies giữa các step có hợp lý không?

## YÊU CẦU OUTPUT
Output: Contract YAML v4.0 theo schema Reviewer — gồm:
- decision + scores
- score_rationale (cho mỗi score < 7)
- consistency_checks
- issues[] với các field mở rộng: blocking, fix_priority, affected_phase
- missing_info, required_updates (nếu decision = CHANGES_REQUESTED)
- edge_cases_checked, not_covered_risks
- recommendation + next_step
artifacts: ["04_review.md"]
```

**Sau output:**
- **APPROVED** → Lưu `current_data.review_result = output`, tăng `step = 5` (Guardrail), log "✅ Kế hoạch đã được duyệt", ghi artifact `04_review.md`
- **CHANGES_REQUESTED** →
  - `retry.review_count++`
  - Nếu `retry.review_count < retry.max_review` → Quay lại Bước 3 (Plan), kèm góp ý
  - Nếu `retry.review_count >= retry.max_review` → Dừng, báo:
    ```
    ⛔ Đã đạt giới hạn review ({retry.max_review} lần).
    Cần người dùng can thiệp.
    ```
    Set `status: blocked`, `user_intervention: true`
- **REJECTED** → Dừng, set `status: failed`, báo người dùng

**Kiểm tra same_error_count:**
- Hash error message từ reviewer và so sánh với `error_history.review`
- Nếu `same_error_count >= 2` → STOP ngay, báo "Lỗi lặp lại, cần can thiệp thủ công"

---

### Bước 5: Pre-Build Guardrail
**Hành động:** Orchestrator chạy guardrail checklist tự động

**Mục đích:** Ngăn build từ plan thiếu — kiểm tra chất lượng kế hoạch trước khi chạy build.

**Guardrail Checklist:**
```yaml
guardrail:
  test_cases:
    required: true
    check: "Plan có ít nhất 1 test step không?"
    fail_action: "BLOCK — yêu cầu bổ sung test cases"
  rollback_strategy:
    required: true
    check: "rollback_strategy.enabled == true?"
    fail_action: "BLOCK — yêu cầu thêm rollback strategy"
  step_action_check:
    required: true
    check: "Mỗi step có action CREATE/MODIFY/DELETE rõ ràng không?"
    fail_action: "BLOCK — mỗi step phải có action rõ ràng"
  step_expected_result:
    required: true
    check: "Mỗi step có expected_result không?"
    fail_action: "BLOCK — mỗi step phải có expected_result"
  requires_backup_check:
    required: true
    check: "requires_backup == true cho MODIFY/DELETE, false cho CREATE?"
    fail_action: "BLOCK — requires_backup không khớp với action"
  per_step_validation_check:
    required: true
    check: "Có per_step_validation cho mỗi step không?"
    fail_action: "BLOCK — cần per_step_validation"
  final_validation_check:
    required: true
    check: "Có final_validation không?"
    fail_action: "BLOCK — cần final_validation"
  dependency_check:
    required: true
    check: "Tất cả file MODIFY trong steps có tồn tại không? (glob check)"
    fail_action: "WARN — file không tồn tại, plan yêu cầu MODIFY nhưng file chưa có"
  backup_check:
    required: false
    check: "Steps có requires_backup:true — backup đã chạy chưa?"
    fail_action: "BLOCK — chạy backup trước khi build"
  validate_steps:
    required: true
    check: "Plan có validate steps không?"
    fail_action: "BLOCK — thêm bước validate"
```

**Xử lý kết quả Guardrail:**
- **Tất cả PASS** → tăng `step = 6` (Backup)
- **BLOCK** → dừng, set `status: blocked`, yêu cầu sửa plan
- **WARN** → log, tiếp tục

Ghi artifact `05_guardrail.md`

---

### Bước 6: Backup — RÀNG BUỘC NGHIÊM NGẶT
**Hành động:** Orchestrator gọi backup-agent (qua backup-agent command)

**Điều kiện:** Chỉ chạy nếu `current_data.plan` có chứa thao tác sửa file cũ (`requires_backup: true`)

**Cách thực hiện (backup-agent):**
1. Orchestrator phân tích plan → danh sách file cần sửa
2. Gọi backup-agent command (action-based):
   ```powershell
   & ".opencode\scripts\backup-utility.ps1" -action save -files @("file1.cs", "file2.razor") -workflowId "<WF-ID>"
   ```
3. backup-agent tự tạo backup manifest: `backup_manifest.json` (trong `.opencode/backup/<WF-ID>/`)
4. Set `backup_done = true`

**Exclude rules tự động:** File nhạy cảm/size lớn được skip với `skip_reason` rõ ràng (SENSITIVE / MAX_SIZE_EXCEEDED)
**Manifest chuẩn:** Gồm `workflow_id`, `created_at`, `tool_version`, `files[]` với `sha256`, `source_path`, `backup_path`, `size`

**RÀNG BUỘC BACKUP — PHẢI TUÂN THỦ:**
1. **Nếu `requires_backup: true` mà backup thất bại → DỪNG NGAY, báo CRITICAL**
   - Không tiếp tục build, không retry
   - Set `status: blocked`, yêu cầu user can thiệp
2. **Nếu file MỚI tạo (action: CREATE) → không cần backup**
   - Log "📝 File mới, không cần backup"
3. **Nếu backup utility không sẵn sàng → báo `CRITICAL`**
   - Kiểm tra script tồn tại trước khi gọi: `Test-Path ".opencode\scripts\backup-utility.ps1"`
   - Nếu không tìm thấy → dừng ngay, không tự backup thủ công
4. **Nếu manifest không được tạo → coi như backup thất bại**

**Nếu chỉ tạo file mới:** Log "📝 Kế hoạch chỉ tạo file mới, không cần backup"

### Rollback an toàn
Khi cần rollback (catastrophic failure), gọi rollback utility:
```powershell
& ".opencode\scripts\rollback-utility.ps1" -workflowId "<WF-ID>"
```
Quy trình rollback:
1. **Preview** — hiển thị danh sách file, đánh dấu conflict
2. **Snapshot** — tự động backup file hiện tại vào `_pre_rollback_<timestamp>/`
3. **Safety** — không ghi đè file mới hơn backup (trừ `--force`)
4. **Summary** — báo cáo restored, skipped, failed

---

### Bước 7: Build (NÂNG CẤP)
**Agent:** `builder`

**Prompt:**
```
Bạn là Builder Agent. Thực thi kế hoạch đã duyệt sau đây.

Kế hoạch:
{current_data.plan}

Yêu cầu:
1. Chia steps thành tối đa 4 chunks (theo chunk field trong plan)

2. **Ràng buộc chỉnh sửa file — TUYỆT ĐỐI:**
   - Chỉ sửa đúng file được liệt kê trong plan (field `file`)
   - Nếu phát hiện file ngoài plan cần sửa → BÁO CÁO, KHÔNG ĐỤNG VÀO
   - `action: MODIFY` không được tự đổi thành `action: CREATE`
   - `action: CREATE` không được ghi đè lên file đã tồn tại (báo FAIL)

3. **Quy tắc file không tồn tại:**
   - Nếu `action: MODIFY` mà file không tồn tại → KHÔNG tự đổi sang CREATE
     → Báo FAIL với error_type="FileNotFound", retryable=false
   - Chỉ `action: CREATE` khi kế hoạch đã nêu rõ

4. **Backup constraint:** Nếu `requires_backup: true` mà backup chưa chạy → báo CRITICAL

5. **Validation theo giai đoạn:**
   - `per_step_validation`: Kiểm tra ngay sau mỗi step (lint, syntax check)
   - `final_validation`: Kiểm tra tổng thể sau tất cả steps (dotnet build, test)

6. Nếu per_step_validation FAIL → dừng step đó, không tiếp tục
7. Nếu chunk FAIL → dừng chunk đó, báo cáo ngay

8. **XỬ LÝ LỖI NGOÀI DỰ KIẾN:**
   - Gặp lỗi không nằm trong phạm vi plan → DỪNG NGAY
   - KHÔNG tự "sửa đại" — không thêm code ngoài logic đã định
   - Chỉ tiếp tục khi lỗi nằm trong phạm vi plan hoặc có chỉ dẫn mới từ orchestrator
   - Báo cáo lỗi chi tiết kèm error_type="Unknown"

9. **Mỗi lỗi phải kèm đầy đủ:** error_type, error_normalized, error_hash, retryable

10. Output: Contract YAML theo schema Builder (đã nâng cấp) — gồm `changed_files`, `created_files`, `deleted_files`, `backup_workflow_id`, `validation_status`
```

**Sau output:** Lưu `current_data.build_result = output`, tăng `step = 9` (Static Analysis), ghi artifact `07_build.md`

**Xử lý kết quả (mở rộng — v3.1):**
- **Tất cả PASS** → tiếp tục
- **FAIL + failure_type == MINOR** (syntax/lint) → Yêu cầu builder sửa
- **FAIL + failure_type == CRITICAL** → Kiểm tra nguyên nhân:
  - **Backup fail** (error_type = "BackupFailed") → DỪNG NGAY, không retry
  - **File không tồn tại** (error_type = "FileNotFound", action=MODIFY) → DỪNG, yêu cầu sửa plan
  - **File ngoài plan bị đụng vào** → DỪNG NGAY, báo CRITICAL, yêu cầu rollback
  - **Tự sửa lỗi ngoài dự kiến** (error_type = "Unknown" + tự thêm code) → DỪNG NGAY, báo CRITICAL
  - **Lỗi logic** → Kiểm tra same_error_count:
    - Nếu error hash trùng với `error_history.build_failures` ≥ 2 lần → Dừng, báo catastrophic failure
    - Nếu không → yêu cầu builder sửa hoặc hỏi user

---

### Bước 8: Static Analysis
**Hành động:** Orchestrator chạy validation script (không gọi agent)

**Mục đích:** YAML/JSON/lint validation — kiểm tra cấu trúc file và state machine hoạt động

**Các bước:**
1. Parse YAML frontmatter của SKILL.md → kiểm tra `name`, `description`, `schema_version`
2. Kiểm tra tất cả internal links (`#...`) có section tương ứng
3. Kiểm tra code block balance (số ``` mở = đóng)
4. Parse YAML samples trong Output Contract section
5. Simulate 1 workflow cycle: START → ANALYZE → DESIGN → PLAN → REVIEW → GUARDRAIL → BACKUP → BUILD → STATIC_ANALYSIS → UI_AUDIT → TESTPLAN → TEST → SKILL_VALIDATION → COMPLETE

**Output:** Ghi artifact `08_static_analysis.md`

**Sau output:**
- **PASS** → tăng step = 9 (UI Audit)
- **FAIL** → `retry.test_count++`, quay lại Bước 7 (Build) nếu retry < 3

---

### Bước 9: UI Audit
**Agent:** `ui-beautifier` (qua `/team-ui-audit`)

**Mục đích:** Kiểm tra và cải thiện giao diện người dùng — phát hiện CSS issues, accessibility problems, đề xuất cải tiến UI/UX.

**Prompt:**
```
Bạn là UI Beautifier Agent. Kiểm tra giao diện người dùng sau khi build.

Phân tích:
{current_data.analysis}

Kế hoạch:
{current_data.plan}

Kết quả build:
{current_data.build_result}

Yêu cầu:
1. Scan tất cả .razor files → phát hiện: CSS !important, inline styles, hardcoded colors, duplicated CSS
2. Kiểm tra accessibility: aria labels, contrast, keyboard navigation
3. Kiểm tra dark mode compatibility (nếu có)
4. Đề xuất cải tiến cụ thể (file, dòng, đề xuất sửa)

Output: Contract YAML:
status: "PASS | CHANGES_NEEDED"
issues:
  - file: "path/to/file.razor"
    severity: "CRITICAL | MAJOR | MINOR"
    category: "CSS | ACCESSIBILITY | DARK_MODE | CONSISTENCY"
    description: "Mô tả vấn đề"
    suggestion: "Đề xuất sửa"
    line: 42
summary: "Tổng kết UI audit"
```

**Sau output:** Lưu `current_data.ui_audit_result = output`, tăng step = 10 (Test Plan), ghi artifact `09_ui_audit.md`

**Xử lý kết quả:**
- **PASS** (không có CRITICAL/MAJOR issues) → tiếp tục
- **CHANGES_NEEDED** (có CRITICAL hoặc MAJOR) → `retry.test_count++`, quay lại Bước 7 (Build) để sửa nếu retry < 3
- **MINOR issues** → chỉ log warning, không block workflow

---

### Bước 10: Test Plan
**Agent:** `test-planner`

**Prompt:**
```
Bạn là Test-Planner Agent. Tạo kế hoạch kiểm thử cho tính năng vừa phát triển.

Phân tích:
{current_data.analysis}

Kế hoạch:
{current_data.plan}

Kết quả build:
{current_data.build_result}

Yêu cầu:
1. Xác định loại test: Unit, Integration, E2E, Edge, Error handling, Security, Performance, Compatibility, Accessibility, Concurrency, Negative
2. Mỗi test case có: ID, Mô tả, Input, Expected, File test
3. Xác định framework test hiện tại (dùng glob/grep)
4. Coverage target: unit ≥ 80%, integration ≥ 60%

Output: Contract YAML theo schema Test-Planner.
```

**Sau output:** Lưu `current_data.test_plan = output`, tăng `step = 11` (Test), ghi artifact `10_test_plan.md`

---

### Bước 11: Test
**Agent:** `tester`

**Prompt:**
```
Bạn là Tester Agent. Thực thi kế hoạch kiểm thử sau đây.

Kế hoạch test:
{current_data.test_plan}

Yêu cầu:
1. Chạy từng test case, ghi nhận PASS/FAIL/SKIP
2. Với FAIL: ghi rõ lỗi, error_normalized
3. Với SKIP: ghi rõ lý do
4. Tính coverage: unit, integration, e2e, overall
5. Nếu coverage < threshold → NEEDS_FIX
6. Timeout mỗi test: 60 giây

Output: Contract YAML theo schema Tester.
```

**Sau output:** Lưu `current_data.test_result = output`, ghi artifact `11_test.md`

**Xử lý kết quả:**
- **APPROVED** (all PASS + coverage >= thresholds) → Chuyển sang Bước 12 (Skill Validation)
- **NEEDS_FIX** (có FAIL hoặc coverage < threshold) →
  - `retry.test_count++`
  - Nếu `retry.test_count < retry.max_test` → Chuyển sang Bước 11a (Analyze Failure)
  - Nếu `retry.test_count >= retry.max_test` → Dừng, báo:
    ```
    ⛔ Đã đạt giới hạn test-fix loop.
    Cần người dùng can thiệp.
    ```
    Set `status: failed`, `user_intervention: true`
  - Kiểm tra same_error_count trước khi retry

---

### Bước 11a: Analyze Failure
**Agent:** `failure-agent`

**Hành động:**
1. Orchestrator thu thập raw error từ `test_result` (FAIL cases)
2. Gọi failure-agent: truyền error message + context (test step, file)
3. failure-agent trả về phân tích: error_hash, error_type, memory match
4. Nếu memory.found == true → apply lesson, chuyển Bước 11b
5. Nếu memory.found == false → chuyển Bước 11b (root cause tìm nguyên nhân mới)

**Prompt:**
```
Bạn là Failure Agent. Phân tích lỗi test sau đây.

Error: {error_message}
Context: Test step, file {current_data.test_result}

Output: Contract YAML theo schema Failure Agent.
```

**Output mẫu:**
```yaml
status: READY
summary: "Phân tích lỗi: TestFailed — assertion failed"
analysis:
  error_type: "TestFailed"
  error_hash: "a1b2c3d4e5f6"
  retryable: true
memory_search:
  found: false
suggestions:
  - action: "consult_root_cause"
    reason: "Lần đầu gặp lỗi này"
```

Ghi artifact `11a_failure_analysis.md`

---

### Bước 11b: Root Cause Analysis
**Agent:** `root-cause-agent`

**Hành động:**
1. Nhận failure_analysis từ Bước 11a
2. Gọi root-cause-agent: truyền error analysis + context codebase
3. root-cause-agent trả về hypotheses ranked by confidence
4. Nếu tìm thấy root cause → ghi failure record, chuyển Bước 11c (Learn) → sau đó Bước 7 (Build) kèm fix_suggestion
5. Nếu INCONCLUSIVE → hỏi user hướng dẫn

**Prompt:**
```
Bạn là Root Cause Agent. Phân tích nguyên nhân gốc từ failure analysis.

Failure Analysis:
{current_data.failure_analysis}

Codebase context: {context từ work hiện tại}

Output: Contract YAML theo schema Root Cause Agent.
```

**Output mẫu:**
```yaml
status: READY
summary: "Root cause analysis: 1 hypothesis generated"
hypotheses:
  - id: "H-001"
    confidence: 0.85
    fix_suggestion: "Sửa validation trong Program.cs"
conclusion:
  most_likely: "H-001"
```

Ghi artifact `11b_root_cause.md`

### Bước 11c: Learning Pipeline
**Agent:** `learning-agent`

**Hành động:**
1. Chạy tự động sau khi root cause được xác định và fix đã được áp dụng
2. Gọi learning-agent để quét failure records, auto-generate lessons và patterns
3. learning-agent ghi trực tiếp vào `.opencode/memory/` (lessons, patterns)
4. Nếu phát hiện pattern mới với confidence HIGH → đề xuất ghi knowledge base
5. Chuyển sang Bước 12 (Skill Validation)

**Prompt:**
```
Bạn là Learning Agent. Chạy Learning Pipeline cho các failure records.

Tham số:
--framework blazor
Context: workflow vừa hoàn tất với root cause đã xác định

Output: Contract YAML theo schema Learning Agent.
```

**Output mẫu:**
```yaml
status: READY
summary: "Đã tạo 1 lesson, 1 pattern mới"
scan:
  total_failures: 5
  processed: 1
  skipped: 4
created:
  lessons:
    - id: "LSN-BLZ-001"
      path: ".opencode/memory/lessons/blazor/LSN-BLZ-001.md"
  patterns:
    - id: "PAT-001"
      path: ".opencode/memory/patterns/PAT-001.md"
suggestions:
  - action: "update_knowledge_base"
    impact: MEDIUM
    requires_approval: true
```

Ghi artifact `11c_learning.md`

---

**Coverage tracking mẫu:**
```yaml
Requirement:
  - login
  - logout
  - remember_me
  - forgot_password

Coverage:
  login: PASS
  logout: PASS
  remember_me: SKIP
  forgot_password: FAIL
```

---

## BÁO CÁO KẾT THÚC

Sau khi workflow hoàn tất (PASS), tổng hợp báo cáo theo mẫu 5 phần:

### Mẫu báo cáo cuối cùng

```markdown
## BÁO CÁO CUỐI CÙNG — {workflow.id}

### 1. Kết quả tổng
- **Workflow ID:** {workflow.id}
- **Trạng thái:** ✅ THÀNH CÔNG / ❌ THẤT BẠI
- **Số bước đã chạy:** {step}/16
- **Review loop:** {retry.review_count} lần
- **Test-fix loop:** {retry.test_count} lần
- **Backup:** {"Đã thực hiện" / "Không cần"}

### 2. Những gì đã làm
{3-5 dòng mô tả công việc đã thực hiện}

| File | Hành động | Trạng thái | Mô tả |
|------|-----------|-----------|-------|
| path/to/file1 | MODIFY | ✅ Thành công | Sửa validation |
| path/to/file2 | CREATE | ✅ Thành công | Thêm test |

### 3. Lỗi / rủi ro còn lại
| Severity | Mô tả | Trạng thái |
|----------|-------|------------|
| MINOR | Cần tối ưu performance | ⏳ Chưa xử lý |
| INFO | Có thể dùng cache | 📝 Ghi nhận |

### 4. Artefact đã tạo
- `01_analysis.md` — Phân tích yêu cầu
- `02_design.md` — Thiết kế giải pháp
- `03_plan.md` — Kế hoạch thực thi
- `04_review.md` — Đánh giá kế hoạch
- `05_guardrail.md` — Pre-build guardrail
- `backup_manifest.json` — Backup manifest
- `07_build.md` — Kết quả build (nâng cấp: error_type, error_hash, retryable, validation_status)
- `08_static_analysis.md` — Static analysis
- `09_ui_audit.md` — UI audit
- `10_test_plan.md` — Kế hoạch test
- `11_test.md` — Kết quả test
- `12_skill_validation.md` — Self-improvement suggestions

### 5. Việc cần user xác nhận
- [ ] Review self-improvement suggestions ({n} items)
- [ ] Xác nhận kết quả test (PASS: {n}, FAIL: {n})
- [ ] Phê duyệt deployment (nếu có)
```

### Bước 12: Skill Validation
**Agent:** `self-improver`

**Điều kiện:** Chỉ chạy nếu workflow kết thúc với PASS

**Prompt:**
```
Bạn là Self-Improver Agent. Đọc toàn bộ quá trình workflow vừa hoàn tất và đề xuất cải tiến.

Yêu cầu gốc: {user_request}

Phân tích: {current_data.analysis}
Kế hoạch: {current_data.plan}
Kết quả review: {current_data.review_result} (số lần review loop: {retry.review_count})
Kết quả build: {current_data.build_result}
Kế hoạch test: {current_data.test_plan}
Kết quả test: {current_data.test_result}

LƯU Ý: Chỉ tạo suggestions, KHÔNG ghi trực tiếp vào knowledge base.
Đề xuất các mục: coding pattern, testing pattern, workflow improvement.
Output: Contract YAML theo schema Self-Improver.
```

**Sau output:** Lưu `current_data.skill_validation_result = output`, ghi artifact `12_skill_validation.md`

#### Approval Gate

```yaml
approval_gate:
  required: true
  approver: "User (human-in-the-loop)"
  process:
    1. Self-Improver → output suggestions vào artifact
    2. Orchestrator set status = "waiting_approval"
    3. Hiển thị suggestions cho user kèm workflow_id
    4. User phản hồi: APPROVE | REJECT | MODIFY
    5. APPROVE → ghi vào knowledge base (từng suggestion được approve)
    6. REJECT → bỏ qua, log lý do
    7. MODIFY → user sửa suggestion, ghi vào knowledge
  auto_approve:
    enabled: true
    condition: "suggestion.impact == LOW && suggestion.requires_approval == false"
```

Chỉ suggestion với `impact == LOW && requires_approval == false` được auto-approve.
Tất cả suggestion khác đều cần user approval.

Set `step = 13`, `step_name = complete`

---

### Bước 13: Complete

Kết thúc workflow, lưu `workflow.json` snapshot.

---

### Nếu workflow thất bại (blocked/failed)

```markdown
## BÁO CÁO THẤT BẠI

### Yêu cầu gốc
{user_request}

### Dừng ở bước
Bước {step}: {step_name}

### Lý do
{chi tiết}

### Trạng thái hiện tại
| Biến | Giá trị |
|------|---------|
| workflow.id | {workflow.id} |
| retry.review_count | {n} |
| retry.test_count | {n} |
| same_error_count | {n} |
| backup_done | {true/false} |

### Đề xuất
{đề xuất hành động cho người dùng}
```

---

## VALIDATION CHECKLIST PER PHASE

Mỗi phase có checklist validate riêng. Orchestrator phải kiểm tra trước khi chuyển sang bước kế tiếp.

```yaml
validation_checklist:
  phase_01_analyze:
    - "Output có đúng schema Analyst v2.0 không?"
    - "summary có ≥ 3 dòng không?"
    - "requirements có ít nhất 1 item không?"
    - "risks có description, severity, mitigation không?"
    - "structure có root, language, framework không?"
    - "entry_points có ít nhất 1 entry không?"
    - "impact_scope có file và level (DIRECT/INDIRECT/UNRELATED) không?"
    - "dependencies có evidence_file và evidence_line không?"
    - "patterns có naming, routing, state_management, testing không?"
    - "conclusion có status, reason, missing_info không?"
    - "scanned_paths và ignored_paths có được ghi nhận không?"
  phase_02_design:
    - "Output có đúng schema Planner v3.2 không?"
    - "design.architecture có mô tả không?"
    - "design.components có list không?"
    - "design.data_flow có mô tả không?"
    - "design.security_concerns có xử lý không?"
    - "design.edge_cases có list không?"
    - "blocking_issues có được ghi nhận không? (ít nhất empty array)"
    - "artifacts có '02_design.md' không?"
    - "effort có giá trị Small/Medium/Large không?"
  phase_03_plan:
    - "steps có ít nhất 1 bước không?"
    - "Mỗi step có order, description, action, file, logic, expected_result, check, requires_backup không?"
    - "action là CREATE/MODIFY/DELETE rõ ràng?"
    - "requires_backup == true nếu action là MODIFY hoặc DELETE?"
    - "requires_backup == false nếu action là CREATE?"
    - "Mỗi step có expected_result mô tả kết quả mong đợi? (REQUIRED v3.2)"
    - "per_step_validation có ít nhất 1 mục không?"
    - "per_chunk_validate có ít nhất 1 mục không? (khuyến nghị v3.2)"
    - "final_validation có ít nhất 1 mục không?"
    - "rollback_strategy.enabled == true"
    - "rollback_strategy.trigger_conditions có được định nghĩa không? (khuyến nghị v3.2)"
    - "rollback_strategy.restore_order có thứ tự restore hợp lý không? (khuyến nghị v3.2)"
    - "Step nào có risk_level=HIGH phải có rollback step tương ứng?"
    - "Chunk assignment có tuân theo Chunk Rules không? (1=config, 2=logic, 3=UI, 4=test)"
    - "validate có ít nhất 1 mục không? (backward compatibility)"
    - "blocking_issues có được kiểm tra không?"
  phase_04_review:
    - "decision phải là APPROVED/CHANGES_REQUESTED/REJECTED"
    - "scores có đủ 6 field không? (completeness, accuracy, safety, efficiency, testability, overall)"
    - "Mỗi score dưới 7 có score_rationale tương ứng không?"
    - "issues có id, severity, category, blocking, description, suggestion không?"
    - "Nếu blocking=true trong issue → decision không thể là APPROVED"
    - "Nếu có CRITICAL issue → decision không thể là APPROVED"
    - "overall >= 8.5 và không CRITICAL → APPROVED"
    - "consistency_checks có 3 field không? (contract_match, file_path_match, dependency_valid)"
    - "Nếu decision = CHANGES_REQUESTED → có missing_info và required_updates không?"
    - "edge_cases_checked có ít nhất 1 item không?"
    - "recommendation và next_step có được định nghĩa không?"
    - "diff_snapshot có được ghi nhận cho mỗi retry không?"
  phase_05_guardrail:
    - "Guardrail checklist đã chạy?"
    - "Plan có test steps không?"
    - "rollback_strategy.enabled == true?"
    - "File dependencies có tồn tại không?"
  phase_06_backup:
    - "backup_done == true nếu plan có sửa file cũ"
    - "backup_manifest.json tồn tại (tên mới, không còn 05_backup_manifest.json)"
    - "Manifest có workflow_id, created_at, tool_version"
    - "Mỗi file entry có original_path, hash, sha256, size_bytes, source_path, backup_path"
    - "File loại trừ (exe, dll, pdb, zip, node_modules, bin/, obj/, dist/, .env, *secret*) có status SKIPPED + skip_reason"
    - "Rollback snapshot được tạo trước khi restore"
  phase_07_build:
    - "Builder output có status PASS/FAIL không?"
    - "Mỗi step có order, status, file, action, requires_backup không?"
    - "Mỗi step có error fields đầy đủ: error_type, error_normalized, error_hash, retryable?"
    - "error_normalized không chứa line number/timestamp?"
    - "Nếu action=MODIFY mà file không tồn tại → error_type=FileNotFound, retryable=false?"
    - "Nếu requires_backup=true và backup fail → failure_type=CRITICAL?"
    - "validation_status có kết quả không?"
    - "changed_files, created_files, deleted_files đã liệt kê đầy đủ?"
    - "backup_workflow_id có nếu có backup?"
    - "Chỉ sửa đúng file trong plan? Không có file ngoài plan bị đụng vào?"
    - "Không tự ý MODIFY → CREATE khi file không tồn tại?"
    - "Có lỗi ngoài dự kiến bị tự 'sửa đại' không?"
  phase_08_static_analysis:
    - "YAML frontmatter parse được không?"
    - "Internal links đều có section tương ứng?"
    - "Code block balance: số ``` mở = đóng?"
    - "YAML samples trong Output Contract parse được?"
  phase_09_ui_audit:
    - "status là PASS hay CHANGES_NEEDED?"
    - "CRITICAL/MAJOR issues được ghi nhận đầy đủ?"
  phase_10_test_plan:
    - "test_types có ít nhất unit/integration?"
    - "test_cases có ít nhất 1 case?"
    - "coverage_target.unit ≥ 80?"
    - "coverage_target.integration ≥ 60?"
  phase_11_test:
    - "status là APPROVED hay NEEDS_FIX?"
    - "coverage.thresholds_met == true nếu APPROVED"
    - "Mỗi result có id, status, duration không?"
  phase_12_skill_validation:
    - "status là READY hay NO_SUGGESTIONS?"
    - "Suggestion có category, content, impact không?"
    - "impact MEDIUM/HIGH cần requires_approval == true"
  phase_13_complete:
    - "workflow.json snapshot đã lưu?"
    - "Báo cáo đã đầy đủ thông tin?"
```

---

## CHECKPOINT MECHANISM

Workflow có thể được tạm dừng và tiếp tục sau. Checkpoint lưu trạng thái hiện tại để rollback nếu cần.

### Checkpoint locations

```yaml
checkpoint:
  enabled: true
  auto_save:
    - after_analyze
    - after_design
    - after_plan
    - after_review
    - after_backup
    - after_build
    - after_static_analysis
    - after_ui_audit
    - after_test_plan
    - after_test
    - after_skill_validation
    - after_complete
  guardrail_checkpoints:            # Mới: checkpoint theo từng artifact
    - step: 2                       # Design phase
      artifact: "02_design.md"
      version: "v1"
      timestamp: "2026-07-26T14:00:00Z"
    - step: 3                       # Plan phase
      artifact: "03_plan.md"
      version: "v1"
      timestamp: "2026-07-26T14:30:00Z"
  manual_save:
    - before_critical_step   # Build, Test
    - before_rollback
```

### Checkpoint data

Mỗi checkpoint lưu `checkpoint_snapshots` vào tracking variables (kèm version + timestamp cho mỗi artifact):

```yaml
checkpoint_snapshot:
  step: 8
  step_name: "static_analysis"
  timestamp: "2026-07-26T14:30:00Z"
  status: "running"
  current_data: { ... }         # Clone current_data tại thời điểm đó
  retry: { ... }                # Clone retry counters
  artifacts:                    # Danh sách artifact đã tạo (kèm version)
    - artifact: "01_analysis.md"
      version: "v1"
      timestamp: "2026-07-26T14:00:00Z"
    - artifact: "02_design.md"
      version: "v1"
      timestamp: "2026-07-26T14:05:00Z"
    - artifact: "03_plan.md"
      version: "v1"
      timestamp: "2026-07-26T14:10:00Z"
    - artifact: "04_review.md"
      version: "v1"
      timestamp: "2026-07-26T14:15:00Z"
    - artifact: "05_guardrail.md"
      version: "v1"
      timestamp: "2026-07-26T14:20:00Z"
    - artifact: "backup_manifest.json"
      version: "v1"
      timestamp: "2026-07-26T14:25:00Z"
    - artifact: "07_build.md"
      version: "v1"
      timestamp: "2026-07-26T14:30:00Z"
```

### Rollback to checkpoint

Khi cần rollback, orchestrator chọn checkpoint và khôi phục:

```yaml
rollback_to_checkpoint:
  steps:
    1. "Xác định checkpoint target (step, timestamp)"
    2. "Gọi backup-agent: restore --checkpoint <id>"
    3. "Xóa artifacts sau checkpoint"
    4. "Khôi phục tracking variables từ snapshot"
    5. "Set step = checkpoint.step"
    6. "Log rollback reason"
```

---

## SƠ ĐỒ QUYẾT ĐỊNH (DECISION TREE)

```yaml
analyze:
  output.status == NEED_MORE_INFO: → hỏi_user
  output.status == READY: → design

design:
  output hợp lệ (có design): → plan
  output rỗng/thiếu: → yêu_cầu_làm_lại

plan:
  output hợp lệ (có steps): → review
  output rỗng/thiếu steps: → yêu_cầu_làm_lại

review:
  decision == APPROVED: → guardrail
  decision == CHANGES_REQUESTED (retry < 3 && same_error_count < 2): → plan
  decision == CHANGES_REQUESTED (retry >= 3 OR same_error_count >= 2): → hỏi_user
  decision == REJECTED: → hỏi_user

guardrail:
  all PASS: → backup
  BLOCK: → dừng, hỏi_user "Plan thiếu, cần sửa?"

backup:
  plan có sửa file cũ: → backup → build
  plan chỉ tạo mới: → build

build:
  all PASS: → static_analysis
  FAIL + failure_type == MINOR (syntax/lint): → sửa, build lại
  FAIL + failure_type == CRITICAL:
    error_type == "BackupFailed": → DỪNG NGAY, hỏi_user "Backup thất bại, cần xử lý thủ công?"
    error_type == "FileNotFound" (action=MODIFY): → DỪNG, hỏi_user "File không tồn tại, cần sửa plan?"
    error_type == "BackupUtilityUnavailable": → DỪNG NGAY, hỏi_user
    error_type == "FileOutsidePlan": → DỪNG NGAY, báo CRITICAL "Builder đã đụng vào file ngoài plan, cần rollback"
    error_type == "ActionMismatch" (MODIFY→CREATE tự ý): → DỪNG NGAY, báo CRITICAL
    error_type == "UnauthorizedFix" (tự sửa lỗi ngoài dự kiến): → DỪNG NGAY, báo CRITICAL
    same_error_count < 2: → hỏi_user
    same_error_count >= 2: → catastrophic → rollback
  catastrophic: → rollback

static_analysis:
  PASS: → ui_audit
  FAIL (retry < 3): → build (kèm báo lỗi)
  FAIL (retry >= 3): → hỏi_user

ui_audit:
  PASS: → testplan
  CHANGES_NEEDED (CRITICAL/MAJOR + retry < 3): → build
  CHANGES_NEEDED (CRITICAL/MAJOR + retry >= 3): → hỏi_user
  MINOR only: → testplan (auto-pass, chỉ log)

test:
  status == APPROVED (PASS + coverage đạt): → report → skill_validation
  status == NEEDS_FIX (FAIL hoặc coverage < threshold + retry < 3): → analyze_failure
  status == NEEDS_FIX (FAIL hoặc coverage < threshold + retry >= 3): → hỏi_user

analyze_failure:
  error message rỗng: → hỏi_user "Thiếu thông tin lỗi"
  memory.found == true (đã từng gặp): → apply_lesson → root_cause
  memory.found == false (lần đầu): → root_cause

root_cause:
  status == READY + hypotheses_count > 0: → ghi memory → build (kèm fix_suggestion)
  status == INCONCLUSIVE (không tìm thấy): → hỏi_user "Không tìm ra nguyên nhân gốc, cần hướng dẫn?"
  conclusion.catastrophic == true: → rollback

skill_validation:
  workflow == PASS: → skill_validation → waiting_approval
  workflow == FAIL: → complete (skip skill_validation)

waiting_approval:
  user APPROVE: → ghi knowledge → complete
  user REJECT: → skip knowledge → complete
  user MODIFY: → ghi knowledge (đã sửa) → complete

complete:
  → Lưu workflow.json → Kết thúc workflow

gitguard_fix_push:
  phát hiện lỗi:
    severity == CRITICAL: → block, hỏi_user "Có fix không?"
    severity == MAJOR: → hỏi_user "Có fix không?"
    severity == MINOR: → hỏi_user hoặc auto-fix
  user đồng ý fix: → dispatcher_agent (builder/planner/reviewer)
  fix xong: → hỏi_user "Có dùng /team-gitpush không?"
    user Y: → team-gitpush (pusher)
    user N: → kết thúc, log lý do
  user không đồng ý fix: → log lý do, kết thúc
```

---

## ROLLBACK MECHANISM

```yaml
rollback:
  enabled: true
  conditions:
    - "catastrophic failure"
    - "max retry reached"
    - "user request"
```

### Định nghĩa Catastrophic Failure

1. **Build trùng lỗi** ≥ 2 lần (same_error_count >= 2 trong build_failures)
2. **Test trùng lỗi** ≥ 2 lần (same_error_count >= 2 trong test_failures)
3. **Syntax/lint toàn bộ file** không thể sửa sau 3 lần retry
4. **File cần sửa bị xóa/mất** trong quá trình build (phát hiện qua diff với backup manifest)
5. **Builder output FAIL với `failure_type: CRITICAL`** và không có giải pháp thay thế
6. **Builder đụng vào file ngoài plan** (error_type = "FileOutsidePlan") — rollback ngay
7. **Builder tự ý đổi action** (error_type = "ActionMismatch") — rollback ngay
8. **Builder tự sửa lỗi ngoài dự kiến** (error_type = "UnauthorizedFix") — rollback ngay

### Cách thực hiện Rollback

```powershell
# rollback-utility.ps1 (action-based)
& ".opencode\scripts\rollback-utility.ps1" -workflowId "<WF-ID>"
```

Rollback tự động:
1. **Preview** trước khi restore
2. **Snapshot** file hiện tại vào `_pre_rollback_<timestamp>/`
3. **Safety**: không ghi đè nếu file đã thay đổi (trừ `--force`)
4. **Summary**: restored, skipped_newer, skipped_notfound, failed

Để force restore (khi user xác nhận):
```powershell
& ".opencode\scripts\rollback-utility.ps1" -workflowId "<WF-ID>" -force
```

---

## TÍCH HỢP VỚI COMMANDS RIÊNG LẺ

| Buoc | Command | Agent | File command |
|------|---------|-------|-------------|
| 0 | /team-syncdocs | general | team-syncdocs.md |
| 0 | /team-cleanup | cleaner | team-cleanup.md |
| 0 | /team | general | team.md |
| 1 | /team-analyze | analyst | team-analyze.md |
| 2-3 | /team-plan | planner (mo rong) | team-plan.md |
| 4 | /team-review | reviewer | team-review.md |
| 6 | /team-build | builder | team-build.md |
| 8 | /team-ui-audit | ui-beautifier | team-ui-audit.md |
| 9 | /team-testplan | test-planner | team-testplan.md |
| 10 | /team-test | tester | team-test.md |
| 11 | team (goi tu) | self-improver | team-selfimprove.md |
| 12 | /team-gitpush | pusher | team-gitpush.md |
Không có command `/team-design` riêng — Design là phần mở rộng của Plan.

### GitGuard → Fix → GitPush Flow

Khi `/team-gitguard` phát hiện lỗi/bug, orchestrator xử lý theo quy trình:

1. **Phân loại lỗi:**
   - **CRITICAL** (security leak, logic sai) → block ngay, hỏi user có fix không
   - **MAJOR** (convention, code quality) → hỏi user có fix không
   - **MINOR** (lint, style) → hỏi user hoặc auto-fix nếu được config

2. **User đồng ý fix** → orchestrator điều phối agent phù hợp (builder, planner, reviewer)

3. **Sau khi fix xong** → **hỏi người dùng:**
   ```
   ✅ Đã fix xong các lỗi từ GitGuard.
   Bạn có muốn dùng /team-gitpush để push lên remote không? (Y/N)
   ```
   - **Y** → chạy `/team-gitpush` (Pusher Agent)
   - **N** → kết thúc, log lý do

4. **User không đồng ý fix** → log lý do, kết thúc

---

## XỬ LÝ NGOẠI LỆ (EXCEPTION HANDLING)

### Timeout
- Mỗi lần gọi agent: tối đa 120 giây
- Nếu quá thời gian: log timeout, hỏi user "Agent không phản hồi, tiếp tục chờ hay bỏ qua?"

### User can thiệp giữa chừng
- Nếu user gửi thông tin mới: cập nhật context, tiếp tục từ bước hiện tại
- Nếu user yêu cầu dừng: set `status: cancelled`, tổng hợp báo cáo tạm thời

### Lỗi gọi agent
- Agent không available: thử lại 1 lần sau 10s, nếu vẫn lỗi → hỏi user
- Agent output sai format: yêu cầu agent làm lại với hướng dẫn cụ thể hơn

### Same error detection
- Mỗi lần nhận error, hash và so sánh với history
- Nếu `same_error_count >= 2` → STOP ngay, không retry mù

---

## VÍ DỤ CHẠY WORKFLOW

```
User: /team "Thêm validation email cho form đăng ký"

Orchestrator:
  step=1, agent=analyst
  → Gửi prompt phân tích
  ← Nhận báo cáo: form ở /src/components/RegisterForm.jsx
  
  step=2, agent=planner (design)
  → Gửi prompt design
  ← Architecture, components, data flow
  
  step=3, agent=planner (plan)
  → Gửi prompt plan
  ← 3 bước (thêm validate, update UI, test)
  
  step=4, agent=reviewer
  → Gửi prompt đánh giá
  ← APPROVED ✅
  
  step=5, guardrail
  → Kiểm tra quality checklist
  ← ✅ PASS (đủ test, rollback, validate)
  
  step=6, backup
  → Backup RegisterForm.jsx → .opencode/backup/WF-20260723-001/
  
  step=7, agent=builder
  → Gửi prompt build (chunk 1/2)
  ← ✅ PASS
  
  step=8, static analysis
  → Validate YAML/JSON/lint
  ← ✅ PASS
  
  step=9, ui audit
  → Kiểm tra CSS, dark mode, a11y
  ← ✅ PASS
  
  step=10, agent=test-planner
  → Gửi prompt test plan
  ← 5 test cases (2 unit, 2 edge, 1 regression)
  
  step=11, agent=tester
  → Chạy test + tính coverage
  ← ✅ 5/5 PASS, coverage 85%
  
  step=12, agent=self-improver
  → Gửi prompt skill validation
  ← 2 suggestions (1 auto-approve, 1 cần user)
  
  step=12a, approval gate
  → Hiển thị suggestions cho user
  ← User approve cả 2
  
  step=13, complete
  → BÁO CÁO KẾT THÚC
```

---

## MIGRATION PLAN

### Bước 0: Backup
- Copy SKILL.md → `.opencode/backup/SKILL.md.{timestamp}_before_v2`

### Bước 1: Viết lại toàn bộ
- Ghi đè `.opencode/skills/dev-team/SKILL.md` với phiên bản mới
- Dung lượng: ~1300 dòng

### Bước 2: Validate cấu trúc
- Frontmatter YAML: check `name`, `description` không đổi
- Internal links: check tất cả anchor `#...` tồn tại trong file
- Code block balance: đảm bảo ``` đóng/mở đúng

### Bước 3: Kiểm tra Backward Compatibility
- Workflow cũ không có workflow_id → mặc định "WF-LEGACY-{timestamp}"
- Workflow cũ thiếu field → dùng giá trị mặc định
- Artifact cũ không có schema → permissive mode (log warning, không block)

### Bước 4: File validation
- Load SKILL.md bằng parser YAML frontmatter
- Verify workflow mẫu không crash

---

## COMPLEXITY ESTIMATE

```yaml
complexity_estimate:
  total_lines: ~1800
  files_affected:
    - ".opencode/skills/dev-team/SKILL.md"
    - ".opencode/commands/team-build.md"
    - ".opencode/commands/team-plan.md"
  agents_needing_update: 0        # Không cần sửa agent riêng
  commands_needing_update: 2      # team-build.md + team-plan.md
  knowledge_files: 0              # .opencode/knowledge/ không cần sửa
  artifacts_structure: 12         # workflow.json + 11 artifact types
  new_sections:
    - "8 nâng cấp chính cho Builder Agent"
    - "Error fields chi tiết (error_type, error_normalized, error_hash, retryable)"
    - "Chuẩn hóa input + step structure + validation stages"
    - "Ràng buộc backup + file existence rules"
    - "depends_on + validation_command trong step schema"
    - "Ràng buộc chỉnh sửa file (FileOutsidePlan, ActionMismatch, UnauthorizedFix)"
    - "deleted_files trong output"
```

---

## VALIDATION & TESTING

### Post-Migration Checks

1. **Frontmatter validation**: YAML parse `name`, `description`, `schema_version`
2. **Internal link check**: Mọi `#...` anchor phải có section tương ứng
3. **Code block consistency**: Số ``` mở = số ``` đóng
4. **YAML sample validation**: Mọi YAML codeblock trong Output Contract parse được
5. **State machine consistency**: Diagram khớp với Decision Tree
6. **Variable checklist**: Mọi biến trong tracking variables được dùng ở đâu đó

### Behavioral Validation

```yaml
static_analysis:
  steps:
    - "Parse SKILL.md frontmatter"
    - "Kiểm tra internal links"
    - "Parse YAML samples"
    - "Simulate workflow cycle: START → ANALYZE → DESIGN → PLAN → REVIEW → BACKUP → BUILD → STATIC_ANALYSIS → UI_AUDIT → TESTPLAN → TEST → SKILL_VALIDATION → WAITING_APPROVAL → COMPLETE"
    - "Verify state transition match decision tree"
```

---

## GHI CHÚ

- Có thể chạy từng bước riêng bằng các lệnh `/team-*`
- Design phase do Planner đảm nhiệm với extended prompt. Không cần agent riêng.
- Luôn validate frontmatter YAML sau mỗi lần sửa file .md
- Skill Validation (self-improver) chỉ tạo suggestions, không ghi trực tiếp knowledge base
- Approval gate bắt buộc cho suggestion có impact MEDIUM/HIGH
- Backward compatible: workflow cũ được gán ID "WF-LEGACY-{timestamp}"
- Backup/Rollback do backup-agent thực hiện, Orchestrator chỉ gọi lệnh
- Nếu workflow bị block ở bước nào, cung cấp đủ thông tin để người dùng biết:
  - Đang ở bước nào, Output hiện tại, Cần quyết định gì
- Khi workflow hoàn tất, output báo cáo phải đầy đủ và rõ ràng






