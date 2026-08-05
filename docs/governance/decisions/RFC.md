---
name: decision-rfc
description: >
  RFC — Request for Comments. Đề xuất thay đổi trước khi ban hành.
  Dùng khi: breaking change, thêm feature mới, thay đổi principle/rule.
agent: general
---

# RFC — Request for Comments

## Mục đích

Đề xuất một thay đổi, được review **trước khi** ban hành thành luật.

## Khi nào dùng RFC

Dùng **RFC** khi thay đổi **breaking** hoặc ảnh hưởng rộng:

- Breaking change (phá compatibility).
- Thêm/thay đổi principle, rule, SPEC.
- Thêm thuật ngữ mới vào Glossary.
- Feature mới cấp platform.

## Quy trình

```text
Need Change
      │
Breaking?
      │
 ┌────┴────┐
 │         │
No        Yes
 │         │
ADR      RFC
```

## Vòng đời

```text
Draft → Review → Approved → (ban hành) → Superseded
                  ↘ Rejected
```

## Quy tắc

- RFC phải chỉ rõ điều khoản SPEC-000 bị ảnh hưởng.
- Approved RFC → merge vào SPEC/rule → ADR nếu cần.
- Mỗi RFC một file: `docs/rfc/RFC-###.md`.

## Template

Xem `docs/governance/templates/RFC-template.md`.
