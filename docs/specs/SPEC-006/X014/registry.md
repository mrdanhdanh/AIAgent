---
name: spec-006-x014-registry
description: SPEC-006 X014 - Context Registry. Dang ky Context definition qua SPEC-005.
agent: general
---

# X014 - Context Registry

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Context definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Context KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime Context (P009).
- Registry resolve, Runtime thuc thi (RB004).
- Context definition la Entry cua Registry (SPEC-005 R0xx).

## XR002 - Entry Types (4)

1. **ContextDefinition** - dac ta Context (schema, sections).
2. **ContextSchema** - context.schema.json.
3. **ContextPolicy** - XPOL-* (S012).
4. **ContextStateMachine** - X009 (XSTM-001/002).

## XR003 - Registry Flow

```text
Declare (SPEC-006 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Context Engine goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime Context data (transient, in-memory).
- ContextGrant (runtime object).
- Context Event (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-006
