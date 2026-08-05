---
id: P018
name: Evolvable
status: Stable
version: 1.0.0
since: 1.0.0
category: Evolution
priority: High
normative: MUST
breaking_change: true
owner: Evolution Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Maintainability
affects:
  - Module
  - Contract
  - Data
verification:
  doctor:
    - migration-check
    - compatibility-check
  runtime: []
  tests:
    - evolvable-tests
violation:
  level: High
  action:
    - doctor_error
formal_rule: module.supports(migration) && module.supports(compatibility) && module.supports(versioning)
decision:
  mandatory: true
  runtime: false
  doctor: true
  dashboard: false
requires:
  - P002
  - P004
conflicts: []
strengthens: []
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P002
  - P004
statement: >
  Mọi module đều phải hỗ trợ Migration, Compatibility, Versioning.
rationale: >
  Hệ thống sống 5-10 năm → thay đổi không phá vỡ; mỗi module có đường nâng cấp rõ.
rules:
  - Mọi module hỗ trợ migration.
  - Mọi module hỗ trợ compatibility.
  - Mọi module hỗ trợ versioning.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P002
  - P004
---

# P018 — Evolvable

## Statement

> Mọi module đều phải hỗ trợ Migration, Compatibility, Versioning.

## Formal Rule

```text
module.supports(migration) && module.supports(compatibility) && module.supports(versioning)
```

## Rules

- Mọi module hỗ trợ migration.
- Mọi module hỗ trợ compatibility.
- Mọi module hỗ trợ versioning.

## Rationale

Hệ thống sống 5-10 năm → thay đổi không phá vỡ; mỗi module có đường nâng cấp rõ.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Module
- Contract
- Data

## Enforcement

- Doctor: migration-check, compatibility-check
- Runtime: 
- Tests: evolvable-tests

## Violation

- Level: High
- Action: doctor_error
