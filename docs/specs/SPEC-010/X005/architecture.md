---
name: spec-010-x005-architecture
description: SPEC-010 X005 - Plugin Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Plugin Architecture

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin Framework duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Manifest-based, sandboxed, khong sua Core.
- Tach Lifecycle (Plugin Framework) khoi Decision (Policy S012).
- Tach Store khoi Sandbox.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Plugin API (install, validate, enable, disable, uninstall)
     |
[Engine Layer]   Lifecycle Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Validator + Sandbox Enforcer
     |
[Store Layer]    Plugin Store + Manifest Index
     |
[Integration]    Registry (SPEC-005) + Exports (SPEC-003/004) + Events (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Khong dependency vong.

## XA004 - Communication Rules

- Install/Enable: sync (blocking).
- Export: qua Registry (SPEC-005).
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

Plugin, PluginManifest, PluginPermission, PluginExport, PluginSandbox (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Plugin khong sua Core | TERM-015 |
| XAD-002 | Manifest permission | TERM-015 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Sandbox cho plugin | isolation |

## Tham chieu

- S014 Plugin Registry - SPEC-001
- X006 Components - SPEC-010
- S011 Observability - SPEC-001
