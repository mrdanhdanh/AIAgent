---
name: spec-001-s009-state-machine
description: >
  SPEC-001 S009 — Runtime State Machine. Trái tim của Runtime. 15 sections
  ST001-ST015. Thiết kế hành vi (Behavior), không thiết kế enum.
  Không nói class/implementation.
agent: general
---

# S009 — Runtime State Machine

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Trái tim của Runtime — ảnh hưởng S010-S015, Dashboard, Doctor, Simulation, Replay, Evolution.

## ST001 — Philosophy

- **Không thiết kế enum — thiết kế hành vi (Behavior).**
- State quyết định hành vi.
- Mọi transition phải có Event + Guard.
- Data là biểu diễn của State.

## ST002 — Principles

- Mỗi State Machine: initial state + terminal states + transitions.
- Mọi transition phát Event (P005).
- Mọi transition có Guard (điều kiện hợp lệ).
- State thuộc Runtime (P006, B006).
- Không transition ngoài bảng.

## ST003 — State Model

```yaml
state_machine:
  model: RM-###
  owner:
  states: [...]
  initial_state:
  terminal_states: [...]
  recovery_states: [...]
  transitions:
    - { from, to, event, guard }
```

## ST004 — State Categories

```text
Initial        → Created
PreExecution   → Validated, Ready
Active         → Running, Paused, Resuming, Retrying
Recovery       → Failed, Retrying
Terminal       → Completed, Cancelled, Archived
```

## ST005 — Execution Lifecycle

```text
Created
    ↓
Validated
    ↓
Ready
    ↓
Running
    ↓
Paused → Resuming → Running
    ↓
Completed
```

Nhánh lỗi:

```text
Running
    ↓
Failed
    ↓
Retrying
    ↓
Running
```

Terminal:

```text
Running → Cancelled
Completed/Failed/Cancelled → Archived
```

## ST006 — Transition Rules

- Chỉ transition có trong bảng là hợp lệ.
- Mọi transition có Guard.
- Transition phát Event tương ứng.
- Không bypass state (VD: Ready → Completed không hợp lệ).

## ST007 — Transition Validation

Doctor kiểm tra:

- Mọi transition phát Event (P005).
- Mọi transition có Guard.
- Execution luôn kết thúc bằng Terminal State.
- Không có transition ngoài bảng.
- Retry phải qua recovery state (Failed → Retrying → Running).

## ST008 — Terminal States

- **Execution**: Completed, Cancelled, Archived.
- **Task**: Completed, Failed.
- **Workflow**: Completed, Archived.
- **Context**: Closed.
- **Contract**: Deprecated.
- **Artifact**: Archived.
- **Capability**: Removed.

## ST009 — Recovery States

- **Execution**: Failed → Retrying → Running (Retry policy guard).
- **Task**: Failed → Running (retry).
- Retry phải có guard (FR-018 Retry Policy, RULE-012).

## ST010 — State Events

Mỗi transition có event tương ứng (chi tiết `state-events.yaml`):

- EXECUTION_VALIDATED, EXECUTION_READY, EXECUTION_STARTED, EXECUTION_PAUSED, EXECUTION_RESUMING, EXECUTION_RESUMED, EXECUTION_FAILED, EXECUTION_RETRYING, EXECUTION_RETRIED, EXECUTION_CANCELLED, EXECUTION_ARCHIVED
- TASK_STARTED, TASK_COMPLETED, TASK_FAILED, TASK_RETRY
- WORKFLOW_APPROVED, WORKFLOW_STARTED, WORKFLOW_COMPLETED, WORKFLOW_FAILED, WORKFLOW_ARCHIVED
- CONTEXT_ACTIVATED, CONTEXT_CLOSED

> Event immutable (P005). S011 (Event Model) tham chiếu tại đây.

## ST011 — State Metrics

```yaml
state_machine_count: 7
execution_states: 11
terminal_transitions: 3
recovery_transitions: 2
invalid_transitions: 0
```

## ST012 — State Ownership

| State Machine | Owner |
|---------------|-------|
| Execution | Runtime |
| Task | Phase |
| Workflow | Workflow |
| Context | Runtime |
| Contract | Component |
| Artifact | Runtime |
| Capability | Registry |

## ST013 — State Invariants

- Execution luôn kết thúc bằng Terminal State.
- Mọi transition phát Event.
- Không transition ngoài bảng.
- Retry phải có guard (Retry policy).
- Context không chia sẻ giữa hai Execution.
- State thuộc Runtime, Agent không giữ state (P006).

## ST014 — State Mapping

```text
State Machine → Component (State Manager CMP-004)
             → Contract (State Contract CTR-007)
             → Model (RM-001/002/004/005/006/008/009/010)
             → Responsibility (RR-015..018)
             → Requirement (FR-006)
             → Boundary (B006)
             → Rule (RULE-005)
             → Principle (P005, P009)
```

## ST015 — Success Criteria

- State Machine chuẩn cho Runtime.
- Mô hình chuyển trạng thái hợp lệ.
- Doctor kiểm tra mọi transition.
- Simulation mô phỏng toàn bộ Execution.
- Replay phát lại Execution.
- Dashboard hiển thị tiến trình.
- S010 chỉ cần đọc State Machine để mô tả luồng thực thi.

## Tham chiếu

- `state-machine.yaml` — nguồn dữ liệu chuẩn (7 state machines).
- `execution-state-machine.yaml` — ST005.
- `state-categories.yaml` — ST004.
- `state-events.yaml` — ST010.
- `state-machine-registry.yaml` — registry tổng hợp.
- `state-machine-validation.yaml` — ST007.
- `state-machine.schema.json` — validate cấu trúc.
- Canonical Models: `../runtime-models/`
- S006: `../S006/components.yaml` (CMP-004)
- S007: `../S007/contracts.yaml` (CTR-007)
- S010 (Execution Flow) sẽ đọc tại đây.
- Constitution: `docs/specs/SPEC-000/`
