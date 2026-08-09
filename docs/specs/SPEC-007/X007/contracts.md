---
name: spec-007-x007-contracts
description: SPEC-007 X007 - Artifact Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Artifact Contracts

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact Manager giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (artifact-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | ArtifactApi ops | can ADR |
| Data Contract | Artifact schema | can ADR |
| Event Contract | ARTIFACT_* events (S011) | can ADR |
| Metric Contract | artifact_* metrics | additive |
| Policy Contract | retention/quota | can ADR |
| Interface Contract | Store, Indexer | can ADR |
| Storage Contract | content write-once | can ADR |

## XCT003 - Compatibility Rules

- Add: field/version moi - OK.
- Change: y nghia field - ADR.
- Remove: field - ADR + RFC + migration.
- Event: them event OK, doi event BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No mutable Artifact contract.
- No contract chua Business Data.

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-007
- SPEC-005 Registry
