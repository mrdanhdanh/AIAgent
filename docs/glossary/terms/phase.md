---
id: TERM-003
name: Phase
version: "1.0"
since: "1.0"
status: Draft
category: Execution
owner: Core Runtime
stability: Stable
tags: [execution, phase, workflow]
aliases: [Stage]
deprecated_aliases: [Step]
summary: Một nhóm Task trong Workflow (không phải Agent).
definition: >
  Phase là một nhóm Task. Phase không phải Agent.
  Phase là một bước logic trong Workflow, gom các Task cùng mục tiêu.
purpose: Gom Task thành bước logic để theo dõi tiến độ.
entity_type: Definition
normative:
  MUST:
    - Group task
    - Define phase-level checkpoint
  MUST NOT:
    - Execute trực tiếp
    - Chọn agent
responsibilities:
  - Group tasks
  - Define phase-level checkpoint
does_not_responsible:
  - Execution (thuộc Runtime)
  - Agent selection
owned_by: Workflow
used_by:
  - Workflow
  - Runtime
depends_on:
  - TERM-002 Workflow
inputs:
  - TERM-004 Task
outputs:
  - Task result
lifecycle: Pending → Running → Completed
states: [Pending, Running, Completed]
invariants:
  - Phase không phải Agent.
related:
  - TERM-002
  - TERM-004
examples:
  - Phase Analyze → Design → Build → Review → Test
references:
  - P001 Runtime First
  - P007 Capability Driven
---

# Phase

Phase là một nhóm Task.

Ví dụ:

```text
Analyze
    ↓
Design
    ↓
Build
    ↓
Review
    ↓
Test
```

Phase không phải Agent.

## Normative

- **MUST** Group tasks.
- **MUST NOT** Execute trực tiếp.

## Responsibilities

- Group tasks
- Define phase-level checkpoint

## Invariant

> Phase không phải Agent.
