---
name: dev-team
description: Hướng dẫn sử dụng Dev Agent Team gồm 9 agents (7 core + 2 support). Dùng khi cần phân tích, lập kế hoạch, đánh giá, code, kiểm thử một yêu cầu phát triển. Tích hợp cơ chế Self-Improvement với approval gate. Sử dụng câu lệnh team hoặc team-*.
schema_version: "2.0"
---

# Dev Agent Team — Orchestrator Guide

Team gồm **General Agent (Orchestrator)** điều phối **9 agents (7 core specialists: analyst, planner, reviewer, builder, ui-beautifier, test-planner, tester + 2 support: self-improver, backup-agent)** theo quy trình phát triển phần mềm hoàn chỉnh:
**Analyze → Design → Plan → Review → Backup → Build → Static Analysis → UI Audit → Test Plan → Test → Skill Validation → Complete**

Trong đó:
- **General Agent (Orchestrator)**: Workflow orchestration + State management (không tự làm backup/restore)
- **7 Core Specialists**: analyst, planner (mở rộng), reviewer, builder, ui-beautifier, test-planner, tester
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
  schema_version: "2.0"          # Để backward compatibility
```

### Artifact structure

```
workflow/
  WF-20260723-001/
    01_analysis.md
    02_design.md                  # Planner mở rộng
    03_plan.md
    04_review.md
    05_backup_manifest.json
    06_build.md
    07_static_analysis.md
    08_ui_audit.md
    09_test_plan.md
    10_test.md
    11_skill_validation.md
    12_report.md
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
    new_artifacts: strict         # Phải đúng schema
    legacy_artifacts: permissive  # Log warning, không block
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
             ┌─────────┐   ┌─────────┐
             │ BACKUP  │   │  PLAN   │
             └────┬────┘   └─────────┘
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
          │ PASS   │ │ FAIL   │ ───► quay lại BUILD
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
  schema_version: "2.0"
  step: 1-12                        # Bước hiện tại (1-12)
  step_name: analyze|design|plan|review|backup|build|static_analysis|ui_audit|testplan|test|skill_validation|complete
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
        step: 3
    test_failures:
      - hash: "..."
        error: "..."
        step: 9
    build_failures:
      - hash: "..."
        error: "..."
        step: 6
    same_error_count: 0              # Nếu ≥ 2 → STOP
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
    skill_validation_result: null
    final_report: null
    checkpoint_snapshots: []
```

### Cách tính error_hash

```
1. Lấy raw error message (từ stderr/exception)
2. Normalize: loại bỏ line number, timestamp, memory address, stack trace line
3. Trim whitespace, lowercase
4. SHA256(string) → lấy 12 ký tự đầu

Ví dụ:
  Raw:    "Line 42: System.NullReferenceException: Object reference at MyClass.cs:123"
  Normal: "system.nullreferenceexception: object reference"
  Hash:   "a1b2c3d4e5f6"
```

---

## OUTPUT CONTRACT CỦA CÁC AGENT

Mỗi agent output theo format YAML cố định. Orchestrator parse các field này để quyết định bước tiếp theo.

### 1. Analyst

**Schema:**

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NEED_MORE_INFO` |
| effort | string | ✅ | `Small`, `Medium`, hoặc `Large` — dựa trên scope phân tích |
| summary | string | ✅ | Tóm tắt phân tích (3-5 dòng) |
| details | string | ✅ | Phân tích chi tiết |
| requirements | string[] | ✅ | Danh sách yêu cầu con |
| risks | object[] | ✅ | Rủi ro: `[{description, severity, mitigation}]` |
| design_proposal | string | ❌ | Đề xuất thiết kế (nếu có) |
| tasks | object[] | ✅ | Task con: `[{name, file, effort}]` |

**Output mẫu:**
```yaml
status: READY
effort: Medium
summary: "Phân tích yêu cầu, xác định 5 file cần sửa"
details: "..."
requirements:
  - "Thêm validation email"
risks:
  - description: "Xung đột với validation hiện tại"
    severity: MEDIUM
    mitigation: "Kiểm tra codebase trước khi sửa"
tasks: []
```

