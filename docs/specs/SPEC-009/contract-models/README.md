---
name: spec-009-contract-models
description: SPEC-009 Appendix - Contract Canonical Models. 8 AM, Aggregate Root = Contract.
agent: general
---

# Appendix - Contract Canonical Models

> **SPEC-009**: Contract System - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Contract | AggregateRoot | Contract Registry | yes |
| AM-002 | ContractDefinition | Entity | Contract Registry | yes |
| AM-003 | ContractVersion | Entity | Contract Registry | yes |
| AM-004 | ContractSchema | Entity | Contract Registry | yes |
| AM-005 | ContractBinding | Value | Contract Registry | - |
| AM-006 | ContractState | Transient | Contract Registry | - |
| AM-007 | ContractVerification | Entity | Contract Registry | yes |
| AM-008 | ContractReference | Value | Contract Registry | yes |

`aggregate_root: AM-001 Contract`

## Relationships

```text
Contract (AM-001)
  +- ContractDefinition (AM-002)
  +- ContractVersion (AM-003)
  +- ContractSchema (AM-004)
  +- ContractVerification (AM-007)
  +- ContractReference (AM-008)
  +- ContractBinding (AM-005)
  +- ContractState (AM-006)
```

## Validation

- Model co schema (contract-models.schema.json).
- Immutable model khong doi (P004).
- Aggregate Root doc nhat: Contract.

## Tham chieu

- S007 Contract Model - SPEC-001
- TERM-014 Contract
