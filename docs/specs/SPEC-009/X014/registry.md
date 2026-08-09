---
name: spec-009-x014-registry
description: SPEC-009 X014 - Contract Registry. Dang ky Contract definition qua SPEC-005.
agent: general
---

# X014 - Contract Registry

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Contract KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime content (o Store).
- Registry resolve, Runtime thuc thi (RB004).
- Contract definition la Entry cua Registry (SPEC-005).

## XR002 - Entry Types (4)

1. **ContractDefinition** - dac ta Contract (schema, metadata).
2. **ContractSchema** - contract.schema.json.
3. **ContractPolicy** - XPOL-* (S012).
4. **ContractStateMachine** - X009 (XSTM-001).

## XR003 - Registry Flow

```text
Declare (SPEC-009 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Contract System goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime Contract content (Store, versioned).
- ContractBinding (runtime object).
- Contract Event (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-009
