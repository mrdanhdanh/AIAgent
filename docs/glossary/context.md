---
id: context
name: Context
status: Draft
category: data
summary: Execution Data — chỉ sống trong Runtime; KHÔNG phải Memory.
definition: >
  Context = Execution Data. Context KHÔNG phải Memory.
  Context chỉ sống trong Runtime.
purpose: Cung cấp dữ liệu thực thi cho Agent trong một lần chạy.
responsibilities:
  - Chứa dữ liệu thực thi (input, state hiện tại)
  - Truyền cho Agent khi invoke
does_not_responsible:
  - Lưu trữ lâu dài (thuộc Memory/Knowledge)
  - Giữ tri thức
owned_by: Runtime
used_by:
  - Agent
  - Runtime
inputs:
  - Workflow data
  - Artifact refs
outputs:
  - Context đã đóng
lifecycle: Created → Active → Closed
related:
  - runtime
  - agent
  - memory
examples:
  - Context của một lần /team
references:
  - P001 Runtime First
---

# Context

Context KHÔNG phải Memory.

```text
Context = Execution Data
```

Context chỉ sống trong Runtime.

## Responsibilities

- Chứa dữ liệu thực thi (input, state hiện tại)
- Truyền cho Agent khi invoke

## Not Responsible

- Lưu trữ lâu dài (thuộc Memory/Knowledge)
- Giữ tri thức

## Owner

Runtime

## Used By

- Agent
- Runtime

## Input

- Workflow data
- Artifact refs

## Output

- Context đã đóng
