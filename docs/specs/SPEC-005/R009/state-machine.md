---
name: spec-005-r009-state-machine
description: SPEC-005 R009 — Registry State Machine. 2 tầng.
agent: general
---

# R009 — Registry State Machine

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Entry chuyển trạng thái như thế nào?**

## RS001 — Philosophy

- Entry luôn có đúng một State.
- State chỉ thay đổi qua Transition.
- Mọi Transition sinh Event.
- **Entry Run dùng State Machine của Runtime (S009) — không định nghĩa lại.**

## RS002 — Principles

- State là nguồn sự thật duy nhất về Entry. · State độc lập implementation. · Transition quyết định Lifecycle. · Run State Machine = S009 (Runtime).

## RS003 — Structure (2 tầng)

1. **Definition State Machine** (RST-001..006).
2. **Run State Machine** — tham chiếu **S009 ST-001..014**.

## RS004 — Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| RST-001 Draft | Initial | Initial | — |
| RST-002 Validating | Preparation | Internal | — |
| RST-003 Published | Active | Active | — |
| RST-004 Deprecated | Control | Active | — |
| RST-005 Retired | Terminal | Terminal | ✅ |
| RST-006 Rejected | Terminal | Terminal | ✅ |

`initial_state: RST-001` · `terminal_states: [RST-005, RST-006]`

## RS005 — Definition Transitions (7)

| From → To | Event | Guard |
|-----------|-------|-------|
| RST-001 → RST-002 | REGISTRY_ENTRY_VALIDATING | Khai báo hợp lệ |
| RST-002 → RST-003 | REGISTRY_ENTRY_PUBLISHED | Validate pass + Storage OK |
| RST-002 → RST-006 | REGISTRY_ENTRY_REJECTED | Validate fail |
| RST-003 → RST-004 | REGISTRY_ENTRY_DEPRECATED | Governance (S013) |
| RST-004 → RST-003 | REGISTRY_ENTRY_REACTIVATED | Governance (S013) |
| RST-003 → RST-005 | REGISTRY_ENTRY_RETIRED | Governance (S013) |
| RST-004 → RST-005 | REGISTRY_ENTRY_RETIRED | Không còn dùng |

## RS006 — Run Mapping (tham chiếu S009)

```text
Entry Created → ST-001 · Validating → ST-002 · Running → ST-004
Completed → ST-008 · Failed → ST-009 · Cancelled → ST-010 · Aborted → ST-014
```

> **Không định nghĩa lại** — chỉ mapping.

## RS007 — Categories

- Initial: RST-001 · Preparation: RST-002 · Active: RST-003 · Control: RST-004 · Terminal: RST-005/006.

## RS008 — Triggers

- **Definition**: Storage · User · Governance (S013) · Scheduler.
- **Run**: Runtime · Policy (S012) · User · Timeout (S009).

## RS009 — Transitions

7 transitions định nghĩa ở RS005.

## RS010 — Transition Guards

- RST-001→002: khai báo hợp lệ (không code RB001).
- RST-002→003: validate pass + Storage OK.
- RST-002→006: validate fail (Invalid Audit S013).
- RST-003/004→005: Governance (S013) / không còn dùng.

## RS011 — State Events

- REGISTRY_ENTRY_VALIDATING · PUBLISHED · REJECTED · DEPRECATED · REACTIVATED · RETIRED.
- Run dùng events EXECUTION_* của S009. · S011 reuse.

## RS012 — State History

```yaml
history:
  fields: [entry_id, state_from, state_to, event, timestamp, correlation_id]
```

Append-only (S011).

## RS013 — State Metrics

- entry_state_distribution · invalid_transitions · published_count · rejected_count · deprecated_count · retired_count.

## RS014 — Validation

- Entry đúng một State. · Transition hợp lệ. · Mọi transition sinh Event (S011). · Run dùng S009 — không định nghĩa lại. · Terminal không có transition ra.

## RS015 — Machine-readable

```text
registry-state-machine.yaml
registry-states.yaml
registry-transitions.yaml
registry-transition-guards.yaml
registry-transition-triggers.yaml
registry-transition-types.yaml
registry-transition-matrix.yaml
registry-state-events.yaml
registry-state-history.yaml
registry-state-metrics.yaml
registry-state-machine-validation.yaml
registry-state-machine-registry.yaml
registry.schema.json
```

## RS016 — Traceability

```text
Entry State (RST) → Event (S011) → History
    ↓
Entry Run → S009 State (ST-001..014)
```

## RS017 — Success Criteria

- Definition có 6 states + 7 transitions.
- Mọi transition sinh Event (S011).
- Run mapping đầy đủ sang S009.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- R008: `../R008/data-model.md`
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
