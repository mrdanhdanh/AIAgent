---
id: TERM-004
name: Task
version: "1.0"
since: "1.0"
status: Draft
category: Execution
owner: Core Runtime
stability: Stable
tags: [execution, task, unit]
aliases: [Work Item]
deprecated_aliases: [Job, Mission, Action]
summary: Đơn vị thực thi nhỏ nhất, do Runtime giao cho Agent.
definition: >
  Task là đơn vị thực thi nhỏ nhất.
  Task được Runtime giao cho Agent để thực thi.
purpose: Là đơn vị công việc tối thiểu trong Phase.
entity_type: Definition
normative:
  MUST:
    - Be executed by an Agent được Runtime giao
  MUST NOT:
    - Điều phối agent khác
    - Sửa workflow
responsibilities:
  - Được thực thi bởi Agent
does_not_responsible:
  - Tự điều phối Agent khác
  - Sửa Workflow
owned_by: Phase
used_by:
  - Agent
  - Runtime
depends_on:
  - TERM-003 Phase
inputs:
  - TERM-009 Context
outputs:
  - TERM-008 Artifact
lifecycle: Queued → Running → Completed → Failed
states: [Queued, Running, Completed, Failed]
invariants:
  - Task không tự điều phối Agent.
  - Task không sửa Workflow.
related:
  - TERM-003
  - TERM-005
  - TERM-009
  - TERM-008
examples:
  - Read Code
  - Generate Plan
  - Review Result
references:
  - P001 Runtime First
  - P006 Stateless Agent
---

# Task

Task là đơn vị thực thi nhỏ nhất.

Ví dụ:

- Read Code
- Generate Plan
- Review Result

Task được Runtime giao cho Agent.

## Normative

- **MUST** Be executed by an Agent.
- **MUST NOT** Điều phối agent khác.

## Responsibilities

- Được thực thi bởi Agent

## Invariant

> Task không tự điều phối Agent.
