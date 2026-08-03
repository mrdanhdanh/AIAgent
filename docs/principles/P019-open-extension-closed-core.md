---
id: P019
name: Open Extension, Closed Core
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
  - Core
  - Plugin
  - SDK
verification:
  doctor:
    - core-modification-check
  runtime: []
  tests:
    - open-extension-tests
violation:
  level: Critical
  action:
    - doctor_error
formal_rule: core.open(extension) && core.closed(modification)
decision:
  mandatory: true
  runtime: false
  doctor: true
  dashboard: false
requires:
  - P003
  - P012
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
  - P003
  - P012
statement: >
  Core gần như bất biến. Mở rộng bằng Plugin, SDK, Capability, Metadata.
rationale: >
  Core bất biến → ổn định; mọi mở rộng qua điểm mở rộng đã định nghĩa.
rules:
  - Không sửa core để mở rộng.
  - Mở rộng qua Plugin, SDK, Capability, Metadata.
  - Core bất biến trừ khi ADR cấp cao.
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
  - P012
---

# P019 — Open Extension, Closed Core

## Statement

> Core gần như bất biến. Mở rộng bằng Plugin, SDK, Capability, Metadata.

## Formal Rule

```text
core.open(extension) && core.closed(modification)
```

## Rules

- Không sửa core để mở rộng.
- Mở rộng qua Plugin, SDK, Capability, Metadata.
- Core bất biến trừ khi ADR cấp cao.

## Rationale

Core bất biến → ổn định; mọi mở rộng qua điểm mở rộng đã định nghĩa.

## Normative

- **MUST** — bất biến, vi phạm là lỗi.

## Affects

- Core
- Plugin
- SDK

## Enforcement

- Doctor: core-modification-check
- Runtime: 
- Tests: open-extension-tests

## Violation

- Level: Critical
- Action: doctor_error
