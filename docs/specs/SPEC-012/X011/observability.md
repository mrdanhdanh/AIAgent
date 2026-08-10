---
name: spec-012-x011-observability
description: SPEC-012 X011 - Simulation Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Simulation Observability

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Simulation quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Simulation la observable (RULE-014).
- Moi thay doi Simulation phai phat Event (S011).
- Khong the debug Simulation ma khong co event/trace.
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
| SIMULATION_DEFINED | Simulation dinh nghia |
| SIMULATION_CONFIGURED | Cau hinh xong |
| SIMULATION_RUNNING | Dang chay |
| SIMULATION_OBSERVED | Quan sat xong |
| SIMULATION_COMPARED | So sanh xong |
| SIMULATION_REPORTED | Report xong |
| SIMULATION_FAILED | Simulation loi |
| SIMULATION_FINDING | Finding moi |
| SIMULATION_DEVIATION | Lech ky vong |
| SIMULATION_ISOLATION_BLOCKED | Isolation bi chan |
| SIMULATION_REPLAYED | Replay xong |
| SIMULATION_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

simulation_runs_total, simulation_reported_total, simulation_failed_total,
simulation_success_rate, simulation_deviation_total, simulation_replayed_total,
simulation_run_duration_seconds, simulation_compare_latency_seconds, simulation_isolation_blocked_total.

Labels: simulation_id, state, execution_id, scenario.

## XO005 - Traces (6 spans)

simulation.define / configure / run / observe / compare / report.
Span attrs: simulation_id, execution_id, scenario, domain.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi lan chay Simulation.

## XO007 - Correlation

correlation_id (Simulation) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Simulation Activity, Success Rate by Scenario, Failures, Deviation, Replay Status.
Tool: X020 Simulation Dashboard.

## XO009 - Health Checks (5)

define_ok, run_ok, isolation_ok (khong doi he thong that),
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-012
