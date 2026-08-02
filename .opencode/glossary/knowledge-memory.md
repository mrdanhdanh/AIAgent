---
name: glossary-knowledge-memory
description: Thuật ngữ Knowledge + Memory — kiến thức và bộ nhớ.
agent: general
---

# Term: Knowledge

**Definition**: Persistent, queryable lessons, patterns, and relationships (graph).

**Owns**:
- lessons / patterns
- graph (entities + relations)

**Does not own**:
- Working state
- Agent state

# Term: Memory

**Definition**: Short- and long-term stored state of the system.

**Owns**:
- working memory
- session memory
- failure records

**Does not own**:
- Knowledge (tách riêng)

**Quan hệ**:
- Context dùng working/cache memory.
- Knowledge queryable qua graph/index.

**Tham chiếu**: P003, P005, P012.