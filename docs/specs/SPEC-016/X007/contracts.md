---
name: SPEC-016-x007-contracts
description: SPEC-016 X007 - CLI Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - CLI Contracts

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (CLI-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | CLIApi ops | can ADR |
| Data Contract | Widget + View schema | can ADR |
| Event Contract | CLI_* events (S011) | can ADR |
| Metric Contract | CLI_* metrics | additive |
| Policy Contract | render scope | can ADR |
| Interface Contract | Store, CommandEngine, FlagEngine | can ADR |
| Export Contract | export schema | can ADR |

## XCT003 - Compatibility Rules

- Add: field/op moi - OK.
- Change: y nghia field - ADR.
- Remove: field/op - ADR + RFC + migration.
- Event: them type OK, doi type BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No write qua CLI.
- No new data source (P005).

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-016
- SPEC-005 Registry