### 2. Planner (mở rộng — gồm Design)

**Schema:**

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NEEDS_MORE_INFO` |
| effort | string | ✅ | `Small`, `Medium`, hoặc `Large` — dựa trên complexity thiết kế |
| design | object | ✅ | Thiết kế: architecture, components, data_flow, security, edge_cases |
| steps | object[] | ✅ | Các bước thực thi: `[{order, description, file, logic, check, chunk}]` |
| rollback_strategy | object | ✅ | Chiến lược rollback: `{enabled, conditions[]}` |
| validate | string[] | ✅ | Các bước validate cuối |

**Output mẫu:**
```yaml
status: READY
effort: Medium
design:
  architecture: "Thêm service layer mới"
  components:
    - "EmailValidator"
  data_flow: "Input → Validate → Save"
  security_concerns:
    - "SQL injection qua email"
  edge_cases:
    - "Email rỗng"
    - "Email Unicide"
steps:
  - order: 1
    description: "Backup file"
    file: "src/validators.ts"
    logic: "Copy file cũ"
    check: "File tồn tại"
    chunk: 1
rollback_strategy:
  enabled: true
  conditions:
    - "catastrophic failure"
    - "max retry reached"
    - "user request"
validate:
  - "Chạy dotnet build"
```

### 3. Reviewer

**Schema:**

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| decision | string | ✅ | `APPROVED`, `CHANGES_REQUESTED`, hoặc `REJECTED` |
| scores | object | ✅ | `{completeness, accuracy, safety, efficiency, testability, overall}` (1-10) |
| issues | object[] | ✅ | `[{id, severity, category, description, suggestion}]` |
| summary | string | ✅ | Tổng kết đánh giá |

**Output mẫu:**
```yaml
decision: CHANGES_REQUESTED
scores:
  completeness: 7
  accuracy: 8
  safety: 9
  efficiency: 7
  testability: 6
  overall: 7.4
issues:
  - id: "#01"
    severity: CRITICAL
    category: CONSISTENCY
    description: "Mô tả vấn đề"
    suggestion: "Đề xuất giải pháp"
summary: "Kế hoạch cần bổ sung security validation"
```

### 4. Builder

**Schema:**

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `PASS` hoặc `FAIL` |
| steps | object[] | ✅ | `[{order, status, file, error, error_normalized}]` |
| overall | string | ✅ | `PASS` / `FAIL` |
| failure_type | string | ❌ | `MINOR` (syntax/lint) hoặc `CRITICAL` (logic) — chỉ khi FAIL |
| details | string | ❌ | Chi tiết lỗi — chỉ khi FAIL |

**Output mẫu:**
```yaml
status: PASS
steps:
  - order: 1
    status: PASS
    file: "src/validators.ts"
  - order: 2
    status: FAIL
    file: "src/handler.ts"
    error: "SyntaxError: Unexpected token"
    error_normalized: "syntaxerror: unexpected token"
overall: "PASS"
```

### 5. Test-Planner

**Schema:**

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NEEDS_MORE_INFO` |
| test_types | object | ✅ | `{unit, integration, e2e, edge, error_handling, security, performance, compatibility, accessibility, concurrency, negative}` — mỗi loại boolean |
| test_cases | object[] | ✅ | `[{id, type, description, input, expected, file}]` |
| framework | string | ✅ | Framework test hiện tại |
| coverage_target | object | ✅ | `{unit, integration, e2e, overall}` |

**Output mẫu:**
```yaml
status: READY
test_types:
  unit: true
  integration: true
  e2e: false
  edge: true
  error_handling: true
  security: true
  performance: false
  compatibility: false
  accessibility: false
  concurrency: false
  negative: true
test_cases:
  - id: "TC-001"
    type: unit
    description: "Validate email hợp lệ"
    input: "user@example.com"
    expected: "true"
    file: "tests/validators.test.ts"
framework: "xUnit + bUnit"
coverage_target:
  unit: 80
  integration: 60
  e2e: 50
  overall: 70
```

