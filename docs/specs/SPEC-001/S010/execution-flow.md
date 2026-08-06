---
name: spec-001-s010-execution-flow
description: >
  SPEC-001 S010 — Runtime Execution Flow. Trả lời: Một Execution diễn ra
  theo trình tự nào? Chuẩn hóa luồng thực thi của Runtime từ Command đến
  Completion. 25 sections EF001-EF025.
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
Synchronization
    ↓
Completion
```

## EF004 — Execution Stages (7)

| Stage | Bao gồm | Event |
|-------|---------|-------|
| Initialize | Create Execution, Allocate Resource | EXECUTION_CREATED |
| Validate | Workflow, Contract, Policy | EXECUTION_VALIDATING |
| Prepare | Context, Capability Resolution | EXECUTION_PREPARED |
| Execute | Agent Coordination | EXECUTION_STARTED |
| Coordinate | Sequential, Parallel, Barrier, Approval, Waiting, Retry, Timeout | EXECUTION_COORDINATING |
| Finalize | Result, Artifact, Metrics | EXECUTION_FINALIZING |
| Complete | Terminal State | EXECUTION_COMPLETED |

> **Coordinate** (không phải Synchronize) — bao gồm mọi hình thức điều phối: Sequential, Parallel, Barrier, Approval, Waiting, Retry, Timeout. EF021 là một loại Coordination.

## EF005 — Canonical Execution Flow (Timeline chuẩn)

```text
Command
    ↓
Execution Created
    ↓
Validation
    ↓
Policy Resolution
    ↓
Preparation
    ↓
Execution
    ↓
Coordination
    ↓
Finalization
    ↓
Completion
```

> Dashboard vẽ timeline trực tiếp từ flow này. Runtime luôn resolve Policy sau Validation.

## EF006 — Workflow Resolution

```text
Workflow
    ↓
Validation
    ↓
Normalization
    ↓
Execution Plan
```

Runtime: đọc → validate → **normalize** → Execution Plan. Normalization chuẩn hóa cấu trúc trước khi chạy. Không sửa Workflow.

## EF007 — Capability Resolution

```text
Capability
      ↓
Registry
      ↓
Resolved

or

Capability
      ↓
Resolution Failed
      ↓
Execution Failed
```

Runtime chỉ resolve. Không biết Agent.

> Resolve Failure → Execution Failed — Doctor trace được lỗi Capability.

## EF008 — Context Flow

```text
Allocate
    ↓
Populate
    ↓
Distribute
    ↓
Mutate
    ↓
Merge
    ↓
Collect
    ↓
Release
```

Context luôn isolated. Agent có thể Mutate Context (trong phạm vi được cấp). **Merge** gộp Context con về Context cha (parallel).

## EF009 — State Flow

State tuân theo S009.

Execution Flow **không định nghĩa State mới**.

## EF010 — Event Flow

```text
Before
    ↓
Action
    ↓
State Changed
    ↓
Event
    ↓
Trace
    ↓
Metrics
```

Không bước nào thiếu Event (P005). **Trace luôn trước Metrics** (P014).

## EF011 — Artifact Flow

```text
Execution Output
        ↓
Checkpoint
        ↓
Execution Result
        ↓
Artifact
        ↓
Publish
        ↓
Archive
```

Artifact immutable (P010). **Checkpoint** dùng cho Replay (S009). Result tổng hợp từ Artifact + Metrics (S008 ENT-012).

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

## EF017 — Failure Flow (5 loại)

| Failure Type | States |
|--------------|--------|
| Validation Failure | ST-002 → ST-009 |
| Capability Failure | Resolution Failed → ST-009 |
| Execution Failure | ST-004 → ST-009 |
| System Failure | ST-004 → ST-014 |
| **Policy Failure** | ST-004 → ST-014 (Aborted) |

**Policy Failure** — Approval denied, Policy violated, Security violation — không phải Execution Failure.

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
workflow-flow.yaml
capability-flow.yaml
context-flow.yaml
event-flow.yaml
artifact-flow.yaml
retry-flow.yaml
approval-flow.yaml
timeout-flow.yaml
replay-flow.yaml
failure-flow.yaml
parallel-flow.yaml
compensation-flow.yaml
execution-lineage.yaml
execution-outcome.yaml
execution-policies.yaml
execution-guarantees.yaml
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

## EF021 — Parallel Execution Flow

Scatter / Gather, barrier, join:

```text
Task
  ↓
Scatter → Task A → Task B → Task C
                ↓
              Barrier (chờ tất cả)
                ↓
              Gather (gộp kết quả)
                ↓
              Join → Task tiếp theo
