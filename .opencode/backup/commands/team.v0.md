---
description: Chạy toàn bộ team workflow: analyze → plan → review → build → testplan → test
agent: general
---

Bạn đang vận hành **Dev Agent Team** — orchestrator điều phối 6 agent chuyên biệt.

Đọc tài liệu đầy đủ tại: `.opencode/skills/dev-team/SKILL.md`
Các lệnh thành phần: `/team-analyze`, `/team-plan`, `/team-review`, `/team-build`, `/team-testplan`, `/team-test`

Yêu cầu: $ARGUMENTS

---

## MÔ HÌNH ORCHESTRATOR

Bạn là **General Agent** đóng vai trò orchestrator. Trách nhiệm:
1. **Triệu hồi** đúng agent theo đúng bước
2. **Truyền context** — output bước trước là input bước sau
3. **Xử lý vòng lặp** — review loop, test-fix loop (tối đa 3 lần)
4. **Theo dõi trạng thái** — biến step, retry_count, status
5. **Quyết định** — tiếp tục, retry, dừng, hoặc hỏi người dùng

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
             │ BACKUP  │   │  PLAN   │ (quay lại)
             └────┬────┘   └─────────┘
                  │
                  ▼
             ┌─────────┐
             │  BUILD  │ ◄──── nếu TEST FAIL (retry < 3)
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
         ┌────────┐ ┌────────┐
         │ PASS   │ │ FAIL   │ ───► quay lại BUILD (retry < 3)
         └───┬────┘ └────────┘
             ▼
        ┌─────────┐
        │ REPORT  │
        └─────────┘
```

---

## BIẾN THEO DÕI (TRACKING VARIABLES)

Duy trì các biến sau xuyên suốt workflow:

```yaml
workflow:
  step: 1-7                          # Bước hiện tại
  step_name: analyze|plan|review|backup|build|testplan|test|report
  status: running|blocked|completed|failed
  retry:
    review_count: 0-3                # Số lần review loop
    test_count: 0-3                  # Số lần test-fix loop
    max_review: 3
    max_test: 3
  user_intervention: false           # true nếu đang chờ người dùng
  backup_done: false                 # true nếu đã backup
  current_data:
    analysis: null                   # Output từ analyst
    plan: null                       # Output từ planner
    review_result: null              # Phản hồi từ reviewer
    build_result: null               # Kết quả từ builder
    test_plan: null                  # Kế hoạch test
    test_result: null               # Kết quả test
```

---

## QUY TRÌNH CHI TIẾT

### Bước 1: Analyze
**Agent:** `analyst` (gọi qua `/team-analyze` hoặc triệu hồi trực tiếp)

**Prompt:**
```
Bạn là Analyst Agent. Phân tích yêu cầu sau, đọc codebase, xác định phạm vi, rủi ro, task con.

Yêu cầu: $ARGUMENTS

Hãy dùng glob/grep/read để hiểu cấu trúc dự án.
Output: Báo cáo phân tích markdown.
Kết luận: READY hoặc NEED_MORE_INFO.
```

**Sau output:**
- `NEED_MORE_INFO` → Hỏi người dùng, set `user_intervention: true`, chờ phản hồi
- `READY` → Lưu `current_data.analysis = output`, tăng `step = 2`

**Edge case:** Nếu analyst output quá ngắn (< 100 từ) → yêu cầu phân tích lại chi tiết hơn

---

### Bước 2: Plan
**Agent:** `planner` (gọi qua `/team-plan` hoặc triệu hồi trực tiếp)

**Prompt:**
```
Bạn là Planner Agent. Dựa trên báo cáo phân tích, lập kế hoạch thực thi chi tiết từng bước.

Báo cáo:
{current_data.analysis}

Yêu cầu:
1. Mỗi bước có: Mô tả, File, Logic, Kiểm tra
2. Thứ tự: config → logic → test
3. Có bước backup nếu sửa file cũ
4. Kết thúc bằng validate tổng thể
```

**Sau output:** Lưu `current_data.plan = output`, tăng `step = 3`

**Kiểm tra:** Kế hoạch phải có ít nhất 1 bước — nếu không → yêu cầu làm lại

---

### Bước 3: Review
**Agent:** `reviewer` (gọi qua `/team-review` hoặc triệu hồi trực tiếp)

**Prompt:**
```
Bạn là Reviewer Agent. Đánh giá kế hoạch sau theo 5 tiêu chí: Đầy đủ, Chính xác, An toàn, Hiệu quả, Kiểm thử.

Kế hoạch:
{current_data.plan}

