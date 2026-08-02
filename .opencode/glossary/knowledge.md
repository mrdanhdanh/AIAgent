---
name: glossary-knowledge
description: Thuật ngữ Knowledge — kiến thức bền vững, queryable (lessons/patterns/graph).
agent: general
---

# Term: Knowledge

**Definition**: Persistent, queryable lessons, patterns, and relationships (graph) of the system.

**Owns**:
- lessons
- patterns
- graph (entities + relations)

**Does not own**:
- Working state
- Agent state
- Session data

**Quan hệ**:
- Knowledge queryable qua Knowledge Graph (P012).
- Context truy vấn knowledge khi cần (không scan folder).
- Học từ workflow (learning pipeline).

**Ví dụ**: lesson về cache-first, pattern DI.

**Tham chiếu**: P003, P012.