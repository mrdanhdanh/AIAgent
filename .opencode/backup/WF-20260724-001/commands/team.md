---
description: Chạy toàn bộ team workflow: analyze → design → review design → plan → review plan → build → testplan → test
agent: general
---

Bạn đang vận hành **Dev Agent Team** — orchestrator điều phối 7 agent chuyên biệt (analyze → design → review design → plan → review plan → build → testplan → test → self-improve).

Đọc tài liệu đầy đủ tại: `.opencode/skills/dev-team/SKILL.md`
Các lệnh thành phần: `/team-analyze`, `/team-design`, `/team-review`, `/team-plan`, `/team-review`, `/team-build`, `/team-testplan`, `/team-test`

Yêu cầu: $ARGUMENTS

---

## WORKFLOW ID

Tạo workflow ID ngay khi bắt đầu: `WF-YYYYMMDD-NNN` (ví dụ: `WF-20260723-001`).
Lưu vào biến `workflow.id` và dùng cho mọi artifact, backup, rollback, logging.

---

## MÔ HÌNH ORCHESTRATOR

Bạn là **General Agent** đóng vai trò orchestrator — chỉ đảm nhiệm orchestration và state management. Các việc khác (backup, rollback, diff) gọi utility riêng.

Trách nhiệm:
1. **Triệu hồi** đúng agent theo đúng bước
2. **Truyền context** qua artifact files (`.opencode/workflows/{WF_ID}/`)
3. **Xử lý vòng lặp** — review loop, test-fix loop (tối đa 3 lần, có kiểm tra lỗi trùng)
4. **Theo dõi trạng thái** — biến step, retry_count, status, error_history
5. **Quyết định** — tiếp tục, retry, rollback, dừng, hoặc hỏi người dùng

---

## MÁY TRẠNG THÁI (STATE MACHINE)

```
                    ┌─────────┐
                    │  START  │
                    └────┬────┘
                         ▼
                    ┌─────────┐
                    │ANALYZE  │ ◄──── NEED_MORE_INFO → hỏi user
                    └────┬────┘
                         ▼
                    ┌─────────┐
                    │ DESIGN  │
                    └────┬────┘
                         ▼
                    ┌──────────────┐
                    │REVIEW DESIGN │
                    └──────┬───────┘
                      ┌────┴────┐
                      │         │
                      ▼         ▼
               ┌──────────┐ ┌──────────┐
               │APPROVED  │ │CHANGES   │ ──► quay DESIGN (retry < 3)
               └────┬─────┘ └──────────┘
                    ▼
               ┌─────────┐
               │  PLAN   │
               └────┬────┘
                    ▼
               ┌─────────────┐
               │REVIEW PLAN  │
               └──────┬──────┘
                 ┌────┴────┐
                 │         │
                 ▼         ▼
          ┌──────────┐ ┌──────────┐
          │APPROVED  │ │CHANGES   │ ──► quay PLAN (retry < 3)
          └────┬─────┘ └──────────┘
               ▼
          ┌─────────┐
          │ BACKUP  │ ──► .opencode/workflows/WF-xxx/backup/
          └────┬────┘
               ▼
          ┌─────────┐
          │  BUILD  │ ◄──── TEST FAIL (retry < 3, error mới)
          └────┬────┘
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
       ┌────────┐ ┌──────────────┐
       │ PASS   │ │ FAIL         │ ──► BUILD nếu error mới
       └───┬────┘ └──────────────┘  ──► ROLLBACK nếu lỗi trùng
           ▼
      ┌─────────┐
      │ REPORT  │
      └────┬────┘
           ▼
      ┌──────────────────┐
      │SELF_IMPROVE      │
      │(suggestion only) │
      └──────┬───────────┘
             ▼
      ┌──────────────┐
      │   COMPLETE   │
      └──────────────┘
```

---

## BIẾN THEO DÕI (TRACKING VARIABLES)

```yaml
workflow:
  id: WF-20260723-001
  created_at: "2026-07-23T22:00:00Z"
  user_request: "$ARGUMENTS"
  step: 1-11
  step_name: analyze|design|review_design|plan|review_plan|backup|build|testplan|test|report|self_improve|complete
  status: running|blocked|waiting_user|cancelled|reviewing|building|testing|self_improving|completed|failed
  agent_current: null
  loop_type: null

  retry:
    review_design_count: 0-3
    review_plan_count: 0-3
    test_count: 0-3
    max_review: 3
    max_test: 3
    self_improve_count: 0-1

  error_history:
    review_design: []
    review_plan: []
    test_failures: []
    build_failures: []

  same_error_count: 0

  user_intervention: false
  backup_done: false
  rollback_enabled: true

  current_data:
    analysis: null
    design: null
    review_design_result: null
    plan: null
    review_plan_result: null
    build_result: null
    test_plan: null
    test_result: null
    self_improve_suggestions: null

  coverage:
    unit: null
    integration: null
    e2e: null
    requirement: null
```

