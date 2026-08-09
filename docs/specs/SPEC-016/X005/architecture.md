---
name: SPEC-016-x005-architecture
description: SPEC-016 X005 - CLI Architecture. Layers, components, dependencies.
agent: general
---

# X005 - CLI Architecture

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Read-only, S011-driven, view registry.
- Tach Pipeline (CLI) khoi Decision (Policy S012).
- Tach Widget Store khoi View Store.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      CLI API (run, parse, resolve, help, complete, trigger)
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
- CLI doc S011 qua read-only interface.

## XA004 - Communication Rules

- Run/Trigger: sync (blocking).
- Help/Completion: sync.
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

CLI, Widget, Panel, CLIView, CLIFilter (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | CLI doc S011 | P005 |
| XAD-002 | Read-only | XC-001 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | View tach Widget Store | render history |

## Tham chieu

- aios-cli
- X006 Components - SPEC-016
- S011 Observability - SPEC-001
