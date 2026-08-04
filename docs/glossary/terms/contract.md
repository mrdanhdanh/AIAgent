---
id: TERM-014
name: Contract
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: Contract Registry
stability: Stable
tags: [platform, contract, interface]
aliases: [Interface]
deprecated_aliases: [API (nhầm lẫn)]
summary: Giao diện giữa hai thành phần; không gọi trực tiếp.
definition: >
  Contract là giao diện giữa hai thành phần.
  Không gọi trực tiếp — qua Contract.
purpose: Định nghĩa input/output versioned để giao tiếp kiểm tra được.
entity_type: Definition
normative:
  MUST:
    - Define input/output
    - Be versioned
    - Be backward compatible
  MUST NOT:
    - Chứa implementation
responsibilities:
  - Định nghĩa giao diện input/output
  - Versioning contract
does_not_responsible:
  - Implementation
  - State
owned_by: Contract Registry
used_by:
  - Runtime
  - Agent
  - Plugin
depends_on:
  - TERM-001 Runtime
inputs:
  - Giao tiếp giữa các thành phần
outputs:
  - Contract schema
lifecycle: Draft → Versioned → Published
states: [Draft, Versioned, Published]
invariants:
  - Contract không chứa implementation.
  - Không gọi trực tiếp — qua Contract.
related:
  - TERM-001
  - TERM-002
  - TERM-005
examples:
  - Workflow → Runtime qua Contract
references:
  - P002 Contract First
  - P004 Everything is Versioned
  - P018 Evolvable
---

# Contract

Contract là giao diện giữa hai thành phần.

Ví dụ:

```text
Workflow
    ↓
Runtime
```

Thông qua Contract.

Không gọi trực tiếp.

## Normative

- **MUST** Define input/output.
- **MUST** Be versioned.
- **MUST NOT** Chứa implementation.

## Responsibilities

- Định nghĩa giao diện input/output
- Versioning contract

## Invariant

> Không gọi trực tiếp — qua Contract.
