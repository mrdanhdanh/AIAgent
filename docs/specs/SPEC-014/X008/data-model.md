---
name: spec-014-x008-data-model
description: SPEC-014 X008 - Dashboard Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Dashboard Data Model

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Dashboard doc du lieu tu S011 metrics (P005).
- Dashboard khong thay doi he thong - read-only (XC-001).
- Dashboard chi chua widget + view - KHONG chua Business Data (S011 OB003A).
- Dashboard khong tao nguon du lieu moi (XC-002).

## XD002 - Principles

- **Read-Only** - khong thay doi he thong (XC-001).
- **S011 Source** - widget doc tu S011 (P005).
- **No New Source** - khong tao nguon moi (XC-002).
- **No Business Data** - chi metadata (S011 OB003A).
- **Observable** - moi view quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Dashboard (AggregateRoot)
  +- DashboardDefinition (Entity)
  +- Widget (Entity) 0..*
  +- Panel (Entity) 0..*
  +- DashboardView (Value) 0..*
  +- DashboardState (Transient)
  +- DashboardExport (Entity) 0..1
  +- DashboardSnapshot (Entity) 0..*
  +- refs: ExecutionRef, SystemRef, MetricRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Dashboard | AggregateRoot | Dashboard | - |
| ENT-X002 | DashboardDefinition | Entity | Dashboard | yes |
| ENT-X003 | Widget | Entity | Dashboard | yes |
| ENT-X004 | Panel | Entity | Dashboard | yes |
| ENT-X005 | DashboardView | Value | Dashboard | - |
| ENT-X006 | DashboardState | Transient | Dashboard | - |
| ENT-X007 | DashboardExport | Entity | Dashboard | yes |
| ENT-X008 | DashboardEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | DashboardMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | DashboardSnapshot | Entity | Dashboard | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | SystemRef | Ref (SPEC-000..013) | System | yes |
| ENT-X013 | MetricRef | Ref (S011) | Dashboard | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | DashboardExtension | Value | Dashboard | yes |

## XD005 - Identity

- dashboard_id: UUID (Create sinh ra).
- execution_id: UUID.
- view_name: per role.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Dashboard | DashboardDefinition | 1..1 |
| REL-X002 | Dashboard | Widget | 0..* |
| REL-X003 | Dashboard | Panel | 0..* |
| REL-X004 | Dashboard | DashboardView | 0..* |
| REL-X005 | Dashboard | DashboardState | 1..1 |
| REL-X006 | Dashboard | DashboardExport | 0..1 |
| REL-X007 | Dashboard | ExecutionRef | 1..1 |
| REL-X008 | Dashboard | DashboardEvent | 0..* |
| REL-X009 | Dashboard | DashboardSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique DashboardId.
2. Read-only - khong thay doi he thong.
3. Widget doc tu S011 metrics.
4. Khong tao nguon du lieu moi.
5. Widget co schema.
6. View day du.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Create, Render.
- Vi pham -> BLOCK + error DASHBOARD_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- View store (P005).
- Persistent (view history).
- DashboardSnapshot optional (debug).

## XD010 - Open Questions

- Khi nao snapshot huu ich?
- Retention mac dinh cho export?

## Tham chieu

- S011 Metrics - SPEC-001
- P005 Observability First
- S011 Observability
