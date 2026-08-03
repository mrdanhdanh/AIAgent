---
name: glossary-event
description: Thuật ngữ Event — thông báo bất biến, có lineage.
agent: general
---

# Term: Event

**Definition**: An immutable notification of a state change, with lineage.

**Owns**:
- payload
- lineage (parent_event, correlation_id)
- timestamp

**Does not own**:
- State (chỉ mô tả thay đổi)
- Artifact content

**Quan hệ**:
- Mọi state change phát event (P004).
- Event immutable, là nguồn sự thật (P012).
- Event dùng cho observability/replay/simulation.

**Format**: `UPPER_SNAKE` — ví dụ `WORKFLOW_STARTED`.

**Tham chiếu**: P004, P008, P012.