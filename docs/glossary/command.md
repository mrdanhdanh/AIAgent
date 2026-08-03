---
id: command
name: Command
status: Draft
category: entrypoint
summary: Entry point — chỉ khởi động Runtime; không làm việc.
definition: >
  Command là entry point. Command không làm việc. Command chỉ khởi động Runtime.
purpose: Điểm vào duy nhất để người dùng khởi động một hoạt động.
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
inputs:
  - Command args
outputs:
  - Runtime start
lifecycle: Available (stateless)
related:
  - runtime
  - workflow
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

## Responsibilities

- Khởi động Runtime
- Trigger Workflow

## Not Responsible

- Thực thi Task
- Xử lý nghiệp vụ

## Owner

AIOS Shell

## Used By

- Người dùng
- CLI

## Input

- Command args

## Output

- Runtime start
