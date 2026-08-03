---
name: glossary-metadata
description: Thuật ngữ Metadata — thông tin quản lý của entity.
agent: general
---

# Term: Metadata

**Definition**: Structured information describing an entity; the machine-readable identity of things.

**Owns**:
- id, type, version, status
- owner, tags, created_at, updated_at

**Does not own**:
- Content (artifact content)
- Runtime state

**Quan hệ**:
- Mọi object có metadata (P003).
- Metadata là nguồn cho resolver/scheduler/doctor/dashboard.
- Metadata machine readable (P014).

**Tham chiếu**: P003, P014.