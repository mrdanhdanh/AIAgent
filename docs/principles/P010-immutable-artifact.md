---
id: P010
name: Immutable Artifact
status: Stable
version: 1.0.0
since: 1.0.0
category: Data
priority: Critical
normative: MUST
breaking_change: true
owner: Artifact Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Reliability
affects:
  - Artifact
  - Runtime
  - Doctor
verification:
  doctor:
    - artifact-overwrite-check
  runtime:
    - immutability-check
  tests:
    - immutable-artifact-tests
violation:
  level: Critical
  action:
    - overwrite_blocked
    - doctor_error
formal_rule: Artifact.mutable == false
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P004
conflicts: []
strengthens:
  - P015
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P004
statement: >
  Artifact sinh ra không sửa. Nếu sửa → version mới.
rationale: >
  Immutable → toàn vẹn, reproducible, audit được.
rules:
  - Không sửa artifact sau khi sinh.
  - Thay đổi → tạo version mới.
  - Artifact có checksum.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P004
---

# P010 — Immutable Artifact

## Statement

> Artifact sinh ra không sửa. Nếu sửa → version mới.

## Formal Rule

```text
Artifact.mutable == false
```

## Rules

- Không sửa artifact sau khi sinh.
- Thay đổi → tạo version mới.
- Artifact có checksum.

## Rationale

Immutable → toàn vẹn, reproducible, audit được.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Artifact
- Runtime
- Doctor

## Enforcement

- Doctor: artifact-overwrite-check
- Runtime: immutability-check
- Tests: immutable-artifact-tests

## Violation

- Level: Critical
- Action: overwrite_blocked, doctor_error
