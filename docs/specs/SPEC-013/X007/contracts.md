---
name: SPEC-013-x007-contracts
description: SPEC-013 X007 - Evolution Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Evolution Contracts

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution Engine giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (Evolution-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | EvolutionApi ops | can ADR |
| Data Contract | Diff + Result schema | can ADR |
| Event Contract | Evolution_* events (S011) | can ADR |
| Metric Contract | Evolution_* metrics | additive |
| Policy Contract | run scope | can ADR |
| Interface Contract | Store, Diff, Comparator | can ADR |
| Report Contract | report schema | can ADR |

## XCT003 - Compatibility Rules

- Add: field/op moi - OK.
- Change: y nghia field - ADR.
- Remove: field/op - ADR + RFC + migration.
- Event: them type OK, doi type BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No production change qua Evolution.
- No non-deterministic Evolution.

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-013
- SPEC-005 Registry
