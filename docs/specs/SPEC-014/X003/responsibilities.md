---
name: spec-014-x003-responsibilities
description: SPEC-014 X003 - Dashboard Responsibilities. Dashboard vs S011 vs User.
agent: general
---

# X003 - Dashboard Responsibilities

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Dashboard?**

## XRM001 - Philosophy

- Dashboard chiu trach nhiem hien thi quan sat.
- S011 cung cap metrics - khong hien thi.
- User xem view - khong thay doi.
- Policy (S012) quyet dinh - Dashboard thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Dashboard | S011 | User | Policy |
|-------------|-----------|------|------|--------|
| Render | OWNER | PROVIDER | - | - |
| Compose | OWNER | - | - | - |
| Build View | OWNER | - | REQUESTER | - |
| Filter | OWNER | - | REQUESTER | - |
| Refresh | OWNER | PROVIDER | - | - |
| Export | OWNER | - | - | - |
| Health Score | OWNER | - | - | - |
| Event Stream | OWNER | - | - | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |

## XRM003 - Owner Principles

- Dashboard la OWNER cua viec hien thi.
- S011 la PROVIDER - cung cap metrics.
- User la REQUESTER - xem view.
- Dashboard khong thay doi he thong (XC-001).

## XRM004 - Boundaries

- Dashboard: render, compose, build, filter, refresh, export.
- S011: cung cap metrics.
- User: xem view.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S011 Metrics - SPEC-001
- X004 Boundaries - SPEC-014
- S012 Policy - SPEC-001
