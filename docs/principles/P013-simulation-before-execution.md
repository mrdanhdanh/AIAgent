---
id: P013
name: Simulation Before Execution
status: Stable
version: 1.0.0
since: 1.0.0
category: Evolution
priority: High
normative: MUST
breaking_change: true
owner: Evolution Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Reliability
affects:
  - Workflow
  - Simulation
  - Doctor
verification:
  doctor:
    - simulation-gate
  runtime:
    - pre-execution-check
  tests:
    - simulation-tests
violation:
  level: High
  action:
    - block_execution
    - doctor_error
formal_rule: execute(workflow) -> simulation_passed
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P011
  - P015
  - P016
conflicts: []
strengthens: []
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P011
  - P015
  - P016
statement: >
  Workflow mới phải qua Simulation trước khi Execute.
rationale: >
  Dự đoán trước khi chạy thật → giảm rủi ro, phát hiện lỗi thiết kế sớm.
rules:
  - Workflow mới/thay đổi → Simulation.
  - Simulation báo rủi ro trước khi Execute.
  - Có Approval trước khi chạy thật.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P011
  - P015
  - P016
---

# P013 — Simulation Before Execution

## Statement

> Workflow mới phải qua Simulation trước khi Execute.

## Formal Rule

```text
execute(workflow) -> simulation_passed
```

## Rules

- Workflow mới/thay đổi → Simulation.
- Simulation báo rủi ro trước khi Execute.
- Có Approval trước khi chạy thật.

## Rationale

Dự đoán trước khi chạy thật → giảm rủi ro, phát hiện lỗi thiết kế sớm.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Workflow
- Simulation
- Doctor

## Enforcement

- Doctor: simulation-gate
- Runtime: pre-execution-check
- Tests: simulation-tests

## Violation

- Level: High
- Action: block_execution, doctor_error
