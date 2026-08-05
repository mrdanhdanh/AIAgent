---
id: P014
name: Observability First
status: Stable
version: 1.0.0
since: 1.0.0
category: Platform
priority: High
normative: MUST
breaking_change: true
owner: Platform Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Operability
affects:
  - Runtime
  - Dashboard
  - Doctor
verification:
  doctor:
    - observability-check
  runtime:
    - metrics-emission
  tests:
    - observability-tests
violation:
  level: High
  action:
    - doctor_error
formal_rule: activity -> observable_data
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: true
requires:
  - P005
  - P009
conflicts: []
strengthens: []
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P005
  - P009
statement: >
  Mọi hoạt động đều sinh Event, Metrics, Logs, Artifacts.
rationale: >
  Không đo được thì không kiểm soát được; cho phép audit, debug, tối ưu.
rules:
  - Mọi hoạt động sinh dữ liệu quan sát.
  - Event cho state change.
  - Metrics cho hiệu năng.
  - Artifacts cho output.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P005
  - P009
---

# P014 — Observability First

## Statement

> Mọi hoạt động đều sinh Event, Metrics, Logs, Artifacts.

## Formal Rule

```text
activity -> observable_data
```

## Rules

- Mọi hoạt động sinh dữ liệu quan sát.
- Event cho state change.
- Metrics cho hiệu năng.
- Artifacts cho output.

## Rationale

Không đo được thì không kiểm soát được; cho phép audit, debug, tối ưu.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Runtime
- Dashboard
- Doctor

## Enforcement

- Doctor: observability-check
- Runtime: metrics-emission
- Tests: observability-tests

## Violation

- Level: High
- Action: doctor_error
