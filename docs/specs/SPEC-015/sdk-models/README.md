---
name: spec-015-sdk-models
description: SPEC-015 Appendix - SDK Canonical Models. 8 AM, Aggregate Root = SDK.
agent: general
---

# Appendix - SDK Canonical Models

> **SPEC-015**: SDK - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | SDK | AggregateRoot | SDK | - |
| AM-002 | SDKDefinition | Entity | SDK | yes |
| AM-003 | Client | Entity | SDK | yes |
| AM-004 | Binding | Entity | SDK | yes |
| AM-005 | SDKView | Value | SDK | - |
| AM-006 | SDKState | Transient | SDK | - |
| AM-007 | SDKExport | Entity | SDK | yes |
| AM-008 | MetricRef | Value | SDK | yes |

`aggregate_root: AM-001 SDK`

## Relationships

```text
SDK (AM-001)
  +- SDKDefinition (AM-002)
  +- Client (AM-003)
  +- Binding (AM-004)
  +- SDKExport (AM-007)
  +- MetricRef (AM-008)
  +- SDKView (AM-005)
  +- SDKState (AM-006)
```

## Validation

- Model co schema (SDK-models.schema.json).
- Immutable model khong doi (P005).
- Aggregate Root doc nhat: SDK.

## Tham chieu

- S011 Metrics - SPEC-001
- P005 Observability First
