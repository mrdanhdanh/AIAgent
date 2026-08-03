---
id: capability
name: Capability
status: Draft
category: execution
summary: Khả năng của hệ thống; không phụ thuộc implementation; Runtime sẽ resolve.
definition: >
  Capability là khả năng (ability). Capability KHÔNG phải Agent.
  Capability không phụ thuộc implementation. Runtime sẽ resolve.
purpose: Tách "cần làm gì" khỏi "ai làm" (capability driven).
responsibilities:
  - Khai báo khả năng có thể thực hiện
  - Được resolve thành Agent/Plugin bởi Runtime
does_not_responsible:
  - Implementation cụ thể
  - Chạy trực tiếp
owned_by: Registry
used_by:
  - Runtime (Capability Resolver)
  - Agent
  - Plugin
inputs:
  - Capability Request
outputs:
  - Resolved Capability
lifecycle: Registered → Available → Deprecated → Removed
related:
  - registry
  - agent
  - plugin
  - runtime
examples:
  - Code Review → Planner Agent | Review Agent | External Plugin
references:
  - P006 Capability Driven
  - P007 Discoverable
---

# Capability

Đây là khái niệm rất quan trọng.

Capability KHÔNG phải Agent.

Capability là khả năng.

Ví dụ:

```text
Code Review
    ↓
Planner Agent | Review Agent | External Plugin
```

Runtime sẽ resolve.

Capability không phụ thuộc implementation.

## Responsibilities

- Khai báo khả năng có thể thực hiện
- Được resolve thành Agent/Plugin bởi Runtime

## Not Responsible

- Implementation cụ thể
- Chạy trực tiếp

## Owner

Registry

## Used By

- Runtime (Capability Resolver)
- Agent
- Plugin

## Input

- Capability Request

## Output

- Resolved Capability
