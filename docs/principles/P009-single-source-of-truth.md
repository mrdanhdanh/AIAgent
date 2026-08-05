---
id: P009
name: Single Source of Truth
status: Stable
version: 1.0.0
since: 1.0.0
category: Data
priority: Critical
normative: MUST
breaking_change: true
owner: Core Data Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Workflow
  - Runtime
  - Registry
verification:
  doctor:
    - duplicate-check
  runtime: []
  tests:
    - single-source-tests
violation:
  level: Critical
  action:
    - doctor_error
formal_rule: count(source.of.truth) == 1
decision:
  mandatory: true
  runtime: false
  doctor: true
  dashboard: false
requires:
  - P003
  - P006
conflicts: []
strengthens:
  - P014
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P003
  - P006
statement: >
  Mỗi dữ liệu chỉ tồn tại một nguồn định nghĩa duy nhất.
rationale: >
  Không copy, không duplicate → không mâu thuẫn, không lỗi đồng bộ.
rules:
  - Mỗi dữ liệu một nguồn.
  - Không copy, không duplicate.
  - State nằm ở Runtime.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P003
  - P006
---

# P009 — Single Source of Truth

## Statement

> Mỗi dữ liệu chỉ tồn tại một nguồn định nghĩa duy nhất.

## Formal Rule

```text
count(source.of.truth) == 1
```

## Rules

- Mỗi dữ liệu một nguồn.
- Không copy, không duplicate.
- State nằm ở Runtime.

## Rationale

Không copy, không duplicate → không mâu thuẫn, không lỗi đồng bộ.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Workflow
- Runtime
- Registry

## Enforcement

- Doctor: duplicate-check
- Runtime: 
- Tests: single-source-tests

## Violation

- Level: Critical
- Action: doctor_error