### 6. Tester

**Schema:**

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `APPROVED` hoặc `NEEDS_FIX` |
| coverage | object | ✅ | `{unit: %, integration: %, e2e: %, overall: %, thresholds_met: bool}` |
| summary | string | ✅ | Tổng kết kết quả test |
| results | object[] | ✅ | `[{id, status, error, duration}]` với status: PASS/FAIL/SKIP |

Cách tính `overall`: `(unit_pass + integration_pass) / (unit_total + integration_total) × 100`

**Output mẫu:**
```yaml
status: APPROVED
coverage:
  unit: 85
  integration: 70
  e2e: 55
  overall: 80.5
  thresholds_met: true
summary: "6/6 PASS, coverage đạt threshold"
results:
  - id: "TC-001"
    status: PASS
    duration: "1.2s"
  - id: "TC-002"
    status: PASS
    duration: "0.8s"
```

### 7. Self-Improver

**Schema:**

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| status | string | ✅ | `READY` hoặc `NO_SUGGESTIONS` |
| suggestions | object[] | ✅ | `[{category, content, impact, requires_approval}]` |
| summary | string | ✅ | Tổng kết |

- `impact`: `LOW` | `MEDIUM` | `HIGH`
- `requires_approval`: `true` | `false` (auto-approve if false + impact == LOW)

**Output mẫu:**
```yaml
status: READY
suggestions:
  - category: coding_pattern
    content: "Dùng FluentValidation thay vì if-else"
    impact: MEDIUM
    requires_approval: true
  - category: workflow_improvement
    content: "Thêm step lint tự động"
    impact: LOW
    requires_approval: false
summary: "2 suggestions, 1 cần approval"
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
**Agent:** `planner` (mở rộng — không có agent Design riêng)

**Prompt:**
```
Bạn là Planner Agent (mở rộng). Dựa trên báo cáo phân tích, thiết kế giải pháp chi tiết.

Báo cáo:
{current_data.analysis}

Yêu cầu Design:
1. Architecture: Mô tả kiến trúc tổng thể
2. Components: Liệt kê component cần tạo/sửa
3. Data flow: Luồng dữ liệu giữa các component
4. Security concerns: Các rủi ro bảo mật
5. Edge cases: Các trường hợp đặc biệt

Output: Contract YAML theo schema Planner (bao gồm cả design).
```

**Sau output:** Lưu `current_data.design = output`, tăng `step = 3`, ghi artifact `02_design.md`

---

### Bước 3: Plan
**Agent:** `planner` (tiếp — cùng agent Design)

**Prompt:**
```
Bạn là Planner Agent. Dựa trên thiết kế, lập kế hoạch thực thi chi tiết từng bước.

Thiết kế:
{current_data.design}

Yêu cầu:
1. Mỗi bước có: Mô tả, File, Logic, Kiểm tra, Chunk (1-4)
2. Thứ tự: config → logic → test
3. Thêm rollback_strategy
4. Kết thúc bằng validate tổng thể

Output: Contract YAML theo schema Planner (cập nhật steps, rollback_strategy, validate).
```

**Sau output:** Lưu `current_data.plan = output`, tăng `step = 4`, ghi artifact `03_plan.md`

**Kiểm tra:** Kế hoạch phải có ít nhất 1 bước — nếu không → yêu cầu làm lại.

---

### Bước 4: Review
**Agent:** `reviewer`

**Prompt:**
```
Bạn là Reviewer Agent. Đánh giá kế hoạch sau theo 5 tiêu chí: Đầy đủ, Chính xác, An toàn, Hiệu quả, Kiểm thử.

Kế hoạch:
{current_data.plan}

