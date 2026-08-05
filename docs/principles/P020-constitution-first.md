---
id: P020
name: Constitution First
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
  - SPEC
  - ADR
  - RFC
  - Code
verification:
  doctor:
    - constitution-conflict-check
  runtime: []
  tests:
    - constitution-first-tests
violation:
  level: Critical
  action:
    - doctor_error
    - block_release
formal_rule: hierarchy: Constitution > ADR > SPEC > Contract > Implementation > Config
decision:
  mandatory: true
  runtime: false
  doctor: true
  dashboard: true
requires:
  - P001
  - P002
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
  - P001
  - P002
  - P016
statement: >
  Thứ tự ưu tiên: Constitution > ADR > SPEC > Contract > Implementation > Configuration.
rationale: >
  Nếu code trái SPEC → Code sai; SPEC trái Constitution → SPEC sai.
rules:
  - Mọi SPEC tham chiếu Constitution.
  - ADR giải thích quyết định dựa trên principle.
  - Code không mâu thuẫn SPEC.
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
  - P002
  - P016
---

# P020 — Constitution First

## Statement

> Thứ tự ưu tiên: Constitution > ADR > SPEC > Contract > Implementation > Configuration.

## Formal Rule

```text
hierarchy: Constitution > ADR > SPEC > Contract > Implementation > Config
```

## Rules

- Mọi SPEC tham chiếu Constitution.
- ADR giải thích quyết định dựa trên principle.
- Code không mâu thuẫn SPEC.

## Rationale

Nếu code trái SPEC → Code sai; SPEC trái Constitution → SPEC sai.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- SPEC
- ADR
- RFC
- Code

## Enforcement

- Doctor: constitution-conflict-check
- Runtime: 
- Tests: constitution-first-tests

## Violation

- Level: Critical
- Action: doctor_error, block_release
