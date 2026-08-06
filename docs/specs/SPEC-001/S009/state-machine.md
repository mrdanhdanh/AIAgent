---
name: spec-001-s009-state-machine
description: >
  SPEC-001 S009 — Runtime State Machine. Hiến pháp của Execution. 20 sections
  SM001-SM020, 14 states (ST-001..014), 6 categories, 19 transitions.
  Không mô tả implementation/code/class/enum/database.
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

### Category

| Category | States |
|----------|--------|
| Initial | Created |
| Preparation | Validating, Prepared |
| Active | Running, Waiting, Suspended |
| Control | Retrying, Cancelling |
| Terminal | Completed, Failed, Cancelled, TimedOut, Aborted |
| Virtual | Replayed |

### Catalog

| ID | State | Category | Type |
|----|-------|----------|------|
| ST-001 | Created | Initial | Initial |
| ST-002 | Validating | Preparation | Internal |
| ST-003 | Prepared | Preparation | Internal |
| ST-004 | Running | Active | Active |
| ST-005 | Waiting | Active | Active |
| ST-006 | Suspended | Active | Active |
| ST-007 | Cancelling | Control | Active |
| ST-008 | Completed | Terminal | Terminal |
| ST-009 | Failed | Terminal | Terminal (retryable) |
| ST-010 | Cancelled | Terminal | Terminal |
| ST-011 | TimedOut | Terminal | Terminal |
| ST-012 | Replayed | Virtual | Terminal |
| ST-013 | Retrying | Control | Internal |
| ST-014 | Aborted | Terminal | Terminal |

## SM004 — State Metadata (template chuẩn)

```yaml
state:
  id:
  name:
  category:
  type:
  owner:
  enter_conditions:
  exit_conditions:
  allowed_transitions:
  events:
  terminal:
  retryable:
  metadata:
```

## SM005 — Transition Model (first-class entity)

```yaml
transition:
  id: TR-###
  from:
  to:
  trigger:
  preconditions:
  postconditions:
  generated_events:
  policy:
  timeout:
```

> Transition là thực thể hạng nhất, không chỉ là mũi tên.

## SM006 — Transition Rules

```text
Created → Validating → Prepared → Running
Running → Waiting → Running (approval)
Running → Suspended → Running (pause/resume)
Running → Completed | Failed | TimedOut | Aborted | Cancelling → Cancelled
Failed → Retrying → Running (nếu policy cho phép)
Completed/Failed → Replayed (replay tạo Execution mới)
```

## SM007 — Transition Matrix

| From | To | Allowed |
|------|-----|---------|
| ST-001 Created | ST-002 Validating | ✔ |
| ST-001 Created | ST-004 Running | ✘ |
| ST-004 Running | ST-008 Completed | ✔ |
| ST-004 Running | ST-009 Failed | ✔ |
| ST-009 Failed | ST-004 Running | ✘ (qua Retrying) |

> Doctor đọc bảng này (`transition-matrix.yaml`).

## SM008 — Transition Conditions

Mỗi transition có điều kiện:

**Running → Completed:**
- **Precondition**: tất cả Task hoàn thành.
- **Postcondition**: Result được publish.

**Running → Failed:**
- **Precondition**: lỗi không retry được.
- **Postcondition**: Failure Artifact.

## SM009 — Triggers

| Trigger | Ví dụ |
|---------|-------|
| Runtime | Running → Completed |
| Policy | Failed → Retrying (retry policy) |
| User | Running → Cancelled |
| Approval | Running → Waiting / Waiting → Running |
| Timeout | Running → TimedOut |
| Event | Completed → Replayed |
| Scheduler | Retrying → Running |

## SM010 — Guards

Guard khác Precondition — Guard quyết định transition có được phép hay không:

```text
Failed → Retrying
Guard: retry_count < policy.max_retry
```

## SM011 — State Invariants

- Chỉ một Active State tại một thời điểm.
- Terminal State không đổi.
- Initial State chỉ một lần.
- Không quay ngược Lifecycle.
- Event luôn đi cùng Transition.

## SM012 — State Ownership

- Owner luôn là **Runtime**.
- State chỉ Runtime được phép thay đổi.
- Agent / Workflow / Plugin / Policy **không được sửa trực tiếp**.

