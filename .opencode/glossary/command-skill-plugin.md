---
name: glossary-command-skill-plugin
description: Thuật ngữ Command + Skill + Plugin — mở rộng và lệnh.
agent: general
---

# Term: Command

**Definition**: A built-in, invocable operation provided by the framework.

**Owns**:
- name
- supports (capabilities)

# Term: Skill

**Definition**: A reusable body of knowledge/procedure that an agent can employ.

**Owns**:
- knowledge content
- supports (capabilities)

# Term: Plugin

**Definition**: A packaged extension that adds agents, skills, commands, capabilities, and more without modifying core.

**Owns**:
- exports (agents, skills, commands, capabilities, workflows, knowledge, widgets)
- permissions

**Does not own**:
- Core

**Quan hệ**:
- Plugin first (P010) — mở rộng qua plugin, không sửa core.
- Plugin chạy trong sandbox (P014).

**Tham chiếu**: P007, P010, P014.