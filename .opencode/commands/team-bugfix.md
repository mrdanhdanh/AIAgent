---
description: Quy trình nhận và fix bug — nhận báo cáo → tái hiện bug → root cause → đề xuất chỉnh sửa → kiểm tra sau sửa → test bUnit + E2E → báo cáo. Dùng agent general (orchestrator) + agents chuyên biệt
agent: general
model: opencode-go/mimo-v2.5
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/team-bugfix`

**Mục đích:** Chạy toàn bộ quy trình nhận và fix bug theo chuẩn Red → Green → Verify — đảm bảo bug được **tái hiện bằng test trước khi sửa**, **fix đúng nguyên nhân gốc** (root cause), **kiểm tra sau sửa** và **test bUnit + E2E** trước khi hoàn tất.

**Cách dùng:** `/team-bugfix <mô tả bug: hiện tượng, bước tái hiện, màn hình/module, expected vs actual, mức độ>`

**Đầu vào:** Mô tả bug bằng ngôn ngữ tự nhiên (tiếng Việt/tiếng Anh), ví dụ:
- `/team-bugfix Khi học từ vựng ở /words, bấm nút Next liên tục làm quiz bị treo. Mong đợi: chuyển câu tiếp theo. Thực tế: màn hình đứng yên, không có lỗi console. Mức độ P1`
- `/team-bugfix --reproduce-only Trang /kanji/5 không hiển thị chi tiết, chỉ có loading spinner mãi`

**Đầu ra:** Báo cáo fix bug hoàn chỉnh gồm: kết quả tái hiện, root cause, fix đã áp dụng, kết quả kiểm tra sau sửa, kết quả test bUnit + E2E, coverage.

**Các lệnh thành phần (chạy riêng lẻ):**
- `/team-analyze` — Phân tích phạm vi bug (impact scope)
- `/team-analyze-failure` — Normalize + classify lỗi từ log/exception
- `/team-root-cause` — Phân tích nguyên nhân gốc, sinh hypotheses
- `/team-build` — Thực thi fix code
- `/team-testplan` — Lập kế hoạch test (regression + reproduce test)
- `/team-test` — Chạy kiểm thử (bUnit)
- `/test-e2e` — Chạy/test E2E Playwright
- `/team-gitguard` — Review security trước push (nếu commit)
- `/team-bug-learn` — **Học từ bug vừa fix** (Learning Pipeline 1 lệnh: ghi failure record + sinh lessons/patterns) — chạy sau khi fix xong

**Xem thêm:** `.opencode/skills/dev-team/SKILL.md`, `.opencode/skills/playwright-e2e/SKILL.md`, `.opencode/skills/playwright-component/SKILL.md`

---

Bạn đang vận hành **Bug-Fix Pipeline** — orchestrator điều phối agents chuyên biệt theo 6 phase.

Đọc tài liệu đầy đủ tại: `.opencode/skills/dev-team/SKILL.md`

## WORKFLOW ID

Tạo workflow ID ngay khi bắt đầu: `BUG-YYYYMMDD-NNN` (ví dụ: `BUG-20260801-001`).
Lưu vào biến `workflow.id` và dùng cho mọi artifact, backup, rollback, logging.

---

## MÔ HÌNH ORCHESTRATOR

Bạn là **General Agent** đóng vai trò orchestrator — chỉ đảm nhiệm orchestration và state management.

Trách nhiệm:
1. **Triệu hồi** đúng agent theo đúng phase
2. **Truyền context** — output phase trước là input phase sau
3. **Xử lý vòng lặp** — reproduce-fix loop, test-fix loop (tối đa 3 lần, kiểm tra same_error_count)
4. **Theo dõi trạng thái** — biến phase, retry_count, status, error_history
5. **Quyết định** — tiếp tục, retry, rollback, dừng, hoặc hỏi người dùng

---

## MÁY TRẠNG THÁI (BUG-FIX STATE MACHINE)

```
                ┌──────────┐
                │  START   │
                └────┬─────┘
                     ▼
              ┌─────────────┐
              │ PHASE 0     │
              │ NHẬN BUG    │ ◄─── thiếu thông tin → hỏi user
              └─────┬───────┘
                    ▼
              ┌─────────────┐
              │ PHASE 1     │
              │ TÁI HIỆN    │──┐
              └─────┬───────┘  │ (không tái hiện → thu thập thêm → hỏi user)
                    ▼           │
              ┌─────────────┐   │
              │ PHASE 2     │   │
              │ ROOT CAUSE  │   │
              │ + ĐỀ XUẤT   │   │
              └─────┬───────┘   │
                    ▼           │
        ┌──── CHỜ USER DUYỆT ──┤
        │   APPROVE | REJECT   │
        └────┬─────────────────┘
             ▼
        ┌───────────┐
        │ PHASE 3   │ ◄── nếu test tái hiện vẫn FAIL (retry < 3)
        │ FIX (GREEN)│
        └─────┬─────┘
              ▼
        ┌───────────┐
        │ PHASE 4   │
        │ KIỂM TRA  │ ◄── regression trong module
        └─────┬─────┘
              ▼
        ┌───────────┐
        │ PHASE 5   │
        │ bUnit+E2E │ ◄── FAIL → quay lại PHASE 3
        └─────┬─────┘
              ▼
        ┌───────────┐
        │ PHASE 6   │
        │ BÁO CÁO   │
        │ +LEARNING │
        └─────┬─────┘
              ▼
         ┌────────┐
         │COMPLETE│
         └────────┘
