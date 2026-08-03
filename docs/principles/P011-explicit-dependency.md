---
id: P011
name: Explicit Dependency
status: Stable
version: 1.0.0
since: 1.0.0
category: Architecture
priority: High
normative: MUST
breaking_change: true
owner: Core Architecture Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Workflow
  - Simulation
  - Doctor
verification:
  doctor:
    - hidden-dependency
  runtime: []
  tests:
    - explicit-dependency-tests
violation:
  level: High
  action:
    - doctor_error
formal_rule: dependency.declared == true
decision:
  mandatory: true
  runtime: false
  doctor: true
  dashboard: false
requires:
  - P001
  - P013
conflicts: []
strengthens: []
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P001
  - P013
statement: >
  Không dependency ẩn. Mọi phụ thuộc khai báo rõ ràng.
rationale: >
  Dependency ẩn → khó hiểu, khó mô phỏng; khai báo rõ → Simulation/Doctor dự đoán chính xác.
rules:
  - Mọi phụ thuộc khai báo trong metadata (depends_on).
  - Không phụ thuộc ngầm định vào trạng thái bên ngoài.
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
  - P013
---

# P011 — Explicit Dependency

## Statement

> Không dependency ẩn. Mọi phụ thuộc khai báo rõ ràng.

## Formal Rule

```text
dependency.declared == true
```

## Rules

- Mọi phụ thuộc khai báo trong metadata (depends_on).
- Không phụ thuộc ngầm định vào trạng thái bên ngoài.

## Rationale

Dependency ẩn → khó hiểu, khó mô phỏng; khai báo rõ → Simulation/Doctor dự đoán chính xác.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Workflow
- Simulation
- Doctor

## Enforcement

- Doctor: hidden-dependency
- Runtime: 
- Tests: explicit-dependency-tests

## Violation

- Level: High
- Action: doctor_error
