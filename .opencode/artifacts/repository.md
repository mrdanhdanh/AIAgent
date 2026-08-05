---
name: artifact-repository
description: Artifact Repository — storage layer; đọc/ghi file artifact, compute checksum, không logic.
agent: general
---

# Artifact Repository

## 1. Vai trò

Lớp storage — **chỉ đọc/ghi file**. Không biết metadata/lineage.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Save(path, content)` | ghi file mới |
| `Read(path)` | đọc nội dung file |
| `Checksum(path)` | SHA256 của file |
| `Exists(path)` | file tồn tại? |
| `Size(path)` | byte size |
| `Move(old, new)` | di chuyển/rename |
| `List(type, workflow)` | liệt kê file theo type |

## 3. Path convention

```
workflow/WF-{id}/artifacts/{type}/{id}_v{version}.md
```

Ví dụ: `workflow/WF-0421/artifacts/plan/PLAN-001_v2.md`

## 4. Không chứa logic

Repository **không biết**:
- Artifact type, id, status.
- Version nào là mới nhất.
- Dependency hay lineage.

Tất cả logic đó thuộc **Manager**.

## 5. Checksum integrity

- Compute SHA256 khi save → lưu trong metadata.
- Lưu `artifacts/checksum.json` (index id → checksum).
- Doctor verify checksum → phát hiện file bị sửa tay.

## 6. Tương tác

- `manager.md` — gọi repository.
- `checksum.md` — integrity check.
- `cache.md` — cache content hash.