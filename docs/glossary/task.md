---
id: task
name: Task
status: Draft
category: execution
summary: Đơn vị thực thi nhỏ nhất, do Runtime giao cho Agent.
definition: >
  Task là đơn vị thực thi nhỏ nhất.
  Task được Runtime giao cho Agent để thực thi.
purpose: Là đơn vị công việc tối thiểu trong Phase.
responsibilities:
  - Được thực thi bởi Agent
does_not_responsible:
  - Tự điều phối Agent khác
  - Sửa Workflow
owned_by: Phase
used_by:
  - Agent
  - Runtime
inputs:
  - Context
outputs:
  - Artifact
lifecycle: Queued → Running → Completed → Failed
related:
  - phase
  - agent
  - context
  - artifact
examples:
  - Read Code
  - Generate Plan
  - Review Result
references:
  - P001 Runtime First
  - P005 Stateless Agents
---

# Task

Task là đơn vị thực thi nhỏ nhất.

Ví dụ:

- Read Code
- Generate Plan
- Review Result

Task được Runtime giao cho Agent.

## Responsibilities

- Được thực thi bởi Agent

## Not Responsible

- Tự điều phối Agent khác
- Sửa Workflow

## Owner

Phase

## Used By

- Agent
- Runtime

## Input

- Context

## Output

- Artifact
