---
description: 'Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache. Tích hợp dry-run, backup trước khi xóa, confirmation gate.'
agent: cleaner
---

## HELP — Hướng dẫn sử dụng `/team-cleanup`

**Mục đích:** Dọn rác Workspace tự động — giải phóng dung lượng ổ đĩa, giữ workspace sạch sẽ.

**Cách dùng:** `/team-cleanup [flags]`

**Flags:**
- `--dry-run` — Chỉ xem trước, không xóa gì
- `--force` — Bỏ qua confirmation gate, tự động xóa
- `--keep-backup <N>` — Giữ lại N workflow backup gần nhất (mặc định: 5)
- `--aggressive` — Chế độ mạnh: xóa cả NuGet cache, dotnet temp
- `--target <type>` — Chỉ dọn loại rác cụ thể (build|backup|temp|cache|log|all)
- `--older-than <days>` — Chỉ xóa file cũ hơn N ngày

**Vị trí trong workflow:** Chạy standalone hoặc tích hợp vào dev-team workflow (bước 0 hoặc cuối).

Xem thêm: `.opencode/skills/workspace-cleaner/SKILL.md`
