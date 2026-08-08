---
name: spec-003-c009-state-machine
description: >
  SPEC-003 C009 — Capability State Machine. Trả lời: Capability chuyển trạng
  thái như thế nào? 2 tầng: Definition (CST-001..006) + Run (tham chiếu S009).
  Mirror W009 (SPEC-002).
agent: general
---

# C009 — Capability State Machine

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability chuyển trạng thái như thế nào?**

## CS001 — Philosophy

- Capability luôn có đúng một State.
- State chỉ thay đổi qua Transition.
- Transition phải hợp lệ.
- Mọi Transition sinh Event.
- **Capability Run dùng State Machine của Runtime (S009) — không định nghĩa lại.**

## CS002 — Principles

- State là nguồn sự thật duy nhất về Capability.
- State độc lập implementation.
- State bất biến sau khi rời khỏi.
- Transition quyết định Lifecycle.
- Không được bỏ qua State.
- Run State Machine = S009 (Runtime).

## CS003 — Structure (2 tầng)

1. **Definition State Machine** (CST-001..006) — vòng đời Capability Definition.
2. **Run State Machine** — Capability chạy như Execution của Runtime → tham chiếu **S009 ST-001..014**.

## CS004 — Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| CST-001 Draft | Initial | Initial | — |
| CST-002 Validating | Preparation | Internal | — |
| CST-003 Published | Active | Active | — |
| CST-004 Deprecated | Control | Active | — |
| CST-005 Retired | Terminal | Terminal | ✅ |
| CST-006 Rejected | Terminal | Terminal | ✅ |

`initial_state: CST-001` · `terminal_states: [CST-005, CST-006]`

## CS005 — Definition Transitions (7)

```text
CST-001 Draft ──► CST-002 Validating ──► CST-003 Published
                       │                       │
                       ▼                       ▼
                    CST-006 Rejected      CST-004 Deprecated
                                              │        │
                                              ▼        ▼
                                        CST-003 Reactivated   CST-005 Retired
```

| From → To | Event | Guard |
|-----------|-------|-------|
| CST-001 → CST-002 | CAPABILITY_VALIDATING | Khai báo hợp lệ (schema, không code) |
| CST-002 → CST-003 | CAPABILITY_PUBLISHED | Validate pass + Registry Entry (S014) |
| CST-002 → CST-006 | CAPABILITY_REJECTED | Validate fail |
| CST-003 → CST-004 | CAPABILITY_DEPRECATED | Governance (S013) cho phép |
| CST-004 → CST-003 | CAPABILITY_REACTIVATED | Governance (S013) duyệt |
| CST-003 → CST-005 | CAPABILITY_RETIRED | Governance (S013) |
| CST-004 → CST-005 | CAPABILITY_RETIRED | Không còn dùng |

## CS006 — Run Mapping (tham chiếu S009)

Capability Run là Execution của Runtime — mọi state của Run = S009:

```text
Capability Created → ST-001 · Validating → ST-002 · Prepared → ST-003
Running → ST-004 · Waiting (Gate) → ST-005 · Suspended → ST-006
Cancelling → ST-007 · Completed → ST-008 · Failed → ST-009
Cancelled → ST-010 · TimedOut → ST-011 · Aborted → ST-014
```

> **Không định nghĩa lại** — chỉ mapping.

## CS007 — Categories

- Initial: CST-001 · Preparation: CST-002 · Active: CST-003 · Control: CST-004 · Terminal: CST-005/006.

## CS008 — Triggers

- **Definition**: Registry (S014) · User · Governance (S013) · Scheduler.
- **Run**: Runtime · Policy (S012) · User · Approval · Timeout (triggers của S009).

## CS009 — Transitions

7 transitions định nghĩa ở CS005 — mỗi transition có event + guard.

## CS010 — Transition Guards

- CST-001→002: khai báo hợp lệ (schema, không code CB001).
- CST-002→003: validate pass + Registry Entry (S014).
- CST-002→006: validate fail (có Invalid Audit S013).
- CST-003→004: Governance (S013) cho phép.
- CST-004→003: Governance (S013) duyệt.
- CST-003/004→005: Governance (S013) / không còn dùng.

## CS011 — State Events

- CAPABILITY_VALIDATING · CAPABILITY_PUBLISHED · CAPABILITY_REJECTED · CAPABILITY_DEPRECATED · CAPABILITY_REACTIVATED · CAPABILITY_RETIRED.
- Run dùng events EXECUTION_* của S009.
- S011 reuse trực tiếp.

## CS012 — State History

```yaml
history:
  fields: [capability_id, state_from, state_to, event, timestamp, correlation_id]
```

Append-only (S011).

## CS013 — State Metrics

- capability_state_distribution · invalid_transitions · published_count · rejected_count · deprecated_count · retired_count.

## CS014 — Validation

Doctor kiểm tra:

- Capability có đúng một State.
- Transition hợp lệ (đã khai báo).
- Mọi transition sinh Event (S011).
- Run dùng State Machine S009 — không định nghĩa lại.
- Terminal không có transition ra.

## CS015 — Machine-readable

```text
capability-state-machine.yaml
capability-states.yaml
capability-transitions.yaml
capability-transition-guards.yaml
capability-transition-triggers.yaml
capability-transition-types.yaml
capability-transition-matrix.yaml
capability-state-events.yaml
capability-state-history.yaml
capability-state-metrics.yaml
capability-state-machine-validation.yaml
capability-state-machine-registry.yaml
capability.schema.json
```

## CS016 — Traceability

```text
Capability State (CST) → Event (S011) → History
    ↓
Capability Run → S009 State (ST-001..014)
```

## CS017 — Success Criteria

- Definition có 6 states + 7 transitions đầy đủ.
- Mọi transition sinh Event (S011).
- Run mapping đầy đủ sang S009.
- Không định nghĩa lại State Machine của Runtime.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C008: `../C008/data-model.md`
- W009: `../../SPEC-002/W009/state-machine.md` (mẫu)
- S009: `../../SPEC-001/S009/state-machine.yaml` (Run states)
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
