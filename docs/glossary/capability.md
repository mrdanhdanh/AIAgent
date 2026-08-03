---
name: glossary-capability
description: Thuật ngữ Capability — khả năng hệ thống, không phụ thuộc agent.
agent: general
---

# Term: Capability

**Definition**: A named, addressable ability of the system, independent of any specific agent.

**Owns**:
- Metadata (id, category, version, owner)

**Does not own**:
- Agent
- Implementation
- State

**Quan hệ**:
- Workflow gọi **capability** (P006), không gọi agent.
- Agent là **implementation** của capability.
- Capability discoverable qua Registry (P007).

**Format**: `<category>.<specific>` — ví dụ `implementation.code`.

**Tham chiếu**: P002, P006, P007.