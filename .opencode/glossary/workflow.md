---
name: glossary-workflow
description: Thuật ngữ Workflow — chuỗi phase có trạng thái.
agent: general
---

# Term: Workflow

**Definition**: An ordered sequence of phases, with runtime state, that orchestrates agents via capabilities.

**Owns**:
- Phases
- State (runtime)
- Metadata (id, version, status)

**Does not own**:
- Agent
- Context (cấp riêng)
- Artifact (output của agent)

**Quan hệ**:
- Workflow → Phase → Task (Object Model).
- Workflow điều phối qua **capability** (P006).
- Workflow state thuộc **Runtime** (P001, P005).

**Tham chiếu**: P001, P006, P009.