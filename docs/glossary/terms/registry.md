---
id: TERM-013
name: Registry
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: Registry Service
stability: Stable
tags: [platform, registry, discovery]
aliases: [Catalog, Service Registry]
deprecated_aliases: [Database (nhầm lẫn)]
summary: Nơi đăng ký (Capability→Agent→Priority); không phải Database.
definition: >
  Registry là nơi đăng ký. Registry không phải Database.
  Registry chứa Capability → Agent → Priority.
purpose: Là nguồn discover để Runtime resolve capability.
entity_type: Service
normative:
  MUST:
    - Register capability
    - Register agent
    - Register priority
  MUST NOT:
    - Lưu dữ liệu nghiệp vụ (thuộc Database)
responsibilities:
  - Đăng ký Capability
  - Đăng ký Agent
  - Đăng ký Priority
does_not_responsible:
  - Lưu dữ liệu nghiệp vụ (thuộc Database)
  - Chạy logic
owned_by: Registry Service
used_by:
  - Runtime (Capability Resolver)
  - Doctor
  - Dashboard
depends_on:
  - TERM-001 Runtime
inputs:
  - Registration
outputs:
  - Lookup result
lifecycle: Registered → Updated → Removed
states: [Registered, Updated, Removed]
invariants:
  - Registry không phải Database.
related:
  - TERM-006
  - TERM-005
  - TERM-015
examples:
  - Capability → Agent → Priority
references:
  - P007 Capability Driven
  - P009 Single Source of Truth
---

# Registry

Registry là nơi đăng ký.

Không phải Database.

Ví dụ:

```text
Capability
    ↓
Agent
    ↓
Priority
```

## Normative

- **MUST** Register capability.
- **MUST NOT** Lưu dữ liệu nghiệp vụ.

## Responsibilities

- Đăng ký Capability
- Đăng ký Agent
- Đăng ký Priority

## Invariant

> Registry không phải Database.
