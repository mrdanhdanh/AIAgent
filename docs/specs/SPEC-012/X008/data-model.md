---
name: spec-012-x008-data-model
description: SPEC-012 X008 - Simulation Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Simulation Data Model

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Simulation mo phong workflow (SPEC-002).
- Simulation isolated - khong doi he thong that (RULE-007).
- Simulation chi chua scenario + result - KHONG chua Business Data (S011 OB003A).
- Simulation deterministic (P013).

## XD002 - Principles

- **Isolated** - khong doi he thong that (RULE-007).
- **Deterministic** - cung input cung ket qua (P013).
- **Replayable** - replay qua Event log (RULE-007).
- **Safe** - khong tao Artifact production (XNF-005).
- **Observable** - moi simulation quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Simulation (AggregateRoot)
  +- SimulationDefinition (Entity)
  +- Scenario (Entity)
  +- SimulationConfig (Entity)
  +- SimulationResult (Value)
  +- SimulationState (Transient)
  +- SimulationReport (Entity) 0..1
  +- SimulationSnapshot (Entity) 0..*
  +- refs: ExecutionRef, WorkflowRef, ScenarioRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Simulation | AggregateRoot | Simulation Engine | - |
| ENT-X002 | SimulationDefinition | Entity | Simulation Engine | yes |
| ENT-X003 | Scenario | Entity | Simulation Engine | yes |
| ENT-X004 | SimulationConfig | Entity | Simulation Engine | yes |
| ENT-X005 | SimulationResult | Value | Simulation Engine | - |
| ENT-X006 | SimulationState | Transient | Simulation Engine | - |
| ENT-X007 | SimulationReport | Entity | Simulation Engine | yes |
| ENT-X008 | SimulationEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | SimulationMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | SimulationSnapshot | Entity | Simulation Engine | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | WorkflowRef | Ref (SPEC-002) | Workflow | yes |
| ENT-X013 | ScenarioRef | Ref (SPEC-012) | Simulation | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | SimulationExtension | Value | Simulation Engine | yes |

## XD005 - Identity

- simulation_id: UUID (Define sinh ra).
- execution_id: UUID.
- scenario: 6 types enum.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Simulation | SimulationDefinition | 1..1 |
| REL-X002 | Simulation | Scenario | 1..1 |
| REL-X003 | Simulation | SimulationConfig | 1..1 |
| REL-X004 | Simulation | SimulationResult | 1..1 |
| REL-X005 | Simulation | SimulationState | 1..1 |
| REL-X006 | Simulation | SimulationReport | 0..1 |
| REL-X007 | Simulation | ExecutionRef | 1..1 |
| REL-X008 | Simulation | SimulationEvent | 0..* |
| REL-X009 | Simulation | SimulationSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique SimulationId.
2. Isolated - khong doi he thong that.
3. Deterministic.
4. Scenario thuoc 6 types.
5. Config hop le.
6. Result co the compare.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Define, Run.
- Vi pham -> BLOCK + error SIMULATION_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Scenario store (P005).
- Persistent (report history).
- SimulationSnapshot optional (debug).

## XD010 - Open Questions

- Khi nao snapshot huu ich?
- Retention mac dinh cho report?

## Tham chieu

- SPEC-002 Workflow
- RULE-007 Event
- S011 Observability
