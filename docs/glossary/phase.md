---
id: phase
name: Phase
status: Draft
category: execution
summary: Một nhóm Task trong Workflow (không phải Agent).
definition: >
  Phase là một nhóm Task. Phase không phải Agent.
  Phase là một bước logic trong Workflow, gom các Task cùng mục tiêu.
purpose: Gom Task thành bước logic để theo dõi tiến độ.
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
inputs:
  - Task
outputs:
  - Task result
lifecycle: Pending → Running → Completed
related:
  - workflow
  - task
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

## Responsibilities

- Group tasks
- Define phase-level checkpoint

## Not Responsible

- Execution (thuộc Runtime)
- Agent selection

## Owner

Workflow

## Used By

- Workflow
- Runtime

## Input

- Task

## Output

- Task result
