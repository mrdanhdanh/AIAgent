---
id: RULE-010
name: Extension
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
  dashboard: False
statement: >
  Không sửa Core. Muốn mở rộng → Plugin. Plugin export Capability → Registry.
purpose: >
  Core bất biến, mở rộng an toàn qua Plugin.
rules:
  - Không sửa Core.
  - Mở rộng qua Plugin.
  - Plugin export Capability→Registry.
constraints:
  allowed:
    - Plugin→Capability→Registry→Done
  forbidden:
    - Sửa Core để thêm tính năng.
examples:
  - Plugin → Capability → Registry
related_principles:
  - P012
  - P019
related_rules:
  - RULE-002
  - RULE-008
verification:
  - doctor: core-modification-check
  - runtime: plugin-sandbox
  - tests: extension-tests
---

# RULE-010 — Extension

## Statement

> Không sửa Core. Muốn mở rộng → Plugin. Plugin export Capability → Registry.

## Purpose

Core bất biến, mở rộng an toàn qua Plugin.

## Rules

- Không sửa Core.
- Mở rộng qua Plugin.
- Plugin export Capability→Registry.

## Allowed

- Plugin→Capability→Registry→Done

## Forbidden

- Sửa Core để thêm tính năng.

## Example

```text
Plugin → Capability → Registry
```

## Related Principles

- P012, P019

## Related Rules

- RULE-002, RULE-008

## Verification

- doctor: core-modification-check
- runtime: plugin-sandbox
- tests: extension-tests
