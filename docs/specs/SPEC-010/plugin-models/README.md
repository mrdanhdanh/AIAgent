---
name: spec-010-plugin-models
description: SPEC-010 Appendix - Plugin Canonical Models. 8 AM, Aggregate Root = Plugin.
agent: general
---

# Appendix - Plugin Canonical Models

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Plugin | AggregateRoot | Plugin Registry | yes |
| AM-002 | PluginDefinition | Entity | Plugin Registry | yes |
| AM-003 | PluginManifest | Entity | Plugin Registry | yes |
| AM-004 | PluginPermission | Value | Plugin Registry | yes |
| AM-005 | PluginExport | Entity | Plugin Registry | - |
| AM-006 | PluginState | Transient | Plugin Registry | - |
| AM-007 | PluginSandbox | Entity | Plugin Registry | - |
| AM-008 | PluginReference | Value | Plugin Registry | yes |

`aggregate_root: AM-001 Plugin`

## Relationships

```text
Plugin (AM-001)
  +- PluginDefinition (AM-002)
  +- PluginManifest (AM-003)
  +- PluginPermission (AM-004)
  +- PluginExport (AM-005)
  +- PluginReference (AM-008)
  +- PluginState (AM-006)
  +- PluginSandbox (AM-007)
```

## Validation

- Model co schema (plugin-models.schema.json).
- Immutable model khong doi (TERM-015).
- Aggregate Root doc nhat: Plugin.

## Tham chieu

- S014 Plugin Registry - SPEC-001
- TERM-015 Plugin
