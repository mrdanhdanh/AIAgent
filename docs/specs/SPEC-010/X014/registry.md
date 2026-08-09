---
name: SPEC-010-x014-registry
description: SPEC-010 X014 - Plugin Registry. Dang ky Plugin definition qua SPEC-005.
agent: general
---

# X014 - Plugin Registry

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Plugin KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime content (o Store).
- Registry resolve, Runtime thuc thi (RB004).
- Plugin definition la Entry cua Registry (SPEC-005).

## XR002 - Entry Types (4)

1. **PluginDefinition** - dac ta Plugin (schema, metadata).
2. **PluginSchema** - Plugin.schema.json.
3. **PluginPolicy** - XPOL-* (S012).
4. **PluginStateMachine** - X009 (XSTM-001).

## XR003 - Registry Flow

```text
Install (SPEC-010 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Plugin Framework goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime Plugin content (Store, versioned).
- PluginExport (runtime object).
- Plugin Event (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-010
