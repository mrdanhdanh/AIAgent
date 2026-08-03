---
id: P004
name: Everything is Versioned
status: Stable
version: 1.0.0
since: 1.0.0
category: Data
priority: High
normative: MUST
breaking_change: true
owner: Core Data Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Maintainability
affects:
  - Workflow
  - Agent
  - Artifact
  - Registry
verification:
  doctor:
    - version-presence
  runtime:
    - version-check
  tests:
    - versioning-tests
violation:
  level: High
  action:
    - doctor_error
    - overwrite_blocked
formal_rule: entity.version != null && immutable_after_publish
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P003
  - P010
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
  - P003
  - P010
statement: >
  Không có object nào không version.
rationale: >
  Version cho phép rollback, trace, compatibility; không ghi đè.
rules:
  - Mọi entity/workflow/agent/artifact có version.
  - Không overwrite — tạo version mới.
  - Version bất biến sau publish.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P003
  - P010
---

# P004 — Everything is Versioned

## Statement

> Không có object nào không version.

## Formal Rule

```text
entity.version != null && immutable_after_publish
```

## Rules

- Mọi entity/workflow/agent/artifact có version.
- Không overwrite — tạo version mới.
- Version bất biến sau publish.

## Rationale

Version cho phép rollback, trace, compatibility; không ghi đè.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Workflow
- Agent
- Artifact
- Registry

## Enforcement

- Doctor: version-presence
- Runtime: version-check
- Tests: versioning-tests

## Violation

- Level: High
- Action: doctor_error, overwrite_blocked
