---
id: P002
name: Contract First
status: Stable
version: 1.0.0
since: 1.0.0
category: Architecture
priority: Critical
normative: MUST
breaking_change: true
owner: Core Architecture Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Workflow
  - Runtime
  - Agent
  - Plugin
verification:
  doctor:
    - direct-call-scan
    - internal-object-leak
  runtime:
    - contract-validation
  tests:
    - contract-first-tests
violation:
  level: Critical
  action:
    - doctor_error
    - contract_reject
formal_rule: module.communication.direct == false
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P001
  - P003
conflicts: []
strengthens:
  - P018
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P001
  - P003
statement: >
  Không module nào giao tiếp trực tiếp. Mọi giao tiếp qua Contract.
rationale: >
  Contract versioned, backward compatible → thay đổi không vỡ, giao tiếp kiểm tra được.
rules:
  - Không truyền object nội bộ.
  - Không phụ thuộc implementation.
  - Chỉ dùng Contract.
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
  - P003
---

# P002 — Contract First

## Statement

> Không module nào giao tiếp trực tiếp. Mọi giao tiếp qua Contract.

## Formal Rule

```text
module.communication.direct == false
```

## Rules

- Không truyền object nội bộ.
- Không phụ thuộc implementation.
- Chỉ dùng Contract.

## Rationale

Contract versioned, backward compatible → thay đổi không vỡ, giao tiếp kiểm tra được.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Workflow
- Runtime
- Agent
- Plugin

## Enforcement

- Doctor: direct-call-scan, internal-object-leak
- Runtime: contract-validation
- Tests: contract-first-tests

## Violation

- Level: Critical
- Action: doctor_error, contract_reject
