---
name: spec-011-x007-contracts
description: SPEC-011 X007 - Doctor Contracts. Contract types, compatibility, anti-patterns.
agent: general
---

# X007 - Doctor Contracts

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor giao tiep voi ngoai vi nhu the nao?**

## XCT001 - Philosophy

- Contract la hop dong - khong phai cai dat.
- Backward compatible (XNF-006).
- Breaking change can ADR + RFC (SPEC-000).
- Contract co schema (doctor-*.schema.json).

## XCT002 - Contract Types (7)

| Type | Vi du | Breaking? |
|------|-------|-----------|
| API Contract | DoctorApi ops | can ADR |
| Data Contract | Finding + Score schema | can ADR |
| Event Contract | DOCTOR_* events (S011) | can ADR |
| Metric Contract | doctor_* metrics | additive |
| Policy Contract | repair scope | can ADR |
| Interface Contract | Store, Scanner, RepairEngine | can ADR |
| Report Contract | report schema | can ADR |

## XCT003 - Compatibility Rules

- Add: field/op moi - OK.
- Change: y nghia field - ADR.
- Remove: field/op - ADR + RFC + migration.
- Event: them type OK, doi type BREAKING.

## XCT004 - Anti-Patterns (Cam)

- No implicit contract (undocumented).
- No silent breaking.
- No core modify qua repair.
- No auto-decision (S013).

## XCT005 - Quality

- Contract co schema + doc + test.
- Contract register trong SPEC-005.
- Doctor X019 check contract validity.

## Tham chieu

- SPEC-000 Constitution
- X017 Extensions - SPEC-011
- SPEC-005 Registry
