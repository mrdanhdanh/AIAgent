---
id: POLICY-009
name: Security
status: Stable
version: 1.0.0
category: Security
statement: >
  Áp dụng Least Privilege, Sandbox, Audit, Approval.
purpose: >
  An toàn toàn hệ thống.
rules:
  - Least Privilege.
  - Sandbox cho Plugin.
  - Audit mọi quyền thay đổi.
  - Approval cho quyền cao.
allowed:
  - Least Privilege, Sandbox, Audit, Approval
forbidden:
  - Quyền vượt mức.
  - Không audit.
related_principles:
  - P016
  - P015
examples:
  - Least Privilege + Sandbox + Audit + Approval
---

# POLICY-009 — Security

## Statement

> Áp dụng Least Privilege, Sandbox, Audit, Approval.

## Purpose

An toàn toàn hệ thống.

## Rules

- Least Privilege.
- Sandbox cho Plugin.
- Audit mọi quyền thay đổi.
- Approval cho quyền cao.

## Allowed

- Least Privilege, Sandbox, Audit, Approval

## Forbidden

- Quyền vượt mức.
- Không audit.

## Example

```text
Least Privilege + Sandbox + Audit + Approval
```

## Related Principles

- P016, P015
