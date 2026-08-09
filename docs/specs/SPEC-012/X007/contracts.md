---
name: spec-012-x007-contracts
description: SPEC-012 X007 - Simulation Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Simulation Contracts

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation Engine giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (simulation-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | SimulationApi ops | can ADR |
| Data Contract | Scenario + Result schema | can ADR |
| Event Contract | SIMULATION_* events (S011) | can ADR |
| Metric Contract | simulation_* metrics | additive |
| Policy Contract | run scope | can ADR |
| Interface Contract | Store, Scenario, Comparator | can ADR |
| Report Contract | report schema | can ADR |

## XCT003 - Compatibility Rules

- Add: field/op moi - OK.
- Change: y nghia field - ADR.
- Remove: field/op - ADR + RFC + migration.
- Event: them type OK, doi type BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No production change qua simulation.
- No non-deterministic simulation.

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-012
- SPEC-005 Registry
