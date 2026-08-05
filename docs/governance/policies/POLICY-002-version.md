---
id: POLICY-002
name: Version
status: Stable
version: 1.0.0
category: Versioning
scope:
  applies_to:
    - Runtime
    - Workflow
    - Plugin
    - SPEC
    - Artifact
    - Agent
    - Capability
  excludes:
    - Example
    - Playground
statement: >
  Áp dụng Semantic Versioning (MAJOR.MINOR.PATCH).
purpose: >
  Version nhất quán, rollback và compatibility được.
rules:
  - SemVer.
  - MAJOR = breaking.
  - MINOR = thêm tính năng.
  - PATCH = sửa lỗi.
allowed:
  - 1.0.0 → 1.1.0 → 1.1.1 → 2.0.0
forbidden:
  - Thay đổi không tăng version.
related_principles:
  - P004
  - P018
examples:
  - 1.0.0 → 1.1.0 → 1.1.1 → 2.0.0
---

# POLICY-002 — Version

## Statement

> Áp dụng Semantic Versioning (MAJOR.MINOR.PATCH).

## Purpose

Version nhất quán, rollback và compatibility được.

## Rules

- SemVer.
- MAJOR = breaking.
- MINOR = thêm tính năng.
- PATCH = sửa lỗi.

## Allowed

- 1.0.0 → 1.1.0 → 1.1.1 → 2.0.0

## Forbidden

- Thay đổi không tăng version.

## Example

```text
1.0.0 → 1.1.0 → 1.1.1 → 2.0.0
```

## Related Principles

- P004, P018
