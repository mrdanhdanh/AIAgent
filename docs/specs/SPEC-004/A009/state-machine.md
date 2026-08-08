---
name: spec-004-a009-state-machine
description: >
  SPEC-004 A009 — Agent State Machine. Trả lời: Agent chuyển trạng thái như
  thế nào? 2 tầng: Definition (AST-001..006) + Run (tham chiếu S009).
  Mirror C009 (SPEC-003).
agent: general
---

# A009 — Agent State Machine

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent chuyển trạng thái như thế nào?**

## AS001 — Philosophy

- Agent luôn có đúng một State.
- State chỉ thay đổi qua Transition.
- Transition phải hợp lệ.
- Mọi Transition sinh Event.
- **Agent Run dùng State Machine của Runtime (S009) — không định nghĩa lại.**

## AS002 — Principles

- State là nguồn sự thật duy nhất về Agent.
- State độc lập implementation.
- State bất biến sau khi rời khỏi.
- Transition quyết định Lifecycle.
- Không được bỏ qua State.
- Run State Machine = S009 (Runtime).

## AS003 — Structure (2 tầng)

1. **Definition State Machine** (AST-001..006) — vòng đời Agent Definition.
2. **Run State Machine** — Agent chạy như Execution của Runtime → tham chiếu **S009 ST-001..014**.

## AS004 — Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| AST-001 Draft | Initial | Initial | — |
| AST-002 Validating | Preparation | Internal | — |
| AST-003 Published | Active | Active | — |
| AST-004 Deprecated | Control | Active | — |
| AST-005 Retired | Terminal | Terminal | ✅ |
| AST-006 Rejected | Terminal | Terminal | ✅ |

`initial_state: AST-001` · `terminal_states: [AST-005, AST-006]`

## AS005 — Definition Transitions (7)

```text
AST-001 Draft ──► AST-002 Validating ──► AST-003 Published
                       │                       │
                       ▼                       ▼
                    AST-006 Rejected      AST-004 Deprecated
                                              │        │
                                              ▼        ▼
                                        AST-003 Reactivated   AST-005 Retired
```

| From → To | Event | Guard |
|-----------|-------|-------|
| AST-001 → AST-002 | AGENT_VALIDATING | Khai báo hợp lệ (schema, không code) |
| AST-002 → AST-003 | AGENT_PUBLISHED | Validate pass + Registry Entry (S014) |
| AST-002 → AST-006 | AGENT_REJECTED | Validate fail |
| AST-003 → AST-004 | AGENT_DEPRECATED | Governance (S013) cho phép |
| AST-004 → AST-003 | AGENT_REACTIVATED | Governance (S013) duyệt |
| AST-003 → AST-005 | AGENT_RETIRED | Governance (S013) |
| AST-004 → AST-005 | AGENT_RETIRED | Không còn dùng |

## AS006 — Run Mapping (tham chiếu S009)

Agent Run là Execution của Runtime — mọi state của Run = S009:

```text
Agent Created → ST-001 · Validating → ST-002 · Prepared → ST-003
Running → ST-004 · Waiting (Gate) → ST-005 · Suspended → ST-006
Cancelling → ST-007 · Completed → ST-008 · Failed → ST-009
Cancelled → ST-010 · TimedOut → ST-011 · Aborted → ST-014
```

> **Không định nghĩa lại** — chỉ mapping.

## AS007 — Categories

- Initial: AST-001 · Preparation: AST-002 · Active: AST-003 · Control: AST-004 · Terminal: AST-005/006.

## AS008 — Triggers

- **Definition**: Registry (S014) · User · Governance (S013) · Scheduler.
- **Run**: Runtime · Policy (S012) · User · Approval · Timeout (triggers của S009).

## AS009 — Transitions

7 transitions định nghĩa ở AS005 — mỗi transition có event + guard.

## AS010 — Transition Guards

- AST-001→002: khai báo hợp lệ (schema, không code AB001).
- AST-002→003: validate pass + Registry Entry (S014).
- AST-002→006: validate fail (có Invalid Audit S013).
- AST-003→004: Governance (S013) cho phép.
- AST-004→003: Governance (S013) duyệt.
- AST-003/004→005: Governance (S013) / không còn dùng.

## AS011 — State Events

- AGENT_VALIDATING · AGENT_PUBLISHED · AGENT_REJECTED · AGENT_DEPRECATED · AGENT_REACTIVATED · AGENT_RETIRED.
- Run dùng events EXECUTION_* của S009.
- S011 reuse trực tiếp.

## AS012 — State History

```yaml
history:
  fields: [agent_id, state_from, state_to, event, timestamp, correlation_id]
```

Append-only (S011).

## AS013 — State Metrics

- agent_state_distribution · invalid_transitions · published_count · rejected_count · deprecated_count · retired_count.

## AS014 — Validation

Doctor kiểm tra:

- Agent có đúng một State.
- Transition hợp lệ (đã khai báo).
- Mọi transition sinh Event (S011).
- Run dùng State Machine S009 — không định nghĩa lại.
- Terminal không có transition ra.

## AS015 — Machine-readable

```text
agent-state-machine.yaml
agent-states.yaml
agent-transitions.yaml
agent-transition-guards.yaml
agent-transition-triggers.yaml
agent-transition-types.yaml
agent-transition-matrix.yaml
agent-state-events.yaml
agent-state-history.yaml
agent-state-metrics.yaml
agent-state-machine-validation.yaml
agent-state-machine-registry.yaml
agent.schema.json
```

## AS016 — Traceability

```text
Agent State (AST) → Event (S011) → History
    ↓
Agent Run → S009 State (ST-001..014)
```

## AS017 — Success Criteria

- Definition có 6 states + 7 transitions đầy đủ.
- Mọi transition sinh Event (S011).
- Run mapping đầy đủ sang S009.
- Không định nghĩa lại State Machine của Runtime.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A008: `../A008/data-model.md`
- C009: `../../SPEC-003/C009/state-machine.md` (mẫu)
- S009: `../../SPEC-001/S009/state-machine.yaml` (Run states)
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
