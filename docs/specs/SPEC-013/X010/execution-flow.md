---
name: spec-013-x010-execution-flow
description: SPEC-013 X010 - Evolution Execution Flow. 6 stages, failure, lineage.
agent: general
---

# X010 - Evolution Execution Flow

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution chay nhu the nao?**

## XF001 - Flow Philosophy

- Evolution chay nhu Execution cua Runtime (SPEC-001).
- Evolution thuc thi pipeline - khong dinh nghia lai.
- Khong buoc nao thieu Event (S011).
- Evolution khong pha vo he thong (P013).

## XF002 - Flow Principles

- **Pipeline** - Diff -> CompatCheck -> Plan -> Migrate -> Heal -> Evolve.
- **Compat truoc khi migrate** (XFR-002).
- **Self-heal doc-only** (XNF-005).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (6)

```text
Diff -> CompatCheck -> Plan -> Migrate -> Heal -> Evolve
```

(/team-syncdocs pipeline)

## XF004 - Canonical Evolution Flow

```text
User/CLI
  -> Diff (so sanh phien ban) [EVOLUTION_DIFFED]
  -> CompatCheck (backward compatible) [EVOLUTION_COMPAT_CHECKED]
  -> Plan (migration plan) [EVOLUTION_PLANNED]
  -> Migrate (thuc hien) [EVOLUTION_MIGRATED]
  -> Heal (doc-only, optional) [EVOLUTION_HEALED]
  -> Evolve (report) [EVOLUTION_EVOLVED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Diff | DiffEngine | cu/moi | SemanticDiff | EVOLUTION_DIFFED |
| CompatCheck | CompatChecker | diff | CompatReport | EVOLUTION_COMPAT_CHECKED |
| Plan | MigrationEngine | diff | MigrationPlan | EVOLUTION_PLANNED |
| Migrate | MigrationEngine | plan | Migrated | EVOLUTION_MIGRATED |
| Heal | SelfHealEngine | findings | Heals (doc) | EVOLUTION_HEALED |
| Evolve | Evolution Engine | migrated | Report | EVOLUTION_EVOLVED |

## XF006 - Failure Modes

- Diff fail -> khong evolution + error.
- Compat fail -> EVOLUTION_FAILED (breaking) + BLOCK.
- Plan fail -> EVOLUTION_FAILED + cleanup.
- Migrate fail -> giu phien ban cu, retry.
- Heal fail -> ghi finding, khong sua core.
- Evolve fail -> retry (S012).

## XF007 - Lineage

- Root Evolution: parent = null.
- Follow-up Evolution: parent = evolution_id truoc.

## XF008 - Query Ops

GetEvolution / GetDiff / GetCompatReport / GetMigrationPlan / GetHistory.
Query khong can grant, khong thay doi Evolution.

## XF009 - Storage

- Diff store (P013), persistent.
- Quota theo policy (X012).
- Snapshot optional.

## XF010 - Validation

- Stage order dung pipeline.
- Moi stage co event.
- Compat truoc migrate (Doctor X019).

## Tham chieu

- /team-syncdocs
- P013 Deterministic Execution
- S012 Policies - SPEC-001
