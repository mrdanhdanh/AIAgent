---
id: P005
name: Event Driven
status: Stable
version: 1.0.0
since: 1.0.0
category: Execution
priority: Critical
normative: MUST
breaking_change: true
owner: Runtime Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Runtime
  - Agent
  - Dashboard
  - Doctor
verification:
  doctor:
    - event-coverage
  runtime:
    - event-emission
  tests:
    - event-driven-tests
violation:
  level: Critical
  action:
    - doctor_error
formal_rule: state_change -> event.emitted
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: true
requires:
  - P001
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
  - P001
statement: >
  Không notify trực tiếp. Mọi state change phát Event.
rationale: >
  Event immutable + lineage → replay/simulate/audit; tách producer khỏi consumer.
rules:
  - Mọi state change đều phát Event.
  - Không gọi trực tiếp khi thông báo.
  - Event immutable, có lineage.
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
---

# P005 — Event Driven

## Statement

> Không notify trực tiếp. Mọi state change phát Event.

## Formal Rule

```text
state_change -> event.emitted
```

## Rules

- Mọi state change đều phát Event.
- Không gọi trực tiếp khi thông báo.
- Event immutable, có lineage.

## Rationale

Event immutable + lineage → replay/simulate/audit; tách producer khỏi consumer.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Runtime
- Agent
- Dashboard
- Doctor

## Enforcement

- Doctor: event-coverage
- Runtime: event-emission
- Tests: event-driven-tests

## Violation

- Level: Critical
- Action: doctor_error
