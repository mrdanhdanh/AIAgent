---
id: TERM-006
name: Capability
version: "1.0"
since: "1.0"
status: Approved
category: Execution
owner: Core Runtime
stability: Stable
tags: [execution, capability, routing]
aliases: [Ability]
deprecated_aliases: [Skill (cũ), Competence]
summary: Khả năng của hệ thống; không phụ thuộc implementation; Runtime sẽ resolve.
definition: >
  Capability là khả năng (ability). Capability KHÔNG phải Agent.
  Capability không phụ thuộc implementation. Runtime sẽ resolve.
purpose: Tách "cần làm gì" khỏi "ai làm" (capability driven).
entity_type: Definition
normative:
  MUST:
    - Khai báo khả năng thực hiện
    - Được resolve bởi Runtime qua Registry
  MUST NOT:
    - Chứa implementation
    - Chạy trực tiếp
responsibilities:
  - Khai báo khả năng có thể thực hiện
  - Được resolve thành Agent/Plugin bởi Runtime
does_not_responsible:
  - Implementation cụ thể
  - Chạy trực tiếp
owned_by: Registry
used_by:
  - Runtime (Capability Resolver)
  - Agent
  - Plugin
depends_on:
  - TERM-013 Registry
inputs:
  - Capability Request
outputs:
  - Resolved Capability
lifecycle: Registered → Available → Deprecated → Removed
states: [Registered, Available, Deprecated, Removed]
invariants:
  - Capability không chứa implementation.
related:
  - TERM-013
  - TERM-005
  - TERM-015
  - TERM-001
examples:
  - Code Review → Planner Agent | Review Agent | External Plugin
references:
  - P007 Capability Driven
  - P012 Plugin First
---

# Capability

Đây là khái niệm rất quan trọng.

Capability KHÔNG phải Agent.

Capability là khả năng.

Ví dụ:

```text
Code Review
    ↓
Planner Agent | Review Agent | External Plugin
```

Runtime sẽ resolve.

Capability không phụ thuộc implementation.

## Normative

- **MUST** Be resolved by Runtime.
- **MUST NOT** Chứa implementation.

## Responsibilities

- Khai báo khả năng có thể thực hiện
- Được resolve thành Agent/Plugin bởi Runtime

## Invariant

> Capability không chứa implementation.
