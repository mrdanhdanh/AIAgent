---
id: TERM-007
name: Command
version: "1.0"
since: "1.0"
status: Draft
category: EntryPoint
owner: AIOS Shell
stability: Stable
tags: [entrypoint, cli, shell]
aliases: [Entry Point]
deprecated_aliases: [Action]
summary: Entry point — chỉ khởi động Runtime; không làm việc.
definition: >
  Command là entry point. Command không làm việc. Command chỉ khởi động Runtime.
purpose: Điểm vào duy nhất để người dùng khởi động một hoạt động.
entity_type: Definition
normative:
  MUST:
    - Start runtime
    - Trigger workflow
  MUST NOT:
    - Execute task
    - Xử lý nghiệp vụ
responsibilities:
  - Khởi động Runtime
  - Trigger Workflow
does_not_responsible:
  - Thực thi Task
  - Xử lý nghiệp vụ
owned_by: AIOS Shell
used_by:
  - Người dùng
  - CLI
depends_on:
  - TERM-001 Runtime
inputs:
  - Command args
outputs:
  - Runtime start
lifecycle: Available (stateless)
states: [Available]
invariants:
  - Command chỉ khởi động Runtime, không làm việc.
related:
  - TERM-001
  - TERM-002
examples:
  - /team → Workflow
  - /ask → Knowledge
references:
  - P001 Runtime First
---

# Command

Command là entry point.

Ví dụ:

```text
/team
    ↓
Workflow
```

Command không làm việc.

Command chỉ khởi động Runtime.

## Normative

- **MUST** Start runtime.
- **MUST NOT** Execute task.

## Responsibilities

- Khởi động Runtime
- Trigger Workflow

## Invariant

> Command chỉ khởi động Runtime.
