---
name: spec-010-x003-responsibilities
description: SPEC-010 X003 - Plugin Responsibilities. Plugin Framework vs Plugin vs Exported.
agent: general
---

# X003 - Plugin Responsibilities

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Plugin Framework?**

## XRM001 - Philosophy

- Plugin Framework chiu trach nhiem Lifecycle Plugin.
- Plugin export - khong quan ly.
- Capability/Agent System nhan export - khong so huu Plugin.
- Policy (S012) quyet dinh - Plugin Framework thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Plugin Framework | Plugin | Exported | Policy |
|-------------|----------------|--------|----------|--------|
| Install | OWNER | MANIFEST | - | - |
| Validate | OWNER | - | - | - |
| Enable | OWNER | - | - | - |
| Disable | OWNER | - | - | - |
| Uninstall | OWNER | - | - | - |
| Export | API | EXPORTER | RECEIVER | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Sandbox | ENFORCER | BOUND | - | - |
| Audit | EMITTER | - | - | - |
| No-Core-Modify | ENFORCER | BOUND | - | - |

## XRM003 - Owner Principles

- Plugin Registry la OWNER duy nhat cua Plugin (TERM-015).
- Plugin la EXPORTER - khong so huu sau install.
- Khong co Owner transfer (TERM-015).
- Plugin khong sua Core - sandbox enforce.

## XRM004 - Boundaries

- Plugin Framework: install, validate, enable, disable, uninstall.
- Plugin: export capability/agent/skill/widget.
- Capability/Agent System: nhan export.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S014 Plugin Registry - SPEC-001
- X004 Boundaries - SPEC-010
- S012 Policy - SPEC-001