Kết luận: APPROVED / CHANGES_REQUESTED / REJECTED (kèm lý do và gợi ý).
```

**Sau output:**
- **APPROVED** → Lưu `current_data.review_result = output`, tăng `step = 4`, log "✅ Kế hoạch đã được duyệt"
- **CHANGES_REQUESTED** →
  - `retry.review_count++`
  - Nếu `retry.review_count < retry.max_review` → Quay lại Bước 2, kèm góp ý:
    ```
    Planner cập nhật kế hoạch theo góp ý của reviewer:
    {output từ reviewer}
    ```
  - Nếu `retry.review_count >= retry.max_review` → Dừng, báo:
    ```
    ⛔ Đã đạt giới hạn review ({retry.max_review} lần).
    Plan hiện tại:
    {current_data.plan}
    
    Góp ý cuối cùng từ reviewer:
    {output}
    
    Cần người dùng can thiệp để quyết định.
    ```
    Set `status: blocked`, `user_intervention: true`

- **REJECTED** → Dừng, báo:
  ```
  ⛔ Kế hoạch bị REJECTED bởi reviewer.
  Lý do: {output}
  Cần người dùng đưa ra hướng tiếp cận khác.
  ```
  Set `status: failed`, `user_intervention: true`

---

### Bước 4: Backup (trước khi Build)
**Hành động:** Chạy trên orchestrator (không gọi agent)

**Điều kiện:** Chỉ chạy nếu `current_data.plan` có chứa thao tác sửa file cũ

**Cách thực hiện:**
1. Phân tích plan để trích xuất danh sách file cần sửa
2. Với mỗi file:
   ```powershell
   if (Test-Path -LiteralPath "path\to\file") {
       $dest = ".opencode\backup\" + "path\to\file"
       $parent = Split-Path $dest -Parent
       New-Item -ItemType Directory -Path $parent -Force
       Copy-Item -LiteralPath "path\to\file" -Destination $dest -Force
       Write-Output "✅ Backup: path\to\file"
   } else {
       Write-Output "⚠️ File không tồn tại, bỏ qua: path\to\file"
   }
   ```
3. Set `backup_done = true`

**Nếu chỉ tạo file mới:** Log "📝 Kế hoạch chỉ tạo file mới, không cần backup"

---

### Bước 5: Build
**Agent:** `builder` (gọi qua `/team-build` hoặc triệu hồi trực tiếp)

**Prompt:**
```
Bạn là Builder Agent. Thực thi kế hoạch đã duyệt sau đây.

Kế hoạch:
{current_data.plan}

Yêu cầu:
1. Backup file trước khi sửa (nếu cần)
2. Làm đúng từng bước trong kế hoạch
3. Kiểm tra syntax/lint sau mỗi bước
4. Báo cáo kết quả từng bước (PASS/FAIL)
5. Nếu gặp vấn đề: dừng, báo cáo chi tiết
```

**Sau output:** Lưu `current_data.build_result = output`, tăng `step = 6`

**Kiểm tra:**
- Nếu tất cả bước PASS → tiếp tục
- Nếu có FAIL → Phân loại:
  - **Lỗi nhẹ** (syntax, lint, typo): Yêu cầu builder sửa:
    ```
    Builder sửa các lỗi sau và chạy lại:
    {chi tiết lỗi}
    ```
  - **Lỗi nặng** (logic sai, thiếu file, kế hoạch sai): Dừng, báo:
    ```
    ⛔ Lỗi nặng trong quá trình build:
    {chi tiết}
    
    Cần người dùng quyết định: sửa kế hoạch hoặc can thiệp thủ công.
    ```
    Set `status: blocked`, `user_intervention: true`

---

### Bước 6: Test Plan
**Agent:** `test-planner` (gọi qua `/team-testplan` hoặc triệu hồi trực tiếp)

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
1. Xác định loại test: Unit, Integration, E2E, Edge cases, Error handling
2. Mỗi test case có: ID, Mô tả, Input, Expected, File test
3. Ưu tiên test tự động hóa
4. Kiểm tra regression
5. Xác định framework test hiện tại (dùng glob/grep)
```

**Sau output:** Lưu `current_data.test_plan = output`, tăng `step = 7`

---

### Bước 7: Test
**Agent:** `tester` (gọi qua `/team-test` hoặc triệu hồi trực tiếp)

**Prompt:**
```
Bạn là Tester Agent. Thực thi kế hoạch kiểm thử sau đây.

Kế hoạch test:
{current_data.test_plan}

Yêu cầu:
1. Chạy từng test case, ghi nhận PASS/FAIL/SKIP
2. Với FAIL: ghi rõ lỗi, stack trace, input gây lỗi
3. Với SKIP: ghi rõ lý do
4. Timeout mỗi test: 60 giây
5. Kết luận: APPROVED hoặc NEEDS_FIX
```

**Sau output:** Lưu `current_data.test_result = output`

