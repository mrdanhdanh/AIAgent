---
name: spec-002-w009-state-machine
description: >
  SPEC-002 W009 — Workflow State Machine. Trả lời: Workflow chuyển trạng thái
  như thế nào? 2 tầng: Definition (WST-001..006) + Run (tham chiếu S009).
  Mirror S009 (SPEC-001).
agent: general
---

# W009 — Workflow State Machine

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow chuyển trạng thái như thế nào?**

## WS001 — Philosophy

- Workflow luôn có đúng một State.
- State chỉ thay đổi qua Transition.
- Transition phải hợp lệ.
- Mọi Transition sinh Event.
- **Workflow Run dùng State Machine của Runtime (S009) — không định nghĩa lại.**

## WS002 — Principles

- State là nguồn sự thật duy nhất về Workflow.
- State độc lập implementation.
- State bất biến sau khi rời khỏi.
- Transition quyết định Lifecycle.
- Không được bỏ qua State.
- Run State Machine = S009 (Runtime).

## WS003 — Structure (2 tầng)

1. **Definition State Machine** (WST-001..006) — vòng đời Workflow Definition.
2. **Run State Machine** — Workflow chạy như Execution của Runtime → tham chiếu **S009 ST-001..014**.

## WS004 — Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| WST-001 Draft | Initial | Initial | — |
| WST-002 Validating | Preparation | Internal | — |
| WST-003 Published | Active | Active | — |
| WST-004 Deprecated | Control | Active | — |
| WST-005 Retired | Terminal | Terminal | ✅ |
| WST-006 Rejected | Terminal | Terminal | ✅ |

`initial_state: WST-001` · `terminal_states: [WST-005, WST-006]`

## WS005 — Definition Transitions (7)

```text
WST-001 Draft ──► WST-002 Validating ──► WST-003 Published
                       │                       │
                       ▼                       ▼
                    WST-006 Rejected      WST-004 Deprecated
                                              │        │
                                              ▼        ▼
                                        WST-003 Reactivated   WST-005 Retired
```

| From → To | Event | Guard |
|-----------|-------|-------|
| WST-001 → WST-002 | WORKFLOW_VALIDATING | Khai báo hợp lệ (schema, không code) |
| WST-002 → WST-003 | WORKFLOW_PUBLISHED | Validate pass + Registry Entry (S014) |
| WST-002 → WST-006 | WORKFLOW_REJECTED | Validate fail |
| WST-003 → WST-004 | WORKFLOW_DEPRECATED | Governance (S013) cho phép |
| WST-004 → WST-003 | WORKFLOW_REACTIVATED | Governance (S013) duyệt |
| WST-003 → WST-005 | WORKFLOW_RETIRED | Governance (S013) |
| WST-004 → WST-005 | WORKFLOW_RETIRED | Không còn dùng |

## WS006 — Run Mapping (tham chiếu S009)

Workflow Run là Execution của Runtime — mọi state của Run = S009:

```text
Workflow Created → ST-001 · Validating → ST-002 · Prepared → ST-003
Running → ST-004 · Waiting (Gate) → ST-005 · Suspended → ST-006
Cancelling → ST-007 · Completed → ST-008 · Failed → ST-009
Cancelled → ST-010 · TimedOut → ST-011 · Replayed → ST-012
Retrying → ST-013 · Aborted → ST-014
```

> **Không định nghĩa lại** — chỉ mapping.

## WS007 — Categories

- Initial: WST-001 · Preparation: WST-002 · Active: WST-003 · Control: WST-004 · Terminal: WST-005/006.

## WS008 — Triggers

- **Definition**: Registry (S014) · User · Governance (S013) · Scheduler.
- **Run**: Runtime · Policy (S012) · User · Approval · Timeout (triggers của S009).

## WS009 — Transitions

7 transitions định nghĩa ở WS005 — mỗi transition có event + guard.

## WS010 — Transition Guards

- WST-001→002: khai báo hợp lệ (schema, không code WB001).
- WST-002→003: validate pass + Registry Entry (S014).
- WST-002→006: validate fail (có Invalid Audit S013).
- WST-003→004: Governance (S013) cho phép.
- WST-004→003: Governance (S013) duyệt.
- WST-003/004→005: Governance (S013) / không còn dùng.

## WS011 — State Events

- WORKFLOW_VALIDATING · WORKFLOW_PUBLISHED · WORKFLOW_REJECTED · WORKFLOW_DEPRECATED · WORKFLOW_REACTIVATED · WORKFLOW_RETIRED.
- Run dùng events EXECUTION_* của S009.
- W009 định nghĩa 6 event types WORKFLOW_* — S011 cung cấp event model (fields, correlation_id).

## WS012 — State History

```yaml
history:
  fields: [workflow_id, state_from, state_to, event, timestamp, correlation_id]
```

Append-only (S011); mỗi transition ghi history + Event.

## WS013 — State Metrics

- workflow_state_distribution · invalid_transitions · published_count · rejected_count · deprecated_count · retired_count.

## WS014 — Validation

Doctor kiểm tra:

- Workflow có đúng một State.
- Transition hợp lệ (đã khai báo).
- Mọi transition sinh Event (S011).
- Run dùng State Machine S009 — không định nghĩa lại.
- Terminal không có transition ra.

## WS015 — Machine-readable

```text
workflow-state-machine.yaml
workflow-states.yaml
workflow-transitions.yaml
workflow-transition-guards.yaml
workflow-transition-triggers.yaml
workflow-transition-types.yaml
workflow-transition-matrix.yaml
workflow-state-events.yaml
workflow-state-history.yaml
workflow-state-metrics.yaml
workflow-state-machine-validation.yaml
workflow-state-machine-registry.yaml
workflow.schema.json
```

## WS016 — Traceability

```text
Workflow State (WST) → Event (S011) → History
    ↓
Workflow Run → S009 State (ST-001..014)
```

## WS017 — Success Criteria

- Definition có 6 states + 7 transitions đầy đủ.
- Mọi transition sinh Event (S011).
- Run mapping đầy đủ sang S009.
- Không định nghĩa lại State Machine của Runtime.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- W008: `../W008/data-model.md`
- S009: `../../SPEC-001/S009/state-machine.yaml` (mẫu + Run states)
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
