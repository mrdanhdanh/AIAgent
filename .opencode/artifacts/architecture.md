---
name: artifact-architecture
description: architecture — kiến trúc Artifact Store (3 lớp Content/Metadata/Lineage), data flow, store interface.
agent: general
---

# Artifact Store — Architecture

## 1. 3 lớp

```text
                    Artifact
                        │
        ┌───────────────┼───────────────┐
        │               │               │
     Content         Metadata        Lineage
   (plan.md)      (id, type, v)   (parent, derived)
```

### Content
Nội dung thực — file storage. Không bị sửa trực tiếp; thay đổi = tạo version mới.

### Metadata
Thông tin quản lý — tra cứu không cần mở file:
- id, type, version, status
- checksum (SHA256), size, path
- tags, created_at, updated_at, capability

### Lineage
Nguồn gốc + quan hệ — tạo DAG traceability:
- workflow, phase, created_by (agent)
- parent, derived_from, consumed_by, superseded_by

## 2. Store Interface

```text
              Artifact Store
                    │
        ┌───────────┼───────────┐
        │           │           │
      Index      Repository   Version
   (metadata)   (content)    (history)
```

- **Index**: map id → metadata (JSON, in-memory cache).
- **Repository**: đọc/ghi file content.
- **Version**: phiên bản hóa artifact.

## 3. Data Flow

```text
Agent produce artifact
        │
        ▼
   Manager.Save(artifact)
        │
   ┌────┼────┐
   │    │    │
   ▼    ▼    ▼
Write  Update  Add
Content Index  History
        │
        ├──> Checksum
        └──> Publish Event (Phase 6)
```

## 4. Dependency DAG

```
Requirement → Design → Plan → Code → Review → Test
                              ↘              ↘
                            Review         Deployment
```

Mỗi mũi tên = `depends_on` trong artifact.

## 5. Traceability

Từ requirement cuối test:
```
REQ-001 → PLAN-001 → CODE-001 → REV-001 → TEST-001
```

Doctor / Simulation dùng chain này.

## 6. Tương tác

- `manager.md` — CRUD API.
- `repository.md` — storage layer.
- `indexing.md` — lookup.
- `versioning.md` — version + diff.
- `lineage.md` — DAG + lineage rules.