```

**Join Policy:**

- **ALL** — chờ tất cả Task con thành công.
- **ANY** — chỉ cần một Task con thành công.
- **QUORUM** — cần đủ tỷ lệ Task con thành công.
- **CUSTOM** — theo logic khai báo.

**Rules:** Mỗi Task con là Task hợp lệ (S009); Barrier chờ mọi Task con đạt Terminal State; mỗi Task con phát Event riêng + lineage (EF023). Scatter/Gather là thuật ngữ chuẩn cho Fan-out/Fan-in.

## EF022 — Compensation Flow

**Compensation ≠ Rollback:**

- **Rollback** là mục tiêu (trở về trạng thái trước Execution).
- **Compensation** là cách đạt được Rollback (bù trừ từng bước đã hoàn thành).

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

**Rules:** Compensation theo thứ tự ngược; mỗi compensation phát Event; không sửa Artifact đã sinh (P010).

## EF023 — Execution Lineage

```text
Root Execution (không có parent)
      ├── Parent Execution
      ├── Child Execution (scatter)
      ├── Replay (Execution mới, lineage giữ nguyên)
      ├── Simulation (simulated: true)
      └── Fork (phân nhánh từ một điểm)
```

**Rules:** Lineage immutable (append-only); mỗi Execution có `lineage_ref`; Doctor/Dashboard/Evolution truy vết đầy đủ.

> **Clone không phải Execution** — Clone là Operation, không thuộc Execution Lineage.

## EF024 — Execution Outcome (mới)

Outcome khác với State — hữu ích cho Dashboard và Analytics:

| Outcome | State |
|---------|-------|
| Success | Completed (ST-008) |
| **Partial Success** | Completed (ST-008) — Join Policy ANY/QUORUM: Task A OK, Task B Failed |
| Failure | Failed (ST-009) |
| Cancelled | Cancelled (ST-010) |
| Timeout | TimedOut (ST-011) |
| Aborted | Aborted (ST-014) |
| Simulation | Completed (simulation=true) |

> Outcome được ghi vào Execution Result (S008 ENT-012).

## EF025 — Execution Policies (mới)

Mỗi policy theo **cùng một model** — SPEC-012 (Policy Engine) chỉ cần tham chiếu:

```yaml
policy:
  id:
  category:
  trigger:
  guard:
  action:
  priority:
  version:
```

| Policy | ID | Category | Trigger | Guard | Action |
|--------|----|----------|---------|-------|--------|
| Retry | POL-RETRY-001 | Recovery | Failed | retry_count < max_retry | Retry |
| Timeout | POL-TIMEOUT-001 | Control | Running | timeout exceeded | TimedOut |
| Approval | POL-APPROVAL-001 | Governance | Approval gate | approval required | Waiting |
| Compensation | POL-COMP-001 | Recovery | Failure | completed steps exist | Compensate |
| Parallel | POL-PARALLEL-001 | Orchestration | Parallel tasks | join policy | Scatter/Gather |
| Resource | POL-RES-001 | Resource | Allocate | resource available | Allocate |

> **Execution Flow chỉ áp dụng policy, không định nghĩa policy.**

## EF026 — Execution Guarantees (mới)

Runtime cam kết — khác với Requirements (S002) và Invariants (S001):

- **Exactly one Active State.**
- **Exactly one Terminal State.**
- **At-least-once Event Publication.**
- **Exactly-once Artifact Publication.**
- **Context Isolation.**
- **Deterministic Replay.**
- **Immutable Lineage.**
- **Immutable Artifact.**
- **Contract-first Communication.**

> Doctor / Dashboard / các Runtime implementation (C#, Go, Rust, Python...) dùng làm tiêu chí kiểm chứng.

## Tham chiếu

- `execution-flow.yaml`
- `execution-stages.yaml`
- `execution-transitions.yaml`
- `execution-validation.yaml`
- `workflow-flow.yaml` / `capability-flow.yaml` / `context-flow.yaml` / `event-flow.yaml` / `artifact-flow.yaml`
- `retry-flow.yaml` / `approval-flow.yaml` / `timeout-flow.yaml` / `replay-flow.yaml` / `failure-flow.yaml`
- `parallel-flow.yaml` / `compensation-flow.yaml` / `execution-lineage.yaml`
- `execution-outcome.yaml` / `execution-policies.yaml` / `execution-guarantees.yaml`
- `execution-flow.schema.json`
- S008 — Runtime Data Model
- S009 — Runtime State Machine
- Constitution: `docs/specs/SPEC-000/`
