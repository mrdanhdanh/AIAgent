---
name: git-history
description: Phân tích lịch sử git — ai sửa, khi nào, lý do, commit nào. Dùng git log, git blame. Nếu không có git history → trả thông báo không crash. Sử dụng trong /knowledge-why.
schema_version: "1.0"
---

# Git History — Skill

## TỔNG QUAN

Skill truy vấn lịch sử git của dự án để trả lời: Ai sửa file này? Khi nào? Lý do gì? Commit nào?

## LỆNH SỬ DỤNG

| Mục đích | Lệnh |
|----------|------|
| Lịch sử file | `git log --oneline -10 -- <file>` |
| Chi tiết commit | `git log -1 --format="%H %an %ad %s" --date=iso -- <file>` |
| Ai sửa dòng nào | `git blame -L <start>,<end> -- <file>` |
| Đổi theo commit | `git log --oneline -- <file> | Select -First 1` |

## QUY TRÌNH

1. **Kiểm tra git repo** — `git rev-parse --is-inside-work-tree` (nếu fail → "Không có git history")
2. **Tìm file** — xác định đường dẫn chính xác
3. **git log file** — lấy commits + author + date + message
4. **git blame** (nếu cần dòng cụ thể) — xác định ai sửa dòng X
5. **Tóm tắt** — nhóm theo commit, rút lý do từ commit message

## ĐỊNH DẠNG ĐẦU RA

```yaml
git_available: true
repository: "JapaneseLearner (master)"
commits:
  - { hash: "91bdafe", author: "unknown", date: "2026-07-30", message: "fix: Fix AdminTests, HomePageTests and WordStudyTests", file: "JapaneseLearner.Tests/AdminTests.cs" }
  - { hash: "91eac55", author: "unknown", date: "2026-07-30", message: "fix(opencode): Fix 12 files in opencode", file: "opencode.json" }
recent_activity: "30 commits gần nhất chủ yếu fix tests + opencode files"
notable_commits:
  - { hash: "9bfe30b", message: "fix: Fix 61 files", note: "Đợt sửa lớn" }
```

## QUY TẮC

- Chỉ trả thông tin có trong git — không suy đoán lý do
- Ghi rõ author nếu có (repo local có thể không cấu hình)
- Commit message là nguồn chính cho "lý do"

## XỬ LÝ NGOẠI LỆ

- Không phải git repo → `git_available: false` + "Không có git history"
- File chưa commit (untracked) → ghi "File mới chưa có lịch sử git"
- git command fail (permission/lock) → trả lỗi + gợi ý chạy lại