---

## QUY TRÌNH CHI TIẾT

### Bước 1: Analyze
**Agent:** `analyst` (qua `/team-analyze`)

**Artifact:** `.opencode/workflows/{WF_ID}/01_analyze.md`

**Prompt** (xem `team-analyze.md`)

**Sau output:**
- Parse YAML output
- `NEED_MORE_INFO` → hỏi user, set `user_intervention: true`
- `READY` → lưu artifact, tăng step = 2

---

### Bước 2: Design
**Agent:** `designer` (triệu hồi trực tiếp)

**Đọc artifact:** `01_analyze.md`

**Artifact:** `.opencode/workflows/{WF_ID}/02_design.md`

**Prompt:**
```
Bạn là Designer Agent. Dựa trên phân tích, thiết kế giải pháp chi tiết.
Phân tích: {nội dung 01_analyze.md}

Output YAML:
- status: READY
- design: architecture, components[], data_flow, security_concerns[], edge_cases[]
```

---

### Bước 3: Review Design
**Agent:** `reviewer` (qua `/team-review`)

**Đọc artifact:** `02_design.md`

**Artifact:** `.opencode/workflows/{WF_ID}/03_review_design.md`

**Prompt** (xem `team-review.md` với context design)

**Sau output:**
- Parse YAML: `decision: APPROVED | CHANGES_REQUESTED | REJECTED`
- **APPROVED** → step = 4
- **CHANGES_REQUESTED** → kiểm tra retry + error_hash, quay lại Bước 2 nếu error mới
- **REJECTED** → failed, hỏi user

---

### Bước 4: Plan
**Agent:** `planner` (qua `/team-plan`)

**Đọc artifact:** `02_design.md`, `03_review_design.md`

**Artifact:** `.opencode/workflows/{WF_ID}/04_plan.md`

**Prompt** (xem `team-plan.md`)

---

### Bước 5: Review Plan
**Agent:** `reviewer` (qua `/team-review`)

**Đọc artifact:** `04_plan.md`

**Artifact:** `.opencode/workflows/{WF_ID}/05_review_plan.md`

**Sau output:** Tương tự Review Design (retry + error hash)

---

### Bước 6: Backup
**Hành động:** Orchestrator gọi Backup Utility (không tự backup thủ công)

**Điều kiện:** Chạy nếu plan có `requires_backup: true`

**Cách thực hiện:**
```powershell
$wfId = $workflow.id
$src = "path\to\file"
$timestamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$hash = (Get-FileHash $src -Algorithm SHA256).Hash.Substring(0,8)
$dest = ".opencode\workflows\$wfId\backup\$([System.IO.Path]::GetFileName($src))_${timestamp}_${hash}"
Copy-Item -LiteralPath $src -Destination $dest -Force
```

Lưu manifest tại `.opencode/workflows/{WF_ID}/backup/manifest.yaml`

---

### Bước 7: Build
**Agent:** `builder` (qua `/team-build`)

**Đọc artifact:** `04_plan.md`, `05_review_plan.md`

**Artifact:** `.opencode/workflows/{WF_ID}/07_build.md`

**Prompt** (xem `team-build.md`)

**Sau output:**
- **PASS** → step = 8
- **FAIL** → kiểm tra error_hash. Nếu trùng >= 2 lần → ROLLBACK. Nếu error mới → retry build.

---

### Bước 8: Test Plan
**Agent:** `test-planner` (qua `/team-testplan`)

**Đọc artifact:** `01_analyze.md`, `04_plan.md`, `07_build.md`

**Artifact:** `.opencode/workflows/{WF_ID}/08_testplan.md`

**Prompt** (xem `team-testplan.md`)

---

### Bước 9: Test
**Agent:** `tester` (qua `/team-test`)

**Đọc artifact:** `08_testplan.md`

**Artifact:** `.opencode/workflows/{WF_ID}/09_test.md`

**Prompt** (xem `team-test.md`)

**Sau output:**
- **PASS** → step = 10 (Report)
- **FAIL** → kiểm tra error_hash. Nếu trùng >= 2 → ROLLBACK. Nếu error mới và retry < 3 → quay Build.

---

### Bước 10: Report
**Hành động:** Orchestrator tổng hợp báo cáo

**Artifact:** `.opencode/workflows/{WF_ID}/10_report.md`

