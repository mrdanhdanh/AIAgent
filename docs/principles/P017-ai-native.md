---
id: P017
name: AI Native
status: Stable
version: 1.0.0
since: 1.0.0
category: Evolution
priority: High
normative: MUST
breaking_change: true
owner: Evolution Team
requires_adr: true
lifecycle: Draft → Review → Stable → Deprecated
rationale_type: Architecture
affects:
  - SPEC
  - Registry
  - Doctor
verification:
  doctor:
    - machine-readable-check
  runtime: []
  tests:
    - ai-native-tests
violation:
  level: High
  action:
    - doctor_error
formal_rule: definition.machine_readable == true
decision:
  mandatory: true
  runtime: false
  doctor: true
  dashboard: false
requires:
  - P003
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
  - P003
  - P020
statement: >
  Mọi thứ đều phải Machine Readable và Human Readable.
rationale: >
  AI đọc được thì AI mới vận hành được; không chỉ có Markdown văn xuôi.
rules:
  - Mọi định nghĩa có dạng machine-readable.
  - Kèm giải thích human-readable.
  - Không chỉ có Markdown.
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
  - P020
---

# P017 — AI Native

## Statement

> Mọi thứ đều phải Machine Readable và Human Readable.

## Formal Rule

```text
definition.machine_readable == true
```

## Rules

- Mọi định nghĩa có dạng machine-readable.
- Kèm giải thích human-readable.
- Không chỉ có Markdown.

## Rationale

AI đọc được thì AI mới vận hành được; không chỉ có Markdown văn xuôi.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- SPEC
- Registry
- Doctor

## Enforcement

- Doctor: machine-readable-check
- Runtime: 
- Tests: ai-native-tests

## Violation

- Level: High
- Action: doctor_error
