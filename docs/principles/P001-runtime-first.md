---
id: P001
name: Runtime First
status: Stable
version: 1.0.0
since: 1.0.0
category: Core
priority: Critical
normative: MUST
breaking_change: true
owner: Runtime Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Runtime
  - Workflow
  - Agent
  - Registry
  - Command
  - Plugin
verification:
  doctor:
    - runtime-direct-call
    - agent-chain
  runtime:
    - orchestration-check
  tests:
    - runtime-first-tests
violation:
  level: Critical
  action:
    - stop_execution
    - doctor_error
formal_rule: caller != Agent && callee == Runtime
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P002
  - P005
  - P007
conflicts: []
strengthens:
  - P005
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P002
  - P005
  - P007
statement: >
  Runtime là trung tâm của AIOS. Mọi hoạt động đều phải được Runtime điều phối.
rationale: >
  Tách điều phối khỏi logic agent → agent đơn giản, thay thế được, scale được.
rules:
  - Agent không gọi Agent.
  - Workflow không gọi Agent.
  - Plugin không gọi Agent.
  - Command không gọi Agent.
  - Chỉ Runtime được phép thực thi Agent.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P002
  - P005
  - P007
---

# P001 — Runtime First

## Statement

> Runtime là trung tâm của AIOS. Mọi hoạt động đều phải được Runtime điều phối.

## Formal Rule

```text
caller != Agent && callee == Runtime
```

## Rules

- Agent không gọi Agent.
- Workflow không gọi Agent.
- Plugin không gọi Agent.
- Command không gọi Agent.
- Chỉ Runtime được phép thực thi Agent.

## Rationale

Tách điều phối khỏi logic agent → agent đơn giản, thay thế được, scale được.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Runtime
- Workflow
- Agent
- Registry
- Command
- Plugin

## Enforcement

- Doctor: runtime-direct-call, agent-chain
- Runtime: orchestration-check
- Tests: runtime-first-tests

## Violation

- Level: Critical
- Action: stop_execution, doctor_error
