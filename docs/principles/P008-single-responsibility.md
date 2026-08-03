---
id: P008
name: Single Responsibility
status: Stable
version: 1.0.0
since: 1.0.0
category: Architecture
priority: High
normative: MUST
breaking_change: true
owner: Core Architecture Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Agent
  - Capability
verification:
  doctor:
    - responsibility-check
  runtime: []
  tests:
    - single-responsibility-tests
violation:
  level: High
  action:
    - doctor_error
formal_rule: agent.responsibilities == 1
decision:
  mandatory: true
  runtime: false
  doctor: true
  dashboard: false
requires:
  - P001
  - P007
conflicts: []
strengthens: []
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P001
  - P007
statement: >
  Một Agent chỉ làm một việc.
rationale: >
  Một trách nhiệm → dễ kiểm thử, thay thế, resolve theo capability.
rules:
  - Mỗi Agent implement một capability cốt lõi.
  - Agent không làm việc ngoài capability của mình.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P001
  - P007
---

# P008 — Single Responsibility

## Statement

> Một Agent chỉ làm một việc.

## Formal Rule

```text
agent.responsibilities == 1
```

## Rules

- Mỗi Agent implement một capability cốt lõi.
- Agent không làm việc ngoài capability của mình.

## Rationale

Một trách nhiệm → dễ kiểm thử, thay thế, resolve theo capability.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Agent
- Capability

## Enforcement

- Doctor: responsibility-check
- Runtime: 
- Tests: single-responsibility-tests

## Violation

- Level: High
- Action: doctor_error
