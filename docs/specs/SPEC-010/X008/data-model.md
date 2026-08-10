---
name: spec-010-x008-data-model
description: SPEC-010 X008 - Plugin Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Plugin Data Model

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Plugin la extension (TERM-015).
- Plugin khong sua Core (TERM-015) - sandbox.
- Plugin chi chua manifest + exports - KHONG chua Business Data (S011 OB003A).
- Plugin co manifest + permission (TERM-015).

## XD002 - Principles

- **No Core Modify** - khong sua Core (TERM-015).
- **Manifest Based** - moi Plugin co manifest (TERM-015).
- **Permission Scoped** - khong vuot permission (TERM-015).
- **Sandboxed** - chay trong sandbox (XNF-005).
- **Observable** - moi Plugin quan sat qua S011.

## XD003 - Structure (3 lop)

```text
Plugin (AggregateRoot)
  +- PluginDefinition (Entity)
  +- PluginManifest (Entity)
  +- PluginPermission (Value) 1..*
  +- PluginExport (Entity) 0..*
  +- PluginState (Transient)
  +- PluginSandbox (Entity)
  +- PluginSnapshot (Entity) 0..*
  +- refs: ExecutionRef, ProviderRef, CapabilityRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Plugin | AggregateRoot | Plugin Registry | yes |
| ENT-X002 | PluginDefinition | Entity | Plugin Registry | yes |
| ENT-X003 | PluginManifest | Entity | Plugin Registry | yes |
| ENT-X004 | PluginPermission | Value | Plugin Registry | yes |
| ENT-X005 | PluginExport | Entity | Plugin Registry | - |
| ENT-X006 | PluginState | Transient | Plugin Registry | - |
| ENT-X007 | PluginSandbox | Entity | Plugin Registry | - |
| ENT-X008 | PluginEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | PluginMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | PluginSnapshot | Entity | Plugin Registry | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | ProviderRef | Ref (SPEC-004/002) | Agent/Task | yes |
| ENT-X013 | CapabilityRef | Ref (SPEC-003) | Capability | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | PluginExtension | Value | Plugin Registry | yes |

## XD005 - Identity

- plugin_id: UUID (Install sinh ra).
- version: SemVer.
- provider_id: UUID.

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Plugin | PluginDefinition | 1..1 |
| REL-X002 | Plugin | PluginManifest | 1..1 |
| REL-X003 | Plugin | PluginPermission | 1..* |
| REL-X004 | Plugin | PluginExport | 0..* |
| REL-X005 | Plugin | PluginState | 1..1 |
| REL-X006 | Plugin | PluginSandbox | 1..1 |
| REL-X007 | Plugin | ExecutionRef | 1..1 |
| REL-X008 | Plugin | PluginEvent | 0..* |
| REL-X009 | Plugin | PluginSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique PluginId.
2. Khong sua Core.
3. Manifest hop le.
4. Khong vuot permission.
5. Sandbox active.
6. Disable truoc uninstall.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Install, Enable.
- Vi pham -> BLOCK + error PLUGIN_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Manifest store (TERM-015).
- Persistent (plugin definition).
- PluginSnapshot optional (debug/doctor).

## XD010 - Open Questions

- Khi nao snapshot huu ich cho Doctor?
- Sandbox che do mac dinh?

## Tham chieu

- S014 Plugin Registry - SPEC-001
- TERM-015 Plugin
- SPEC-005 Registry
