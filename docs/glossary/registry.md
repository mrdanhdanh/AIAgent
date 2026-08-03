---
name: glossary-registry
description: Thuật ngữ Registry — nơi đăng ký và khám phá capability/agent/skill/command.
agent: general
---

# Term: Registry

**Definition**: The single source of truth for registered capabilities, agents, skills, and commands.

**Owns**:
- registered entries (capability/agent/skill/command)
- metadata of entries

**Does not own**:
- Workflow state
- Artifact content

**Quan hệ**:
- Registry là nguồn discover (P007).
- Plugin đăng ký exports vào Registry (P010).
- Resolver query Registry để chọn agent.

**Tham chiếu**: P006, P007, P010, P012.