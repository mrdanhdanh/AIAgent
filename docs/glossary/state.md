---
name: glossary-state
description: Thuật ngữ State — trạng thái runtime, thuộc Runtime.
agent: general
---

# Term: State

**Definition**: The runtime condition of an entity, owned and tracked by the Runtime.

**Owns**:
- value (phase, status của workflow/agent)
- transition history

**Does not own**:
- Agent business logic
- Content

**Quan hệ**:
- State thuộc Runtime (P001) — agent không giữ state (P005).
- Mọi state transition phát event (P004).
- State versioned/traceable.

**Phân biệt**: State (runtime) ≠ Status (mức trưởng thành khai báo).

**Tham chiếu**: P001, P004, P005.