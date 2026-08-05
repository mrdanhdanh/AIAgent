---
id: P016
name: Human Approval
status: Stable
version: 1.0.0
since: 1.0.0
category: Governance
priority: Critical
normative: MUST
breaking_change: true
owner: Governance Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Governance
affects:
  - Release
  - Merge
  - Delete
  - Policy
verification:
  doctor:
    - approval-check
  runtime:
    - policy-gate
  tests:
    - human-approval-tests
violation:
  level: Critical
  action:
    - block_execution
formal_rule: merge/release/delete -> policy.approved
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires:
  - P013
  - P020
conflicts: []
strengthens: []
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
related:
  - P013
  - P020
statement: >
  AI không được Merge, Release, Delete nếu chưa qua Policy.
rationale: >
  Hành động không thể đảo ngược/ảnh hưởng rộng phải có người duyệt.
rules:
  - Merge/Release/Delete phải qua Policy.
  - Mức rủi ro cao → human approval.
  - Không bypass approval.
implications:
  - Tuân thủ theo formal rule.
anti_patterns:
  - Vi phạm formal rule.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Áp dụng trong SPEC-001.
references:
  - P013
  - P020
---

# P016 — Human Approval

## Statement

> AI không được Merge, Release, Delete nếu chưa qua Policy.

## Formal Rule

```text
merge/release/delete -> policy.approved
```

## Rules

- Merge/Release/Delete phải qua Policy.
- Mức rủi ro cao → human approval.
- Không bypass approval.

## Rationale

Hành động không thể đảo ngược/ảnh hưởng rộng phải có người duyệt.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Release
- Merge
- Delete
- Policy

## Enforcement

- Doctor: approval-check
- Runtime: policy-gate
- Tests: human-approval-tests

## Violation

- Level: Critical
- Action: block_execution
