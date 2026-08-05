---
name: artifact-history
description: Artifact History — log thay đổi: ai sửa, khi nào, workflow nào, version diff.
agent: general
---

# Artifact History

## 1. Mục đích

Ghi lại mọi thay đổi artifact để traceability + audit.

## 2. Format

`artifacts/history.json`:
```json
{
  "PLAN-001": [
    {
      "version": 1,
      "checksum": "sha256:abc",
      "action": "created",
      "agent": "planner",
      "workflow": "WF-0421",
      "timestamp": "2026-08-02T10:00:00Z"
    },
    {
      "version": 2,
      "checksum": "sha256:def",
      "action": "updated",
      "agent": "planner",
      "workflow": "WF-0421",
      "timestamp": "2026-08-02T11:00:00Z"
    }
  ]
}
```

## 3. Actions

- `created` — artifact mới.
- `updated` — version bump.
- `archived` — status archived.
- `deleted` — soft delete.
- `consumed` — agent khác đọc (optional log).

## 4. Query

```text
Manager.History(PLAN-001) → [v1, v2]
```

## 5. Tương tác

- `versioning.md` — produce history entries.
- Evolution (Phase 10) — phân tích history patterns.
- Doctor — kiểm tra artifact frequently modified.