---
name: spec-011-x008-data-model
description: SPEC-011 X008 - Doctor Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Doctor Data Model

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Doctor kiem tra toan bo he sinh thai (SPEC-000..010).
- Doctor khong sua core (P015).
- Doctor chi chua findings + score - KHONG chua Business Data (S011 OB003A).
- Doctor co report (markdown/JSON).

## XD002 - Principles

- **Non-Invasive** - khong sua core (P015).
- **Safe Repair** - chi sua doc (P015).
- **Measurable** - moi check co diem (XNF-003).
- **Comprehensive** - scan toan bo (XNF-005).
- **Observable** - moi check quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Scan (AggregateRoot)
  +- ScanDefinition (Entity)
  +- Finding (Entity) 0..*
  +- HealthScore (Entity)
  +- RepairAction (Value) 0..*
  +- ScanState (Transient)
  +- DoctorReport (Entity) 0..1
  +- DoctorSnapshot (Entity) 0..*
  +- refs: ExecutionRef, SystemRef, ScannerRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Scan | AggregateRoot | Doctor | - |
| ENT-X002 | ScanDefinition | Entity | Doctor | yes |
| ENT-X003 | Finding | Entity | Doctor | - |
| ENT-X004 | HealthScore | Entity | Doctor | yes |
| ENT-X005 | RepairAction | Value | Doctor | - |
| ENT-X006 | ScanState | Transient | Doctor | - |
| ENT-X007 | DoctorReport | Entity | Doctor | yes |
| ENT-X008 | DoctorEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | DoctorMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | DoctorSnapshot | Entity | Doctor | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | SystemRef | Ref (SPEC-000..010) | System | yes |
| ENT-X013 | ScannerRef | Ref (SPEC-011) | Doctor | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | DoctorExtension | Value | Doctor | yes |

## XD005 - Identity

- scan_id: UUID (Scan sinh ra).
- execution_id: UUID.
- scope: Environment|System|Runtime|Capability.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Scan | ScanDefinition | 1..1 |
| REL-X002 | Scan | Finding | 0..* |
| REL-X003 | Scan | HealthScore | 1..1 |
| REL-X004 | Scan | RepairAction | 0..* |
| REL-X005 | Scan | ScanState | 1..1 |
| REL-X006 | Scan | DoctorReport | 0..1 |
| REL-X007 | Scan | ExecutionRef | 1..1 |
| REL-X008 | Scan | DoctorEvent | 0..* |
| REL-X009 | Scan | DoctorSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique ScanId.
2. Khong sua core.
3. Score 0-100.
4. Finding co source.
5. Repair chi sua doc.
6. Report day du.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Scan, Score.
- Vi pham -> BLOCK + error DOCTOR_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Findings store (P005).
- Persistent (report history).
- DoctorSnapshot optional (debug).

## XD010 - Open Questions

- Khi nao snapshot huu ich?
- Retention mac dinh cho report?

## Tham chieu

- /doctor command
- SPEC-000..010
- S011 Observability
