---
name: spec-010-x012-policies
description: SPEC-010 X012 - Plugin Policies. 10 policies binding S012, no core modify.
agent: general
---

# X012 - Plugin Policies

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin Framework dung policy nao de bao ve Plugin?**

## XP001 - Philosophy

- Plugin Framework THUC THI policy - khong dinh nghia lai policy (S012).
- Policy ap dung truoc moi Plugin op.
- Deny wins khi conflict (S012).
- Moi quyet dinh policy co trace (S011).

## XP002 - Principles

- Policy la khai bao, khong hardcode.
- Plugin Framework khong quyet dinh chinh sach.
- Policy decision chi dua tren metadata.
- Quota va timeout cau hinh qua policy.

## XP003 - Policies (10)

| Policy | Ten | Nguon | Priority |
|--------|-----|-------|----------|
| XPOL-001 | No Core Modify | TERM-015 | Critical |
| XPOL-002 | Manifest Required | TERM-015 | Critical |
| XPOL-003 | Permission Scoped | TERM-015 | Critical |
| XPOL-004 | Sandbox Enforced | TERM-015 | High |
| XPOL-005 | No Business Data | S011 OB003A | Critical |
| XPOL-006 | Retention | S012 | High |
| XPOL-007 | Quota | S012 | High |
| XPOL-008 | Disable Before Uninstall | TERM-015 | High |
| XPOL-009 | Audit All | S011 | High |
| XPOL-010 | Schema Valid | X008 | High |

## XP004 - Enforcement

- **Point**: Plugin Framework, truoc moi op.
- **Result**: allow | deny | warn.
- **Log**: policy decision log (S011).
- **CACHE**: khong cache decision.

## XP005 - Resolution

- Thu tu: SPEC-005 policy registry.
- Conflict: deny wins.
- Scope: plugin op cu the.

## XP006 - Approval / Retry / Timeout Binding

- Approval: XPOL-001/003/006 can approval (S012).
- Retry: Enable/Export/Disable/Uninstall, max 3 lan, exponential backoff.
- Timeout: install 1s, validate 500ms, enable 1s, uninstall 1s (cau hinh, khong hardcode).

## XP007 - Traceability

Moi policy co source + principle. Kiem tra bang Doctor (X019).

## Tham chieu

- S012 Policy - SPEC-001
- TERM-015 Plugin
- X019 Doctor - SPEC-010
