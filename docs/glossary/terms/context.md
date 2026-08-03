---
id: TERM-009
name: Context
version: "1.0"
since: "1.0"
status: Draft
category: Data
owner: Runtime
stability: Stable
tags: [data, context, execution]
aliases: [Execution Data]
deprecated_aliases: [Working Set]
summary: Execution Data — chỉ sống trong Runtime; KHÔNG phải Memory.
definition: >
  Context = Execution Data. Context KHÔNG phải Memory.
  Context chỉ sống trong Runtime.
purpose: Cung cấp dữ liệu thực thi cho Agent trong một lần chạy.
entity_type: Data
normative:
  MUST:
    - Be scoped to một execution
    - Be allocated bởi Runtime
    - Be closed sau execution
  MUST NOT:
    - Persist sau runtime (thuộc Memory/Knowledge)
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
depends_on:
  - TERM-001 Runtime
inputs:
  - Workflow data
  - Artifact refs
outputs:
  - Context đã đóng
lifecycle: Created → Active → Closed
states: [Created, Active, Closed]
invariants:
  - Context chỉ sống trong Runtime.
  - Context không phải Memory.
related:
  - TERM-001
  - TERM-005
  - TERM-010
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

## Normative

- **MUST** Be scoped to execution.
- **MUST NOT** Persist sau runtime.

## Responsibilities

- Chứa dữ liệu thực thi (input, state hiện tại)
- Truyền cho Agent khi invoke

## Invariant

> Context chỉ sống trong Runtime.
