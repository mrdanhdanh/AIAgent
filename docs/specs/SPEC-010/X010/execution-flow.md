---
name: spec-010-x010-execution-flow
description: SPEC-010 X010 - Plugin Execution Flow. 7 stages TERM-015, failure, lineage.
agent: general
---

# X010 - Plugin Execution Flow

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin chay nhu the nao trong Runtime?**

## XF001 - Flow Philosophy

- Plugin chay nhu Execution cua Runtime (SPEC-001).
- Plugin Framework thuc thi TERM-015 - khong dinh nghia lai flow.
- Khong buoc nao thieu Event (S011).
- Plugin khong sua Core (TERM-015).

## XF002 - Flow Principles

- **TERM-015** - Install -> Validate -> Sandbox -> Enable -> Export -> Disable -> Uninstall.
- **Validate truoc khi enable** (XFR-002).
- **Permission scoped** - khong vuot (TERM-015).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (7)

```text
Install -> Validate -> Sandbox -> Enable -> Export -> Disable -> Uninstall
```

(TERM-015 - Plugin Framework thuc thi)

## XF004 - Canonical Plugin Flow

```text
Plugin manifest
  -> Install (plugin_id sinh) [PLUGIN_INSTALLED]
  -> Validate (schema + permission) [PLUGIN_VALIDATING]
  -> Sandbox (isolation) [PLUGIN_SANDBOXED]
  -> Enable (export san sang) [PLUGIN_ENABLED]
  -> Export (capability/agent/skill/widget) [PLUGIN_EXPORTED]
Can tat
  -> Disable [PLUGIN_DISABLED]
Het dung
  -> Uninstall [PLUGIN_UNINSTALLED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Install | Plugin Framework | manifest | Plugin | PLUGIN_INSTALLED |
| Validate | Plugin Framework | manifest | Validated | PLUGIN_VALIDATING |
| Sandbox | SandboxEnforcer | plugin | Sandbox | PLUGIN_SANDBOXED |
| Enable | Plugin Framework | validated | Enabled Plugin | PLUGIN_ENABLED |
| Export | ExportManager | plugin | Exports | PLUGIN_EXPORTED |
| Disable | Plugin Framework | - | Disabled | PLUGIN_DISABLED |
| Uninstall | Uninstaller | - | Uninstalled | PLUGIN_UNINSTALLED |

## XF006 - Failure Modes

- Install fail -> khong tao Plugin + error.
- Validate fail -> PLUGIN_REJECTED + cleanup.
- Sandbox fail -> khong enable + event.
- Enable fail -> retry (S012).
- Export fail -> giu Plugin, retry.
- Disable fail -> giu Plugin, retry.
- Uninstall fail -> giu Plugin, retry.

## XF007 - Lineage

- Root Plugin: parent = null.
- Chain Plugin: parent = plugin_id truoc (dependency).

## XF008 - Query Ops

GetPlugin / GetManifest / SearchPlugins / ListExports / GetHistory.
Query khong can grant, khong thay doi Plugin.

## XF009 - Storage

- Manifest store (TERM-015), persistent.
- Quota theo policy (X012).
- Snapshot optional cho Doctor.

## XF010 - Validation

- Stage order dung TERM-015.
- Moi stage co event.
- Khong Core modify (Doctor X019).

## Tham chieu

- S014 Plugin Registry - SPEC-001
- TERM-015 Plugin
- S012 Policies - SPEC-001
