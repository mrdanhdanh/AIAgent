---
name: lifecycle-specification
description: >
  Specification Lifecycle — Draft → Review → Approved → Implemented → Verified → Stable.
agent: general
---

# Specification Lifecycle

> D005 — Vòng đời của một SPEC (SPEC-001..020).

## States

```text
Draft
   │
Review
   │
Approved
   │
Implemented
   │
Verified
   │
Stable
```

## Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Draft | Review | Đủ nội dung (Vision/Design/Contract) |
| Review | Approved | Approval pass (POLICY-001) |
| Approved | Implemented | Có implementation (SPEC-###) |
| Implemented | Verified | Doctor/Validator pass |
| Verified | Stable | Đóng băng |

## Quy tắc

- Mỗi SPEC có `spec.yaml` (metadata, status, implemented_by).
- Không mâu thuẫn SPEC-000 Constitution (P020).
- Traceability: SPEC → Implementation → Test (POLICY-011).

## Tham chiếu

- P020 Constitution First
- POLICY-011 Traceability
- `docs/specs/SPEC-000/` (Constitution)
