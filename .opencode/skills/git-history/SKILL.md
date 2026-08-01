---
name: git-history
description: Truy vấn lịch sử git — ai sửa, khi nào, lý do, commit nào. Dùng git log/blame. Dùng trong /why, /ask.
schema_version: "1.0"
---

# Git History — Truy Vấn Lịch Sử

Skill chuyên truy vấn lịch sử git để trả lời "ai sửa", "khi nào", "tại sao", "commit nào".

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [CÁC LỆNH CHÍNH](#các-lệnh-chính)
- [QUY TRÌNH](#quy-trình)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Truy vấn lịch sử git của file/symbol — phục vụ trả lời lý do thay đổi và quyết định thiết kế.

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/why <component>` | Giải thích lý do tồn tại (kết hợp git history) |
| `/ask <câu hỏi>` | Hỏi về lịch sử thay đổi |

---

## CÁC LỆNH CHÍNH

```powershell
# Lịch sử commit của file
git log --oneline -- <path>

# Ai sửa từng dòng (blame)
git blame <path> --line-porcelain

# Chi tiết commit
git show <hash> --stat

# Tìm commit theo từ khóa
git log --oneline --grep="từ khóa"
```

---

## QUY TRÌNH

### Bước 1: Kiểm tra git repo
```powershell
git rev-parse --is-inside-work-tree
```
Nếu không phải repo git → `status: NO_GIT`.

### Bước 2: Xác định file/symbol
Dùng index hoặc input để xác định file liên quan.

### Bước 3: Truy vấn lịch sử
- `git log` cho file → danh sách commit
- `git blame` → ai sửa dòng nào
- `git show` → chi tiết thay đổi + message (lý do)

### Bước 4: Trả lời
Tổng hợp: ai sửa, khi nào, commit nào, lý do (từ commit message).

---

## OUTPUT CONTRACT

```yaml
status: "READY | NO_GIT | NOT_FOUND"
summary: "Tóm tắt lịch sử git"
target: "File/symbol được truy vấn"
git_info:
  repo_root: "Đường dẫn repo"
  branch: "Tên branch"
history:
  - commit: "hash"
    author: "Tên tác giả"
    date: "YYYY-MM-DD"
    message: "Nội dung commit"
    files_changed: ["file1", "file2"]
blame_highlights:
  - line: 42
    commit: "hash"
    author: "Tên"
    date: "YYYY-MM-DD"
    code: "Nội dung dòng"
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Đúng dữ liệu git**: Không bịa author/date/commit hash.
2. **NO_GIT**: Nếu không có repo → báo rõ, không trả lời rỗng.
3. **Lý do từ commit message**: Không suy đoán ý định — đọc message.
4. Dùng `--` trước path để tránh nhầm flag.