Output: Contract YAML theo schema Reviewer.
```

**Sau output:**
- **APPROVED** → Lưu `current_data.review_result = output`, tăng `step = 5`, log "✅ Kế hoạch đã được duyệt", ghi artifact `04_review.md`
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

### Bước 5: Backup
**Hành động:** Orchestrator gọi backup-agent (qua backup-agent command)

**Điều kiện:** Chỉ chạy nếu `current_data.plan` có chứa thao tác sửa file cũ

**Cách thực hiện (backup-agent):**
1. Orchestrator phân tích plan → danh sách file cần sửa
2. Gọi backup-agent command: `backup-agent --files <file_list> --workflow-id <id>`
3. backup-agent tự tạo backup manifest: `05_backup_manifest.json`
4. Set `backup_done = true`

**Nếu chỉ tạo file mới:** Log "📝 Kế hoạch chỉ tạo file mới, không cần backup"

---

### Bước 6: Build
**Agent:** `builder`

**Prompt:**
```
Bạn là Builder Agent. Thực thi kế hoạch đã duyệt sau đây.

Kế hoạch:
{current_data.plan}

Yêu cầu:
1. Chia steps thành tối đa 4 chunks (theo chunk field trong plan)
2. Sau mỗi chunk: kiểm tra syntax/lint
3. Nếu chunk FAIL → dừng chunk đó, báo cáo ngay
4. Backup file trước khi sửa (backup-agent đã làm)
5. Output: Contract YAML theo schema Builder
```

**Sau output:** Lưu `current_data.build_result = output`, tăng `step = 7`, ghi artifact `06_build.md`

**Kiểm tra:**
- **Tất cả PASS** → tiếp tục
- **FAIL + failure_type == MINOR** → Yêu cầu builder sửa
- **FAIL + failure_type == CRITICAL** → Kiểm tra same_error_count:
  - Nếu error hash trùng với `error_history.build_failures` ≥ 2 lần → Dừng, báo catastrophic failure
  - Nếu không → yêu cầu builder sửa hoặc hỏi user

---

### Bước 7: Static Analysis
**Hành động:** Orchestrator chạy validation script (không gọi agent)

**Mục đích:** YAML/JSON/lint validation — kiểm tra cấu trúc file và state machine hoạt động

**Các bước:**
1. Parse YAML frontmatter của SKILL.md → kiểm tra `name`, `description`, `schema_version`
2. Kiểm tra tất cả internal links (`#...`) có section tương ứng
3. Kiểm tra code block balance (số ``` mở = đóng)
4. Parse YAML samples trong Output Contract section
5. Simulate 1 workflow cycle: START → ANALYZE → DESIGN → PLAN → REVIEW → ... → COMPLETE

**Output:** Ghi artifact `07_static_analysis.md`

**Sau output:**
- **PASS** → tiếp tục
- **FAIL** → `retry.test_count++`, quay lại Bước 6 (Build) nếu retry < 3

---

### Bước 8: UI Audit
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

**Sau output:** Lưu `current_data.ui_audit_result = output`, ghi artifact `08_ui_audit.md`

**Xử lý kết quả:**
- **PASS** (không có CRITICAL/MAJOR issues) → tiếp tục
- **CHANGES_NEEDED** (có CRITICAL hoặc MAJOR) → `retry.test_count++`, quay lại Bước 6 (Build) để sửa nếu retry < 3
- **MINOR issues** → chỉ log warning, không block workflow

---

### Bước 9: Test Plan
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

**Sau output:** Lưu `current_data.test_plan = output`, tăng `step = 10`, ghi artifact `09_test_plan.md`

---

### Bước 10: Test
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

**Sau output:** Lưu `current_data.test_result = output`, ghi artifact `10_test.md`

**Xử lý kết quả:**
- **APPROVED** (all PASS + coverage >= thresholds) → Chuyển sang Bước 11 (Skill Validation)
- **NEEDS_FIX** (có FAIL hoặc coverage < threshold) →
  - `retry.test_count++`
  - Nếu `retry.test_count < retry.max_test` → Quay lại Bước 6 (Build)
  - Nếu `retry.test_count >= retry.max_test` → Dừng, báo:
    ```
    ⛔ Đã đạt giới hạn test-fix loop.
    Cần người dùng can thiệp.
    ```
    Set `status: failed`, `user_intervention: true`
  - Kiểm tra same_error_count trước khi retry

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

Sau khi workflow hoàn tất (PASS), tổng hợp báo cáo:

```markdown
## BÁO CÁO CUỐI CÙNG

### Yêu cầu gốc
{user_request}

### Thông tin workflow
| Thông số | Giá trị |
|----------|---------|
| Workflow ID | {workflow.id} |
| Số lần review loop | {retry.review_count} |
| Số lần test-fix loop | {retry.test_count} |
| Backup | {"Đã thực hiện" / "Không cần"} |
| Tổng số bước | 12 |

### Phân tích (tóm tắt)
{3-5 dòng từ current_data.analysis}

### Kế hoạch
✅ APPROVED (sau {retry.review_count} lần review)

### File đã thay đổi
| File | Trạng thái |
|------|-----------|
| path/to/file1 | ✅ Thành công |
| path/to/file2 | ✅ Thành công |

### Kết quả test
- **PASS:** {n} | **FAIL:** {n} | **SKIP:** {n}
- **Tỷ lệ PASS:** {x}%
- **Coverage:** unit={u}% integration={i}% overall={o}%

### Skill Validation
- Số suggestions: {n}
- Approval status: APPROVED / REJECTED / PENDING
```

### Bước 11: Skill Validation
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

**Sau output:** Lưu `current_data.skill_validation_result = output`, ghi artifact `11_skill_validation.md`

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

Set `step = 12`, `step_name = complete`

---

### Bước 12: Complete

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
    - "Output có đúng schema Analyst không?"
    - "summary có ≥ 3 dòng không?"
    - "requirements có ít nhất 1 item không?"
    - "risks có description, severity, mitigation không?"
  phase_02_design:
    - "Output có đúng schema Planner không?"
    - "design.architecture có mô tả không?"
    - "design.components có list không?"
    - "design.data_flow có mô tả không?"
    - "design.security_concerns có xử lý không?"
    - "design.edge_cases có list không?"
  phase_03_plan:
    - "steps có ít nhất 1 bước không?"
    - "Mỗi step có order, description, file, logic, check, chunk không?"
    - "rollback_strategy.enabled == true"
    - "validate có ít nhất 1 mục không?"
  phase_04_review:
    - "decision phải là APPROVED/CHANGES_REQUESTED/REJECTED"
    - "scores có đủ 6 field không?"
    - "issues có id, severity, category không?"
  phase_05_backup:
    - "backup_done == true nếu plan có sửa file cũ"
    - "05_backup_manifest.json tồn tại"
  phase_06_build:
    - "Builder output có status PASS/FAIL không?"
    - "Mỗi step có order, status, file không?"
    - "error_normalized không chứa line number/timestamp"
  phase_07_static_analysis:
    - "YAML frontmatter parse được không?"
    - "Internal links đều có section tương ứng?"
    - "Code block balance: số ``` mở = đóng?"
    - "YAML samples trong Output Contract parse được?"
  phase_08_ui_audit:
    - "status là PASS hay CHANGES_NEEDED?"
    - "CRITICAL/MAJOR issues được ghi nhận đầy đủ?"
  phase_09_test_plan:
    - "test_types có ít nhất unit/integration?"
    - "test_cases có ít nhất 1 case?"
    - "coverage_target.unit ≥ 80?"
    - "coverage_target.integration ≥ 60?"
  phase_10_test:
    - "status là APPROVED hay NEEDS_FIX?"
    - "coverage.thresholds_met == true nếu APPROVED"
    - "Mỗi result có id, status, duration không?"
  phase_11_skill_validation:
    - "status là READY hay NO_SUGGESTIONS?"
    - "Suggestion có category, content, impact không?"
    - "impact MEDIUM/HIGH cần requires_approval == true"
  phase_12_complete:
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
  manual_save:
    - before_critical_step   # Build, Test
    - before_rollback
```

### Checkpoint data

Mỗi checkpoint lưu `checkpoint_snapshots` vào tracking variables:

```yaml
checkpoint_snapshot:
  step: 7
  step_name: "static_analysis"
  timestamp: "2026-07-26T14:30:00Z"
  status: "running"
  current_data: { ... }         # Clone current_data tại thời điểm đó
  retry: { ... }                # Clone retry counters
  artifacts:                    # Danh sách artifact đã tạo
    - "01_analysis.md"
    - "02_design.md"
    - "03_plan.md"
    - "04_review.md"
    - "05_backup_manifest.json"
    - "06_build.md"
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
  decision == APPROVED: → backup
  decision == CHANGES_REQUESTED (retry < 3 && same_error_count < 2): → plan
  decision == CHANGES_REQUESTED (retry >= 3 OR same_error_count >= 2): → hỏi_user
  decision == REJECTED: → hỏi_user

backup:
  plan có sửa file cũ: → backup → build
  plan chỉ tạo mới: → build

build:
  all PASS: → static_analysis
  FAIL + failure_type == MINOR: → sửa, build lại
  FAIL + failure_type == CRITICAL (same_error_count < 2): → hỏi_user
  FAIL + failure_type == CRITICAL (same_error_count >= 2): → catastrophic → rollback
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
  status == NEEDS_FIX (FAIL hoặc coverage < threshold + retry < 3): → build
  status == NEEDS_FIX (FAIL hoặc coverage < threshold + retry >= 3): → hỏi_user

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

### Cách thực hiện Rollback

```powershell
# rollback-utility.ps1
param($workflow_id)
$backup_root = ".opencode\backup\$workflow_id"
# Đọc manifest và restore từng file
$manifest = Get-Content "$backup_root\05_backup_manifest.json" | ConvertFrom-Json
foreach ($entry in $manifest.files) {
    Copy-Item -LiteralPath $entry.backup_path -Destination $entry.original_path -Force
    Write-Output "✅ Restored: $($entry.original_path)"
}
```

---

## TÍCH HỢP VỚI COMMANDS RIÊNG LẺ

| Buoc | Command | Agent | File command |
|------|---------|-------|-------------|
| Buoc | Command | Agent | File command |
|------|---------|-------|-------------|
| 1 | /team-analyze | analyst | team-analyze.md |
| 2-3 | /team-plan | planner (mo rong) | team-plan.md |
| 4 | /team-review | reviewer | team-review.md |
| 6 | /team-build | builder | team-build.md |
| 8 | /team-ui-audit | ui-beautifier | team-ui-audit.md |
| 9 | /team-testplan | test-planner | team-testplan.md |
| 10 | /team-test | tester | team-test.md |
| 11 | (goi tu team.md) | self-improver | .opencode/agents/self-improver.md |
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
  
  step=5, backup
  → Backup RegisterForm.jsx → .opencode/backup/WF-20260723-001/
  
  step=6, agent=builder
  → Gửi prompt build (chunk 1/2)
  ← ✅ PASS
  
  step=7, static analysis
  → Validate YAML/JSON/lint
  ← ✅ PASS
  
  step=8, ui audit
  → Kiểm tra CSS, dark mode, a11y
  ← ✅ PASS
  
  step=9, agent=test-planner
  → Gửi prompt test plan
  ← 5 test cases (2 unit, 2 edge, 1 regression)
  
  step=10, agent=tester
  → Chạy test + tính coverage
  ← ✅ 5/5 PASS, coverage 85%
  
  step=11, agent=self-improver
  → Gửi prompt skill validation
  ← 2 suggestions (1 auto-approve, 1 cần user)
  
  step=11a, approval gate
  → Hiển thị suggestions cho user
  ← User approve cả 2
  
  step=12, complete
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
  total_lines: 1399
  files_affected:
    - ".opencode/skills/dev-team/SKILL.md"
  agents_needing_update: 0        # .opencode/agents/ không cần sửa
  commands_needing_update: 0      # team-*.md command files không cần sửa
  knowledge_files: 0              # .opencode/knowledge/ không cần sửa
  artifacts_structure: 7          # workflow.json + 6 artifact types
  new_sections: 4                 # Migration Plan, Complexity Estimate, Validation & Testing, Approval Gate
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

