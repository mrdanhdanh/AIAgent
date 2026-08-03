---
name: glossary-kernel
description: Thuật ngữ Kernel — lõi điều phối của Runtime.
agent: general
---

# Term: Kernel

**Definition**: The core coordination layer of the Runtime: scheduler, state machine, resource manager.

**Owns**:
- scheduler
- state machine
- resource manager
- transaction coordinator

**Does not own**:
- Agent business logic
- Plugin extensions

**Quan hệ**:
- Kernel là lõi của Runtime (P001).
- Mọi task điều phối qua kernel.
- Kernel không phụ thuộc plugin (P010).

**Tham chiếu**: P001, P009, P014.