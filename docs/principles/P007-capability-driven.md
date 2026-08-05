---
id: P007
name: Capability Driven
status: Stable
version: 1.0.0
since: 1.0.0
category: Execution
priority: Critical
normative: MUST
breaking_change: true
owner: Runtime Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Runtime
  - Registry
  - Agent
  - Plugin
  - Workflow
verification:
  doctor:
    - capability-not-agent
  runtime:
    - capability-resolution
  tests:
    - capability-driven-tests
violation:
  level: Critical
  action:
    - doctor_error
formal_rule: workflow.calls == capability (khong phai agent)
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P001
conflicts: []
strengthens:
  - P012
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P001
statement: >
  Runtime không biết Agent cụ thể. Runtime chỉ biết Capability.
rationale: >
  Tách "cần làm gì" khỏi "ai làm"; đổi Agent/Plugin không đổi Workflow.
rules:
  - Không gọi Agent cụ thể — gọi Capability.
  - Capability không phụ thuộc implementation.
  - Runtime resolve qua Registry.
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
---

# P007 — Capability Driven

## Statement

> Runtime không biết Agent cụ thể. Runtime chỉ biết Capability.

## Formal Rule

```text
workflow.calls == capability (khong phai agent)
```

## Rules

- Không gọi Agent cụ thể — gọi Capability.
- Capability không phụ thuộc implementation.
- Runtime resolve qua Registry.

## Rationale

Tách "cần làm gì" khỏi "ai làm"; đổi Agent/Plugin không đổi Workflow.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Runtime
- Registry
- Agent
- Plugin
- Workflow

## Enforcement

- Doctor: capability-not-agent
- Runtime: capability-resolution
- Tests: capability-driven-tests

## Violation

- Level: Critical
- Action: doctor_error
