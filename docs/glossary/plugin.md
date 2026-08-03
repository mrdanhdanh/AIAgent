---
id: plugin
name: Plugin
status: Draft
category: platform
summary: Extension; không được sửa Core.
definition: >
  Plugin là extension. Plugin không được sửa Core.
purpose: Mở rộng AIOS (agent, capability, widget...) mà không đụng Core.
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
inputs:
  - Plugin manifest
outputs:
  - Exported capability/agent/skill
lifecycle: Installed → Enabled → Disabled → Uninstalled
related:
  - registry
  - capability
  - agent
examples:
  - External Plugin cung cấp capability Code Review
references:
  - P010 Plugin First
  - P014 Least Privilege
---

# Plugin

Plugin là extension.

Plugin không được sửa Core.

## Responsibilities

- Cung cấp extension (capability, agent, skill, widget)
- Khai báo permission trong manifest

## Not Responsible

- Sửa Core
- Truy cập ngoài permission

## Owner

Plugin Registry

## Used By

- Runtime
- Registry

## Input

- Plugin manifest

## Output

- Exported capability/agent/skill
