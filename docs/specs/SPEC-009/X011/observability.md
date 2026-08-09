---
name: spec-009-x011-observability
description: SPEC-009 X011 - Contract Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Contract Observability

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Contract quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Contract la observable (RULE-014).
- Moi thay doi Contract phai phat Event (S011).
- Khong the debug Contract System ma khong co event/trace.
- Observability la bat buoc (P005, XNF-004).

## XO002 - Principles

- **Event-first** - moi stage/transition co event.
- **Immutable events** - chi append (P005).
- **Correlated** - correlation_id xuyen suot.
- **Metrics co label** - phan tich duoc.
- **Audit day du** - ai lam gi, khi nao (XFR-015).

## XO003 - Events (12)

| Event | Y nghia |
|-------|---------|
| CONTRACT_DECLARED | Contract khai bao |
| CONTRACT_VALIDATING | Dang validate |
| CONTRACT_COMPAT_CHECKED | Compat check xong |
| CONTRACT_PUBLISHED | Publish versioned |
| CONTRACT_VERSIONED | Version moi |
| CONTRACT_RESOLVED | Caller resolve |
| CONTRACT_VERIFIED | Verify xong |
| CONTRACT_BOUND | Caller bind |
| CONTRACT_RETIRED | Retire |
| CONTRACT_REJECTED | Tu choi |
| CONTRACT_COMPAT_BLOCKED | Compat fail bi chan |
| CONTRACT_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

contract_declared_total, contract_published_total, contract_rejected_total,
contract_retired_total, contract_resolved_total, contract_compat_blocked_total,
contract_verified_total, contract_resolve_latency_seconds, contract_versions_active_current.

Labels: contract_id, state, execution_id, provider_id.

## XO005 - Traces (8 spans)

contract.declare / validate / compat_check / publish / resolve / verify / bind / retire.
Span attrs: contract_id, execution_id, version, provider_id.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-015 bat buoc ghi audit moi thay doi Contract.

## XO007 - Correlation

correlation_id (Contract) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Contract Activity, Lifecycle, Failures, Version Status, Binding Status.
Tool: X020 Contract Dashboard.

## XO009 - Health Checks (5)

declare_ok, compat_ok (backward compatible), resolve_ok,
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- S007 Contract Model - SPEC-001
- X019 Doctor - SPEC-009
