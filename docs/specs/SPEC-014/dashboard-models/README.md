---
name: spec-014-dashboard-models
description: SPEC-014 Appendix - Dashboard Canonical Models. 8 AM, Aggregate Root = Dashboard.
agent: general
---

# Appendix - Dashboard Canonical Models

> **SPEC-014**: Dashboard - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Dashboard | AggregateRoot | Dashboard | - |
| AM-002 | DashboardDefinition | Entity | Dashboard | yes |
| AM-003 | Widget | Entity | Dashboard | yes |
| AM-004 | Panel | Entity | Dashboard | yes |
| AM-005 | DashboardView | Value | Dashboard | - |
| AM-006 | DashboardState | Transient | Dashboard | - |
| AM-007 | DashboardExport | Entity | Dashboard | yes |
| AM-008 | MetricRef | Value | Dashboard | yes |

`aggregate_root: AM-001 Dashboard`

## Relationships

```text
Dashboard (AM-001)
  +- DashboardDefinition (AM-002)
  +- Widget (AM-003)
  +- Panel (AM-004)
  +- DashboardExport (AM-007)
  +- MetricRef (AM-008)
  +- DashboardView (AM-005)
  +- DashboardState (AM-006)
```

## Validation

- Model co schema (dashboard-models.schema.json).
- Immutable model khong doi (P005).
- Aggregate Root doc nhat: Dashboard.

## Tham chieu

- S011 Metrics - SPEC-001
- P005 Observability First
