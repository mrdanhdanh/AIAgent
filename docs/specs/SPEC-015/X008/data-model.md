---
name: SPEC-015-x008-data-model
description: SPEC-015 X008 - SDK Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - SDK Data Model

> **SPEC-015**: SDK - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **SDK luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- SDK doc du lieu tu S011 metrics (P005).
- SDK khong thay doi he thong - read-only (XC-001).
- SDK chi chua widget + view - KHONG chua Business Data (S011 OB003A).
- SDK khong tao nguon du lieu moi (XC-002).

## XD002 - Principles

- **Read-Only** - khong thay doi he thong (XC-001).
- **S011 Source** - widget doc tu S011 (P005).
- **No New Source** - khong tao nguon moi (XC-002).
- **No Business Data** - chi metadata (S011 OB003A).
- **Observable** - moi view quan sat qua S011.

## XD003 - Structure (3 lop)

```text
SDK (AggregateRoot)
  +- SDKDefinition (Entity)
  +- Widget (Entity) 0..*
  +- Panel (Entity) 0..*
  +- SDKView (Value) 0..*
  +- SDKState (Transient)
  +- SDKExport (Entity) 0..1
  +- SDKSnapshot (Entity) 0..*
  +- refs: ExecutionRef, SystemRef, MetricRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | SDK | AggregateRoot | SDK | - |
| ENT-X002 | SDKDefinition | Entity | SDK | yes |
| ENT-X003 | Widget | Entity | SDK | yes |
| ENT-X004 | Panel | Entity | SDK | yes |
| ENT-X005 | SDKView | Value | SDK | - |
| ENT-X006 | SDKState | Transient | SDK | - |
| ENT-X007 | SDKExport | Entity | SDK | yes |
| ENT-X008 | SDKEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | SDKMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | SDKSnapshot | Entity | SDK | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | SystemRef | Ref (SPEC-000..013) | System | yes |
| ENT-X013 | MetricRef | Ref (S011) | SDK | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | SDKExtension | Value | SDK | yes |

## XD005 - Identity

- SDK_id: UUID (Create sinh ra).
- execution_id: UUID.
- view_name: per role.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | SDK | SDKDefinition | 1..1 |
| REL-X002 | SDK | Widget | 0..* |
| REL-X003 | SDK | Panel | 0..* |
| REL-X004 | SDK | SDKView | 0..* |
| REL-X005 | SDK | SDKState | 1..1 |
| REL-X006 | SDK | SDKExport | 0..1 |
| REL-X007 | SDK | ExecutionRef | 1..1 |
| REL-X008 | SDK | SDKEvent | 0..* |
| REL-X009 | SDK | SDKSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique SDKId.
2. Read-only - khong thay doi he thong.
3. Widget doc tu S011 metrics.
4. Khong tao nguon du lieu moi.
5. Widget co schema.
6. View day du.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Create, Render.
- Vi pham -> BLOCK + error SDK_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- View store (P005).
- Persistent (view history).
- SDKSnapshot optional (debug).

## XD010 - Open Questions

- Khi nao snapshot huu ich?
- Retention mac dinh cho export?

## Tham chieu

- S011 Metrics - SPEC-001
- P005 Observability First
- S011 Observability
