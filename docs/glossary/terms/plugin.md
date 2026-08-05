---
id: TERM-015
name: Plugin
version: "1.0"
since: "1.0"
status: Approved
category: Extension
owner: Plugin Registry
stability: Stable
tags: [extension, plugin, modular]
aliases: [Extension, Module]
deprecated_aliases: [Addon]
summary: Extension; không được sửa Core.
definition: >
  Plugin là extension. Plugin không được sửa Core.
purpose: Mở rộng AIOS (agent, capability, widget...) mà không đụng Core.
entity_type: Extension
normative:
  MUST:
    - Provide extension (capability, agent, skill, widget)
    - Khai báo permission trong manifest
  MUST NOT:
    - Modify core
    - Truy cập ngoài permission
responsibilities:
  - Cung cấp extension (capability, agent, skill, widget)
  - Khai báo permission trong manifest
does_not_responsible:
  - Sửa Core
  - Truy cập ngoài permission
owned_by: Plugin Registry
used_by:
  - Runtime
  - Registry
depends_on:
  - TERM-013 Registry
  - TERM-014 Contract
inputs:
  - Plugin manifest
outputs:
  - Exported capability/agent/skill
lifecycle: Installed → Enabled → Disabled → Uninstalled
states: [Installed, Enabled, Disabled, Uninstalled]
invariants:
  - Plugin không được sửa Core.
related:
  - TERM-013
  - TERM-006
  - TERM-005
examples:
  - External Plugin cung cấp capability Code Review
references:
  - P012 Plugin First
  - P016 Human Approval
---

# Plugin

Plugin là extension.

Plugin không được sửa Core.

## Normative

- **MUST** Provide extension.
- **MUST NOT** Modify core.

## Responsibilities

- Cung cấp extension (capability, agent, skill, widget)
- Khai báo permission trong manifest

## Invariant

> Plugin không được sửa Core.
