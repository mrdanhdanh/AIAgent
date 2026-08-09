---
name: spec-013-x011-observability
description: SPEC-013 X011 - Evolution Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Evolution Observability

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Evolution quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Evolution la observable (RULE-014).
- Moi thay doi Evolution phai phat Event (S011).
- Khong the debug Evolution ma khong co event/trace.
- Observability la bat buoc (P005, XNF-004).

## XO002 - Principles

- **Event-first** - moi stage/transition co event.
- **Immutable events** - chi append (P005).
- **Correlated** - correlation_id xuyen suot.
- **Metrics co label** - phan tich duoc.
- **Audit day du** - ai lam gi, khi nao (XFR-016).

## XO003 - Events (12)

| Event | Y nghia |
|-------|---------|
| EVOLUTION_DIFFED | Diff xong |
| EVOLUTION_COMPAT_CHECKED | Compat check xong |
| EVOLUTION_PLANNED | Migration plan xong |
| EVOLUTION_MIGRATED | Migrate xong |
| EVOLUTION_HEALED | Heal doc xong |
| EVOLUTION_EVOLVED | Evolve xong |
| EVOLUTION_FAILED | Evolution loi |
| EVOLUTION_FINDING | Finding moi |
| EVOLUTION_BREAKING_BLOCKED | Breaking change bi chan |
| EVOLUTION_MIGRATED_DOC | Migration doc xong |
| EVOLUTION_REVERTED | Revert phien ban cu |
| EVOLUTION_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

evolution_diffs_total, evolution_migrations_total, evolution_failed_total,
evolution_evolved_total, evolution_heals_total, evolution_breaking_blocked_total,
evolution_diff_duration_seconds, evolution_migrate_latency_seconds, evolution_health_score_current.

Labels: evolution_id, state, execution_id, module.

## XO005 - Traces (6 spans)

evolution.diff / compat_check / plan / migrate / heal / evolve.
Span attrs: evolution_id, execution_id, module, version_from.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi lan chay Evolution.

## XO007 - Correlation

correlation_id (Evolution) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Evolution Activity, Compatibility Status, Failures, Health Trend, Migration Status.
Tool: X020 Evolution Dashboard.

## XO009 - Health Checks (5)

diff_ok, compat_ok (backward compatible), migrate_ok,
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- P013 Deterministic Execution
- X019 Doctor - SPEC-013
