---
name: spec-015-x011-observability
description: SPEC-015 X011 - SDK Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - SDK Observability

> **SPEC-015**: SDK Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai SDK quan sat duoc nhu the nao?**

## XO001 - Philosophy

- SDK la observable (RULE-014).
- Moi thay doi SDK phai phat Event (S011).
- Khong the debug SDK ma khong co event/trace.
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
| SDK_CreateD | SDK dinh nghia |
| SDK_RenderD | Cau hinh xong |
| SDK_RUNNING | Dang chay |
| SDK_ComposeD | Quan sat xong |
| SDK_FilterD | So sanh xong |
| SDK_ExportED | Export xong |
| SDK_FAILED | SDK loi |
| SDK_FINDING | Finding moi |
| SDK_DEVIATION | Lech ky vong |
| SDK_ISOLATION_BLOCKED | Isolation bi chan |
| SDK_REPLAYED | Replay xong |
| SDK_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

SDK_runs_total, SDK_Exported_total, SDK_failed_total,
SDK_success_rate, SDK_deviation_total, SDK_replayed_total,
SDK_run_duration_seconds, SDK_Filter_latency_seconds, SDK_isolation_blocked_total.

Labels: SDK_id, state, execution_id, scenario.

## XO005 - Traces (6 spans)

SDK.Create / Render / run / Compose / Filter / Export.
Span attrs: SDK_id, execution_id, scenario, domain.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi lan chay SDK.

## XO007 - Correlation

correlation_id (SDK) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - SDK

SDK Activity, Success Rate by Scenario, Failures, Deviation, Replay Status.
Tool: X020 SDK Doctor.

## XO009 - Health Checks (5)

Create_ok, run_ok, isolation_ok (khong doi he thong that),
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-015
