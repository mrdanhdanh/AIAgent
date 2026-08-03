---
id: workflow
name: Workflow
status: Draft
category: execution
summary: Kế hoạch thực thi (không phải Agent, không chứa Prompt/Logic).
definition: >
  Workflow là kế hoạch thực thi. Workflow không phải Agent.
  Workflow không chứa Prompt. Workflow không chứa Logic. Workflow chỉ mô tả.
purpose: Mô tả trình tự thực thi và phụ thuộc giữa các bước.
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
inputs:
  - Command
  - Request
outputs:
  - Execution Plan
lifecycle: Draft → Approved → Running → Completed → Archived
related:
  - runtime
  - phase
  - task
  - command
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

## Responsibilities

- Define execution order
- Define dependencies
- Define checkpoints
- Define rollback point

## Not Responsible

- Execution (thuộc Runtime)
- Prompt engineering
- Business Logic

## Owner

AIOS Kernel

## Used By

- Runtime
- Workflow Engine
- Doctor

## Input

- Command
- Request

## Output

- Execution Plan
