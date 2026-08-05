---
name: spec-001-s009-state-machine
description: >
  SPEC-001 S009 — Runtime State Machine. Hiến pháp của Execution. 18 sections
  SM001-SM018, 14 states (ST-001..014), 18 transitions. Không mô tả
  implementation/code/class/enum/database.
agent: general
---

# S009 — Runtime State Machine

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Hiến pháp của Execution — Retry, Timeout, Cancellation, Replay, Approval, Rollback, Doctor đều là transition hợp lệ.

## Mục tiêu

> **Execution của Runtime được phép chuyển qua những trạng thái nào và theo quy tắc nào?**

Không mô tả:

- implementation
- code
- class
- enum
- database

Chỉ mô tả **Canonical State Machine**.

## SM001 — State Philosophy

- Runtime luôn ở đúng một State.
- Một Execution chỉ có một Active State.
- State chỉ thay đổi qua Transition.
- Transition phải hợp lệ.
- Mọi Transition sinh Event.
- State không được sửa trực tiếp.

## SM002 — State Principles

- State là nguồn sự thật duy nhất về Execution.
- State độc lập implementation.
- State bất biến sau khi rời khỏi.
- Transition quyết định Lifecycle.
- Không được bỏ qua State.

## SM003 — Runtime States (14)

| ID | State | Type |
|----|-------|------|
| ST-001 | Created | Initial |
| ST-002 | Validating | Internal |
| ST-003 | Prepared | Internal |
| ST-004 | Running | Active |
| ST-005 | Waiting | Active |
| ST-006 | Suspended | Active |
| ST-007 | Cancelling | Active |
| ST-008 | Completed | Terminal |
| ST-009 | Failed | Terminal |
| ST-010 | Cancelled | Terminal |
| ST-011 | TimedOut | Terminal |
| ST-012 | Replayed | Terminal |
| ST-013 | Retrying | Internal |
| ST-014 | Aborted | Terminal |

## SM004 — Transition Rules

```text
Created → Validating → Prepared → Running
Running → Waiting → Running (approval)
Running → Suspended → Running (pause/resume)
Running → Completed | Failed | TimedOut | Aborted | Cancelling → Cancelled
Failed → Retrying → Running (nếu policy cho phép)
Completed/Failed → Replayed (replay tạo Execution mới)
```

## SM005 — Transition Matrix

| From | To | Allowed |
|------|-----|---------|
| ST-001 Created | ST-002 Validating | ✔ |
| ST-001 Created | ST-004 Running | ✘ |
| ST-004 Running | ST-008 Completed | ✔ |
| ST-004 Running | ST-009 Failed | ✔ |
| ST-009 Failed | ST-004 Running | ✘ (qua Retrying) |

> Doctor đọc bảng này (`transition-matrix.yaml`) — đầy đủ 21 mục.

## SM006 — Transition Conditions

Mỗi transition có điều kiện:

**Running → Completed:**
- **Precondition**: tất cả Task hoàn thành.
- **Postcondition**: Result được publish.

**Running → Failed:**
- **Precondition**: lỗi không retry được.
- **Postcondition**: Failure Artifact.

## SM007 — State Invariants

- Chỉ một Active State tại một thời điểm.
- Terminal State không đổi.
- Initial State chỉ một lần.
- Không quay ngược Lifecycle.
- Event luôn đi cùng Transition.

## SM008 — State Ownership

- Owner luôn là **Runtime**.
- Không Agent nào được đổi State.

## SM009 — Failure State

| State | Nghĩa | Khác nhau |
|-------|-------|-----------|
| Failed | Lỗi thực thi, có thể retry | Recoverable |
| Cancelled | Người dùng/approval hủy | Intentional |
| TimedOut | Vượt thời gian (policy) | Policy-driven |
| Aborted | Lỗi hệ thống, không thể tiếp tục | System-level |

## SM010 — Retry Model

```text
Failed → Retrying → Running (nếu Policy cho phép)
```

Điều kiện: FR-018 Retry Policy, RULE-012. Giới hạn: max_retries, backoff, timeout_per_retry. Retry không thay đổi Lineage gốc.

## SM011 — Replay Model

- **Replay không phải Resume.**
- Replay tạo **Execution mới**.
- Lineage giữ nguyên.
- Completed/Failed → Replayed (terminal).

> Phục vụ Simulation, Doctor, Evolution.

## SM012 — Approval Gate

```text
Running → Waiting (Approval) → Running
```

## SM013 — State Events

Mỗi transition sinh Event (18 events — `state-events.yaml`):

- EXECUTION_VALIDATING, EXECUTION_PREPARED, EXECUTION_STARTED, EXECUTION_WAITING, EXECUTION_APPROVED, EXECUTION_SUSPENDED, EXECUTION_RESUMED, EXECUTION_CANCELLING, EXECUTION_CANCELLED, EXECUTION_COMPLETED, EXECUTION_FAILED, EXECUTION_TIMED_OUT, EXECUTION_ABORTED, EXECUTION_RETRYING, EXECUTION_RETRIED, EXECUTION_REPLAYED, EXECUTION_VALIDATION_FAILED

## SM014 — Machine-readable

```text
state-machine.yaml
states.yaml
transitions.yaml
transition-matrix.yaml
state-events.yaml
retry-model.yaml
replay-model.yaml
state.schema.json
```

## SM015 — Validation

Doctor kiểm tra:

- Invalid Transition.
- Multiple Active State.
- Missing Initial.
- Missing Terminal.
- Circular Transition.
- Dead State.
- Unreachable State.
- Missing Event.

## SM016 — Metrics

Dashboard:

```yaml
state_distribution: {}
average_duration: 0
failure_rate: 0
retry_rate: 0
timeout_rate: 0
cancellation_rate: 0
```

## SM017 — Traceability

```text
State → Transition → Requirement → Responsibility → Contract → Event → Execution Flow
```

## SM018 — Success Criteria

Hoàn thành khi:

- Chỉ có một Canonical State Machine.
- Mọi State có ID, Owner, Lifecycle và Transition rõ ràng.
- Mọi Transition đều có điều kiện và sinh Event.
- Không tồn tại Transition không hợp lệ hoặc trạng thái không thể đạt tới.
- Doctor xác minh toàn bộ State Machine từ file machine-readable.
- S010 (Execution Flow) chỉ mô tả **thứ tự thực thi**, không định nghĩa lại State.

## Tham chiếu

- `state-machine.yaml` — nguồn dữ liệu chuẩn.
- `states.yaml` — SM003.
- `transitions.yaml` — SM006.
- `transition-matrix.yaml` — SM005.
- `state-events.yaml` — SM013.
- `retry-model.yaml` — SM010.
- `replay-model.yaml` — SM011.
- `state.schema.json` — validate cấu trúc.
- Canonical Models: `../runtime-models/`
- S008: `../S008/data-model.md`
- Constitution: `docs/specs/SPEC-000/`
