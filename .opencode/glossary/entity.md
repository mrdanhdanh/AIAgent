---
name: glossary-entity
description: Thuật ngữ Entity — thực thể cơ bản của AIOS.
agent: general
---

# Term: Entity

**Definition**: The base abstraction of AIOS; everything that has an identity and metadata.

**Owns**:
- id
- type
- version
- status
- metadata

**Does not own**:
- Content (artifact riêng)
- State (runtime riêng)

**Quan hệ**:
- Workflow, Agent, Artifact, Capability, Plugin đều là Entity (P003).
- Mọi entity versioned (P009).
- Mọi entity phát event khi state thay đổi (P004).

**Tham chiếu**: P003, P004, P009.