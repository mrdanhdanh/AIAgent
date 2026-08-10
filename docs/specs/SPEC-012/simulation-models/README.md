---
name: spec-012-simulation-models
description: SPEC-012 Appendix - Simulation Canonical Models. 8 AM, Aggregate Root = Simulation.
agent: general
---

# Appendix - Simulation Canonical Models

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Simulation | AggregateRoot | Simulation Engine | - |
| AM-002 | SimulationDefinition | Entity | Simulation Engine | yes |
| AM-003 | Scenario | Entity | Simulation Engine | yes |
| AM-004 | SimulationConfig | Entity | Simulation Engine | yes |
| AM-005 | SimulationResult | Value | Simulation Engine | - |
| AM-006 | SimulationState | Transient | Simulation Engine | - |
| AM-007 | SimulationReport | Entity | Simulation Engine | yes |
| AM-008 | WorkflowRef | Value | Simulation Engine | yes |

`aggregate_root: AM-001 Simulation`

## Relationships

```text
Simulation (AM-001)
  +- SimulationDefinition (AM-002)
  +- Scenario (AM-003)
  +- SimulationConfig (AM-004)
  +- SimulationReport (AM-007)
  +- WorkflowRef (AM-008)
  +- SimulationResult (AM-005)
  +- SimulationState (AM-006)
```

## Validation

- Model co schema (simulation-models.schema.json).
- Immutable model khong doi (P005).
- Aggregate Root doc nhat: Simulation.

## Tham chieu

- SPEC-002 Workflow
- RULE-007 Event
