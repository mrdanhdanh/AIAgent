---
name: spec-009-x003-responsibilities
description: SPEC-009 X003 - Contract Responsibilities. Contract System vs Provider vs Caller.
agent: general
---

# X003 - Contract Responsibilities

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Contract System?**

## XRM001 - Philosophy

- Contract System chiu trach nhiem Lifecycle Contract.
- Provider khai bao - khong quan ly.
- Caller goi qua Contract - khong so huu.
- Policy (S012) quyet dinh - Contract System thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Contract System | Provider | Caller | Policy |
|-------------|----------------|----------|--------|--------|
| Declare | OWNER | DECLARER | - | - |
| Validate | OWNER | - | - | - |
| Version | OWNER | - | - | - |
| Resolve | OWNER | - | REQUESTER | - |
| Verify | OWNER | - | - | - |
| Retire | OWNER | - | - | Retention |
| Compat | OWNER | - | - | - |
| Bind | API | - | REQUESTER | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |
| No-Direct-Call | OWNER | - | BOUND | - |

## XRM003 - Owner Principles

- Contract Registry la OWNER duy nhat cua Contract (TERM-014).
- Provider la DECLARER - khong so huu sau declare.
- Khong co Owner transfer (P004).
- Contract immutable - version moi khi thay doi.

## XRM004 - Boundaries

- Contract System: declare, validate, version, resolve, verify, retire.
- Provider: khai bao Contract.
- Caller: goi qua Contract.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S007 Contract Model - SPEC-001
- X004 Boundaries - SPEC-009
- S012 Policy - SPEC-001
