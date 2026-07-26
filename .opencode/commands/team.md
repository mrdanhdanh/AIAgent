---
description: Chạy toàn bộ team workflow: analyze → design/plan → review → backup → build → smoke test → testplan → test → self-improve
agent: general
---

## HELP — Hướng dẫn sử dụng `/team`

**Mục đích:** Chạy toàn bộ Dev Agent Team workflow tự động — Analyze → Design → Plan → Review → Backup → Build → Smoke Test → UI Audit → Test Plan → Test → Self-Improve → Complete.

**Cách dùng:** `/team <yêu cầu phát triển bằng ngôn ngữ tự nhiên>`

**Đầu vào:** Mô tả yêu cầu phát triển (tiếng Việt hoặc tiếng Anh), ví dụ: `/team Thêm chức năng reset password`

**Đầu ra:** Báo cáo cuối cùng gồm phân tích, kế hoạch, kết quả build, kết quả test, coverage, self-improvement suggestions.

**Các lệnh thành phần (chạy riêng lẻ):**
- `/team-analyze` — Phân tích yêu cầu
- `/team-plan` — Thiết kế + Lập kế hoạch
- `/team-review` — Đánh giá kế hoạch
- `/team-build` — Thực thi code
- `/team-ui-audit` — Kiểm tra UI
- `/team-testplan` — Lập kế hoạch test
- `/team-test` — Chạy kiểm thử
- `/team-selfimprove` — Đề xuất cải tiến
- `/team-gitguard` — Review security trước push
- `/team-gitpush` — Push an toàn lên git

**Xem thêm:** `.opencode/skills/dev-team/SKILL.md`

---

Bạn đang vận hành **Dev Agent Team** — orchestrator điều phối 7 agent chuyên biệt theo 12 bước.

Đọc tài liệu đầy đủ tại: `.opencode/skills/dev-team/SKILL.md`
Các lệnh thành phần: `/team-analyze`, `/team-plan`, `/team-review`, `/team-build`, `/team-ui-audit`, `/team-testplan`, `/team-test`

Yêu cầu: $ARGUMENTS

---

## WORKFLOW ID

Tạo workflow ID ngay khi bắt đầu: `WF-YYYYMMDD-NNN`.
Lưu vào biến `workflow.id` và dùng cho mọi artifact, backup, rollback, logging.

---

## MÔ HÌNH ORCHESTRATOR

Bạn là **General Agent** đóng vai trò orchestrator — chỉ đảm nhiệm orchestration và state management.

Trách nhiệm:
1. **Triệu hồi** đúng agent theo đúng bước
2. **Truyền context** — output bước trước là input bước sau
3. **Xử lý vòng lặp** — review loop, test-fix loop (tối đa 3 lần, kiểm tra same_error_count)
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
             │  BUILD  │ ◄──── nếu SMOKE/TEST FAIL
             └────┬────┘
                  ▼
             ┌───────────┐
             │SMOKE TEST │ ←── behavioral validation
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
         ┌──────────────┐
         │SELF_IMPROVE  │ ←── approval gate
         └──────┬───────┘
                ▼
         ┌────────────────┐
         │ WAITING_APPROVAL│
         └───────┬────────┘
           ┌─────┴─────┐
           │           │
           ▼           ▼
      ┌─────────┐ ┌──────────┐
      │APPROVED │ │ REJECTED │
      └────┬────┘ └────┬─────┘
           │            │
           ▼            ▼
      ┌─────────┐ ┌─────────┐
      │COMPLETE │ │COMPLETE │ (skip KB)
      └─────────┘ └─────────┘
