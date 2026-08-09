---
name: spec-013-evolution-models
description: SPEC-013 Appendix - Evolution Canonical Models. 8 AM, Aggregate Root = Evolution.
agent: general
---

# Appendix - Evolution Canonical Models

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Evolution | AggregateRoot | Evolution Engine | - |
| AM-002 | EvolutionDefinition | Entity | Evolution Engine | yes |
| AM-003 | SemanticDiff | Entity | Evolution Engine | yes |
| AM-004 | CompatibilityReport | Entity | Evolution Engine | yes |
| AM-005 | MigrationPlan | Value | Evolution Engine | - |
| AM-006 | EvolutionState | Transient | Evolution Engine | - |
| AM-007 | EvolutionReport | Entity | Evolution Engine | yes |
| AM-008 | ModuleRef | Value | Evolution Engine | yes |

`aggregate_root: AM-001 Evolution`

## Relationships

```text
Evolution (AM-001)
  +- EvolutionDefinition (AM-002)
  +- SemanticDiff (AM-003)
  +- CompatibilityReport (AM-004)
  +- EvolutionReport (AM-007)
  +- ModuleRef (AM-008)
  +- MigrationPlan (AM-005)
  +- EvolutionState (AM-006)
```

## Validation

- Model co schema (evolution-models.schema.json).
- Immutable model khong doi (P013).
- Aggregate Root doc nhat: Evolution.

## Tham chieu

- /team-syncdocs (9 modules)
- P013 Deterministic Execution
