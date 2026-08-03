---
id: POLICY-005
name: Release
status: Stable
version: 1.0.0
category: Release
statement: >
  Release phải qua Simulation→Doctor→Validation→Approval→Release.
purpose: >
  Không release trực tiếp; mọi bản phát hành đều kiểm chứng.
rules:
  - Simulation trước.
  - Doctor kiểm tra.
  - Validation.
  - Approval.
  - Release.
allowed:
  - Simulation→Doctor→Validation→Approval→Release
forbidden:
  - Release trực tiếp.
related_principles:
  - P013
  - P016
examples:
  - Simulation → Doctor → Validation → Approval → Release
---

# POLICY-005 — Release

## Statement

> Release phải qua Simulation→Doctor→Validation→Approval→Release.

## Purpose

Không release trực tiếp; mọi bản phát hành đều kiểm chứng.

## Rules

- Simulation trước.
- Doctor kiểm tra.
- Validation.
- Approval.
- Release.

## Allowed

- Simulation→Doctor→Validation→Approval→Release

## Forbidden

- Release trực tiếp.

## Example

```text
Simulation → Doctor → Validation → Approval → Release
```

## Related Principles

- P013, P016
