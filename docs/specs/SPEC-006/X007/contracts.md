---
name: spec-006-x007-contracts
description: SPEC-006 X007 - Context Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Context Contracts

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Context Engine giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (context-*.schema.json).

## XCT002 - Contract Types

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | ContextApi ops | can ADR |
| Data Contract | ContextItem key/value schema | can ADR |
| Event Contract | CONTEXT_* events (S011) | can ADR |
| Metric Contract | context_* metrics | additive |
| Policy Contract | XPOL-* | can ADR |
| Interface Contract | PolicyGuard, Store | can ADR |

## XCT003 - Compatibility Rules

- Add: field/section moi - OK.
- Change: y nghia field - ADR.
- Remove: field - ADR + RFC + migration.
- Event: them event OK, doi event BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No shared mutable Context.
- No contract chua Business Data.

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-006
- SPEC-005 Registry
