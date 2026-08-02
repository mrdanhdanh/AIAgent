---
name: artifact-manager
description: Artifact Manager — CRUD API + version control. Không đọc file trực tiếp; qua Repository.
agent: general
---

# Artifact Manager

## 1. API

| Method | Vai trò |
|--------|---------|
| `Create(type, content, metadata)` | Tạo artifact mới (v1, status=created) |
| `Get(id)` | Đọc artifact (metadata + content reference) |
| `Update(id, content)` | Tạo version mới, không overwrite |
| `Archive(id)` | status → archived |
| `Delete(id)` | status → deleted (soft delete) |
| `History(id)` | List versions |
| `Version(id, v)` | Get specific version |

## 2. Create flow

1. Validate type (types.yaml).
2. Generate id (PREFIX-NNN).
3. Write content → repository.
4. Compute checksum (SHA256).
5. Save metadata → index.
6. Set lineage (parent nếu có).
7. Return artifact object.

## 3. Version flow

1. Read current artifact.
2. Write new content → repository (không overwrite).
3. Bump version.
4. Save history entry (old version metadata).
5. Update index với version mới.

## 4. Lineage on create

```yaml
# Khi planner tạo PLAN-001 từ REQ-001:
id: PLAN-001
lineage:
  created_by: planner
  parent: REQ-001
  derived_from: [REQ-001]
  workflow: WF-0421
```

## 5. Dependency tracking

- Khi Builder `consumed_by` liên kết qua `depends_on`.
- Manager tự cập nhật `consumed_by` khi artifact mới ref id này.

## 6. Tương tác

- `repository.md` — storage.
- `indexing.md` — metadata store.
- `validator.md` — validation before save.
- `contract.md` — agent produce/consume.