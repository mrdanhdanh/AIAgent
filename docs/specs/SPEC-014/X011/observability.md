---
name: spec-014-x011-observability
description: SPEC-014 X011 - Dashboard Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Dashboard Observability

> **SPEC-014**: Dashboard Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Dashboard quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Dashboard la observable (RULE-014).
- Moi thay doi Dashboard phai phat Event (S011).
- Khong the debug Dashboard ma khong co event/trace.
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
| DASHBOARD_CreateD | Dashboard dinh nghia |
| DASHBOARD_RenderD | Cau hinh xong |
| DASHBOARD_RUNNING | Dang chay |
| DASHBOARD_ComposeD | Quan sat xong |
| DASHBOARD_FilterD | So sanh xong |
| DASHBOARD_ExportED | Export xong |
| DASHBOARD_FAILED | Dashboard loi |
| DASHBOARD_FINDING | Finding moi |
| DASHBOARD_DEVIATION | Lech ky vong |
| DASHBOARD_ISOLATION_BLOCKED | Isolation bi chan |
| DASHBOARD_REPLAYED | Replay xong |
| DASHBOARD_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

DASHBOARD_runs_total, DASHBOARD_Exported_total, DASHBOARD_failed_total,
DASHBOARD_success_rate, DASHBOARD_deviation_total, DASHBOARD_replayed_total,
DASHBOARD_run_duration_seconds, DASHBOARD_Filter_latency_seconds, DASHBOARD_isolation_blocked_total.

Labels: DASHBOARD_id, state, execution_id, scenario.

## XO005 - Traces (6 spans)

Dashboard.Create / Render / run / Compose / Filter / Export.
Span attrs: DASHBOARD_id, execution_id, scenario, domain.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi lan chay Dashboard.

## XO007 - Correlation

correlation_id (Dashboard) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Dashboard Activity, Success Rate by Scenario, Failures, Deviation, Replay Status.
Tool: X020 Dashboard.

## XO009 - Health Checks (5)

Create_ok, run_ok, isolation_ok (khong doi he thong that),
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-014
