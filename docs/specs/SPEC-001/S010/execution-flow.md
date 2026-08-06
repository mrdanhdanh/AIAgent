---
name: spec-001-s010-execution-flow
description: >
  SPEC-001 S010 — Runtime Execution Flow. Trả lời: Một Execution diễn ra
  theo trình tự nào? Chuẩn hóa luồng thực thi của Runtime từ Command đến
  Completion. 23 sections EF001-EF023.
  Không mô tả implementation/class/code/API.
agent: general
---

# S010 — Runtime Execution Flow

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Chuẩn hóa toàn bộ Execution Lifecycle của Runtime.

## Mục tiêu

> **Một Execution được Runtime xử lý theo trình tự nào?**

Không mô tả:

- implementation
- code
- class
- API
- protocol

Chỉ mô tả **Execution Flow Logic**.

## EF001 — Execution Philosophy

Execution là đơn vị thực thi chuẩn của AIOS.

Mọi Execution:

- bắt đầu từ Runtime
- được Runtime điều phối
- kết thúc tại Runtime

Không thành phần nào được thực thi ngoài Execution.

## EF002 — Execution Principles

- Runtime First
- Contract First
- Metadata First
- Event Driven
- Capability Driven
- Deterministic
- Replayable
- Observable

## EF003 — Execution Lifecycle Overview

```text
Command
    ↓
Execution Created
    ↓
Validation
    ↓
Preparation
    ↓
Running
    ↓
Completion
```

## EF004 — Execution Stages

| Stage | Purpose |
|-------|---------|
| Initialize | Tạo Execution |
| Validate | Kiểm tra Workflow/Contract |
| Prepare | Chuẩn bị Context |
| Execute | Điều phối Agent |
| Finalize | Publish Artifact |
| Complete | Kết thúc |

## EF005 — Canonical Execution Flow

```text
Command
    ↓
Execution
    ↓
Workflow
    ↓
Validation
    ↓
Context
    ↓
Capability Resolution
    ↓
Agent Coordination
    ↓
State Update
    ↓
Event Publishing
    ↓
Artifact Publishing
    ↓
Completion
```

Đây là luồng chuẩn.

## EF006 — Workflow Resolution

Runtime:

- đọc Workflow
- validate
- tạo Execution Plan

> Không sửa Workflow.

## EF007 — Capability Resolution

```text
Task
      ↓
Capability
      ↓
Registry
      ↓
Resolved
```

Runtime chỉ resolve. Không biết Agent.

## EF008 — Context Flow

```text
Allocate
      ↓
Populate
      ↓
Distribute
      ↓
Collect
      ↓
Release
```

Context luôn isolated.

## EF009 — State Flow

State tuân theo S009.

Execution Flow **không định nghĩa State mới**.

## EF010 — Event Flow

Mỗi bước:

```text
Before
    ↓
Action
    ↓
After
    ↓
Event
```

Không bước nào thiếu Event.

## EF011 — Artifact Flow

```text
Execution
      ↓
Output
      ↓
Artifact
      ↓
Publish
```

Artifact immutable.

## EF012 — Retry Flow

```text
Failed
      ↓
Retry Policy
      ↓
Retry
      ↓
Running
```

Retry **không tạo Execution mới**.

## EF013 — Timeout Flow

```text
Running
      ↓
Timeout
      ↓
TimedOut
```

Runtime dừng Execution.

## EF014 — Cancellation Flow

```text
Running
      ↓
Cancelling
      ↓
Cancelled
```

Cancellation luôn graceful.

## EF015 — Approval Flow

```text
Running
      ↓
Waiting
      ↓
Approved
      ↓
Running
```

Approval chỉ thay đổi Flow. **Không thay đổi Workflow.**

## EF016 — Replay Flow

Replay:

```text
Completed
      ↓
Replay
      ↓
New Execution
```

Replay **không** Resume.

## EF017 — Failure Flow

```text
Failure
      ↓
Isolation
      ↓
Failure Event
      ↓
Failure Artifact
      ↓
Terminal State
```

Không sửa lỗi nghiệp vụ.

## EF018 — Machine-readable

```text
execution-flow.yaml
execution-stages.yaml
execution-transitions.yaml
execution-validation.yaml
retry-flow.yaml
approval-flow.yaml
timeout-flow.yaml
replay-flow.yaml
failure-flow.yaml
parallel-flow.yaml
compensation-flow.yaml
execution-lineage.yaml
execution-flow.schema.json
```

## EF019 — Traceability

```text
Execution
      ↓
State
      ↓
Event
      ↓
Artifact
      ↓
Metrics
      ↓
Dashboard
```

Execution phải truy vết được toàn bộ Lifecycle.

## EF020 — Success Criteria

Hoàn thành khi:

- Có đúng một Canonical Execution Flow.
- Không có bước thực thi ngoài Runtime.
- Mọi bước đều sinh Event.
- Mọi Execution đều có Terminal State.
- Retry, Replay, Approval, Timeout, Cancellation đều tuân theo State Machine.
- Doctor có thể xác minh toàn bộ Flow từ machine-readable.
- Dashboard dựng được Execution Timeline mà không cần đọc implementation.

## EF021 — Parallel Execution Flow (mở rộng)

Fan-out / Fan-in, barrier, join cho workflow song song:

```text
Task
  ↓
Fan-out → Task A → Task B → Task C
                ↓
              Barrier (chờ tất cả)
                ↓
              Fan-in (gộp kết quả)
                ↓
              Join → Task tiếp theo
```

**Rules:**

- Mỗi Task con là một Task hợp lệ (S009 Task SM).
- Barrier chờ tất cả Task con đạt Terminal State.
- Mỗi Task con phát Event riêng.
- Mỗi Task con có lineage (EF023).

## EF022 — Compensation Flow (mở rộng)

Rollback/compensation cho các bước đã hoàn thành khi execution thất bại:

```text
Failure
      ↓
Identify Completed Steps
      ↓
Compensate (ngược thứ tự)
      ↓
Compensation Artifact
      ↓
Terminal State
```

**Rules:**

- Compensation theo **thứ tự ngược** của Execution.
- Mỗi compensation phát Event.
- Không sửa Artifact đã sinh (P010).
- Nền tảng cho Rollback (P015).

## EF023 — Execution Lineage (mở rộng)

Chuẩn hóa quan hệ Parent/Child/Replay/Retry/Simulation:

```text
Parent Execution
      ├── Child Execution (fan-out)
      ├── Replay (Execution mới, lineage giữ nguyên)
      └── Simulation (simulated: true)
Retry: Cùng Execution, không tạo lineage mới.
```

**Rules:**

- Lineage immutable (append-only).
- Mỗi Execution có `lineage_ref`.
- Doctor / Dashboard / Evolution truy vết đầy đủ.
- Nền tảng cho orchestration phức tạp.

## Tham chiếu

- `execution-flow.yaml`
- `execution-stages.yaml`
- `execution-transitions.yaml`
- `execution-validation.yaml`
- `retry-flow.yaml`
- `approval-flow.yaml`
- `timeout-flow.yaml`
- `replay-flow.yaml`
- `failure-flow.yaml`
- `parallel-flow.yaml`
- `compensation-flow.yaml`
- `execution-lineage.yaml`
- `execution-flow.schema.json`
- S008 — Runtime Data Model
- S009 — Runtime State Machine
- Constitution: `docs/specs/SPEC-000/`
