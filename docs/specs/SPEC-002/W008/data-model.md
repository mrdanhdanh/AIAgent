---
name: spec-002-w008-data-model
description: >
  SPEC-002 W008 — Workflow Data Model. Trả lời: Workflow Engine quản lý dữ
  liệu nào? 15 entities, Aggregate Root = Workflow — không quản lý Business
  Data. Mirror S008 (SPEC-001).
agent: general
---

# W008 — Workflow Data Model

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine quản lý dữ liệu nào?**

## WF001 — Data Philosophy

- Workflow Data Model là SSOT (P009) cho Workflow Engine.
- Workflow không quản lý Business Data.
- Workflow không quản lý Execution Data (thuộc S008).

## WF002 — Aggregate Root

**Workflow** là Aggregate Root duy nhất.

- Workflow owns: [Definition, Context, Result, Events, Metrics].
- Workflow references: [Execution (S008), Capability, Registry Entry (S014)].
- Ownership và Reference khác nhau — không nhầm lẫn.

## WF003 — Classification

| Nhóm | Gồm |
|------|-----|
| Definition Data | WorkflowDefinition, WorkflowStep, Branch, Gate, Version |
| Execution Data | WorkflowContext, WorkflowResult |
| Transient | WorkflowContext |
| Persistent Metadata | WorkflowResult, Events, Metrics, Trace, Lineage |
| Reference Data | Execution Ref (S008), Capability Ref, Registry Entry (S014) |
| **Không quản lý** | Business Data, Knowledge, Plugin Data, User Data |

## WF004 — Entities (15)

| ID | Entity | Kind | Owner | Immutable |
|----|--------|------|-------|-----------|
| ENT-W001 | Workflow | AggregateRoot | Workflow | — |
| ENT-W002 | WorkflowDefinition | Entity | Workflow | ✅ |
| ENT-W003 | WorkflowVersion | Entity | Workflow | ✅ |
| ENT-W004 | WorkflowStep | Value | Workflow | ✅ |
| ENT-W005 | StepCondition | Value | Workflow | ✅ |
| ENT-W006 | StepGate | Value | Workflow | ✅ |
| ENT-W007 | StepContext | Transient | Workflow | — |
| ENT-W008 | WorkflowResult | Entity | Workflow | ✅ |
| ENT-W009 | WorkflowEvent | Ref (S011) | Runtime | ✅ |
| ENT-W010 | WorkflowMetric | Ref (S011) | Runtime | ✅ |
| ENT-W011 | WorkflowRegistryEntry | Ref (S014) | Workflow | ✅ |
| ENT-W012 | WorkflowPlan | Transient | Workflow | — |
| ENT-W013 | WorkflowLineage | Ref (S011) | Runtime | ✅ |
| ENT-W014 | ExecutionRef | Ref (S008) | Runtime | ✅ |
| ENT-W015 | WorkflowExtension | Value | Workflow | ✅ |

> ENT-W009/010/013/014 là **Reference** tới Runtime (S008/S011/S014) — không định nghĩa lại.

## WF005 — Invariants (12)

- Workflow có đúng một Definition.
- Definition có ít nhất một Step.
- WorkflowContext isolated.
- WorkflowResult immutable.
- Event không thay đổi.
- Workflow ID toàn cục.
- Workflow luôn có Owner.
- Workflow luôn có Version.
- Workflow luôn có Lifecycle.
- Workflow không đổi Identity.
- Definition không đổi khi Published.
- Step không đổi sau Published.

## WF006 — Consistency

- Levels: Definition Consistency · Context Consistency · Result Consistency.
- Definition luôn hợp lệ (validate trước khi chạy).
- Context không bị chia sẻ.
- Result luôn immutable.
- Metrics chỉ append.
- Event chỉ append.

## WF007 — Lifecycle

- **Definition**: Draft → Published → Deprecated → Retired.
- **Run**: Idle → Assigned → Running → Completed.

## WF008 — Ownership

- Workflow, Definition, Step, Context, Result → Workflow Team.
- Execution (S008) → Runtime.

## WF009 — References

- Workflow → Execution: ExecutionRef (S008).
- Workflow → Registry: WorkflowRegistryEntry (S014).
- Workflow → Capability: Capability Ref (S014).
- Workflow → Event: WorkflowEvent (S011).

## WF010 — Relations

- Workflow 1-1 Definition · Definition 1-N Step · Step 0-N Branch · Step 0-1 Gate · Workflow 1-1 Context (trong chạy) · Workflow 1-1 Result.

## WF011 — Validation

- Workflow có đúng một Definition.
- Definition có ít nhất một Step.
- Branch trỏ đến Step tồn tại.
- Gate có policy_ref (S012).
- Context không bị chia sẻ.
- Result immutable.
- Reference trỏ đến entity tồn tại.

## WF012 — Queries

- Theo Workflow ID.
- Theo Definition Version.
- Theo ExecutionRef (S008).
- Theo Registry Entry (S014).

## WF013 — Machine-readable

```text
workflow-data-model.yaml
workflow-entities.yaml
workflow-identities.yaml
workflow-invariants.yaml
workflow-lifecycle.yaml
workflow-ownership.yaml
workflow-references.yaml
workflow-relations.yaml
workflow-validation.yaml
workflow-data.schema.json
```

## WF014 — Traceability

```text
Workflow → Definition → Step → Branch/Gate
    ↓
Execution (S008) → Event/Metrics (S011) → Registry (S014)
```

## WF015 — Success Criteria

- Workflow là Aggregate Root duy nhất.
- 15 entities đủ fields.
- 12 invariants đúng.
- Không quản lý Business Data.
- Reference tới Runtime (S008/S011/S014) — không định nghĩa lại.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- Appendix: `../workflow-models/workflow-models.yaml`
- W002: `../W002/requirements.md`
- S008: `../../SPEC-001/S008/runtime-data-model.yaml` (mẫu)
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
