---
id: TERM-019
name: Evolution
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: Evolution Engine
stability: Stable
tags: [platform, evolution, migration, versioning]
aliases: [System Evolution, Upgrade]
deprecated_aliases: [Rewrite]
summary: Tiến hóa hệ thống an toàn; không phá vỡ hệ thống.
definition: >
  Evolution là tiến hóa hệ thống an toàn.
  Evolution diff, check compatibility, migrate, self-heal doc-only.
purpose: Thay đổi hệ thống an toàn theo P013.
entity_type: Service
normative:
  MUST:
    - Keep backward compatibility
    - Have migration plan
    - Self-heal doc-only
  MUST NOT:
    - Phá vỡ hệ thống
    - Sửa Core tự động
responsibilities:
  - Semantic Diff
  - Compatibility Check
  - Migration Plan + Migrate
  - Health Score
does_not_responsible:
  - Phá vỡ hệ thống
  - Sửa Core tự động
owned_by: Evolution Engine
used_by:
  - Runtime
  - Doctor
  - User
depends_on:
  - TERM-001 Runtime
  - TERM-012 Event
inputs:
  - Phiên bản cũ/mới
outputs:
  - Semantic Diff
  - Migration Plan
  - Evolution Report
lifecycle: Diffed → CompatChecked → Planned → Migrated → Evolved
states: [Diffed, CompatChecked, Planned, Migrated, Evolved]
invariants:
  - Evolution không phá vỡ hệ thống.
related:
  - TERM-001
  - TERM-012
references:
  - SPEC-013 Evolution Engine
---

# Evolution

Tiến hóa hệ thống an toàn.

## Normative

- **MUST** Keep backward compatibility.
- **MUST** Have migration plan.
- **MUST NOT** Phá vỡ hệ thống.

## Responsibilities

- Semantic Diff
- Compatibility Check
- Migration Plan + Migrate

## Invariant

> Evolution không phá vỡ hệ thống.
