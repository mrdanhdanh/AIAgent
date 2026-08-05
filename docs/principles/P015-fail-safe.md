---
id: P015
name: Fail Safe
status: Stable
version: 1.0.0
since: 1.0.0
category: Security
priority: Critical
normative: MUST
breaking_change: true
owner: Security Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Security
affects:
  - Runtime
  - Artifact
  - Doctor
verification:
  doctor:
    - error-handling-check
  runtime:
    - rollback-check
  tests:
    - fail-safe-tests
violation:
  level: Critical
  action:
    - stop_execution
    - rollback
    - doctor_error
formal_rule: error -> rollback && audit
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P004
  - P010
  - P013
conflicts: []
strengthens: []
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P004
  - P010
  - P013
statement: >
  Nếu lỗi → Rollback → Artifact → Audit. Không im lặng bỏ qua lỗi.
rationale: >
  Lỗi phải hiển thị, có vết, có thể rollback; im lặng → mất kiểm soát.
rules:
  - Lỗi luôn được báo cáo.
  - Có rollback point.
  - Có artifact ghi lỗi.
  - Có audit trail.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P004
  - P010
  - P013
---

# P015 — Fail Safe

## Statement

> Nếu lỗi → Rollback → Artifact → Audit. Không im lặng bỏ qua lỗi.

## Formal Rule

```text
error -> rollback && audit
```

## Rules

- Lỗi luôn được báo cáo.
- Có rollback point.
- Có artifact ghi lỗi.
- Có audit trail.

## Rationale

Lỗi phải hiển thị, có vết, có thể rollback; im lặng → mất kiểm soát.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Runtime
- Artifact
- Doctor

## Enforcement

- Doctor: error-handling-check
- Runtime: rollback-check
- Tests: fail-safe-tests

## Violation

- Level: Critical
- Action: stop_execution, rollback, doctor_error