## SM013 — Terminal Rules

- Terminal **không có transition ra**.
- **Ngoại lệ duy nhất**: Replay (tạo Execution mới, không quay lại Execution cũ).

## SM014 — Failure States

| State | Nghĩa | Khác nhau |
|-------|-------|-----------|
| Failed | Lỗi thực thi, có thể retry | Recoverable |
| Cancelled | Người dùng/approval hủy | Intentional |
| TimedOut | Vượt thời gian (policy) | Policy-driven |
| Aborted | Lỗi hệ thống, không thể tiếp tục | System-level |

## SM015 — Retry Model

```text
Failed → Retrying → Running (nếu Policy cho phép)
Guard: retry_count < policy.max_retry
```

Giới hạn: max_retries, backoff, timeout_per_retry. Retry không thay đổi Lineage gốc.

## SM016 — Replay Model

- **Replay không phải Resume.**
- Replay tạo **Execution mới**.
- Lineage giữ nguyên.
- Completed/Failed → Replayed (terminal).

> Phục vụ Simulation, Doctor, Evolution.

## SM017 — Approval Gate

```text
Running → Waiting (Approval) → Running
```

## SM018 — Concurrency & Composite

**Concurrency Rules:**

- Một Execution chỉ có một Active State.
- Không được Running + Waiting đồng thời.

**Composite States:**

- Execution State ≠ Task State ≠ Phase State.
- Không được trộn lẫn các mức state.

## SM019 — State Principles & Design Rules

- **One Active State** — luôn đúng một Active State.
- **Immutable History** — history chỉ append.
- **Deterministic Transition** — cùng trigger + guard → cùng kết quả.
- **Explicit Transition** — không transition ngầm.
- **Event on Transition** — mọi transition sinh event.
- **Runtime Owned** — chỉ Runtime đổi state.
- **Replay Creates New Execution** — replay không quay lại execution cũ.

## SM020 — Compliance & Traceability Matrix

```text
State → Requirement → Principle → Rule → Doctor Rule
```

Traceability:

```text
State → Transition → Event → Artifact → Requirement → Responsibility → Boundary → Doctor
```

Doctor kiểm tra mọi state/transition theo matrix này.

## Machine-readable

```text
state-machine.yaml
states.yaml
transitions.yaml
transition-types.yaml
transition-triggers.yaml
transition-matrix.yaml
transition-guards.yaml
state-events.yaml
state-history.yaml
state-metrics.yaml
retry-model.yaml
replay-model.yaml
state.schema.json
```

## Validation (SM015 cũ → mở rộng)

Doctor kiểm tra:

- Invalid Transition.
- Multiple Active State.
- Missing Initial.
- Missing Terminal.
- Circular Transition.
- Dead State.
- Unreachable State.
- Missing Event.
- Invalid Guard.

## Success Criteria

Hoàn thành khi:

- Chỉ có một Canonical State Machine.
- Mọi State có ID, Category, Owner, Lifecycle, Transition rõ ràng.
- Mọi Transition là first-class (trigger/guard/pre/post/events/policy/timeout).
- Mọi Trigger + Guard được định nghĩa.
- Không tồn tại Transition không hợp lệ hoặc trạng thái không thể đạt tới.
- Doctor xác minh toàn bộ từ file machine-readable.
- S010 (Execution Flow) chỉ mô tả **thứ tự thực thi**, không định nghĩa lại State.

## Tham chiếu

- `state-machine.yaml` — nguồn dữ liệu chuẩn.
- `states.yaml` — SM003.
- `transitions.yaml` — SM005.
- `transition-types.yaml` / `transition-triggers.yaml` / `transition-guards.yaml` — SM009/SM010.
- `transition-matrix.yaml` — SM007.
- `state-events.yaml` — Event on transition.
- `state-history.yaml` — history immutable.
- `state-metrics.yaml` — Dashboard.
- `retry-model.yaml` — SM015.
- `replay-model.yaml` — SM016.
- `state.schema.json` — validate cấu trúc.
- Canonical Models: `../runtime-models/`
- S008: `../S008/data-model.md`
- Constitution: `docs/specs/SPEC-000/`
