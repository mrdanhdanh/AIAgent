---
id: RULE-008
name: Security
status: Stable
version: 1.0.0
category: Security
policy_type: mandatory
severity: critical
compliance: required
enforcement:
  runtime: True
  doctor: True
  validator: False
  dashboard: False
statement: >
  Quyền tối thiểu theo thành phần: Runtime Full, Agent Workspace Only, Plugin Sandbox, Skill Read Only.
purpose: >
  Least privilege, giảm diện tích tấn công.
rules:
  - Runtime: Full.
  - Agent: Workspace Only.
  - Plugin: Sandbox.
  - Skill: Read Only.
constraints:
  allowed:
    - Runtime Full
    - Agent Workspace Only
    - Plugin Sandbox
    - Skill Read Only
  forbidden:
    - Agent truy cập ngoài workspace.
    - Plugin truy cập ngoài sandbox.
examples:
  - Plugin chạy trong sandbox
related_principles:
  - P016
  - P012
related_rules:
  - RULE-010
  - RULE-012
verification:
  - doctor: permission-check
  - runtime: policy-gate
  - tests: security-tests
---

# RULE-008 — Security

## Statement

> Quyền tối thiểu theo thành phần: Runtime Full, Agent Workspace Only, Plugin Sandbox, Skill Read Only.

## Purpose

Least privilege, giảm diện tích tấn công.

## Rules

- Runtime: Full.
- Agent: Workspace Only.
- Plugin: Sandbox.
- Skill: Read Only.

## Allowed

- Runtime Full
- Agent Workspace Only
- Plugin Sandbox
- Skill Read Only

## Forbidden

- Agent truy cập ngoài workspace.
- Plugin truy cập ngoài sandbox.

## Example

```text
Plugin chạy trong sandbox
```

## Permission Model

```text
permissions:
  Runtime:
    execute: true
    write_state: true
  Agent:
    execute: true
    write_state: false
  Skill:
    execute: false
    read_only: true
  Plugin:
    execute: true (sandbox)
    write_state: false
```

## Related Principles

- P016, P012

## Related Rules

- RULE-010, RULE-012

## Verification

- doctor: permission-check
- runtime: policy-gate
- tests: security-tests
