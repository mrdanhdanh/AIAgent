---
name: glossary-plugin
description: Thuật ngữ Plugin — gói mở rộng, không sửa core.
agent: general
---

# Term: Plugin

**Definition**: A packaged extension that adds agents, skills, commands, capabilities, workflows, and more, without modifying core.

**Owns**:
- exports (agents, skills, commands, capabilities, workflows, knowledge, widgets)
- permissions (khai báo)
- manifest

**Does not own**:
- Core
- Runtime internals

**Quan hệ**:
- Plugin First (P010) — mở rộng qua plugin, không sửa core.
- Plugin chạy trong sandbox theo permission (P014).
- Plugin phải certified trước enable.
- Plugin đăng ký exports vào Registry (P007).

**Tham chiếu**: P007, P010, P014.