**Xử lý kết quả:**
- **PASS (tất cả PASS)** → Chuyển sang BÁO CÁO KẾT THÚC
- **FAIL (có 1+ FAIL)** →
  - `retry.test_count++`
  - Nếu `retry.test_count < retry.max_test` → Quay lại Bước 5 (Build) với:
    ```
    Builder sửa các lỗi test sau và build lại:
    {chi tiết FAIL từ tester}
    
    Kế hoạch gốc:
    {current_data.plan}
    ```
  - Nếu `retry.test_count >= retry.max_test` → Dừng, báo:
    ```
    ⛔ Đã đạt giới hạn test-fix loop ({retry.max_test} lần).
    Lỗi còn tồn đọng:
    {chi tiết FAIL}
    
    Cần người dùng can thiệp.
    ```
    Set `status: failed`, `user_intervention: true`

---

## BÁO CÁO KẾT THÚC

Sau khi workflow hoàn tất (PASS), tổng hợp báo cáo:

```markdown
## 📋 BÁO CÁO CUỐI CÙNG

### Yêu cầu gốc
$ARGUMENTS

### Thông tin workflow
| Thông số | Giá trị |
|----------|---------|
| Số lần review loop | {retry.review_count} |
| Số lần test-fix loop | {retry.test_count} |
| Backup | {"Đã thực hiện" / "Không cần"} |
| Tổng số bước | 7 |

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

### Tổng kết
✅ **Hoàn thành** — Tất cả test PASS, sẵn sàng cho production.
```

### Nếu workflow thất bại (blocked/failed)

```markdown
## ⛔ BÁO CÁO THẤT BẠI

### Yêu cầu gốc
$ARGUMENTS

### Dừng ở bước
Bước {step}: {step_name}

### Lý do
{chi tiết}

### Trạng thái hiện tại
| Biến | Giá trị |
|------|---------|
| retry.review_count | {n} |
| retry.test_count | {n} |
| backup_done | {true/false} |

### Đề xuất
{đề xuất hành động cho người dùng}
```

---

## SƠ ĐỒ QUYẾT ĐỊNH (DECISION TREE)

```yaml
analyze:
  output == NEED_MORE_INFO: → hỏi_user
  output == READY: → plan

plan:
  output hợp lệ (có bước): → review
  output rỗng/thiếu: → yêu_cầu_làm_lại

review:
  APPROVED: → backup
  CHANGES_REQUESTED (retry < 3): → plan (kèm góp ý)
  CHANGES_REQUESTED (retry >= 3): → hỏi_user
  REJECTED: → hỏi_user

backup:
  plan có sửa file cũ: → backup → build
  plan chỉ tạo mới: → build

build:
  all PASS: → testplan
  lỗi nhẹ (syntax): → sửa, build lại
  lỗi nặng: → hỏi_user

test:
  all PASS: → report
  FAIL (retry < 3): → build (kèm báo lỗi)
  FAIL (retry >= 3): → hỏi_user
```

---

## TÍCH HỢP VỚI COMMANDS RIÊNG LẺ

Orchestrator có thể gọi từng agent riêng qua command files:

| Bước | Command | Agent | File command |
|------|---------|-------|-------------|
| 1 | `/team-analyze` | analyst | `team-analyze.md` |
| 2 | `/team-plan` | planner | `team-plan.md` |
| 3 | `/team-review` | reviewer | `team-review.md` |
| 5 | `/team-build` | builder | `team-build.md` |
| 6 | `/team-testplan` | test-planner | `team-testplan.md` |
| 7 | `/team-test` | tester | `team-test.md` |

Khi gọi các command này, nội dung command file sẽ là input đầy đủ cho agent.
Orchestrator có thể dùng chúng thay vì viết prompt thủ công.

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

---

## VÍ DỤ CHẠY WORKFLOW

```
User: /team "Thêm validation email cho form đăng ký"

Orchestrator:
  step=1, agent=analyst
  → Gửi prompt phân tích
  ← Nhận báo cáo: form ở /src/components/RegisterForm.jsx
  
  step=2, agent=planner
  → Gửi prompt lập kế hoạch
  ← Nhận kế hoạch: 3 bước (thêm validate, update UI, test)
  
  step=3, agent=reviewer
  → Gửi prompt đánh giá
  ← APPROVED ✅
  
  step=4, backup
  → Backup RegisterForm.jsx → .opencode/backup/
  
  step=5, agent=builder
  → Gửi prompt build
  ← ✅ Thành công: 3/3 bước PASS
  
  step=6, agent=test-planner
  → Gửi prompt test plan
  ← 5 test cases (2 unit, 2 edge, 1 regression)
  
  step=7, agent=tester
  → Gửi prompt test
  ← ✅ 5/5 PASS
  
  → BÁO CÁO KẾT THÚC
```

---

## GHICHÚ

- Có thể chạy từng bước riêng bằng các lệnh `/team-*`
- Luôn validate frontmatter YAML sau mỗi lần sửa file .md
- Nếu workflow bị block ở bước nào, cung cấp đủ thông tin để người dùng biết:
  - Đang ở bước nào
  - Output hiện tại là gì
  - Cần quyết định gì
- Khi workflow hoàn tất, output báo cáo phải đầy đủ và rõ ràng