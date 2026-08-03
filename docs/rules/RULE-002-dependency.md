---
id: RULE-002
name: Dependency
status: Stable
version: 1.0.0
category: Architecture
policy_type: mandatory
severity: critical
compliance: required
enforcement:
  runtime: True
  doctor: True
  validator: True
  dashboard: True
statement: >
  Mọi dependency phải explicit. Runtime chỉ đọc Registry, không tự scan.
purpose: >
  Không dependency ẩn; dependency graph từ khai báo.
rules:
  - Mọi dependency khai báo rõ (depends_on).
  - Runtime chỉ đọc Registry để tìm Agent.
  - Không tự scan Agent.
constraints:
  allowed:
    - Workflow declares depends_on: Capability
    - Runtime reads Registry
  forbidden:
    - Runtime tự scan Agent.
    - Dependency ngầm định.
examples:
  - Workflow depends_on Capability → Registry resolve Agent
related_principles:
  - P011
  - P009
related_rules:
  - RULE-001
  - RULE-003
verification:
  - doctor: hidden-dependency
  - tests: explicit-dependency-tests
---

# RULE-002 — Dependency

## Statement

> Mọi dependency phải explicit. Runtime chỉ đọc Registry, không tự scan.

## Purpose

Không dependency ẩn; dependency graph từ khai báo.

## Rules

- Mọi dependency khai báo rõ (depends_on).
- Runtime chỉ đọc Registry để tìm Agent.
- Không tự scan Agent.

## Allowed

- Workflow declares depends_on: Capability
- Runtime reads Registry

## Forbidden

- Runtime tự scan Agent.
- Dependency ngầm định.

## Example

```text
Workflow depends_on Capability → Registry resolve Agent
```

## Related Principles

- P011, P009

## Related Rules

- RULE-001, RULE-003

## Verification

- doctor: hidden-dependency
- tests: explicit-dependency-tests
