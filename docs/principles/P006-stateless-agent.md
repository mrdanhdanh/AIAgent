---
id: P006
name: Stateless Agent
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
  - Agent
  - Runtime
verification:
  doctor:
    - agent-state-check
  runtime:
    - stateless-check
  tests:
    - stateless-agent-tests
violation:
  level: Critical
  action:
    - stop_execution
    - doctor_error
formal_rule: Agent.state == null
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P001
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
  - P001
  - P009
statement: >
  Agent KHÔNG giữ state.
rationale: >
  Stateless → replaceable, scalable, replayable; mọi state nằm ở Runtime.
rules:
  - Agent không cache.
  - Agent không nhớ.
  - Agent không lưu session.
  - Mọi state nằm ở Runtime.
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
  - P009
---

# P006 — Stateless Agent

## Statement

> Agent KHÔNG giữ state.

## Formal Rule

```text
Agent.state == null
```

## Rules

- Agent không cache.
- Agent không nhớ.
- Agent không lưu session.
- Mọi state nằm ở Runtime.

## Rationale

Stateless → replaceable, scalable, replayable; mọi state nằm ở Runtime.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Agent
- Runtime

## Enforcement

- Doctor: agent-state-check
- Runtime: stateless-check
- Tests: stateless-agent-tests

## Violation

- Level: Critical
- Action: stop_execution, doctor_error
