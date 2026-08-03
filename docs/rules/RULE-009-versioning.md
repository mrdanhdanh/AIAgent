---
id: RULE-009
name: Versioning
status: Stable
version: 1.0.0
category: Data
policy_type: mandatory
severity: high
compliance: required
enforcement:
  runtime: True
  doctor: True
  validator: True
  dashboard: False
statement: >
  Mọi object có version. Không overwrite.
purpose: >
  Rollback, trace, compatibility.
rules:
  - Mọi object có version.
  - Không overwrite.
  - Version bất biến sau publish.
constraints:
  allowed:
    - Workflow 1.0→1.1→2.0
  forbidden:
    - Ghi đè version cũ.
examples:
  - Workflow 1.0 → 1.1 → 2.0
related_principles:
  - P004
  - P010
  - P018
related_rules:
  - RULE-005
  - RULE-013
verification:
  - doctor: version-presence
  - runtime: version-check
  - tests: versioning-tests
---

# RULE-009 — Versioning

## Statement

> Mọi object có version. Không overwrite.

## Purpose

Rollback, trace, compatibility.

## Rules

- Mọi object có version.
- Không overwrite.
- Version bất biến sau publish.

## Allowed

- Workflow 1.0→1.1→2.0

## Forbidden

- Ghi đè version cũ.

## Example

```text
Workflow 1.0 → 1.1 → 2.0
```

## Related Principles

- P004, P010

## Related Rules

- RULE-005, RULE-013

## Verification

- doctor: version-presence
- runtime: version-check
- tests: versioning-tests
