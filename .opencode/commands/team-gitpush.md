---
description: Auto-commit từ diff, pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, xác nhận user, push lên remote
agent: pusher
---

## THAM SỐ

$ARGUMENTS

Hỗ trợ các flag:
- `--skip-checks`: Bỏ qua safety checks, chỉ push
- `--force`: Force push (xác nhận kép)
- `--branch <name>`: Push lên branch cụ thể
- `--message "<msg>"`: Ghi đè commit message
- `--no-commit`: Bỏ qua auto-commit, chỉ push commit đã có (ahead > 0 mới push)
- `--cur`: Chỉ stage file có unstaged changes (`git add -u` thay vì `git add -A`), bỏ qua untracked files

Script utility tại `.opencode\scripts\gitpush-utility.ps1` xử lý toàn bộ logic. Agent gọi script và parse kết quả.
