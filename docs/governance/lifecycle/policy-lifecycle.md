---
name: lifecycle-policy
description: >
  Policy Lifecycle — Draft → Review → Approved → Active → Deprecated → Retired.
  Policy cũng có vòng đời riêng.
agent: general
---

# Policy Lifecycle

> D005 — Mỗi Policy có vòng đời riêng.

## States

```text
Draft
   │
Review
   │
Approved
   │
Active
   │
Deprecated
   │
Retired
```

## Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Draft | Review | Đủ nội dung policy |
| Review | Approved | Approval bởi role phù hợp (roles.yaml) |
| Approved | Active | Ban hành |
| Active | Deprecated | Có policy thay thế |
| Deprecated | Retired | Hết deprecation window |

## Quy tắc

- Policy bất biến sau Approved — sửa → version mới (POLICY-002).
- Không xóa trực tiếp — luôn qua Deprecated (POLICY-004).
- Mọi transition phát Event (Policy Updated).

## Tham chiếu

- POLICY-002 Version
- POLICY-004 Deprecation
- `roles.yaml` (ai approve policy)
