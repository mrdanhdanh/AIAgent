---
name: spec-009-x005-architecture
description: SPEC-009 X005 - Contract Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Contract Architecture

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract System duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Interface-only, versioned, backward compatible.
- Tach Lifecycle (Contract System) khoi Decision (Policy S012).
- Tach Store khoi Verifier.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Contract API (declare, validate, version, resolve, verify)
     |
[Engine Layer]   Lifecycle Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Validator + Compat Checker
     |
[Store Layer]    Contract Store + Version Index
     |
[Integration]    Registry (SPEC-005) + Events/Metrics (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Khong dependency vong.

## XA004 - Communication Rules

- Declare/Resolve: sync (blocking).
- Verify: sync, truoc khi dung.
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

Contract, ContractVersion, ContractSchema, ContractBinding, ContractVerification (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Contract interface-only | TERM-014 |
| XAD-002 | Version immutable | P004 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Store tach Version Index | compat check |

## Tham chieu

- S007 Contract Model - SPEC-001
- X006 Components - SPEC-009
- S011 Observability - SPEC-001
