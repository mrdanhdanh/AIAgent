---
name: spec-011-x012-policies
description: SPEC-011 X012 - Doctor Policies. 10 policies binding S012, non-invasive.
agent: general
---

# X012 - Doctor Policies

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor dung policy nao de bao ve he thong?**

## XP001 - Philosophy

- Doctor THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Doctor op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Doctor khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | Non-Invasive | P015 | Critical |
| XPOL-002 | Safe Repair | P015 | Critical |
| XPOL-003 | Scan All | P005 | Critical |
| XPOL-004 | Score Strict | P005 | High |
| XPOL-005 | No Business Data | S011 OB003A | Critical |
| XPOL-006 | Retention | S012 | High |
| XPOL-007 | Quota | S012 | High |
| XPOL-008 | No Auto-Decision | S013 | Critical |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Schema Valid | X008 | High |

## XP004 - Enforcement

- **Point**: Doctor, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: doctor op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-001/008/006 can approval (S012).
- Retry: Scan/Report, max 3 lan, exponential backoff.
- Timeout: scan 30s, diagnose 5s, score 1s, report 5s (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- P015 Fail-Safe
- X019 Doctor - SPEC-011
