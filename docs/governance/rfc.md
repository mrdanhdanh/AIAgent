---
name: gov-rfc
description: G-005 — Quy trình RFC. Đề xuất thay đổi trước khi ban hành.
agent: general
---

# RFC — Request for Comments

## Mục đích

Đề xuất một thay đổi, được cộng đồng/team review **trước khi** ban hành thành luật.

## Khi nào viết RFC

- Thêm/thay đổi principle, rule, SPEC.
- Thêm thuật ngữ mới vào Glossary.
- Breaking change.
- Feature mới ở cấp platform.

## Template

```markdown
---
id: RFC-001
title: <đề xuất>
status: Draft | Review | Approved | Rejected | Superseded
date: YYYY-MM-DD
affects_spec: [SPEC-000, ...]
requires_adr: false
---

# RFC-001 — <title>

## Problem
Vấn đề gì?

## Proposal
Đề xuất thế nào?

## Impact
Ảnh hưởng SPEC/rule/module nào?

## Open Questions
Chưa rõ gì?
```

## Vòng đời

```text
Draft → Review → Approved → (ban hành) → Superseded
                  ↘ Rejected
```

## Vị trí

- RFC thực tế: `docs/rfc/RFC-001.md`, ...

## Quy tắc

- RFC phải chỉ rõ điều khoản SPEC-000 bị ảnh hưởng.
- Approved RFC → merge vào SPEC/rule tương ứng → ADR nếu cần.
