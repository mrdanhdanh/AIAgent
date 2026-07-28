---
description: Chạy toàn bộ team workflow: analyze → plan → review → build → testplan → test
agent: general
---

Bạn đang vận hành **Dev Agent Team**. Đọc skill tại `.opencode/skills/dev-team/SKILL.md` để biết chi tiết vai trò từng agent.

Yêu cầu: $ARGUMENTS

## QUY TRÌNH

### Bước 1: Analyze
Dùng agent **analyst** với lời nhắc:
"Phân tích yêu cầu sau trong ngữ cảnh dự án hiện tại: $ARGUMENTS"

Đợi kết quả phân tích. Nếu cần thêm thông tin, hỏi lại người dùng.

### Bước 2: Plan
Dùng agent **planner** với lời nhắc:
"Dựa trên báo cáo phân tích sau, lập kế hoạch thực thi chi tiết:\n\n{output từ analyst}"

### Bước 3: Review
Dùng agent **reviewer** với lời nhắc:
"Đánh giá kế hoạch sau:\n\n{output từ planner}"

- Nếu CHANGES_REQUESTED: quay lại Bước 2 với góp ý của reviewer
- Nếu REJECTED: dừng lại, báo cáo người dùng
- Nếu APPROVED: tiếp tục

### Bước 4: Backup (trước khi Build)
Backup các file sẽ bị thay đổi (dùng bash để copy vào `.opencode/backup/`). Chỉ thực hiện nếu kế hoạch có sửa file.

### Bước 5: Build
Dùng agent **builder** với lời nhắc:
"Thực thi kế hoạch đã duyệt:\n\n{output từ planner}"

### Bước 6: Test Plan
Dùng agent **test-planner** với lời nhắc:
"Tạo kế hoạch kiểm thử cho tính năng vừa phát triển.\n\nPhân tích: {output từ analyst}\nKế hoạch: {output từ planner}\nKết quả build: {output từ builder}"

### Bước 7: Test
Dùng agent **tester** với lời nhắc:
"Thực thi kế hoạch kiểm thử:\n\n{output từ test-planner}"

- Nếu FAIL: quay lại Bước 5 (Build) để sửa lỗi

### Kết thúc
Tổng hợp báo cáo cuối cùng gồm:
- Yêu cầu gốc
- Phân tích
- Kế hoạch (kết quả review)
- File đã thay đổi
- Kết quả test (PASS/FAIL)
- Kết luận

## Ghi chú
- Có thể chạy từng bước riêng bằng `/team-analyze`, `/team-plan`, `/team-review`, `/team-build`, `/team-testplan`, `/team-test`
- Luôn validate frontmatter YAML sau mỗi lần sửa file .md
