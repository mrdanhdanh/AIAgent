---
id: RULE-005
name: State
status: Stable
version: 1.0.0
category: State
policy_type: mandatory
severity: critical
compliance: required
enforcement:
  runtime: True
  doctor: True
  validator: True
  dashboard: False
statement: >
  State chỉ tồn tại ở Runtime. Agent, Skill, Artifact không có state/mutable.
purpose: >
  Stateless components → replaceable, replayable; single source of truth.
rules:
  - Chỉ Runtime giữ state.
  - Agent không có state.
  - Skill không có state.
  - Artifact immutable.
constraints:
  allowed:
    - Runtime: Execution State, Context
  forbidden:
    - Agent giữ state.
    - Skill giữ state.
    - Artifact mutable.
examples:
  - Agent × State = KHÔNG được phép
related_principles:
  - P001
  - P006
  - P009
  - P010
related_rules:
  - RULE-011
  - RULE-006
verification:
  - doctor: agent-state-check
  - runtime: stateless-check
  - tests: state-tests
---

# RULE-005 — State

## Statement

> State chỉ tồn tại ở Runtime. Agent, Skill, Artifact không có state/mutable.

## Purpose

Stateless components → replaceable, replayable; single source of truth.

## Rules

- Chỉ Runtime giữ state.
- Agent không có state.
- Skill không có state.
- Artifact immutable.

## Allowed

- Runtime: Execution State, Context

## Forbidden

- Agent giữ state.
- Skill giữ state.
- Artifact mutable.

## Example

```text
Agent × State = KHÔNG được phép
```

## Related Principles

- P001, P006, P009, P010

## Related Rules

- RULE-011, RULE-006

## Verification

- doctor: agent-state-check
- runtime: stateless-check
- tests: state-tests
