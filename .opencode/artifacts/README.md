---
name: artifact-store
description: >
  Artifact Store v5.0 — Artifact không còn là file .md; là object có Content/Metadata/Lineage.
  Nền tảng cho Context Engine, Event Bus, Simulation, Knowledge Graph, Evolution.
agent: general
---

# Artifact Store v5.0

## 1. Vấn đề

Hiện nay artifact vẫn là file `.md` rời rạc:
```
plan.md, review.md, analysis.md
```

Không ai biết version, ai tạo, artifact nào phụ thuộc gì. Các phase sau (Context Engine, Simulation, Knowledge Graph) không thể reuse.

## 2. Giải pháp

Biến artifact thành **Artifact Object** có 3 lớp:

```
Artifact
├── Content   (nội dung thực — file)
├── Metadata  (id, type, version, checksum, tags...)
└── Lineage   (parent, derived_from, created_by, consumed_by...)
```

File chỉ là **Storage** của Content. Framework làm việc qua Metadata + Lineage.

## 3. Kiến trúc

```text
Workflow Runtime
       │
       ▼
  Artifact Manager
       │
       ├──────────┬──────────┐
       │          │          │
   Metadata   Versioning   Lineage
       │          │          │
       └──────────┼──────────┘
                  │
           Artifact Store
                  │
           Artifact Index
                  │
           Context Engine (Phase 4)
```

## 4. File hệ thống

| File | Vai trò |
|------|---------|
| `artifact.schema.yaml` | Schema 3 lớp |
| `metadata.schema.yaml` | Schema chi tiết metadata |
| `types.yaml` | 12 artifact types chuẩn |
| `architecture.md` | Kiến trúc + data flow |
| `manager.md` | CRUD API |
| `repository.md` | Storage layer |
| `validator.md` | Validation checks |
| `indexing.md` | Artifact index |
| `versioning.md` | Version + history |
| `lifecycle.md` | Created → Archived |
| `lineage.md` | Lineage + DAG |
| `dependency.md` | Dependency graph |
| `checksum.md` | Integrity |
| `diff.md` | Diff giữa versions |
| `cache.md` | Artifact cache |
| `query.md` | Query API |
| `contract.md` | Agent contract |
| `tags.md` | Tag system |
| `metrics.md` | Metrics |
| `tests.md` | Test cases |

## 5. Nguyên tắc

- Không **chỉnh sửa trực tiếp** artifact file — mọi thay đổi qua version mới.
- Mỗi artifact có version, checksum, lineage — traceable từ requirement tới test.
- Artifact Index (JSON) dùng lookup O(1) — không scan file system.
- Lineage tạo DAG — Context Engine chỉ cần traverse ngược/forward.

## 6. Tương tác

- **Context Engine (Phase 4)**: đọc metadata + lineage thay vì đọc file.
- **Event Bus (Phase 6)**: publish event khi artifact thay đổi.
- **Simulation (Phase 7)**: mô phỏng luồng artifact không cần chạy agent.
- **Knowledge Graph (Phase 9)**: lập chỉ mục từ lineage.
- **Evolution (Phase 10)**: phân tích artifact history.