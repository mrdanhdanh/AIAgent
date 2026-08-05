---
name: architecture-state-machine
description: STATE_MACHINE — state machine chuẩn hóa cho Workflow, Phase, Agent, Artifact trong Agent Framework v4.
agent: general
---

# STATE_MACHINE.md — State Machine

> Bảng chuyển trạng thái chuẩn. Mọi transition phải nằm trong bảng này.

## 1. Workflow State Machine

```
Pending → Running → Completed
             ↘
             Retry → Running
             ↘
             Failed → Rollback → Completed
                          ↘
                          Archived
```

| State | Transition | Điều kiện | Event |
|-------|-----------|-----------|-------|
| Pending | → Running | validated, đủ điều kiện | `WORKFLOW_STARTED` |
| Running | → Completed | mọi phase Done | `WORKFLOW_FINISHED` |
| Running | → Retry | phase lỗi, retry còn | `WORKFLOW_RETRY` |
| Retry | → Running | chuẩn bị lại | `WORKFLOW_STARTED` |
| Running | → Failed | phase lỗi, hết retry | `WORKFLOW_FAILED` |
| Failed | → Rollback | có rollback plan | `WORKFLOW_ROLLBACK` |
| Rollback | → Completed | rollback xong | `WORKFLOW_FINISHED` |
| Rollback | → Archived | không recover được | `WORKFLOW_ARCHIVED` |
| Completed | → Archived | hết active window | `WORKFLOW_ARCHIVED` |

## 2. Phase State Machine

```
Ready → Running → Done
          ↘
          Skipped → Done
          ↘
          Failed → Ready (retry)
                ↘ Retried/Aborted
```

| State | Transition | Điều kiện | Event |
|-------|-----------|-----------|-------|
| Ready | → Running | dependency Done | `PHASE_STARTED` |
| Running | → Done | output artifact hợp lệ | `PHASE_FINISHED` |
| Ready | → Skipped | không cần thiết | `PHASE_SKIPPED` |
| Skipped | → Done | workflow tiếp tục | — |
| Running | → Failed | lỗi | `PHASE_FAILED` |
| Failed | → Ready | retry còn | `PHASE_RETRY` |
| Failed | → Aborted | hết retry | `PHASE_ABORTED` |

## 3. Agent State Machine

```
Loaded → Ready → Running → Waiting → Completed
                    ↘
                    Failed → Ready (nếu retry)
                    ↘
                    Failed (chung cuộc)
```

| State | Transition | Điều kiện | Event |
|-------|-----------|-----------|-------|
| Loaded | → Ready | registry validated | `AGENT_READY` |
| Ready | → Running | nhận task | `AGENT_STARTED` |
| Running | → Waiting | chờ artifact/context | `AGENT_WAITING` |
| Waiting | → Running | nhận đủ dữ liệu | `AGENT_STARTED` |
| Running | → Completed | xong output | `AGENT_FINISHED` |
| Running | → Failed | lỗi | `AGENT_FAILED` |
| Failed | → Ready | retry hợp lệ | `AGENT_READY` |

## 4. Artifact State Machine

```
Created → Validated → Versioned → Archived
```

| State | Transition | Điều kiện |
|-------|-----------|-----------|
| Created | → Validated | checksum + format đúng |
| Validated | → Versioned | gán version |
| Versioned | → Archived | hết dùng / thay thế |

## 5. Quy tắc chung

- Transition hợp lệ duy nhất theo bảng; transition khác = lỗi WF-003 (invalid transition).
- Mỗi transition bắt buộc emit Event tương ứng.
- Retry đếm theo `retry` field; vượt → Failed/Aborted.
- Không có transition ngầm (implicit) ngoài bảng.