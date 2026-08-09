---
name: spec-009-x012-policies
description: SPEC-009 X012 - Contract Policies. 10 policies binding S012, interface-only.
agent: general
---

# X012 - Contract Policies

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract System dung policy nao de bao ve Contract?**

## XP001 - Philosophy

- Contract System THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Contract op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Contract System khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | Interface Only | TERM-014 | Critical |
| XPOL-002 | No Implementation | TERM-014 | Critical |
| XPOL-003 | Version Strict | P004 | High |
| XPOL-004 | Backward Compatible | S007 | Critical |
| XPOL-005 | No Business Data | S011 OB003A | Critical |
| XPOL-006 | Retention | S012 | High |
| XPOL-007 | Quota | S012 | High |
| XPOL-008 | No Direct Call | TERM-014 | Critical |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Schema Valid | X008 | High |

## XP004 - Enforcement

- **Point**: Contract System, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: contract op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-003/004/006 can approval (S012).
- Retry: Publish/Resolve/Verify/Retire, max 3 lan, exponential backoff.
- Timeout: declare 500ms, validate 500ms, resolve 1s, verify 1s (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- TERM-014 Contract
- X019 Doctor - SPEC-009
