---
name: spec-008-x005-architecture
description: SPEC-008 X005 - Event Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Event Architecture

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event Bus duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Append-only log, topic-based routing.
- Tach Lifecycle (Event Bus) khoi Decision (Policy S012).
- Tach Event Store khoi Router.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Event API (publish, subscribe, deliver, replay)
     |
[Engine Layer]   Route Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Validator
     |
[Store Layer]    Event Store (append-only) + Replay
     |
[Integration]    Registry (SPEC-005) + Metrics (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Khong dependency vong.

## XA004 - Communication Rules

- Publish: async (fire-and-forget voi retry).
- Subscribe: sync register.
- Deliver: async push hoac pull qua replay.
- Moi op co trace_id (S011).

## XA005 - Domain Model

Event, EventStream, Subscription, Topic, EventLineage (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Event append-only | P010 immutable |
| XAD-002 | Topic-based routing | subscriber filter |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Store tach Replay | simulate/audit |

## Tham chieu

- S011 Event Model - SPEC-001
- X006 Components - SPEC-008
- S011 Observability - SPEC-001
