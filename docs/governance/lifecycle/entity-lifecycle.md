---
name: lifecycle-entity
description: >
  Entity Lifecycle — Draft → Review → Approved → Deprecated → Removed.
  Mọi Entity trong AIOS dùng chung.
agent: general
---

# Entity Lifecycle

> D005 — Mọi Entity (Workflow, Agent, Artifact, Capability, Plugin, SPEC) dùng chung lifecycle này.

## States

```text
Draft
   │
Review
   │
Approved
   │
Deprecated
   │
Removed
```

## Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Draft | Review | Đủ nội dung |
| Review | Approved | Approval pass (POLICY-001) |
| Approved | Deprecated | Có replacement (POLICY-004) |
| Deprecated | Removed | Hết deprecation window |

## Quy tắc

- Không xóa trực tiếp — luôn qua Deprecated.
- Deprecated phải có replacement + window rõ ràng.
- Mọi transition phát Event (P005).

## Tham chiếu

- POLICY-004 Deprecation
- Glossary: `terms/entity.md` (nếu có)