```

---

## BIẾN THEO DÕI (TRACKING VARIABLES)

```yaml
workflow:
  id: "WF-{YYYYMMDD}-{NNN}"
  created_at: "2026-07-24T00:00:00Z"
  project: "JapaneseLearner"
  branch: "main"
  schema_version: "2.0"
  step: 1-11
  step_name: analyze|design|plan|review|backup|build|smoke_test|testplan|test|self_improve|complete
  status: running|blocked|completed|failed|waiting_user|cancelled|reviewing|building|testing|self_improving|waiting_approval
  retry:
    review_count: 0-3
    test_count: 0-3
    max_review: 3
    max_test: 3
    self_improve_count: 0-1
  user_intervention: false
  backup_done: false
  error_history:
    review: []
    test_failures: []
    build_failures: []
  same_error_count: 0
  coverage:
    thresholds:
      unit: 80
      integration: 60
      e2e: 50
      overall: 70
    mandatory: true
  current_data:
    analysis: null
    design: null
    plan: null
    review_result: null
    build_result: null
    smoke_test_result: null
    test_plan: null
    test_result: null
    self_improve_result: null
    final_report: null
```

---

## QUY TRÌNH CHI TIẾT

### Bước 1: Analyze
**Agent:** `analyst` (qua `/team-analyze`)

**Prompt** (xem `team-analyze.md`)

**Sau output:**
- Parse YAML output theo schema Analyst
- `status: NEED_MORE_INFO` → hỏi user, set `user_intervention: true`
- `status: READY` → lưu `current_data.analysis = output`, tăng `step = 2`

---

### Bước 2: Design
**Agent:** `planner` (mở rộng — qua `/team-plan`)

**Prompt:**
```
Bạn là Planner Agent (mở rộng). Dựa trên báo cáo phân tích, thiết kế giải pháp chi tiết.
Báo cáo: {current_data.analysis}

Yêu cầu Design:
1. Architecture: Mô tả kiến trúc tổng thể
2. Components: Liệt kê component cần tạo/sửa
3. Data flow: Luồng dữ liệu giữa các component
4. Security concerns: Các rủi ro bảo mật
5. Edge cases: Các trường hợp đặc biệt

Output: Contract YAML theo schema Planner (bao gồm design).
```

**Sau output:** Lưu `current_data.design = output`, tăng `step = 3`

---

### Bước 3: Plan
**Agent:** `planner` (tiếp — cùng agent Design, qua `/team-plan`)

**Prompt:**
```
Bạn là Planner Agent. Dựa trên thiết kế, lập kế hoạch thực thi chi tiết từng bước.
Thiết kế: {current_data.design}

Yêu cầu:
1. Mỗi bước có: Mô tả, File, Logic, Kiểm tra, Chunk (1-4)
2. Thứ tự: config → logic → test
3. Thêm rollback_strategy
4. Kết thúc bằng validate tổng thể

