---
name: dev-team
description: Hướng dẫn sử dụng Dev Agent Team gồm 6 agent. Dùng khi cần phân tích, lập kế hoạch, đánh giá, code, kiểm thử một yêu cầu phát triển. Sử dụng câu lệnh team hoặc team-*.
---

# Dev Agent Team

Team gồm 6 agent chuyên biệt phối hợp theo quy trình phát triển phần mềm hoàn chỉnh:
**Analyze → Plan → Review → Build → Test Plan → Test**

## Mục lục

- [Vai trò các Agent](#vai-trò-các-agent)
- [Quyền hạn chi tiết](#quyền-hạn-chi-tiết)
- [Các lệnh](#các-lệnh)
- [Luồng làm việc (Workflow)](#luồng-làm-việc-workflow)
- [Cơ chế phối hợp (Inter-Agent Communication)](#cơ-chế-phối-hợp-inter-agent-communication)
- [Cấu trúc file agents](#cấu-trúc-file-agents)
- [Ví dụ sử dụng](#ví-dụ-sử-dụng)
- [Xử lý lỗi (Troubleshooting)](#xử-lý-lỗi-troubleshooting)
- [Best Practices](#best-practices)
- [Glossary](#glossary)

---

## Vai trò các Agent

| Agent | File | Vai trò chính | Đầu ra (output) |
|-------|------|---------------|-----------------|
| **Analyst** | `.opencode/agents/analyst.md` | Phân tích yêu cầu, xác định phạm vi, rủi ro, task con | Báo cáo phân tích markdown |
| **Planner** | `.opencode/agents/planner.md` | Lập kế hoạch thực thi chi tiết theo từng bước | Kế hoạch thực thi từng bước |
| **Reviewer** | `.opencode/agents/reviewer.md` | Đánh giá, phản biện kế hoạch | Phản hồi (APPROVED / CHANGES_REQUESTED / REJECTED) |
| **Builder** | `.opencode/agents/builder.md` | Thực thi kế hoạch, viết code, tạo/sửa file | Kết quả thực thi + file đã thay đổi |
| **Test-Planner** | `.opencode/agents/test-planner.md` | Tạo kế hoạch kiểm thử chi tiết | Kế hoạch test (test cases) |
| **Tester** | `.opencode/agents/tester.md` | Thực thi kiểm thử, validate, báo cáo kết quả | Báo cáo test PASS/FAIL |

## Quyền hạn chi tiết

| Agent | Đọc file | Tìm file (glob) | Tìm nội dung (grep) | Sửa file | Chạy lệnh |
|-------|----------|-----------------|---------------------|----------|-----------|
| **Analyst** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Planner** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Reviewer** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Builder** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Test-Planner** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Tester** | ✅ | ✅ | ✅ | ❌ | ✅ (chỉ test) |

> **Ghi chú:** Builder có toàn quyền (read/write/execute) vì là người thực thi thay đổi.
> Tester được chạy bash nhưng không được sửa file (chỉ chạy lệnh test).
> Analyst/Planner/Reviewer/Test-Planner là read-only.

## Các lệnh

### Lệnh chính

| Lệnh | Mô tả | Argument |
|------|-------|----------|
| `/team <yêu cầu>` | Chạy toàn bộ workflow 6 bước | Yêu cầu phát triển (text) |
| `/team-analyze <yêu cầu>` | Chỉ chạy bước phân tích | Yêu cầu cần phân tích |
| `/team-plan <báo cáo>` | Chỉ lập kế hoạch | Báo cáo phân tích từ Analyst |
| `/team-review <kế hoạch>` | Chỉ đánh giá kế hoạch | Kế hoạch từ Planner |
| `/team-build <kế hoạch>` | Chỉ thực thi code | Kế hoạch đã APPROVED |
| `/team-testplan <thông tin>` | Chỉ tạo kế hoạch test | Phân tích + Kế hoạch + Kết quả build |
| `/team-test <kế hoạch test>` | Chỉ chạy kiểm thử | Kế hoạch test từ Test-Planner |

### Cách dùng từng lệnh

**`/team` — Full workflow:**
```
/team "Thêm API đăng ký người dùng với email và mật khẩu"
```
Kết quả: Phân tích → Kế hoạch → Review → Build → Test Plan → Test → Báo cáo

**`/team-analyze` — Chỉ phân tích:**
```
/team-analyze "Tìm hiểu cấu trúc dự án React hiện tại"
```
Dùng khi bạn chỉ muốn hiểu codebase mà chưa muốn thay đổi.

**`/team-plan` — Chỉ lập kế hoạch:**
```
/team-plan "Báo cáo: ... (dán output từ /team-analyze)"
```
Dùng khi bạn muốn tự xem xét báo cáo trước khi lập kế hoạch.

**`/team-review` — Chỉ đánh giá:**
```
/team-review "Kế hoạch: ... (dán output từ /team-plan)"
```
Dùng khi bạn muốn đánh giá kế hoạch thủ công.

**`/team-build` — Chỉ build:**
```
/team-build "Kế hoạch: ... (dán output đã APPROVED)"
```
Dùng khi kế hoạch đã được duyệt, chỉ cần thực thi.

## Luồng làm việc (Workflow)

### Full workflow

```
User Request "/team <yêu cầu>"
        │
        ▼
┌─────────────────────────────────────────┐
│  Bước 1: Analyze                        │
│  Agent: analyst                         │
│  Hành động: Đọc codebase, phân tích     │
│  Đầu ra: Báo cáo phân tích              │
│  Nếu không rõ: Hỏi lại người dùng       │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Bước 2: Plan                           │
│  Agent: planner                         │
│  Hành động: Lập kế hoạch từng bước      │
│  Đầu ra: Kế hoạch thực thi              │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Bước 3: Review                         │
│  Agent: reviewer                        │
│  Hành động: Đánh giá kế hoạch           │
│  Đầu ra: Phản hồi                       │
│                                         │
│  Kết quả:                               │
│  ├── APPROVED ──────► tiếp tục          │
│  ├── CHANGES_REQUESTED ──► quay lại 2   │
│  └── REJECTED ──────────► dừng, báo cáo │
└────────────────┬────────────────────────┘
                 │ (APPROVED)
                 ▼
┌─────────────────────────────────────────┐
│  Bước 4: Backup                         │
│  Hành động: Sao lưu file sẽ sửa         │
│  Đích: .opencode/backup/                │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Bước 5: Build                          │
│  Agent: builder                         │
│  Hành động: Sửa/tạo file theo kế hoạch  │
│  Đầu ra: File đã thay đổi + báo cáo     │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Bước 6: Test Plan                      │
│  Agent: test-planner                    │
│  Hành động: Tạo test cases              │
│  Đầu ra: Kế hoạch test                 │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Bước 7: Test                           │
│  Agent: tester                          │
│  Hành động: Chạy test, ghi nhận         │
│  Đầu ra: Báo cáo test PASS/FAIL         │
│                                         │
│  Nếu FAIL ──────────► quay lại Bước 5   │
│  Nếu PASS ──────────► báo cáo cuối      │
└────────────────┬────────────────────────┘
                 │ (PASS)
                 ▼
        BÁO CÁO KẾT QUẢ
```

### Workflow rút gọn (dùng lệnh riêng lẻ)

```
/team-analyze → [Analyst] → Báo cáo phân tích
/team-plan    → [Planner] → Kế hoạch
/team-review  → [Reviewer]→ Phản hồi
/team-build   → [Builder] → Code
/team-testplan→ [TP]      → Test plan
/team-test    → [Tester]  → Test report
```

## Cơ chế phối hợp (Inter-Agent Communication)

Các agent giao tiếp qua **output text** (không ghi file tạm, không dùng biến môi trường):

```
Analyst ──(báo cáo phân tích)──► Planner ──(kế hoạch)──► Reviewer
                                                            │
                                              (CHANGES_REQUESTED)
                                                            │
                                              ◄─────────────┘
                                                            │ (APPROVED)
                                                            ▼
                                                       Builder ──(kết quả)──► Test-Planner
                                                                                 │
                                                                           (test plan)
                                                                                 │
                                                                                 ▼
                                                                             Tester ──(báo cáo)──► User
```

### Chi tiết từng luồng:

1. **Analyst → Planner**: Báo cáo phân tích dạng markdown có cấu trúc
2. **Planner → Reviewer**: Kế hoạch thực thi từng bước
3. **Reviewer → Planner**: Phản hồi APPROVED/CHANGES_REQUESTED kèm góp ý cụ thể
4. **Planner → Builder**: Kế hoạch đã APPROVED
5. **Builder → Test-Planner**: Kết quả thực thi + file đã thay đổi
6. **Test-Planner → Tester**: Kế hoạch test chi tiết
7. **Tester → User**: Báo cáo PASS/FAIL

## Cấu trúc file agents

```
.opencode/
├── agents/                          # Định nghĩa 6 agent
│   ├── analyst.md                   # Phân tích yêu cầu
│   ├── planner.md                   # Lập kế hoạch
│   ├── reviewer.md                  # Đánh giá kế hoạch
│   ├── builder.md                   # Thực thi code
│   ├── test-planner.md              # Lập kế hoạch test
│   └── tester.md                    # Chạy kiểm thử
├── commands/                        # Lệnh gọi agent
│   ├── team.md                      # Full workflow (general agent)
│   ├── team-analyze.md              # Chỉ chạy analyst
│   ├── team-plan.md                 # Chỉ chạy planner
│   ├── team-review.md               # Chỉ chạy reviewer
│   ├── team-build.md                # Chỉ chạy builder
│   ├── team-testplan.md             # Chỉ chạy test-planner
│   └── team-test.md                 # Chỉ chạy tester
├── skills/dev-team/
│   └── SKILL.md                     # Tài liệu này
└── backup/                          # Backup tự động (tạo bởi builder)
    ├── agents/
    ├── commands/
    └── skills/
```

## Ví dụ sử dụng

### Ví dụ 1: Full workflow

```bash
/team "Thêm validation cho form đăng ký: kiểm tra email hợp lệ, password >= 8 ký tự"
```

Kết quả mong đợi:
1. Analyst đọc codebase, tìm file form đăng ký
2. Planner lập kế hoạch thêm validation rules
3. Reviewer kiểm tra kế hoạch
4. Builder thêm code validation
5. Test-Planner tạo test cases
6. Tester chạy test, báo cáo PASS/FAIL

### Ví dụ 2: Chỉ phân tích

```bash
/team-analyze "Xem xét cấu trúc dự án hiện tại và đề xuất cải tiến kiến trúc"
```

### Ví dụ 3: Kết hợp thủ công

```bash
# Bước 1: Phân tích
/team-analyze "Thêm dark mode cho ứng dụng"

# Lấy output, xem xét, rồi:
/team-plan "Báo cáo: [dán output]"

# Lấy output kế hoạch, xem xét, rồi:
/team-review "Kế hoạch: [dán output]"

# Nếu APPROVED:
/team-build "Kế hoạch: [dán output]"
```

### Ví dụ 4: Xử lý vòng lặp review

```bash
# Lần 1: Planner tạo kế hoạch
/team-plan "Báo cáo: ..."

# Lần 2: Reviewer yêu cầu sửa
/team-review "Kế hoạch: ..."  → CHANGES_REQUESTED

# Lần 3: Planner sửa theo góp ý
/team-plan "Báo cáo: ... \n\n Góp ý của reviewer: ..."

# Lần 4: Reviewer duyệt
/team-review "Kế hoạch: ..."  → APPROVED
```

## Xử lý lỗi (Troubleshooting)

### Lỗi thường gặp

| Vấn đề | Nguyên nhân | Cách xử lý |
|--------|-------------|------------|
| Analyst không tìm thấy file | Codebase quá lớn, không biết tìm ở đâu | Chạy lại với hướng dẫn cụ thể hơn |
| Planner tạo kế hoạch không khả thi | Thiếu thông tin về codebase | Chạy `/team-analyze` chi tiết hơn trước |
| Reviewer REJECTED | Kế hoạch sai hướng | Đọc lại phân tích, hỏi người dùng nếu cần |
| Builder edit thất bại | Nội dung file đã thay đổi so với kế hoạch | Đọc lại file thực tế, báo cáo Planner |
| Builder gặp lỗi syntax | Code sai cú pháp | Sửa lỗi, chạy lại |
| Test FAIL | Code sai logic hoặc thiếu edge case | Quay lại Builder sửa, chạy lại test |
| Tester không có framework | Dự án chưa có test | Chạy test thủ công hoặc yêu cầu setup |

### Error Recovery Flow

```
Phát hiện lỗi
    │
    ▼
┌─────────────────────────────────────┐
│  Lỗi nhẹ (syntax, lint)            │
│  → Tự động sửa, chạy lại           │
└─────────────────────────────────────┘
    │
    ▼ (nếu không tự sửa được)
┌─────────────────────────────────────┐
│  Lỗi vừa (logic sai, thiếu file)   │
│  → Báo cáo, dừng bước hiện tại     │
│  → Gợi ý hướng xử lý               │
└─────────────────────────────────────┘
    │
    ▼ (nếu cần thay đổi kế hoạch)
┌─────────────────────────────────────┐
│  Lỗi nặng (sai hướng, kế hoạch sai)│
│  → Dừng toàn bộ workflow            │
│  → Báo cáo người dùng               │
│  → Đề xuất bước tiếp theo           │
└─────────────────────────────────────┘
```

### Cờ báo động (Red Flags)

Những dấu hiệu cần dừng lại và hỏi người dùng:
- Kế hoạch sửa > 10 files cùng lúc
- Kế hoạch xóa file không có backup
- Builder phát hiện secret/token trong code
- Test có > 50% FAIL
- Workflow chạy quá lâu (> 30 phút)

## Best Practices

1. **Luôn backup trước khi build**: Builder tự động backup vào `.opencode/backup/`
2. **Review kỹ trước khi build**: Reviewer là bước quan trọng nhất
3. **Chạy từng bước riêng lẻ khi cần**: Dùng `/team-analyze` trước nếu không chắc chắn
4. **Kiểm tra codebase trước**: Nếu dự án mới, chạy `/team-analyze` để hiểu cấu trúc
5. **Test kỹ edge cases**: Đừng chỉ test happy path
6. **Ghi chép lại**: Luôn đọc kết quả từng bước trước khi chuyển sang bước tiếp theo
7. **Không ngại REJECTED**: Reviewer REJECTED là tốt — tránh lãng phí thời gian build sai
8. **Tái sử dụng output**: Output từ bước trước là input cho bước sau

### Khi nào nên dùng full workflow vs từng bước

| Tình huống | Nên dùng |
|------------|----------|
| Yêu cầu rõ ràng, nhỏ (< 3 files) | `/team` full workflow |
| Yêu cầu phức tạp, nhiều rủi ro | Từng bước: analyze → xem xét → plan → review → build |
| Codebase mới, chưa hiểu rõ | `/team-analyze` trước |
| Đã có kế hoạch từ trước | `/team-build` hoặc `/team-review` |
| Bug fix nhanh | `/team` full workflow (nhanh) |

## Glossary

| Thuật ngữ | Giải thích |
|-----------|------------|
| **Agent** | Một AI chuyên biệt với vai trò cụ thể trong team |
| **Workflow** | Quy trình 6 bước từ phân tích đến kiểm thử |
| **Frontmatter** | Phần YAML giữa `---` ở đầu file `.md`, chứa metadata |
| **Subagent** | Agent con được gọi từ agent khác (general agent gọi subagent) |
| **Inter-Agent Communication** | Cơ chế truyền output giữa các agent qua text |
| **$ARGUMENTS** | Biến chứa input người dùng truyền vào lệnh |
| **APPROVED/CHANGES_REQUESTED/REJECTED** | 3 kết quả review |
| **PASS/FAIL/SKIP** | 3 kết quả test |
| **Backup** | Sao lưu file trước khi sửa, lưu ở `.opencode/backup/` |
| **Edge case** | Trường hợp đặc biệt, đầu vào biên, dễ gây lỗi |
| **Happy path** | Luồng chính, đầu vào hợp lệ, không lỗi |
| **Breaking change** | Thay đổi không tương thích ngược, cần migration |
| **Regression** | Lỗi phát sinh do thay đổi mới làm hỏng tính năng cũ |
