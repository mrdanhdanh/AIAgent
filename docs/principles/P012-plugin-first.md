---
id: P012
name: Plugin First
status: Stable
version: 1.0.0
since: 1.0.0
category: Platform
priority: Critical
normative: MUST
breaking_change: true
owner: Platform Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Core
  - Plugin
  - Registry
  - SDK
verification:
  doctor:
    - core-modification-check
  runtime:
    - plugin-sandbox
  tests:
    - plugin-first-tests
violation:
  level: Critical
  action:
    - stop_execution
    - doctor_error
formal_rule: core.modified == false (khi mo rong)
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P001
  - P007
conflicts: []
strengthens:
  - P019
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P001
  - P007
statement: >
  Core không sửa. Muốn mở rộng → Plugin.
rationale: >
  Core bất biến → ổn định, ít bug; plugin chạy sandbox theo permission.
rules:
  - Không sửa core để thêm tính năng.
  - Mở rộng qua Plugin/SDK/Capability/Metadata.
  - Plugin không truy cập ngoài permission.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P001
  - P007
---

# P012 — Plugin First

## Statement

> Core không sửa. Muốn mở rộng → Plugin.

## Formal Rule

```text
core.modified == false (khi mo rong)
```

## Rules

- Không sửa core để thêm tính năng.
- Mở rộng qua Plugin/SDK/Capability/Metadata.
- Plugin không truy cập ngoài permission.

## Rationale

Core bất biến → ổn định, ít bug; plugin chạy sandbox theo permission.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Core
- Plugin
- Registry
- SDK

## Enforcement

- Doctor: core-modification-check
- Runtime: plugin-sandbox
- Tests: plugin-first-tests

## Violation

- Level: Critical
- Action: stop_execution, doctor_error
