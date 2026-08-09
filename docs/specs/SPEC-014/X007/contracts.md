---
name: spec-014-x007-contracts
description: SPEC-014 X007 - Dashboard Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Dashboard Contracts

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (dashboard-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | DashboardApi ops | can ADR |
| Data Contract | Widget + View schema | can ADR |
| Event Contract | DASHBOARD_* events (S011) | can ADR |
| Metric Contract | dashboard_* metrics | additive |
| Policy Contract | render scope | can ADR |
| Interface Contract | Store, RenderEngine, FilterEngine | can ADR |
| Export Contract | export schema | can ADR |

## XCT003 - Compatibility Rules

- Add: field/op moi - OK.
- Change: y nghia field - ADR.
- Remove: field/op - ADR + RFC + migration.
- Event: them type OK, doi type BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No write qua Dashboard.
- No new data source (P005).

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-014
- SPEC-005 Registry
