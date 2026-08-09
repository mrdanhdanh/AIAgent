---
name: spec-009-x008-data-model
description: SPEC-009 X008 - Contract Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Contract Data Model

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Contract la giao dien giua hai thanh phan (TERM-014).
- Contract versioned (P004) - backward compatible (XNF-005).
- Contract chi chua interface - KHONG chua implementation (TERM-014).
- Contract khong chua Business Data (S011 OB003A).

## XD002 - Principles

- **Interface Only** - chi input/output (TERM-014).
- **No Implementation** - khong chua code (TERM-014).
- **Versioned** - moi thay doi = version moi (P004).
- **Compatible** - backward compatible (XNF-005).
- **Observable** - moi Contract quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Contract (AggregateRoot)
  +- ContractDefinition (Entity)
  +- ContractVersion (Entity) 1..*
  +- ContractSchema (Entity)
  +- ContractBinding (Value) 0..*
  +- ContractState (Transient)
  +- ContractVerification (Entity) 0..*
  +- ContractSnapshot (Entity) 0..*
  +- refs: ExecutionRef, ProviderRef, CallerRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Contract | AggregateRoot | Contract Registry | yes |
| ENT-X002 | ContractDefinition | Entity | Contract Registry | yes |
| ENT-X003 | ContractVersion | Entity | Contract Registry | yes |
| ENT-X004 | ContractSchema | Entity | Contract Registry | yes |
| ENT-X005 | ContractBinding | Value | Contract Registry | - |
| ENT-X006 | ContractState | Transient | Contract Registry | - |
| ENT-X007 | ContractVerification | Entity | Contract Registry | yes |
| ENT-X008 | ContractEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | ContractMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | ContractSnapshot | Entity | Contract Registry | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | ProviderRef | Ref (SPEC-004/002) | Agent/Task | yes |
| ENT-X013 | CallerRef | Ref (SPEC-004) | Agent | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | ContractExtension | Value | Contract Registry | yes |

## XD005 - Identity

- contract_id: UUID (Declare sinh ra).
- version: SemVer (P004).
- provider_id: UUID.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Contract | ContractDefinition | 1..1 |
| REL-X002 | Contract | ContractVersion | 1..* |
| REL-X003 | Contract | ContractSchema | 1..1 |
| REL-X004 | Contract | ContractBinding | 0..* |
| REL-X005 | Contract | ContractState | 1..1 |
| REL-X006 | Contract | ContractVerification | 0..* |
| REL-X007 | Contract | ExecutionRef | 1..1 |
| REL-X008 | Contract | ContractEvent | 0..* |
| REL-X009 | Contract | ContractSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique ContractId.
2. Interface only - khong implementation.
3. Versioned (P004).
4. Version moi backward compatible.
5. Schema hop le.
6. Khong goi truc tiep.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Declare, Version.
- Vi pham -> BLOCK + error CONTRACT_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Versioned store (P004).
- Persistent (contract definition).
- ContractSnapshot optional (debug/doctor).

## XD010 - Open Questions

- Khi nao snapshot huu ich cho Doctor?
- Compat check tu dong?

## Tham chieu

- S007 Contract Model - SPEC-001
- TERM-014 Contract
- SPEC-005 Registry
