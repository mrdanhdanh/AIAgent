---
id: agent
name: Agent
status: Draft
category: execution
summary: Execution Unit — chỉ implement Capability; không phải Workflow/Capability.
definition: >
  Agent = Execution Unit. Agent không phải Workflow. Agent không phải Capability.
  Agent chỉ implement Capability.
purpose: Thực thi Task được Runtime giao.
responsibilities:
  - Execute Task
  - Read Context
  - Produce Artifact
  - Emit Events
does_not_responsible:
  - Gọi Agent khác
  - Sửa Workflow
  - Sửa Runtime
owned_by: AIOS Kernel
used_by:
  - Runtime
  - Scheduler
inputs:
  - Task
  - Context
outputs:
  - Artifact
  - Events
lifecycle: Registered → Ready → Running → Completed
related:
  - capability
  - task
  - context
  - artifact
  - event
examples:
  - Planner Agent
  - Builder Agent
  - Reviewer Agent
references:
  - P001 Runtime First
  - P005 Stateless Agents
  - P006 Capability Driven
---

# Agent

Đây là thứ hiện tại hệ thống đang dùng.

Định nghĩa mới:

```text
Agent = Execution Unit
```

Không phải:

```text
Agent = Workflow
```

Không phải:

```text
Agent = Capability
```

Agent chỉ implement Capability.

## Responsibilities

- Execute Task
- Read Context
- Produce Artifact
- Emit Events

## Not Responsible

- Gọi Agent khác
- Sửa Workflow
- Sửa Runtime

## Owner

AIOS Kernel

## Used By

- Runtime
- Scheduler

## Input

- Task
- Context

## Output

- Artifact
- Events
