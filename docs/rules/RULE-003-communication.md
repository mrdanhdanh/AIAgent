---
id: RULE-003
name: Communication
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
  Mọi giao tiếp thông qua Contract. Có 4 loại: Command/Request, Contract, Event, Query.
purpose: >
  Giao tiếp kiểm tra được, không phụ thuộc implementation.
rules:
  - Mọi giao tiếp qua Contract.
  - Không gọi trực tiếp implementation.
  - Đúng loại giao tiếp cho từng nhu cầu.
constraints:
  allowed:
    - Command→Request
    - Runtime→Contract
    - Event Bus→Event
    - Registry→Query
  forbidden:
    - Runtime gọi Builder.cs trực tiếp.
    - Truyền object nội bộ qua biên giới.
examples:
  - Runtime → Builder Contract (không phải Builder.cs)
related_principles:
  - P002
  - P001
  - P017
related_rules:
  - RULE-007
  - RULE-002
verification:
  - doctor: direct-call-scan
  - runtime: contract-validation
  - tests: communication-tests
---

# RULE-003 — Communication

## Statement

> Mọi giao tiếp thông qua Contract. Có 4 loại: Command/Request, Contract, Event, Query.

## Purpose

Giao tiếp kiểm tra được, không phụ thuộc implementation.

## Rules

- Mọi giao tiếp qua Contract.
- Không gọi trực tiếp implementation.
- Đúng loại giao tiếp cho từng nhu cầu.

## Allowed

- Command→Request
- Runtime→Contract
- Event Bus→Event
- Registry→Query

## Forbidden

- Runtime gọi Builder.cs trực tiếp.
- Truyền object nội bộ qua biên giới.

## Example

```text
Runtime → Builder Contract (không phải Builder.cs)
```

## Related Principles

- P002, P001

## Related Rules

- RULE-007, RULE-002

## Verification

- doctor: direct-call-scan
- runtime: contract-validation
- tests: communication-tests
