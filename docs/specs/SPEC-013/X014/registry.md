---
name: SPEC-013-x014-registry
description: SPEC-013 X014 - Evolution Registry. Dang ky Evolution definition qua SPEC-005.
agent: general
---

# X014 - Evolution Registry

> **SPEC-013**: Evolution - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Evolution KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime Results (o Store).
- Registry resolve, Runtime thuc thi (RB004).
- Evolution definition la Entry cua Registry (SPEC-005).

## XR002 - Entry Types (4)

1. **EvolutionDefinition** - dac ta Evolution (scanners, pipeline).
2. **ScannerDefinition** - scanner schema.
3. **EvolutionPolicy** - XPOL-* (S012).
4. **EvolutionStateMachine** - X009 (XSTM-001).

## XR003 - Registry Flow

```text
Declare (SPEC-013 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Evolution goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime Results (Store).
- HealthScore history (Result Store).
- Evolution Event (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-013
