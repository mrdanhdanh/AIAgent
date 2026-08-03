---
name: glossary-memory
description: Thuật ngữ Memory — bộ nhớ ngắn/dài hạn của hệ thống.
agent: general
---

# Term: Memory

**Definition**: Short- and long-term stored state of the system, scoped per working session or workflow.

**Owns**:
- working memory
- session memory
- failure records

**Does not own**:
- Knowledge (tách riêng)
- Agent business logic

**Quan hệ**:
- Context dùng working/cache memory.
- Failure records giúp agent tránh lỗi lặp lại.
- Memory có TTL, namespace theo scope.

**Tham chiếu**: P003, P005, P012.