Output: Contract YAML theo schema Planner (cập nhật steps, rollback_strategy, validate).
```

**Sau output:** Lưu `current_data.plan = output`, tăng `step = 4`

**Kiểm tra:** Kế hoạch phải có ít nhất 1 bước — nếu không → yêu cầu làm lại.

---

### Bước 4: Review
**Agent:** `reviewer` (qua `/team-review`)

**Prompt** (xem `team-review.md`)

**Sau output:**
- **APPROVED** → Lưu `current_data.review_result = output`, tăng `step = 5`
- **CHANGES_REQUESTED** →
  - `retry.review_count++`
  - Nếu `retry.review_count < retry.max_review` và `same_error_count < 2` → Quay lại Bước 3 (Plan)
  - Nếu `retry.review_count >= retry.max_review` hoặc `same_error_count >= 2` → Dừng, set `status: blocked`
- **REJECTED** → Dừng, set `status: failed`

---

### Bước 5: Backup
**Hành động:** Orchestrator gọi **Backup Utility** script (không tự backup thủ công)

**Điều kiện:** Chạy nếu plan có `requires_backup: true` hoặc có file cũ cần sửa

**Cách thực hiện:**
```powershell
# Gọi Backup Utility (luôn dùng script, KHÔNG tự copy thủ công)
$backupScript = ".opencode\scripts\backup-utility.ps1"
$files = @("path/to/file1.cs", "path/to/file2.razor")  # từ plan
& $backupScript -files $files -workflowId "$($workflow.id)"
```

Backup Utility sẽ:
1. Copy từng file vào `.opencode/backup/<WF-ID>/` (giữ nguyên cấu trúc thư mục)
2. Tính SHA256 hash (12 ký tự đầu) cho mỗi file
3. Ghi manifest `05_backup_manifest.json`
4. Trả về báo cáo JSON

**Set:** `backup_done = true`

**Nếu chỉ tạo file mới:** Log "📝 Kế hoạch chỉ tạo file mới, không cần backup"

---

### Rollback (khi catastrophic failure)
Khi cần rollback, gọi **Rollback Utility**:
```powershell
$rollbackScript = ".opencode\scripts\rollback-utility.ps1"
& $rollbackScript -workflowId "$($workflow.id)" [-force]
```

---

### Bước 6: Build
**Agent:** `builder` (qua `/team-build`)

**Prompt** (xem `team-build.md`)

**Sau output:**
- **PASS** → tăng `step = 7`
- **FAIL + failure_type == MINOR** → Yêu cầu builder sửa
- **FAIL + failure_type == CRITICAL** → Kiểm tra same_error_count:
  - Nếu ≥ 2 → Catastrophic failure → ROLLBACK
  - Nếu < 2 → hỏi user

---

### Bước 7: Smoke Test
**Hành động:** Orchestrator chạy validation (không gọi agent)

**Các bước:**
1. Parse YAML frontmatter của SKILL.md → kiểm tra name, description, schema_version
2. Kiểm tra tất cả internal links (`#...`) có section tương ứng
3. Kiểm tra code block balance (số ``` mở = đóng)
4. Parse YAML samples trong Output Contract section
5. Simulate 1 workflow cycle: START → ANALYZE → DESIGN → PLAN → REVIEW → ... → COMPLETE

**Sau output:**
- **PASS** → tăng `step = 8`
- **FAIL** → `retry.test_count++`, quay lại Bước 6 nếu retry < 3

---

### Bước 8: Test Plan
**Agent:** `test-planner` (qua `/team-testplan`)

**Prompt** (xem `team-testplan.md`)

**Sau output:** Lưu `current_data.test_plan = output`, tăng `step = 9`

---

### Bước 9: Test
**Agent:** `tester` (qua `/team-test`)

**Prompt** (xem `team-test.md`)

**Sau output:**
- **APPROVED** (all PASS + coverage >= thresholds) → BÁO CÁO KẾT THÚC
- **NEEDS_FIX** →
  - `retry.test_count++`
  - Nếu `retry.test_count < retry.max_test` và `same_error_count < 2` → Quay lại Bước 6
  - Nếu `retry.test_count >= retry.max_test` hoặc `same_error_count >= 2` → Dừng, set `status: failed`

---

### Bước 10: Self-Improvement
**Agent:** `self-improver`

**Điều kiện:** Chỉ chạy nếu workflow PASS

**Prompt** (xem `team-selfimprove.md`)

**Approval Gate:**
- Self-Improver tạo suggestions vào artifact
- Set status = `waiting_approval`
- Hiển thị suggestions cho user
- User phản hồi: APPROVE | REJECT | MODIFY
- Auto-approve nếu `impact == LOW && requires_approval == false`

Set `step = 11`

---

### Bước 11: Complete

Kết thúc workflow, lưu workflow.json snapshot.

---

## SƠ ĐỒ QUYẾT ĐỊNH (DECISION TREE)

```yaml
analyze:
  output.status == NEED_MORE_INFO: → hoi_user
  output.status == READY: → design

design:
  output hop le (co design): → plan
  output rong/thieu: → yeu_cau_lam_lai

plan:
  output hop le (co steps): → review
  output thieu steps: → yeu_cau_lam_lai

review:
  decision == APPROVED: → backup
  decision == CHANGES_REQUESTED (retry < 3 && same_error < 2): → plan
  decision == CHANGES_REQUESTED (retry >= 3 OR same_error >= 2): → hoi_user
  decision == REJECTED: → hoi_user

backup:
  can sua file cu: → backup → build
  chi tao moi: → build

build:
  all PASS: → smoke_test
  FAIL + MINOR (same_error < 2): → sua, build lai
  FAIL + CRITICAL (same_error < 2): → hoi_user
  FAIL + same_error >= 2: → catastrophic → rollback

smoke_test:
  PASS: → testplan
  FAIL (retry < 3): → build
  FAIL (retry >= 3): → hoi_user

test:
  APPROVED (PASS + coverage dat): → report → self_improve
  NEEDS_FIX (retry < 3 && same_error < 2): → build
  NEEDS_FIX (retry >= 3 OR same_error >= 2): → hoi_user

self_improve:
  PASS: → self_improve → waiting_approval
  FAIL: → complete (skip)

waiting_approval:
  user APPROVE: → ghi knowledge → complete
  user REJECT: → skip → complete
  user MODIFY: → ghi knowledge (da sua) → complete

complete:
  → Luu workflow.json → Ket thuc
```

---

## TÍCH HỢP VỚI COMMANDS RIÊNG LẺ

| Buoc | Command | Agent | File command |
|------|---------|-------|-------------|
| 1 | `/team-analyze` | analyst | `team-analyze.md` |
| 2-3 | `/team-plan` | planner (mở rộng) | `team-plan.md` |
| 4 | `/team-review` | reviewer | `team-review.md` |
| 4.5 | `/team-gitguard` | guardian | `team-gitguard.md` |
| 6 | `/team-build` | builder | `team-build.md` |
| 7 | `/team-ui-audit` | ui-beautifier | `team-ui-audit.md` |
| 9 | `/team-testplan` | test-planner | `team-testplan.md` |
| 10 | `/team-test` | tester | `team-test.md` |
| 11 | (gọi từ team.md) | self-improver | `.opencode/agents/self-improver.md` |
| 12 | `/team-gitpush` | pusher | `team-gitpush.md` |

Không có command `/team-design` riêng — Design là phần mở rộng của Plan.

### GitGuard (Pre-Push Review)

Command `/team-gitguard` dùng **Guardian Agent** để review source code trước khi push lên git. Kiểm tra: secret leak, convention violation, security vulnerability, code quality, build/test. Output: PASS | BLOCKED | WARNING.

Xem thêm: `.opencode/skills/gitguard/SKILL.md`

### GitPush (Safe Push)

Command `/team-gitpush` dùng **Pusher Agent** để thực hiện git push an toàn với safety checks và confirmation gate. Quy trình:

1. **Git status analysis** — branch, remote, ahead/behind, staged/unstaged
2. **Safety checks** — secret scan, convention, security, code quality (clone GitGuard)
3. **Build validation** — `dotnet build`
4. **Test validation** — `dotnet test`
5. **Diff summary** — file changed, insertions, deletions
6. **Confirmation gate** — bảng tổng kết, user xác nhận Y/N
7. **Push execution** — `git push origin <branch>`
8. **Post-push verification** — xác nhận remote synced

Flags: `--skip-checks`, `--force`, `--branch <name>`, `--message "<msg>"` (fast path commit+push).

Xem thêm: `.opencode/skills/gitpush/SKILL.md`

---

## XỬ LÝ NGOẠI LỆ

### Timeout
- Mỗi lần gọi agent: tối đa 120 giây

### User can thiệp
- User gửi thông tin mới: cập nhật context, tiếp tục từ bước hiện tại
- User yêu cầu dừng: set `status: cancelled`, báo cáo tạm thời

### Lỗi gọi agent
- Không available: thử lại 1 lần sau 10s, vẫn lỗi → hỏi user
- Output sai format: yêu cầu làm lại

### Same error detection
- `same_error_count >= 2` → STOP, rollback

### Rollback tự động
```powershell
$backup_root = ".opencode\backup\$workflow_id"
# Đọc manifest và restore từng file
```

---

## GHI CHÚ

- Tạo workflow ID ngay khi bắt đầu
- Luôn validate frontmatter YAML sau mỗi lần sửa file .md
- Design phase do Planner đảm nhiệm với extended prompt
- Self-Improvement chỉ tạo suggestions, không ghi trực tiếp knowledge base
- Approval gate bắt buộc cho suggestion có impact MEDIUM/HIGH
- Backup/Rollback do Backup Utility thực hiện, Orchestrator chỉ gọi lệnh
- Khi workflow hoàn tất, output báo cáo đầy đủ và rõ ràng
