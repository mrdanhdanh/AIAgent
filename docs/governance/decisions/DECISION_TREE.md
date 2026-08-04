---
name: decision-tree
description: >
  Decision Tree — xác định dùng ADR, RFC hay thay đổi trực tiếp.
agent: general
---

# Decision Tree

> D005 — Framework quyết định: khi nào ADR, khi nào RFC, khi nào thay đổi trực tiếp.

## Tree

```text
Need Change
      │
      ▼
Breaking?  ──── Yes ────► RFC
      │
      No
      │
      ▼
Affects multiple modules?  ──── Yes ────► ADR
      │
      No
      │
      ▼
Changes principle/rule?  ──── Yes ────► RFC
      │
      No
      │
      ▼
Minor / internal / format?  ──── Yes ────► Direct change
      │
      No
      │
      ▼
     ADR
```

## Tóm tắt

| Tình huống | Công cụ |
|------------|---------|
| Breaking change | RFC |
| Ảnh hưởng nhiều module | ADR |
| Đổi principle/rule | RFC |
| Thêm thuật ngữ glossary | RFC |
| Thay đổi nội bộ, không breaking | ADR |
| Format / sửa lỗi nhỏ | Trực tiếp |

## Emergency Path

Trong môi trường enterprise, có trường hợp khẩn cấp cần xử lý nhanh:

```text
Critical Bug
      │
Emergency Fix
      │
Temporary Approval
      │
Hotfix Release
      │
Post Review (ADR bắt buộc)
```

### Quy tắc Emergency

- **Temporary Approval** — người/role cấp phép tạm, có expiration.
- **Hotfix Release** — chỉ khi Critical Bug ảnh hưởng production.
- **Post Review bắt buộc** — sau hotfix phải viết ADR + RFC nếu breaking (P020).
- Mọi emergency phải ghi audit trail (audit-policy.yaml).

## Quy tắc

- Thay đổi Core/Constitution → luôn RFC + ADR (P020).
- Không bypass approval (POLICY-001).
- Mọi quyết định đáng nhớ → ghi lại (traceability).

## Tham chiếu

- `decisions/ADR.md`
- `decisions/RFC.md`
- POLICY-001 Approval