```

---

## BIẾN THEO DÕI (TRACKING VARIABLES)

```yaml
workflow:
  id: "BUG-{YYYYMMDD}-{NNN}"
  created_at: "2026-08-01T00:00:00Z"
  project: "JapaneseLearner"
  branch: "main"
  phase: 0-6
  phase_name: receive|reproduce|root_cause|fix|verify|test|report
  status: running|blocked|completed|failed|waiting_user|waiting_approval
  retry:
    reproduce_count: 0-3
    test_count: 0-3
    max_retry: 3
  user_intervention: false
  backup_done: false
  same_error_count: 0
  error_history:
    reproduce_failures: []
    test_failures: []
    build_failures: []
  current_data:
    bug_report: null
    reproduction_test: null
    reproduce_result: null
    root_cause: null
    fix_proposal: null
    build_result: null
    verify_result: null
    test_result: null
    final_report: null
```

---

## BUG REPORT INPUT (ĐỊNH DẠNG CHUẨN)

Parse `$ARGUMENTS` và chuẩn hóa thành cấu trúc sau — **thiếu field bắt buộc → `NEEDS_MORE_INFO`, hỏi user**:

```yaml
bug_report:
  title: "Tóm tắt ngắn bug"
  module: "words | kanji | grammar | alphabet | practice | admin | other"
  screen: "Tên màn hình / route (vd: /words, /kanji/{Id})"
  severity: "P0 (crash/block) | P1 (high) | P2 (normal) | P3 (low)"
  description: "Mô tả hiện tượng lỗi"
  steps_to_reproduce:
    - "Bước 1"
    - "Bước 2"
  expected: "Hành vi mong đợi"
  actual: "Hành vi thực tế"
  environment: "browser/OS (nếu biết)"
  evidence: "log/exception/screenshot (nếu có)"
