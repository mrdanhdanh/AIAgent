---
name: spec-014-x005-architecture
description: SPEC-014 X005 - Dashboard Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Dashboard Architecture

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Read-only, S011-driven, view registry.
- Tach Pipeline (Dashboard) khoi Decision (Policy S012).
- Tach Widget Store khoi View Store.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Dashboard API (render, compose, build, filter, refresh, export)
     |
[Engine Layer]   Pipeline Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Read-Only Guard
     |
[Store Layer]    View Store + Widget Store
     |
[Integration]    S011 Metrics + SPEC-008 Events + SPEC-011 Doctor + Events (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Dashboard doc S011 qua read-only interface.

## XA004 - Communication Rules

- Render/Refresh: sync (blocking).
- Export: sync.
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

Dashboard, Widget, Panel, DashboardView, DashboardFilter (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Dashboard doc S011 | P005 |
| XAD-002 | Read-only | XC-001 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | View tach Widget Store | render history |

## Tham chieu

- dashboard-sdk
- X006 Components - SPEC-014
- S011 Observability - SPEC-001
