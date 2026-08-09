---
name: spec-008-x011-observability
description: SPEC-008 X011 - Event Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Event Observability

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Event quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Event la observable (RULE-014).
- Moi thay doi Event phai phat Event (RULE-007).
- Khong the debug Event Bus ma khong co event/trace.
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
| EVENT_CREATED | Event tao |
| EVENT_VALIDATING | Dang validate |
| EVENT_LINEAGED | Lineage gan |
| EVENT_STORED | Log append |
| EVENT_ROUTED | Route xong |
| EVENT_DELIVERED | Subscriber nhan |
| EVENT_REPLAYED | Replay |
| EVENT_ARCHIVED | Archive |
| EVENT_REJECTED | Tu choi |
| EVENT_LOST | Mat event (deliver fail) |
| EVENT_MUTATE_BLOCKED | Mutate bi chan |
| EVENT_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

event_published_total, event_delivered_total, event_rejected_total,
event_archived_total, event_lost_total, event_replayed_total,
event_deliver_latency_seconds, event_publish_latency_seconds, event_subscription_active_current.

Labels: event_id, state, execution_id, producer_id.

## XO005 - Traces (8 spans)

event.publish / validate / lineage / store / route / deliver / replay / archive.
Span attrs: event_id, execution_id, correlation_id, producer_id.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi thay doi Event.

## XO007 - Correlation

correlation_id (Event) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Event Activity, Lifecycle, Failures, Subscription Status, Replay Status.
Tool: X020 Event Dashboard.

## XO009 - Health Checks (5)

publish_ok, deliver_ok (khong lost), lineage_ok (chain lien tuc),
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-008
