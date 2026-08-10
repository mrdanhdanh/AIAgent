---
name: spec-006-x012-policies
description: SPEC-006 X012 - Context Policies. 10 policies binding S012, isolation.
agent: general
---

# X012 - Context Policies

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Context Engine dung policy nao de bao ve Context?**

## XP001 - Philosophy

- Context Engine THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Context op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Context Engine khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | Isolation | POL-ISOL-001 | Critical |
| XPOL-002 | No Business Data | S011 OB003A | Critical |
| XPOL-003 | Transient | P009 | Critical |
| XPOL-004 | Grant Scope | S012 | High |
| XPOL-005 | Release Before End | S010 EF008 | Critical |
| XPOL-006 | Context Quota | S012 | High |
| XPOL-007 | Merge Same Execution | S012 | High |
| XPOL-008 | Retry Policy | S012 | Medium |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Key Schema | X008 | High |

## XP004 - Enforcement

- **Point**: Context Engine, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: context op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-004/005/006 can approval (S012).
- Retry: Distribute/Collect/Release, max 3 lan, exponential backoff.
- Timeout: allocate 500ms, mutate 1s, merge 1s, release 500ms (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- X008 Data Model - SPEC-006
- X019 Doctor - SPEC-006
