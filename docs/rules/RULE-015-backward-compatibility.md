---
id: RULE-015
name: Backward Compatibility
status: Stable
version: 1.0.0
category: Compatibility
policy_type: mandatory
severity: critical
compliance: required
enforcement:
  runtime: false
  doctor: true
  validator: true
  dashboard: false
statement: >
  Mỗi thay đổi phải khai báo compatibility: backward required, forward preferred.
purpose: >
  Nền tảng cho Evolution Engine — mọi thay đổi khai báo ảnh hưởng
  compatibility + migration cần thiết.
rules:
  - Mỗi thay đổi khai báo compatibility.
  - backward: required.
  - forward: preferred.
  - migration_required: khai báo rõ.
constraints:
  allowed:
    - Khai báo compatibility trong metadata thay đổi
  forbidden:
    - Breaking change không khai báo.
    - Phá backward compatibility không có ADR.
examples:
  - Contract v1→v2 backward: required, migration_required: true
related_principles:
  - P018
  - P004
related_rules:
  - RULE-009
  - RULE-013
verification:
  - doctor: compatibility-check
  - validator: compat-schema
  - tests: compatibility-tests
---

# RULE-015 — Backward Compatibility

## Statement

> Mỗi thay đổi phải khai báo compatibility: backward required, forward preferred.

## Purpose

Nền tảng cho Evolution Engine — mọi thay đổi khai báo ảnh hưởng compatibility + migration cần thiết.

## Rules

- Mỗi thay đổi khai báo compatibility.
- backward: required.
- forward: preferred.
- migration_required: khai báo rõ.

## Allowed

- Khai báo compatibility trong metadata thay đổi

## Forbidden

- Breaking change không khai báo.
- Phá backward compatibility không có ADR.

## Example

```text
compatibility:
  backward: required
  forward: preferred
  migration_required: false
```

## Related Principles

- P018, P004

## Related Rules

- RULE-009, RULE-013

## Verification

- doctor: compatibility-check
- validator: compat-schema
- tests: compatibility-tests