```

**Field bắt buộc:** `title`, `module`, `description`, `expected`, `actual`.
**Nếu thiếu `steps_to_reproduce`** → ước lượng từ `description` + `module`, ghi rõ "giả định".

---

## QUY TRÌNH CHI TIẾT (6 PHASE)

### PHASE 0: NHẬN BUG (Receive)

**Hành động:** Orchestrator tự parse + validate input.

1. Parse `$ARGUMENTS` theo format chuẩn ở trên
2. Kiểm tra field bắt buộc (`title`, `module`, `description`, `expected`, `actual`)
3. Thiếu → `status: waiting_user`, hỏi user bổ sung chính xác từng field thiếu
4. Đủ → gán severity mặc định `P2` nếu không khai báo, tăng `phase = 1`

**Output:** `current_data.bug_report` chuẩn hóa.

---

### PHASE 1: TÁI HIỆN BUG (Reproduce — RED)

**Nguyên tắc:** Không sửa code trước khi tái hiện được bug bằng test. Bug chưa tái hiện = chưa xác nhận tồn tại.

**Hành động:**
1. **Xác định loại test tái hiện phù hợp** (dựa trên `module` + `screen`):
   - Bug logic/service → **bUnit component test** (`.opencode/skills/playwright-component/SKILL.md`)
   - Bug UI/tương tác → **E2E Playwright** (`.opencode/skills/playwright-e2e/SKILL.md`)
   - Bug service/dữ liệu → **xUnit unit test** (`JapaneseLearner.Tests/`)
2. **Viết failing test** mô phỏng đúng `steps_to_reproduce` — test này phải FAIL (RED) vì bug còn tồn tại:
   - `JapaneseLearner.Tests/` — dùng `BunitTestBase` cho component test
   - `JapaneseLearner.E2ETests/` — dùng `AppFixture` (port 5173, KHÔNG đổi)
3. **Chạy test tái hiện**:
   ```powershell
   dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj --filter "FullyQualifiedName~<TênTestTáiHiện>"
   dotnet test JapaneseLearner.E2ETests\JapaneseLearner.E2ETests.csproj --filter "FullyQualifiedName~<TênTestTáiHiện>"
   ```
4. **Đánh giá kết quả:**
   - **Test FAIL đúng chỗ (bug tái hiện)** → ghi nhận, tăng `phase = 2`
   - **Test PASS (không tái hiện được)** → `reproduce_count++`, thu thập thêm evidence (log, bước cụ thể hơn), hỏi user. Nếu `reproduce_count >= 3` → `status: blocked`, yêu cầu user cung cấp thêm thông tin.
   - **Test FAIL nhưng sai vị trí** (lỗi khác) → ghi nhận, phân tích tiếp, có thể là bug khác.

**Output:** `current_data.reproduction_test` (file + tên test), `current_data.reproduce_result`.

---

### PHASE 2: ROOT CAUSE + ĐỀ XUẤT CHỈNH SỬA

**Hành động:**
1. **Phân tích nguyên nhân gốc** (gọi `root-cause-agent` — quy trình `/team-root-cause`):
   - Input: error từ test tái hiện + context codebase
   - Output: hypotheses ranked by confidence, `most_likely`, `fix_suggestion`
2. **Xác định file bị ảnh hưởng** (impact scope — tương tự `/team-analyze`):
   - File chứa logic lỗi
   - File test cần tạo/sửa
3. **Xây dựng fix proposal** chi tiết:

```yaml
fix_proposal:
  root_cause: "Mô tả nguyên nhân gốc"
  evidence:
    - file: "path/to/file.cs"
      line: 42
      snippet: "code gây lỗi"
  hypothesis_confidence: 0.85
  proposed_changes:
    - file: "path/to/file.cs"
      action: "MODIFY"
      logic: "Mô tả thay đổi cụ thể"
      requires_backup: true
    - file: "JapaneseLearner.Tests/ReproduceTests.cs"
      action: "CREATE"
      logic: "Test tái hiện (đã viết ở Phase 1)"
      requires_backup: false
  risk_assessment: "low | medium | high"
  alternative_fixes:
    - "Cách fix khác (nếu có)"
```

4. **Trình user duyệt (APPROVAL GATE):**
   - Hiển thị root cause + proposed_changes
   - User chọn: `APPROVE` → Phase 3 | `REJECT` → dừng, trả report | `MODIFY` → sửa proposal

**Output:** `current_data.root_cause`, `current_data.fix_proposal`.

---

### PHASE 3: FIX (GREEN)

**Hành động:**
1. **Backup file trước khi sửa** — gọi Backup Utility (KHÔNG tự copy thủ công):
   ```powershell
   $backupScript = ".opencode\scripts\backup-utility.ps1"
   $files = @("path/to/file.cs")  # từ fix_proposal.proposed_changes (action=MODIFY)
   & $backupScript -action save -files $files -workflowId "$($workflow.id)"
   ```
   - `requires_backup: true` + backup thất bại → DỪNG NGAY (CRITICAL)
   - File mới (CREATE) → không cần backup
2. **Thực thi fix** theo `proposed_changes` (gọi `builder` — quy trình `/team-build`):
   - Chỉ sửa đúng file trong proposal
   - Tuân thủ convention dự án (FluentUI, DI, tri-state rendering, cache-first)
3. **Chạy lại test tái hiện**:
   - Test tái hiện **PASS** (GREEN) → bug đã fix, tăng `phase = 4`
   - Test tái hiện vẫn **FAIL** → `test_count++`, phân tích lỗi mới/giống (same_error_count), quay lại Phase 2/3:
     - `same_error_count >= 2` → catastrophic → ROLLBACK (gọi `rollback-utility.ps1`)
     - `test_count >= 3` → dừng, hỏi user

**Output:** `current_data.build_result`.

---

### PHASE 4: KIỂM TRA SAU SỬA (Verify)

**Hành động:**
1. **Regression trong module** — chạy toàn bộ test liên quan đến module bị ảnh hưởng:
   ```powershell
   dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj
   ```
2. **Kiểm tra tác động phụ** — xác nhận fix không vỡ tính năng khác:
   - Chạy test của các component/service cùng module
   - Xem xét impact scope từ Phase 2 (INDIRECT files)
3. **Đánh giá:**
   - Regression PASS + không phát hiện tác động phụ → tăng `phase = 5`
   - Regression FAIL → quay lại Phase 3, kèm lỗi cụ thể

**Output:** `current_data.verify_result`.

---

### PHASE 5: TEST bUnit + E2E

**Hành động:** Chạy toàn bộ bộ test theo thứ tự **unit trước, E2E sau**:

```powershell
# 1. bUnit + xUnit unit tests (fast, no server)
dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj

