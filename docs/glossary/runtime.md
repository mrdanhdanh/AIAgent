---
name: glossary-runtime
description: Thuật ngữ Runtime — trung tâm điều phối.
agent: general
---

# Term: Runtime

**Definition**: The central execution coordinator of AIOS; all execution flows through it.

**Owns**:
- Kernel (scheduler, state machine)
- Workflow state
- Agent lifecycle
- Resource management

**Does not own**:
- Agent business logic
- Artifact content (qua store)
- Knowledge

**Quan hệ**:
- Runtime là trung tâm (P001).
- Agent không tự điều phối agent khác — qua Runtime.
- Context/Artifact/Event truy cập qua Runtime/API (không bypass).

**Tham chiếu**: P001, P009, P011.