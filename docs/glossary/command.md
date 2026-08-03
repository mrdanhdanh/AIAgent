---
name: glossary-command
description: Thuật ngữ Command — lệnh cài sẵn của framework.
agent: general
---

# Term: Command

**Definition**: A built-in, invocable operation provided by the framework.

**Owns**:
- name
- supports (capabilities)

**Does not own**:
- Agent state
- Workflow state

**Quan hệ**:
- Command là entry point cho người dùng/CLI.
- Command map tới capability (P006, P007).
- Command discoverable qua Registry.

**Ví dụ**: `/team`, `/doctor`, `/test-e2e`.

**Tham chiếu**: P006, P007.