# 2. E2E Playwright (AppFixture auto-start dev server, port 5173)
dotnet test JapaneseLearner.E2ETests\JapaneseLearner.E2ETests.csproj
```

**Lưu ý:**
- Port 5173 hardcode trong `AppFixture.cs` — KHÔNG đổi
- Browser path hardcode trong `PlaywrightFixture.cs:24` — fail trên máy khác (báo warning nếu gặp)
- E2E dùng collection `E2E` (`DisableParallelization = true`) — chạy tuần tự
- Timeout mỗi test: 60s

**Đánh giá kết quả:**
- **bUnit PASS + E2E PASS** → tăng `phase = 6`
- **bUnit FAIL** → quay lại Phase 3 (fix logic)
- **E2E FAIL** → phân tích: flaky (retry 1 lần) hay bug thật → quay lại Phase 3 nếu bug thật
- **Coverage** ≥ ngưỡng mặc định (unit ≥ 80, integration ≥ 60) — không đạt → ghi warning, đề xuất thêm test

**Output:** `current_data.test_result`.

---

### PHASE 6: BÁO CÁO + LEARNING

**Hành động:**
1. **Tổng hợp báo cáo fix bug** theo Output Contract (bên dưới)
2. **Ghi failure record + học từ bug** — gọi **`/team-bug-learn`** (1 lệnh duy nhất, tổng hợp failure → root-cause → learning → self-improve):
   ```powershell
   /team-bug-learn "<error message hoặc file log>" --task "<mô tả task>" --root-cause "<nguyên nhân>" --fix "<fix đã áp dụng>"
   ```
   - Lệnh này tự chạy `failure-analyzer.ps1` (deterministic hash) → ghi `BUG-{NNNN}.md` → sinh lessons/patterns → đề xuất cải tiến
   - **Bắt buộc:** chạy `/team-bug-learn` sau khi fix thành công — đây là cơ chế tự học của hệ thống
   - Nếu bug lặp lại (error_hash trùng) → lệnh dedup, cập nhật attempts thay vì tạo record mới
3. **Đề xuất cải tiến** (nếu có): pattern lặp lại, anti-pattern (do `/team-bug-learn` STEP 4 trả về)
4. **Set `status: completed`**, lưu `workflow.json` snapshot

---

## ĐỊNH DẠNG ĐẦU RA (YAML CONTRACT — BÁO CÁO FINAL)

```yaml
status: "COMPLETE | BLOCKED | FAILED"
workflow_id: "BUG-20260801-001"
summary: "Tóm tắt: bug đã fix, root cause, kết quả test"
bug_report:
  title: "..."
  module: "..."
  severity: "P1"
reproduce:
  test_file: "JapaneseLearner.Tests/ReproduceTests.cs"
  test_name: "QuizNext_ShouldAdvance_WhenClicked"
  result_before_fix: "FAIL (RED — bug tái hiện)"
  result_after_fix: "PASS (GREEN)"
root_cause:
  description: "Nguyên nhân gốc"
  evidence_file: "path/to/file.cs"
  evidence_line: 42
fix_applied:
  - file: "path/to/file.cs"
    action: "MODIFY"
    description: "Mô tả fix"
  - file: "JapaneseLearner.Tests/ReproduceTests.cs"
    action: "CREATE"
    description: "Test tái hiện"
verify:
  regression_result: "PASS"
  affected_components: ["WordQuiz"]
test_results:
  bunit:
    total: 42
    passed: 42
    failed: 0
    coverage_unit: 85
    thresholds_met: true
  e2e:
    total: 8
    passed: 8
    failed: 0
    note: "E2E pass — chạy trên máy có browser path hợp lệ"
  overall_coverage: 83
