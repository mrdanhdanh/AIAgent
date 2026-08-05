---
id: TERM-005
name: Agent
version: "1.0"
since: "1.0"
status: Approved
category: Execution
owner: Core Runtime
stability: Stable
tags: [execution, agent, unit]
aliases: [Execution Unit]
deprecated_aliases: [Worker]
summary: Execution Unit — chỉ implement Capability; không phải Workflow/Capability.
definition: >
  Agent = Execution Unit. Agent không phải Workflow. Agent không phải Capability.
  Agent chỉ implement Capability.
purpose: Thực thi Task được Runtime giao.
entity_type: Execution
normative:
  MUST:
    - Execute task
    - Read context
    - Produce artifact
    - Emit events
  MUST NOT:
    - Gọi agent khác
    - Sửa workflow
    - Sửa runtime
    - Giữ state
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
depends_on:
  - TERM-001 Runtime
  - TERM-006 Capability
  - TERM-009 Context
inputs:
  - TERM-004 Task
  - TERM-009 Context
outputs:
  - TERM-008 Artifact
  - TERM-012 Event
lifecycle: Registered → Ready → Running → Completed
states: [Registered, Ready, Running, Completed]
invariants:
  - Agent không giữ state.
  - Agent không gọi agent khác trực tiếp.
related:
  - TERM-006
  - TERM-004
  - TERM-009
  - TERM-008
  - TERM-012
examples:
  - Planner Agent
  - Builder Agent
  - Reviewer Agent
references:
  - P001 Runtime First
  - P006 Stateless Agent
  - P007 Capability Driven
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

## Normative

- **MUST** Execute task.
- **MUST NOT** Gọi agent khác.
- **MUST NOT** Giữ state.

## Responsibilities

- Execute Task
- Read Context
- Produce Artifact
- Emit Events

## Invariant

> Agent không giữ state.
