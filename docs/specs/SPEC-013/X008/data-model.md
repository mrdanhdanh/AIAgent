---
name: spec-013-x008-data-model
description: SPEC-013 X008 - Evolution Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Evolution Data Model

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Evolution tien hoa he thong (SPEC-000..012).
- Evolution khong pha vo he thong (P013).
- Evolution chi chua diff + migration plan - KHONG chua Business Data (S011 OB003A).
- Evolution backward compatible (XNF-002).

## XD002 - Principles

- **Safe Evolution** - khong pha vo he thong (P013).
- **Backward Compatible** - giu tuong thich (XNF-002).
- **Migration Planned** - moi thay doi co plan (XNF-003).
- **Self-Heal Safe** - doc-only (XNF-005).
- **Observable** - moi evolution quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Evolution (AggregateRoot)
  +- EvolutionDefinition (Entity)
  +- SemanticDiff (Entity) 0..*
  +- CompatibilityReport (Entity)
  +- MigrationPlan (Value) 0..*
  +- EvolutionState (Transient)
  +- EvolutionReport (Entity) 0..1
  +- EvolutionSnapshot (Entity) 0..*
  +- refs: ExecutionRef, SystemRef, ModuleRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Evolution | AggregateRoot | Evolution Engine | - |
| ENT-X002 | EvolutionDefinition | Entity | Evolution Engine | yes |
| ENT-X003 | SemanticDiff | Entity | Evolution Engine | yes |
| ENT-X004 | CompatibilityReport | Entity | Evolution Engine | yes |
| ENT-X005 | MigrationPlan | Value | Evolution Engine | - |
| ENT-X006 | EvolutionState | Transient | Evolution Engine | - |
| ENT-X007 | EvolutionReport | Entity | Evolution Engine | yes |
| ENT-X008 | EvolutionEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | EvolutionMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | EvolutionSnapshot | Entity | Evolution Engine | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | SystemRef | Ref (SPEC-000..012) | System | yes |
| ENT-X013 | ModuleRef | Ref (SPEC-013) | Evolution | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | EvolutionExtension | Value | Evolution Engine | yes |

## XD005 - Identity

- evolution_id: UUID (Diff sinh ra).
- version_from/version_to: SemVer.
- execution_id: UUID.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Evolution | EvolutionDefinition | 1..1 |
| REL-X002 | Evolution | SemanticDiff | 0..* |
| REL-X003 | Evolution | CompatibilityReport | 1..1 |
| REL-X004 | Evolution | MigrationPlan | 0..* |
| REL-X005 | Evolution | EvolutionState | 1..1 |
| REL-X006 | Evolution | EvolutionReport | 0..1 |
| REL-X007 | Evolution | ExecutionRef | 1..1 |
| REL-X008 | Evolution | EvolutionEvent | 0..* |
| REL-X009 | Evolution | EvolutionSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique EvolutionId.
2. Khong pha vo he thong.
3. Backward compatible.
4. Moi thay doi co migration plan.
5. Self-heal doc-only.
6. Report day du.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Diff, Migrate.
- Vi pham -> BLOCK + error EVOLUTION_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Diff store (P013).
- Persistent (migration history).
- EvolutionSnapshot optional (debug).

## XD010 - Open Questions

- Khi nao snapshot huu ich?
- Retention mac dinh cho report?

## Tham chieu

- /team-syncdocs (9 modules)
- P013 Deterministic Execution
- S011 Observability
