---
name: spec-012-x012-policies
description: SPEC-012 X012 - Simulation Policies. 10 policies binding S012, isolated.
agent: general
---

# X012 - Simulation Policies

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation Engine dung policy nao de bao ve he thong?**

## XP001 - Philosophy

- Simulation Engine THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Simulation op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Simulation Engine khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | Isolated | RULE-007 | Critical |
| XPOL-002 | Deterministic | P013 | Critical |
| XPOL-003 | Replayable | RULE-007 | High |
| XPOL-004 | Safe | P015 | Critical |
| XPOL-005 | No Business Data | S011 OB003A | Critical |
| XPOL-006 | Retention | S012 | High |
| XPOL-007 | Quota | S012 | High |
| XPOL-008 | Scenario Valid | X008 | High |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Schema Valid | X008 | High |

## XP004 - Enforcement

- **Point**: Simulation Engine, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: simulation op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-001/004/006 can approval (S012).
- Retry: Run/Observe/Report, max 3 lan, exponential backoff.
- Timeout: define 1s, configure 1s, run 30s, report 5s (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- RULE-007 Event
- X019 Doctor - SPEC-012
