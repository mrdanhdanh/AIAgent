---
name: spec-007-x012-policies
description: SPEC-007 X012 - Artifact Policies. 10 policies binding S012, immutable.
agent: general
---

# X012 - Artifact Policies

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact Manager dung policy nao de bao ve Artifact?**

## XP001 - Philosophy

- Artifact Manager THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Artifact op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Artifact Manager khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | Immutable | P010 | Critical |
| XPOL-002 | No Overwrite | TERM-008 | Critical |
| XPOL-003 | Checksum Required | P010 | Critical |
| XPOL-004 | Version Strict | P004 | High |
| XPOL-005 | No Business Data | S011 OB003A | Critical |
| XPOL-006 | Retention | S012 | High |
| XPOL-007 | Quota | S012 | High |
| XPOL-008 | Consume Read-Only | S012 | High |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Schema Valid | X008 | High |

## XP004 - Enforcement

- **Point**: Artifact Manager, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: artifact op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-001/002/006 can approval (S012).
- Retry: Publish/Index/Archive, max 3 lan, exponential backoff.
- Timeout: create 500ms, checksum 1s, publish 1s, archive 500ms (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- P010 Immutable Artifact
- X019 Doctor - SPEC-007
