---
id: RULE-011
name: Resource Ownership
status: Stable
version: 1.0.0
category: Data
policy_type: mandatory
severity: high
compliance: required
enforcement:
  runtime: False
  doctor: True
  validator: False
  dashboard: False
statement: >
  Mỗi thành phần chỉ sở hữu tài nguyên của chính mình.
purpose: >
  Tránh xung đột, rõ trách nhiệm, dễ audit.
rules:
  - Runtime owns Execution State, Context.
  - Workflow owns Definition.
  - Agent owns nothing (state).
  - Artifact owns immutable content.
  - Registry owns Metadata.
constraints:
  allowed:
    - Runtime: Execution State, Context
    - Workflow: Definition
    - Artifact: Immutable content
    - Registry: Metadata
  forbidden:
    - Sửa tài nguyên của thành phần khác.
    - Agent owns state.
examples:
  - Agent không sở hữu State
related_principles:
  - P009
  - P010
  - P008
related_rules:
  - RULE-005
  - RULE-006
verification:
  - doctor: ownership-check
  - tests: ownership-tests
---

# RULE-011 — Resource Ownership

## Statement

> Mỗi thành phần chỉ sở hữu tài nguyên của chính mình.

## Purpose

Tránh xung đột, rõ trách nhiệm, dễ audit.

## Rules

- Runtime owns Execution State, Context.
- Workflow owns Definition.
- Agent owns nothing (state).
- Artifact owns immutable content.
- Registry owns Metadata.

## Allowed

- Runtime: Execution State, Context
- Workflow: Definition
- Artifact: Immutable content
- Registry: Metadata

## Forbidden

- Sửa tài nguyên của thành phần khác.
- Agent owns state.

## Example

```text
Agent không sở hữu State
```

## Related Principles

- P009, P010

## Related Rules

- RULE-005, RULE-006

## Verification

- doctor: ownership-check
- tests: ownership-tests
