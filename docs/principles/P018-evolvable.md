---
id: P018
name: Evolvable
status: Draft
category: Quality
severity: high
breaking_change: true
enforced_by:
  - doctor
implemented_in:
  - SPEC-016
  - SPEC-017
related:
  - P002
  - P004
statement: >
  Mọi module đều phải hỗ trợ Migration, Compatibility, Versioning.
rationale: >
  Hệ thống sống 5-10 năm → thay đổi không được phá vỡ. Mỗi module phải
  có đường nâng cấp rõ ràng.
rules:
  - Mọi module hỗ trợ migration.
  - Mọi module hỗ trợ compatibility.
  - Mọi module hỗ trợ versioning.
implications:
  - Breaking change có deprecation window.
  - Data migration có plan.
anti_patterns:
  - Thay đổi không có migration.
  - Phá compatibility không báo trước.
exceptions:
  - Không có.
examples:
  - Contract v1→v2 có bước compat.
references:
  - P002 Contract First
  - P004 Everything is Versioned
---

# P018 — Evolvable

## Statement

> Mọi module đều phải hỗ trợ Migration, Compatibility, Versioning.

## Rules

- Migration.
- Compatibility.
- Versioning.

## Implications

- Breaking change có deprecation window.
- Data migration có plan.

## Anti Pattern

❌ Thay đổi không có migration / phá compatibility không báo trước.
