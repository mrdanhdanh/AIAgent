---
name: spec-013-x012-policies
description: SPEC-013 X012 - Evolution Policies. 10 policies binding S012, safe evolution.
agent: general
---

# X012 - Evolution Policies

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution Engine dung policy nao de bao ve he thong?**

## XP001 - Philosophy

- Evolution Engine THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Evolution op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Evolution Engine khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | Safe Evolution | P013 | Critical |
| XPOL-002 | Backward Compatible | P013 | Critical |
| XPOL-003 | Migration Planned | P013 | Critical |
| XPOL-004 | Self-Heal Safe | P015 | Critical |
| XPOL-005 | No Business Data | S011 OB003A | Critical |
| XPOL-006 | Retention | S012 | High |
| XPOL-007 | Quota | S012 | High |
| XPOL-008 | Module Valid | X008 | High |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Schema Valid | X008 | High |

## XP004 - Enforcement

- **Point**: Evolution Engine, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: Evolution op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-001/003/006 can approval (S012).
- Retry: Migrate/Heal/Evolve, max 3 lan, exponential backoff.
- Timeout: Diff 1s, Plan 1s, run 30s, report 5s (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-013
