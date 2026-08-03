---
id: contract
name: Contract
status: Draft
category: contract
summary: Giao diện giữa hai thành phần; không gọi trực tiếp.
definition: >
  Contract là giao diện giữa hai thành phần.
  Không gọi trực tiếp — qua Contract.
purpose: Định nghĩa input/output versioned để giao tiếp kiểm tra được.
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
inputs:
  - Giao tiếp giữa các thành phần
outputs:
  - Contract schema
lifecycle: Draft → Versioned → Published
related:
  - runtime
  - workflow
  - agent
examples:
  - Workflow → Runtime qua Contract
references:
  - P002 Contract First
  - P009 Versioned
  - P015 Backward Compatible
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

## Responsibilities

- Định nghĩa giao diện input/output
- Versioning contract

## Not Responsible

- Implementation
- State

## Owner

Contract Registry

## Used By

- Runtime
- Agent
- Plugin

## Input

- Giao tiếp giữa các thành phần

## Output

- Contract schema
