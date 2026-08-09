---
name: SPEC-013-x008-data-model
description: SPEC-013 X008 - Evolution Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Evolution Data Model

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Evolution mo phong workflow (SPEC-002).
- Evolution isolated - khong doi he thong that (RULE-007).
- Evolution chi chua Diff + result - KHONG chua Business Data (S011 OB003A).
- Evolution deterministic (P013).

## XD002 - Principles

- **Isolated** - khong doi he thong that (RULE-007).
- **Deterministic** - cung input cung ket qua (P013).
- **Replayable** - replay qua Event log (RULE-007).
- **Safe** - khong tao Artifact production (XNF-005).
- **Observable** - moi Evolution quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Evolution (AggregateRoot)
  +- EvolutionDefinition (Entity)
  +- Diff (Entity)
  +- EvolutionPlan (Entity)
  +- EvolutionResult (Value)
  +- EvolutionState (Transient)
  +- EvolutionReport (Entity) 0..1
  +- EvolutionSnapshot (Entity) 0..*
  +- refs: ExecutionRef, WorkflowRef, DiffRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Evolution | AggregateRoot | Evolution Engine | - |
| ENT-X002 | EvolutionDefinition | Entity | Evolution Engine | yes |
| ENT-X003 | Diff | Entity | Evolution Engine | yes |
| ENT-X004 | EvolutionPlan | Entity | Evolution Engine | yes |
| ENT-X005 | EvolutionResult | Value | Evolution Engine | - |
| ENT-X006 | EvolutionState | Transient | Evolution Engine | - |
| ENT-X007 | EvolutionReport | Entity | Evolution Engine | yes |
| ENT-X008 | EvolutionEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | EvolutionMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | EvolutionSnapshot | Entity | Evolution Engine | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | WorkflowRef | Ref (SPEC-002) | Workflow | yes |
| ENT-X013 | DiffRef | Ref (SPEC-013) | Evolution | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | EvolutionExtension | Value | Evolution Engine | yes |

## XD005 - Identity

- Evolution_id: UUID (Diffed sinh ra).
- execution_id: UUID.
- Diff: 6 types enum.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Evolution | EvolutionDefinition | 1..1 |
| REL-X002 | Evolution | Diff | 1..1 |
| REL-X003 | Evolution | EvolutionPlan | 1..1 |
| REL-X004 | Evolution | EvolutionResult | 1..1 |
| REL-X005 | Evolution | EvolutionState | 1..1 |
| REL-X006 | Evolution | EvolutionReport | 0..1 |
| REL-X007 | Evolution | ExecutionRef | 1..1 |
| REL-X008 | Evolution | EvolutionEvent | 0..* |
| REL-X009 | Evolution | EvolutionSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique EvolutionId.
2. Isolated - khong doi he thong that.
3. Deterministic.
4. Diff thuoc 6 types.
5. Plan hop le.
6. Result co the compare.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Diffed, Run.
- Vi pham -> BLOCK + error Evolution_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Diff store (P005).
- Persistent (report history).
- EvolutionSnapshot optional (debug).

## XD010 - Open Questions

- Khi nao snapshot huu ich?
- Retention mac dinh cho report?

## Tham chieu

- SPEC-002 Workflow
- RULE-007 Event
- S011 Observability
