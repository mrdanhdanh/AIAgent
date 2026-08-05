---
id: P003
name: Metadata First
status: Stable
version: 1.0.0
since: 1.0.0
category: Data
priority: Critical
normative: MUST
breaking_change: true
owner: Core Data Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - Workflow
  - Agent
  - Artifact
  - Capability
  - Plugin
verification:
  doctor:
    - metadata-presence
  runtime:
    - entity-init-check
  tests:
    - metadata-first-tests
violation:
  level: Critical
  action:
    - doctor_error
formal_rule: entity.metadata != null
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P002
  - P009
conflicts: []
strengthens:
  - P017
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P002
  - P009
statement: >
  Mọi thực thể đều phải có metadata.
rationale: >
  Metadata là nguồn cho resolver/scheduler/doctor/dashboard; không hard-code đặc tính.
rules:
  - Mọi entity có id, version, owner, status, created, updated.
  - Không hard-code đặc tính thực thể trong code.
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
  - P009
---

# P003 — Metadata First

## Statement

> Mọi thực thể đều phải có metadata.

## Formal Rule

```text
entity.metadata != null
```

## Rules

- Mọi entity có id, version, owner, status, created, updated.
- Không hard-code đặc tính thực thể trong code.

## Rationale

Metadata là nguồn cho resolver/scheduler/doctor/dashboard; không hard-code đặc tính.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Workflow
- Agent
- Artifact
- Capability
- Plugin

## Enforcement

- Doctor: metadata-presence
- Runtime: entity-init-check
- Tests: metadata-first-tests

## Violation

- Level: Critical
- Action: doctor_error