```markdown
## BÁO CÁO CUỐI CÙNG

### Thông tin workflow
| Thông số | Giá trị |
|----------|---------|
| Workflow ID | {workflow.id} |
| Yêu cầu | $ARGUMENTS |
| Số lần review design loop | {retry.review_design_count} |
| Số lần review plan loop | {retry.review_plan_count} |
| Số lần test-fix loop | {retry.test_count} |
| Backup | {"Đã thực hiện" / "Không cần"} |
| Rollback | {"Đã thực hiện" / "Không"} |
| Tổng số bước | 11 |

### File đã thay đổi
| File | Trạng thái |
|------|-----------|
| path/to/file1 | Thanh cong |

### Ket qua test
| Loai | PASS | FAIL | SKIP |
|------|------|------|------|
| Unit | 5 | 0 | 0 |
| **Tong** | **n** | **n** | **n** |

**Ty le PASS:** 100%

### Requirement Coverage
| Requirement | Status | Test case |
|-------------|--------|-----------|
| REQ-001 | PASS | TC-001 |

### Tong ket
**Hoan thanh** — Tat ca test PASS.

### Self-Improvement Suggestions
{current_data.self_improve_suggestions}
```

---

### Bước 11: Self-Improvement
**Agent:** `self-improver` (gọi trực tiếp)

**Điều kiện:** Chỉ chạy nếu workflow PASS

**Artifact:** `.opencode/workflows/{WF_ID}/11_self_improve.md`

**Prompt** (xem `team-selfimprove.md`)

**Lưu ý:** Self-improver chỉ tạo SUGGESTIONS, không ghi knowledge base trực tiếp. Cần review + approve trước khi áp dụng.

---

## SƠ ĐỒ QUYẾT ĐỊNH (DECISION TREE)

```yaml
analyze:
  NEED_MORE_INFO: → hoi_user
  READY: → design

design:
  READY: → review_design
  NEED_MORE_INFO: → hoi_user

review_design:
  APPROVED: → plan
  CHANGES_REQUESTED (retry < 3, error moi): → design
  CHANGES_REQUESTED (retry >= 3): → hoi_user
  CHANGES_REQUESTED (error trung): → hoi_user
  REJECTED: → hoi_user

plan:
  hop le: → review_plan
  rong/thieu: → yeu_cau_lam_lai

review_plan:
  APPROVED: → backup
  CHANGES_REQUESTED (retry < 3, error moi): → plan
  CHANGES_REQUESTED (retry >= 3): → hoi_user
  CHANGES_REQUESTED (error trung): → hoi_user
  REJECTED: → hoi_user

backup:
  can sua file cu: → backup → build
  chi tao moi: → build

build:
  all PASS: → testplan
  loi nhe, error moi: → sua, build lai
  loi nang: → hoi_user
  error trung (same_error >= 2): → rollback → failed

test:
  all PASS: → report
  FAIL (retry < 3, error moi): → build
  FAIL (retry >= 3): → hoi_user
  error trung (same_error >= 2): → rollback → failed

self_improve:
  PASS: → self_improve → complete
  FAIL: → complete (skip)

complete:
  → Ket thuc workflow
```

---

## TÍCH HỢP VỚI COMMANDS RIÊNG LẺ

| Buoc | Command | Agent | File command |
|------|---------|-------|-------------|
| 1 | `/team-analyze` | analyst | `team-analyze.md` |
| 2 | (goi truc tiep) | designer | `.opencode/agents/designer.md` |
| 3 | `/team-review` | reviewer | `team-review.md` |
| 4 | `/team-plan` | planner | `team-plan.md` |
| 5 | `/team-review` | reviewer | `team-review.md` |
| 7 | `/team-build` | builder | `team-build.md` |
| 8 | `/team-testplan` | test-planner | `team-testplan.md` |
| 9 | `/team-test` | tester | `team-test.md` |
| 11 | (goi tu team.md) | self-improver | `.opencode/agents/self-improver.md` |

---

## XU LY NGOAI LE

### Timeout
- Moi lan goi agent: toi da 120 giay
- Qua thoi gian: log timeout, hoi user

### User can thiep
- User gui thong tin moi: cap nhat artifact, tiep tuc tu buoc hien tai
- User yeu cau dung: set `status: cancelled`, bao cao tam thoi

### Loi goi agent
- Khong available: thu lai 1 lan sau 10s, van loi → hoi user
- Output sai format: yeu cau lam lai

### Rollback tu dong
- `same_error_count >= 2`: rollback tu dong
- `max_retry_reached`: hoi user truoc khi rollback

---

## GHI CHU

- Tao workflow ID ngay khi bat dau
- Luu artifact truoc khi chuyen buoc
- Tat ca agent output phai theo YAML contract
- Khi workflow hoan tat, output bao cao day du
