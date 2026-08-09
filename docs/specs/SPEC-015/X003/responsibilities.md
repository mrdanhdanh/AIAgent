---
name: spec-015-x003-responsibilities
description: SPEC-015 X003 - SDK Responsibilities. SDK vs S011 vs User.
agent: general
---

# X003 - SDK Responsibilities

> **SPEC-015**: SDK - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong SDK?**

## XRM001 - Philosophy

- SDK chiu trach nhiem hien thi quan sat.
- S011 cung cap metrics - khong hien thi.
- User xem view - khong thay doi.
- Policy (S012) quyet dinh - SDK thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | SDK | S011 | User | Policy |
|-------------|-----------|------|------|--------|
| Render | OWNER | PROVIDER | - | - |
| Compose | OWNER | - | - | - |
| Bind API | OWNER | - | REQUESTER | - |
| Filter | OWNER | - | REQUESTER | - |
| Refresh | OWNER | PROVIDER | - | - |
| Export | OWNER | - | - | - |
| Health Score | OWNER | - | - | - |
| Event Stream | OWNER | - | - | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |

## XRM003 - Owner Principles

- SDK la OWNER cua viec hien thi.
- S011 la PROVIDER - cung cap metrics.
- User la REQUESTER - xem view.
- SDK khong thay doi he thong (XC-001).

## XRM004 - Boundaries

- SDK: render, compose, build, filter, refresh, export.
- S011: cung cap metrics.
- User: xem view.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S011 Metrics - SPEC-001
- X004 Boundaries - SPEC-015
- S012 Policy - SPEC-001
