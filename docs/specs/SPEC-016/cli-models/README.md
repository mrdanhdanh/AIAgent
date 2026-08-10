---
name: spec-015-cli-models
description: SPEC-016 Appendix - CLI Canonical Models. 8 AM, Aggregate Root = CLI.
agent: general
---

# Appendix - CLI Canonical Models

> **SPEC-016**: CLI - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | CLI | AggregateRoot | CLI | - |
| AM-002 | CLIDefinition | Entity | CLI | yes |
| AM-003 | Widget | Entity | CLI | yes |
| AM-004 | Panel | Entity | CLI | yes |
| AM-005 | CLIView | Value | CLI | - |
| AM-006 | CLIState | Transient | CLI | - |
| AM-007 | CLIExport | Entity | CLI | yes |
| AM-008 | MetricRef | Value | CLI | yes |

`aggregate_root: AM-001 CLI`

## Relationships

```text
CLI (AM-001)
  +- CLIDefinition (AM-002)
  +- Widget (AM-003)
  +- Panel (AM-004)
  +- CLIExport (AM-007)
  +- MetricRef (AM-008)
  +- CLIView (AM-005)
  +- CLIState (AM-006)
```

## Validation

- Model co schema (CLI-models.schema.json).
- Immutable model khong doi (P005).
- Aggregate Root doc nhat: CLI.

## Tham chieu

- S011 Metrics - SPEC-001
- P005 Observability First
