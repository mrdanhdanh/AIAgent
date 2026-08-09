---
name: spec-016-x003-responsibilities
description: SPEC-016 X003 - CLI Responsibilities. CLI vs S011 vs User.
agent: general
---

# X003 - CLI Responsibilities

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong CLI?**

## XRM001 - Philosophy

- CLI chiu trach nhiem hien thi quan sat.
- S011 cung cap metrics - khong hien thi.
- User xem view - khong thay doi.
- Policy (S012) quyet dinh - CLI thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | CLI | S011 | User | Policy |
|-------------|-----------|------|------|--------|
| Render | OWNER | PROVIDER | - | - |
| Compose | OWNER | - | - | - |
| Resolve Alias | OWNER | - | REQUESTER | - |
| Filter | OWNER | - | REQUESTER | - |
| Refresh | OWNER | PROVIDER | - | - |
| Export | OWNER | - | - | - |
| Health Score | OWNER | - | - | - |
| Event Stream | OWNER | - | - | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |

## XRM003 - Owner Principles

- CLI la OWNER cua viec hien thi.
- S011 la PROVIDER - cung cap metrics.
- User la REQUESTER - xem view.
- CLI khong thay doi he thong (XC-001).

## XRM004 - Boundaries

- CLI: run, parse, resolve, help, complete, trigger.
- S011: cung cap metrics.
- User: xem view.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S011 Metrics - SPEC-001
- X004 Boundaries - SPEC-016
- S012 Policy - SPEC-001
