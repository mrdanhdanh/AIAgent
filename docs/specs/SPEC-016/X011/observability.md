---
name: SPEC-016-x011-observability
description: SPEC-016 X011 - CLI Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - CLI Observability

> **SPEC-016**: CLI Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai CLI quan sat duoc nhu the nao?**

## XO001 - Philosophy

- CLI la observable (RULE-014).
- Moi thay doi CLI phai phat Event (S011).
- Khong the debug CLI ma khong co event/trace.
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
| CLI_CreateD | CLI dinh nghia |
| CLI_RenderD | Cau hinh xong |
| CLI_RUNNING | Dang chay |
| CLI_ComposeD | Quan sat xong |
| CLI_FilterD | So sanh xong |
| CLI_ExportED | Export xong |
| CLI_FAILED | CLI loi |
| CLI_FINDING | Finding moi |
| CLI_DEVIATION | Lech ky vong |
| CLI_ISOLATION_BLOCKED | Isolation bi chan |
| CLI_REPLAYED | Replay xong |
| CLI_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

CLI_runs_total, CLI_Exported_total, CLI_failed_total,
CLI_success_rate, CLI_deviation_total, CLI_replayed_total,
CLI_run_duration_seconds, CLI_Filter_latency_seconds, CLI_isolation_blocked_total.

Labels: CLI_id, state, execution_id, scenario.

## XO005 - Traces (6 spans)

CLI.Create / Render / run / Compose / Filter / Export.
Span attrs: CLI_id, execution_id, scenario, domain.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi lan chay CLI.

## XO007 - Correlation

correlation_id (CLI) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - CLI

CLI Activity, Success Rate by Scenario, Failures, Deviation, Replay Status.
Tool: X020 CLI.

## XO009 - Health Checks (5)

Create_ok, run_ok, isolation_ok (khong doi he thong that),
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-016
