---
name: SPEC-016-x008-data-model
description: SPEC-016 X008 - CLI Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - CLI Data Model

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- CLI doc du lieu tu S011 metrics (P005).
- CLI khong thay doi he thong - read-only (XC-001).
- CLI chi chua widget + view - KHONG chua Business Data (S011 OB003A).
- CLI khong tao nguon du lieu moi (XC-002).

## XD002 - Principles

- **Read-Only** - khong thay doi he thong (XC-001).
- **S011 Source** - widget doc tu S011 (P005).
- **No New Source** - khong tao nguon moi (XC-002).
- **No Business Data** - chi metadata (S011 OB003A).
- **Observable** - moi view quan sat qua S011.

## XD003 - Structure (3 lop)

```text
CLI (AggregateRoot)
  +- CLIDefinition (Entity)
  +- Widget (Entity) 0..*
  +- Panel (Entity) 0..*
  +- CLIView (Value) 0..*
  +- CLIState (Transient)
  +- CLIExport (Entity) 0..1
  +- CLISnapshot (Entity) 0..*
  +- refs: ExecutionRef, SystemRef, MetricRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | CLI | AggregateRoot | CLI | - |
| ENT-X002 | CLIDefinition | Entity | CLI | yes |
| ENT-X003 | Widget | Entity | CLI | yes |
| ENT-X004 | Panel | Entity | CLI | yes |
| ENT-X005 | CLIView | Value | CLI | - |
| ENT-X006 | CLIState | Transient | CLI | - |
| ENT-X007 | CLIExport | Entity | CLI | yes |
| ENT-X008 | CLIEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | CLIMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | CLISnapshot | Entity | CLI | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | SystemRef | Ref (SPEC-000..013) | System | yes |
| ENT-X013 | MetricRef | Ref (S011) | CLI | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | CLIExtension | Value | CLI | yes |

## XD005 - Identity

- CLI_id: UUID (Create sinh ra).
- execution_id: UUID.
- view_name: per role.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | CLI | CLIDefinition | 1..1 |
| REL-X002 | CLI | Widget | 0..* |
| REL-X003 | CLI | Panel | 0..* |
| REL-X004 | CLI | CLIView | 0..* |
| REL-X005 | CLI | CLIState | 1..1 |
| REL-X006 | CLI | CLIExport | 0..1 |
| REL-X007 | CLI | ExecutionRef | 1..1 |
| REL-X008 | CLI | CLIEvent | 0..* |
| REL-X009 | CLI | CLISnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique CLIId.
2. Read-only - khong thay doi he thong.
3. Widget doc tu S011 metrics.
4. Khong tao nguon du lieu moi.
5. Widget co schema.
6. View day du.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Create, Render.
- Vi pham -> BLOCK + error CLI_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- View store (P005).
- Persistent (view history).
- CLISnapshot optional (debug).

## XD010 - Open Questions

- Khi nao snapshot huu ich?
- Retention mac dinh cho export?

## Tham chieu

- S011 Metrics - SPEC-001
- P005 Observability First
- S011 Observability
