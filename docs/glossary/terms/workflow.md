---
id: TERM-002
name: Workflow
version: "1.0"
since: "1.0"
status: Approved
category: Execution
owner: Core Runtime
stability: Stable
tags: [execution, workflow, plan]
aliases: [Execution Plan]
deprecated_aliases: [Runbook]
summary: Kế hoạch thực thi (không phải Agent, không chứa Prompt/Logic).
definition: >
  Workflow là kế hoạch thực thi. Workflow không phải Agent.
  Workflow không chứa Prompt. Workflow không chứa Logic. Workflow chỉ mô tả.
purpose: Mô tả trình tự thực thi và phụ thuộc giữa các bước.
entity_type: Definition
normative:
  MUST:
    - Define execution order
    - Define dependencies (depends_on)
    - Define checkpoints
    - Define rollback point
  MUST NOT:
    - Contain prompt
    - Contain business logic
    - Self-modify trong lúc chạy
  SHOULD:
    - Reference capability thay vì agent cụ thể
responsibilities:
  - Define execution order
  - Define dependencies
  - Define checkpoints
  - Define rollback point
does_not_responsible:
  - Execution (thuộc Runtime)
  - Prompt engineering
  - Business Logic
owned_by: AIOS Kernel
used_by:
  - Runtime
  - Workflow Engine
  - Doctor
depends_on:
  - TERM-001 Runtime
inputs:
  - TERM-007 Command
  - Request
outputs:
  - Execution Plan
lifecycle: Draft → Approved → Running → Completed → Archived
states: [Draft, Approved, Running, Completed, Archived]
invariants:
  - Workflow không được tự thay đổi trong khi thực thi.
  - Workflow không chứa Prompt hoặc Logic.
related:
  - TERM-001
  - TERM-003
  - TERM-004
  - TERM-007
examples:
  - Workflow Analyze → Design → Build → Review → Test
references:
  - P001 Runtime First
  - P003 Metadata First
---

# Workflow

Workflow không phải Agent.

Workflow là kế hoạch thực thi.

```text
Workflow
    ↓
Phase
    ↓
Task
    ↓
Execution
```

Workflow không chứa Prompt.

Workflow không chứa Logic.

Workflow chỉ mô tả.

## Normative

- **MUST** Define execution order.
- **MUST NOT** Contain prompt hoặc logic.
- **MUST NOT** Self-modify.

## Responsibilities

- Define execution order
- Define dependencies
- Define checkpoints
- Define rollback point

## Invariant

> Workflow không được tự thay đổi.
