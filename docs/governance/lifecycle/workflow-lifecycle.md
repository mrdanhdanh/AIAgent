---
name: lifecycle-workflow
description: >
  Workflow Lifecycle — Created → Validated → Running → Completed.
agent: general
---

# Workflow Lifecycle

> D005 — Vòng đời của một Workflow khi chạy.

## States

```text
Created
   │
Validated
   │
Running
   │
Completed
```

## Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Created | Validated | Schema + contract hợp lệ |
| Validated | Running | Simulation pass (P013) |
| Running | Completed | Mọi Phase/Task xong |
| Running | Failed | Lỗi → rollback/retry (RULE-012) |

## Quy tắc

- Workflow mới phải Simulation trước khi chạy (P013).
- Mọi transition phát Event (WorkflowStarted/WorkflowCompleted).
- Workflow không tự thay đổi khi Running.

## Tham chiếu

- RULE-004 Execution (State Machine)
- P013 Simulation Before Execution
