---
name: spec-011-x005-architecture
description: SPEC-011 X005 - Doctor Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Doctor Architecture

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Non-invasive, scanner registry, doc-only repair.
- Tach Pipeline (Doctor) khoi Decision (Policy S012).
- Tach Findings Store khoi Score Store.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Doctor API (scan, diagnose, score, repair, report)
     |
[Engine Layer]   Pipeline Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Safe-Repair Guard
     |
[Store Layer]    Findings Store + Score Store
     |
[Integration]    Scanners (SPEC-000..010) + Events (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Scanner goi system qua read-only interface.

## XA004 - Communication Rules

- Scan/Score: sync (blocking).
- Repair: sync, doc-only.
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

Scan, Finding, HealthScore, RepairAction, DoctorReport (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Doctor khong sua core | P015 |
| XAD-002 | Scanner registry | mo rong de dang |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Score tach Store | report history |

## Tham chieu

- /doctor command
- X006 Components - SPEC-011
- S011 Observability - SPEC-001
