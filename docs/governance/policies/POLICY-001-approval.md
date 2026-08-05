---
id: POLICY-001
name: Approval
status: Stable
version: 1.0.0
category: Approval
scope:
  applies_to:
    - Runtime
    - Workflow
    - Plugin
    - SPEC
    - Principle
    - Rule
    - Registry
  excludes:
    - Example
    - Playground
statement: >
  Không có thay đổi nào đi thẳng vào Core.
purpose: >
  Mọi thay đổi qua chuỗi Draft→Review→Approve→Implement→Validate→Release.
rules:
  - Không thay đổi Core trực tiếp.
  - Chuỗi approval bắt buộc.
  - Approval ghi lại để audit.
allowed:
  - Draft→Review→Approve→Implement→Validate→Release
forbidden:
  - Thay đổi Core không approval.
  - Bypass approval gate.
related_principles:
  - P016
  - P020
  - P001
examples:
  - Draft → Review → Approve → Implement → Validate → Release
---

# POLICY-001 — Approval

## Statement

> Không có thay đổi nào đi thẳng vào Core.

## Purpose

Mọi thay đổi qua chuỗi Draft→Review→Approve→Implement→Validate→Release.

## Rules

- Không thay đổi Core trực tiếp.
- Chuỗi approval bắt buộc.
- Approval ghi lại để audit.

## Allowed

- Draft→Review→Approve→Implement→Validate→Release

## Forbidden

- Thay đổi Core không approval.
- Bypass approval gate.

## Example

```text
Draft → Review → Approve → Implement → Validate → Release
```

## Related Principles

- P016, P020
