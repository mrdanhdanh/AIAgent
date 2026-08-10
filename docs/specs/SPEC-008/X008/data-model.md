---
name: spec-008-x008-data-model
description: SPEC-008 X008 - Event Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Event Data Model

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Event la thong bao bat bien ve state change (TERM-012).
- Event immutable (P010) - append-only (P005).
- Event chi chua metadata - KHONG chua Business Data (S011 OB003A).
- Event co lineage (RULE-007).

## XD002 - Principles

- **Immutable** - khong doi sau publish (P010).
- **Append-Only** - khong xoa, khong overwrite (P005).
- **Lineaged** - chain lien tuc (RULE-007).
- **Ordered** - thu tu per source.
- **Observable** - moi Event quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Event (AggregateRoot)
  +- EventDefinition (Entity)
  +- EventStream (Entity)
  +- EventMetadata (Entity)
  +- EventLineage (Value)
  +- EventState (Transient)
  +- Subscription (Entity) 0..*
  +- EventSnapshot (Entity) 0..*
  +- refs: ExecutionRef, ProducerRef, SubscriberRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Event | AggregateRoot | Event Bus | yes |
| ENT-X002 | EventDefinition | Entity | Event Bus | yes |
| ENT-X003 | EventStream | Entity | Event Bus | yes |
| ENT-X004 | EventMetadata | Entity | Event Bus | yes |
| ENT-X005 | EventLineage | Value | Event Bus | yes |
| ENT-X006 | EventState | Transient | Event Bus | - |
| ENT-X007 | Subscription | Entity | Event Bus | - |
| ENT-X008 | EventMetric | Ref (S011) | Runtime | yes |
| ENT-X009 | EventSnapshot | Entity | Event Bus | - |
| ENT-X010 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X011 | ProducerRef | Ref (SPEC-004/002) | Agent/Task | yes |
| ENT-X012 | SubscriberRef | Ref (SPEC-004) | Agent | yes |
| ENT-X013 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X014 | Topic | Value | Event Bus | yes |
| ENT-X015 | EventExtension | Value | Event Bus | yes |

## XD005 - Identity

- event_id: UUID (Publish sinh ra).
- correlation_id: UUID (S011).
- sequence: per-source sequence number.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Event | EventDefinition | 1..1 |
| REL-X002 | Event | EventStream | 1..1 |
| REL-X003 | Event | EventMetadata | 1..1 |
| REL-X004 | Event | EventLineage | 1..1 |
| REL-X005 | Event | EventState | 1..1 |
| REL-X006 | Event | Subscription | 0..* |
| REL-X007 | Event | ExecutionRef | 1..1 |
| REL-X008 | Event | Topic | 1..1 |
| REL-X009 | Event | EventSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique EventId.
2. Single Owner - mot Execution.
3. Immutable - khong doi sau publish.
4. Append-only - khong xoa.
5. Lineage lien tuc.
6. Thu tu per source bao toan.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Publish, Deliver.
- Vi pham -> BLOCK + error EVENT_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Append-only log (P005).
- Persistent (event log cho replay/audit).
- EventSnapshot optional (debug/doctor).

## XD010 - Open Questions

- Khi nao snapshot huu ich cho Doctor?
- Retention mac dinh?

## Tham chieu

- S011 Event Model - SPEC-001
- RULE-007 Event
- SPEC-005 Registry
