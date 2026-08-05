---
name: workflow-runtime-state-machine
description: state-machine — state machine Workflow định nghĩa đầy đủ cho Phase 1: Workflow + Phase trạng thái.
agent: general
---

# state-machine.md — State Machine Runtime

> Định nghĩa trạng thái Runtime (Workflow + Phase). Ánh xạ từ `architecture/STATE_MACHINE.md`.

## 1. Workflow state

```text
Created
   ↓
Validated
   ↓
Running
   ↓
Paused
   ↓
Retry
   ↓
Failed
   ↓
Completed
   ↓
Archived
```

## 2. Bảng Workflow transition

| State | Transition | Trigger |
|-------|-----------|---------|
| Created | → Validated | loader + validator pass |
| Validated | → Running | CreateInstance + chạy |
| Running | → Paused | Pause() |
| Running | → Retry | phase fail, retry còn |
| Running | → Failed | phase fail hết retry / abort |
| Running | → Completed | hết phase |
| Paused | → Running | Resume() |
| Retry | → Running | chạy lại phase |
| Failed | → Completed | rollback thành công |
| Completed | → Archived | cleanup |
| Failed | → Archived | cleanup |

## 3. Phase state

```text
Pending
   ↓
Ready
   ↓
Running
   ↓
Completed
   ↓
Skipped
   ↓
Failed
```

## 4. Bảng Phase transition

| State | End | Trigger |
|-------|-----|---------|
| Pending | → Ready | dependency Completed |
| Ready | → Running | scheduler chọn |
| Running | → Completed | output hợp lệ |
| Running | → Skipped | optional + fail |
| Running | → Failed | fail hết retry |
| Ready | → Failed | dependency fail |

## 5. Ánh xạ Architecture

- Khớp `architecture/STATE_MACHINE.md` (Workflow + Phase).
- Thêm `Paused` (Pause/Resume) — mở rộng từ Phase 1.
- Thêm `Validated` trạng thái giữa Created/Running.

## 6. Quy tắc

- Transition hợp lệ duy nhất trong bảng.
- Mỗi transition phải emit event (runtime.md).
- Retry reset `retry_count` khi thành công.