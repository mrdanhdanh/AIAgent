---
name: spec-011-doctor-models
description: SPEC-011 Appendix - Doctor Canonical Models. 8 AM, Aggregate Root = Scan.
agent: general
---

# Appendix - Doctor Canonical Models

> **SPEC-011**: Doctor - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Scan | AggregateRoot | Doctor | - |
| AM-002 | ScanDefinition | Entity | Doctor | yes |
| AM-003 | Finding | Entity | Doctor | - |
| AM-004 | HealthScore | Entity | Doctor | yes |
| AM-005 | RepairAction | Value | Doctor | - |
| AM-006 | ScanState | Transient | Doctor | - |
| AM-007 | DoctorReport | Entity | Doctor | yes |
| AM-008 | ScannerRef | Value | Doctor | yes |

`aggregate_root: AM-001 Scan`

## Relationships

```text
Scan (AM-001)
  +- ScanDefinition (AM-002)
  +- Finding (AM-003)
  +- HealthScore (AM-004)
  +- DoctorReport (AM-007)
  +- ScannerRef (AM-008)
  +- RepairAction (AM-005)
  +- ScanState (AM-006)
```

## Validation

- Model co schema (doctor-models.schema.json).
- Immutable model khong doi (P010).
- Aggregate Root doc nhat: Scan.

## Tham chieu

- /doctor command
- P005 Observability
