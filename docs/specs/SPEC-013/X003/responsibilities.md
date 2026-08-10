---
name: spec-013-x003-responsibilities
description: SPEC-013 X003 - Evolution Responsibilities. Evolution Engine vs System vs Modules.
agent: general
---

# X003 - Evolution Responsibilities

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Evolution Engine?**

## XRM001 - Philosophy

- Evolution Engine chiu trach nhiem tien hoa he thong.
- He thong bi evolution - khong tu thay doi.
- Modules (9) thuc hien tung chuc nang.
- Policy (S012) quyet dinh - Evolution thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Evolution | He thong | Modules | Policy |
|-------------|-----------|----------|---------|--------|
| Diff | OWNER | BOUND | DiffEngine | - |
| CompatCheck | OWNER | - | CompatChecker | - |
| Plan | OWNER | - | MigrationEngine | - |
| Migrate | OWNER | BOUND | MigrationEngine | - |
| Self-Heal | OWNER | BOUND | SelfHealEngine | Scope |
| Score | OWNER | - | HealthScorer | - |
| Benchmark | OWNER | - | Benchmark (SPEC-003) | - |
| Knowledge Migrate | OWNER | BOUND | Knowledge | - |
| Stress Test | RUNNER | - | Simulation (SPEC-012) | - |
| Evolve | OWNER | - | - | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |

## XRM003 - Owner Principles

- Evolution Engine la OWNER cua viec tien hoa.
- He thong la SUBJECT - chi bi evolution.
- Modules thuc hien chuc nang - khong so huu.
- Evolution khong pha vo he thong (P013).

## XRM004 - Boundaries

- Evolution: diff, compat, plan, migrate, heal, score, evolve.
- He thong: bi evolution.
- Modules: thuc hien chuc nang.
- Registry (SPEC-005): luu definition.

## Tham chieu

- /team-syncdocs (9 modules)
- X004 Boundaries - SPEC-013
- S012 Policy - SPEC-001
