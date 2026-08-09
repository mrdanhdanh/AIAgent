---
name: spec-009-x007-contracts
description: SPEC-009 X007 - Contract Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Contract Contracts

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract System giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-005).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (contract-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | ContractApi ops | can ADR |
| Data Contract | Contract schema | can ADR |
| Event Contract | CONTRACT_* events (X011 dinh nghia — S011 cung cap event model) | can ADR |
| Metric Contract | contract_* metrics | additive |
| Policy Contract | retention/compat | can ADR |
| Interface Contract | Store, Verifier | can ADR |
| Binding Contract | caller-binding schema | can ADR |

## XCT003 - Compatibility Rules

- Add: field/op moi - OK.
- Change: y nghia field - ADR.
- Remove: field/op - ADR + RFC + migration.
- Event: them type OK, doi type BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No implementation trong Contract.
- No direct call (TERM-014).

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-009
- SPEC-005 Registry
