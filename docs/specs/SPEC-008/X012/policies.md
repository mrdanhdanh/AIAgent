---
name: spec-008-x012-policies
description: SPEC-008 X012 - Event Policies. 10 policies binding S012, immutable.
agent: general
---

# X012 - Event Policies

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event Bus dung policy nao de bao ve Event?**

## XP001 - Philosophy

- Event Bus THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Event op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Event Bus khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | Immutable | P010 | Critical |
| XPOL-002 | Append-Only | P005 | Critical |
| XPOL-003 | Lineage Required | RULE-007 | Critical |
| XPOL-004 | At-Least-Once | S012 | High |
| XPOL-005 | No Business Data | S011 OB003A | Critical |
| XPOL-006 | Retention | S012 | High |
| XPOL-007 | Quota | S012 | High |
| XPOL-008 | Ordering | S012 | High |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Schema Valid | X008 | High |

## XP004 - Enforcement

- **Point**: Event Bus, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: event op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-001/002/006 can approval (S012).
- Retry: Store/Route/Deliver/Archive, max 3 lan, exponential backoff.
- Timeout: publish 500ms, validate 500ms, deliver 1s, replay 5s (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-008
