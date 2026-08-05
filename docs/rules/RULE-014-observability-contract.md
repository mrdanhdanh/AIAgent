---
id: RULE-014
name: Observability Contract
status: Stable
version: 1.0.0
category: Observability
policy_type: mandatory
severity: high
compliance: required
enforcement:
  runtime: true
  doctor: true
  validator: false
  dashboard: true
statement: >
  Runtime bắt buộc phát telemetry: Metrics → Logs → Events → Artifacts.
purpose: >
  Mọi execution đều đo được. Observability Contract định nghĩa dữ liệu
  telemetry bắt buộc mà Runtime phải xuất.
rules:
  - Runtime phát telemetry cho mọi execution.
  - Metrics cho hiệu năng.
  - Logs cho debug.
  - Events cho state change.
  - Artifacts cho output.
constraints:
  allowed:
    - Execution → Metrics → Logs → Events → Artifacts
  forbidden:
    - Execution không để lại telemetry.
    - Thay đổi state không có Event.
examples:
  - Runtime phát event WORKFLOW_STARTED + metrics + log
related_principles:
  - P014
  - P005
related_rules:
  - RULE-007
  - RULE-004
verification:
  - doctor: observability-check
  - runtime: metrics-emission
  - tests: observability-tests
---

# RULE-014 — Observability Contract

## Statement

> Runtime bắt buộc phát telemetry: Metrics → Logs → Events → Artifacts.

## Purpose

Mọi execution đều đo được. Observability Contract định nghĩa dữ liệu telemetry bắt buộc mà Runtime phải xuất.

## Rules

- Runtime phát telemetry cho mọi execution.
- Metrics cho hiệu năng.
- Logs cho debug.
- Events cho state change.
- Artifacts cho output.

## Allowed

- Execution → Metrics → Logs → Events → Artifacts

## Forbidden

- Execution không để lại telemetry.
- Thay đổi state không có Event.

## Example

```text
Execution
    ↓
Metrics
    ↓
Logs
    ↓
Events
    ↓
Artifacts
```

## Related Principles

- P014, P005

## Related Rules

- RULE-007, RULE-004

## Verification

- doctor: observability-check
- runtime: metrics-emission
- tests: observability-tests
