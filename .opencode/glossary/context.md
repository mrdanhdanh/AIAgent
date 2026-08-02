---
name: glossary-context
description: Thuật ngữ Context — package dữ liệu cấp cho agent trước khi chạy.
agent: general
---

# Term: Context

**Definition**: A scoped data package delivered to an agent before execution, containing only what the agent needs.

**Owns**:
- package (project/task/artifacts refs/knowledge)
- budget (token limit)

**Does not own**:
- Agent state
- Artifact content (chỉ ref)
- Workflow state

**Quan hệ**:
- Runtime cấp context cho agent qua **Context Engine**.
- Agent chỉ nhận context package (P001) — không tự đọc project.
- Context có budget; vượt → nén/loại context ít giá trị.

**Tham chiếu**: P001, P002, P005.