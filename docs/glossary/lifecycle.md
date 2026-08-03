---
name: glossary-lifecycle
description: Thuật ngữ Lifecycle — vòng đời của entity.
agent: general
---

# Term: Lifecycle

**Definition**: The ordered sequence of statuses an entity moves through over time.

**Owns**:
- status sequence (draft → experimental → stable → deprecated → removed)
- transition rules

**Does not own**:
- Runtime state

**Quan hệ**:
- Mọi entity có lifecycle (P003).
- Lifecycle khai báo; state là runtime (Phân biệt state/status).
- Mỗi transition phát event (P004).

**Tham chiếu**: P003, P004, P009.