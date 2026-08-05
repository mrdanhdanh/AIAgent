---
name: artifact-versioning
description: Artifact Versioning — version increment, history log, immutable content.
agent: general
---

# Artifact Versioning

## 1. Nguyên tắc

- **Không overwrite** — mỗi thay đổi tạo version mới.
- Version = integer tăng dần (1, 2, 3...).
- File path: `{id}_v{version}.md`.

## 2. History

`artifacts/history.json`:
```json
{
  "PLAN-001": [
    { "version": 1, "checksum": "sha256:abc", "updated_at": "...", "updated_by": "planner" },
    { "version": 2, "checksum": "sha256:def", "updated_at": "...", "updated_by": "planner" }
  ]
}
```

## 3. Diff

Giữa version giúp Context Engine chỉ gửi diff (xem `diff.md`).

## 4. Get latest

Manager.Get(id) luôn trả latest version; Manager.Version(id, v) trả version cụ thể.

## 5. Rollback

Không có "rollback" true; tạo version mới copy nội dung từ version cũ. Giữ lịch sử đầy đủ.