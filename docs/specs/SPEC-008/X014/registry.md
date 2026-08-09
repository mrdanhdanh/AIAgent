---
name: spec-008-x014-registry
description: SPEC-008 X014 - Event Registry. Dang ky Event definition qua SPEC-005.
agent: general
---

# X014 - Event Registry

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Event KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime content (o Store).
- Registry resolve, Runtime thuc thi (RB004).
- Event definition la Entry cua Registry (SPEC-005).

## XR002 - Entry Types (4)

1. **EventDefinition** - dac ta Event (schema, metadata).
2. **EventSchema** - event.schema.json.
3. **EventPolicy** - XPOL-* (S012).
4. **EventStateMachine** - X009 (XSTM-001).

## XR003 - Registry Flow

```text
Declare (SPEC-008 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Event Bus goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime Event content (Store, append-only).
- Subscription (runtime object).
- Event log (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-008
