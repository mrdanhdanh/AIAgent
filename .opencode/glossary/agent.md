---
name: glossary-agent
description: Thuật ngữ Agent — runtime execution unit cho một hoặc nhiều capability.
agent: general
---

# Term: Agent

**Definition**: Runtime execution unit responsible for fulfilling one or more capabilities.

**Owns**:
- Metadata (id, name, version, status)

**Does not own**:
- Workflow
- Context
- State

**Quan hệ**:
- Agent thực thi **capability** (P006).
- Agent nhận **context**, trả **artifact**, phát **event**.
- Agent **stateless** (P005) — không giữ state giữa các lần gọi.

**Tham chiếu**: P001, P005, P006, P008.