next_steps:
  - "Chạy /team-gitguard trước khi commit (nếu cần)"
issues: []
```

---

## FLAGS

**Flags:**

| Flag | Mô tả |
|------|-------|
| `--reproduce-only` | Chỉ chạy Phase 0-1 (tái hiện bug), dừng sau khi xác nhận RED |
| `--fix-only` | Bỏ qua Phase 1 (tái hiện), vào thẳng Phase 2-3 (dùng khi đã có test thất bại sẵn) |
| `--skip-e2e` | Bỏ Phase 5 E2E (chạy nhanh, chỉ bUnit) |
| `--skip-bunit` | Bỏ Phase 5 bUnit (chỉ E2E) |
| `--quick` | Rút gọn: bỏ approval gate Phase 2 nếu `hypothesis_confidence >= 0.9` và risk = low |
| `--auto-approve` | Tự duyệt fix proposal (bỏ approval gate) — chỉ dùng khi user tin tưởng pipeline |

---

## VALIDATION CHECKLIST PER PHASE

```yaml
phase_0_receive:
  - "Bug report có đủ title, module, description, expected, actual?"
  - "Thiếu field → status waiting_user + hỏi user?"
phase_1_reproduce:
  - "Đã viết failing test trước khi sửa code?"
  - "Test chạy FAIL đúng vị trí (RED) chưa?"
  - "Không tái hiện được → đã thu thập thêm evidence?"
phase_2_root_cause:
  - "Root cause có hypothesis_confidence không?"
  - "Fix proposal có file, action, logic, requires_backup?"
  - "Đã qua approval gate (trừ --quick/--auto-approve)?"
phase_3_fix:
  - "File MODIFY đã backup qua backup-utility.ps1?"
  - "Chỉ sửa đúng file trong proposal?"
  - "Test tái hiện PASS (GREEN)?"
  - "Mỗi lỗi có error_type, error_normalized, error_hash, retryable?"
phase_4_verify:
  - "Regression trong module PASS?"
  - "Không có tác động phụ (INDIRECT files)?"
phase_5_test:
  - "bUnit test PASS?"
  - "E2E test PASS (hoặc SKIP có lý do)?"
  - "Coverage ≥ ngưỡng (unit 80, integration 60)?"
phase_6_report:
  - "Báo cáo đầy đủ root cause, fix, test results?"
  - "workflow.json snapshot đã lưu?"
```

---

## XỬ LÝ NGOẠI LỆ

| Tình huống | Xử lý |
|------------|-------|
| Bug không tái hiện được | `reproduce_count++`, hỏi user thêm evidence; ≥ 3 lần → BLOCKED |
| User từ chối fix proposal | Dừng, trả report, `status: failed` |
| Backup thất bại | DỪNG NGAY, CRITICAL, không sửa file |
| Test tái hiện vẫn FAIL sau fix | `same_error_count >= 2` → ROLLBACK; `test_count >= 3` → hỏi user |
| E2E fail do môi trường (browser path) | SKIP + ghi warning, không tính FAIL |
| User gửi thông tin mới | Cập nhật bug_report, tiếp tục từ phase hiện tại |
| User yêu cầu dừng | `status: cancelled`, trả báo cáo tạm thời |

---

## Output Contract

```yaml
output:
  status: "COMPLETE | BLOCKED | FAILED"
  workflow_id: "BUG-YYYYMMDD-NNN"
  reproduce_result: "RED (bug tái hiện) | GREEN (bug đã fix)"
  root_cause: "nguyên nhân gốc"
  fix_applied: []
  verify: "PASS | FAIL"
  test_bunit: { total: 0, passed: 0, failed: 0 }
  test_e2e: { total: 0, passed: 0, failed: 0 }
  coverage: "0%"
  recommendation: "next steps"
```

---

## GHI CHÚ

- Tạo workflow ID `BUG-YYYYMMDD-NNN` ngay khi bắt đầu
- Luôn tái hiện bug bằng test TRƯỚC khi sửa (nguyên tắc Red → Green)
- Backup/Rollback do Backup Utility thực hiện, orchestrator chỉ gọi lệnh
- Chạy unit test trước E2E
- Không đổi port 5173 (hardcode trong AppFixture.cs)
- Khi workflow hoàn tất, output báo cáo đầy đủ theo YAML contract
