---
name: spec-006-x008-data-model
description: SPEC-006 X008 - Context Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Context Data Model

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Execution Context luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Context la d? lieu transient cua Execution (S008 ENT Context).
- Context chi chua metadata v? Execution - KHONG chua Business Data (S011 OB003A).
- Context song cung Execution: Allocate -> Release (P009).
- Moi Context co dung mot Execution owner (P006).

## XD002 - Principles

- **Transient** - khong persist (P009).
- **Isolated** - khong chia se giua Execution (P006).
- **Keyed** - moi item co key duy nhat trong scope.
- **Validated** - moi mutation validate truoc khi chap nhan.
- **Observable** - moi thay doi sinh Event (S011).

## XD003 - Structure (3 lop)

```text
Context (AggregateRoot)
  +- ContextMetadata (Entity)
  +- ContextSection (Entity) 1..*
  |    +- ContextItem (Value) 1..*
  +- ContextState (Transient)
  +- ContextGrant (Entity) 0..*
  +- ContextSnapshot (Entity) 0..*
  +- refs: ExecutionRef, AgentRef, CapabilityRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Context | AggregateRoot | Context Engine | - |
| ENT-X002 | ContextMetadata | Entity | Context Engine | yes |
| ENT-X003 | ContextSection | Entity | Context Engine | - |
| ENT-X004 | ContextItem | Value | Context Engine | yes |
| ENT-X005 | ContextKey | Value | Context Engine | yes |
| ENT-X006 | ContextState | Transient | Context Engine | - |
| ENT-X007 | ContextGrant | Entity | Context Engine | - |
| ENT-X008 | ContextEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | ContextMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | ContextSnapshot | Entity | Context Engine | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | AgentRef | Ref (SPEC-004) | Agent | yes |
| ENT-X013 | CapabilityRef | Ref (SPEC-003) | Capability | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | ContextExtension | Value | Context Engine | yes |

## XD005 - Identity

- context_id: UUID (Allocate sinh ra).
- key_path: contextId/section/item - dinh danh duy nhat moi item.
- grant_id: UUID moi lan Distribute.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Context | ContextMetadata | 1..1 |
| REL-X002 | Context | ContextSection | 1..* |
| REL-X003 | ContextSection | ContextItem | 1..* |
| REL-X004 | Context | ContextState | 1..1 |
| REL-X005 | Context | ContextGrant | 0..* |
| REL-X006 | Context | ExecutionRef | 1..1 |
| REL-X007 | Context | AgentRef | 0..* |
| REL-X008 | Context | ContextEvent | 0..* |
| REL-X009 | Context | ContextSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique ContextId.
2. Single Owner - mot Execution.
3. Key unique trong section.
4. It nhat mot section.
5. Key hop le theo schema.
6. KHONG chua Business Data.
7. Grant scope nam trong context scope.

## XD008 - Validation

- Validate khi: Allocate, Populate, Mutate, Merge, Distribute.
- Vi pham -> BLOCK + error CONTEXT_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- In-memory (P009 - transient).
- ContextSnapshot optional (debug/doctor).
- Khong dua Context vao LocalStorage/DB (SPEC-005 chi chua registry).

## XD010 - Open Questions

- Khi nao snapshot huu ich cho Doctor?
- Gioi han kich thuoc Context?

## Tham chieu

- S008 ENT Context - SPEC-001
- S010 EF008 - SPEC-001
- S011 OB003A - SPEC-001
- Registry - SPEC-005
