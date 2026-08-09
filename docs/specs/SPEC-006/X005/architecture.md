---
name: spec-006-x005-architecture
description: SPEC-006 X005 - Context Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Context Architecture

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Context Engine duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Nho, metadata-only, transient.
- Tach Lifecycle (Context Engine) khoi Decision (Policy S012).
- Tach Event/Metric (S011) khoi Logic.
- Khong duong vong qua Business layer.

## XA002 - Layer Model

```text
[API Layer]      Context API (allocate, populate, distribute, mutate, merge, collect, release)
     |
[Engine Layer]   Lifecycle Orchestrator (EF008) + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Scope Check + Validator
     |
[Data Layer]     In-Memory Context Store (transient)
     |
[Integration]    Registry (SPEC-005) + Events/Metrics (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Data.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Khong dependency vong.

## XA004 - Communication Rules

- Sync: allocate/populate/mutate/merge (blocking).
- Async: events, metrics (S011).
- Query: read-only, khong can grant.
- Moi op co trace_id (S011).

## XA005 - Domain Model

Context, ContextSection, ContextItem, ContextGrant, ContextState (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Context in-memory | P009 transient |
| XAD-002 | Context khong business data | P001 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | State machine cua S009 | khong dinh nghia lai |

## Tham chieu

- S010 EF008 - SPEC-001
- X006 Components - SPEC-006
- S011 Observability - SPEC-001
