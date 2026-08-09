---
name: spec-008-x007-contracts
description: SPEC-008 X007 - Event Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Event Contracts

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event Bus giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (event-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | EventApi ops | can ADR |
| Data Contract | Event schema (S011) | can ADR |
| Event Contract | EVENT_* types (S011) | can ADR |
| Metric Contract | event_* metrics | additive |
| Policy Contract | retention/quota | can ADR |
| Interface Contract | Store, Router, Subscription | can ADR |
| Stream Contract | event stream schema | can ADR |

## XCT003 - Compatibility Rules

- Add: field/type moi - OK.
- Change: y nghia field - ADR.
- Remove: field - ADR + RFC + migration.
- Event: them type OK, doi type BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No mutable Event contract.
- No contract chua Business Data.

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-008
- SPEC-005 Registry
