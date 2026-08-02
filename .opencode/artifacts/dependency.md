---
name: artifact-dependency
description: Artifact Dependency — DAG quan hệ artifact; depends_on tạo graph acyclic.
agent: general
---

# Artifact Dependency

## 1. Khái niệm

Artifact form **DAG** (Directed Acyclic Graph) thông qua `depends_on`.

## 2. Graph

```
REQ-001 → PLAN-001 → CODE-001 → REV-001 → TEST-001
                          ↘
                        REV-002 (guardian)
```

## 3. Rules

- `depends_on` = [id artifact phụ thuộc].
- Một artifact có thể depends nhiều artifact.
- Không cycle (validator ART-008 kiểm tra).
- Khi artifact bị delete/archive → cảnh báo nếu artifact khác depends_on nó.

## 4. Dependency chain (traceability)

```text
TEST-001
  depends_on: [REV-001]
    depends_on: [CODE-001]
      depends_on: [PLAN-001]
        depends_on: [REQ-001]
```

Context Engine traverse ngược để lấy toàn bộ context.

## 5. Impact analysis

Nếu PLAN-001 thay đổi:
- Manager tìm: artifact nào `depends_on: [PLAN-001]`.
- → CODE-001, REV-001, TEST-001 cần re-evaluate.

## 6. Tương tác

- `lineage.md` — lineage là chain; dependency là graph.
- `query.md` — FindDependencies.
- Phase 6 (Event Bus) — event khi dependency thay đổi.