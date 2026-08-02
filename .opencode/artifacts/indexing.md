---
name: artifact-indexing
description: Artifact Index — lookup O(1) map id → metadata, không scan file system.
agent: general
---

# Artifact Index

## 1. Mục đích

Thay vì scan `workflow/` folder mỗi lần tìm artifact → dùng **index JSON**.

## 2. Format

`artifacts/artifact-index.json`:
```json
{
  "version": "5.0",
  "updated": "2026-08-02T...",
  "artifacts": {
    "PLAN-001": {
      "type": "plan",
      "version": 2,
      "status": "published",
      "path": "workflow/WF-0421/artifacts/plan/PLAN-001_v2.md",
      "checksum": "sha256:abc123",
      "size": 4500,
      "workflow": "WF-0421",
      "phase": "planning",
      "created_by": "planner",
      "tags": ["planning"]
    }
  },
  "by_type": {
    "plan": ["PLAN-001", "PLAN-002"],
    "code": ["CODE-001"]
  },
  "by_workflow": {
    "WF-0421": ["PLAN-001", "CODE-001"]
  }
}
```

## 3. Update

- Manager cập nhật index mỗi khi Create/Update/Archive/Delete.
- Index load vào memory (cache) — invalidate khi thay đổi.

## 4. Query

- `Find(id)` — O(1) hash map lookup.
- `FindByType(type)` — O(1) từ `by_type`.
- `FindByWorkflow(wf)` — O(1) từ `by_workflow`.
- `FindLineage(id)` — traverse DAG.

## 5. Tương tác

- `manager.md` maintain index.
- `cache.md` — index cache trong memory.
- Context Engine đọc index, không đọc file.