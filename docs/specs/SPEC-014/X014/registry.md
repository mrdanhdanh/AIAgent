---
name: spec-014-x014-registry
description: SPEC-014 X014 - Dashboard Registry. Dang ky Dashboard definition qua SPEC-005.
agent: general
---

# X014 - Dashboard Registry

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Dashboard KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime Results (o Store).
- Registry resolve, Runtime thuc thi (RB004).
- Dashboard definition la Entry cua Registry (SPEC-005).

## XR002 - Entry Types (4)

1. **DashboardDefinition** - dac ta Dashboard (scanners, pipeline).
2. **ScannerDefinition** - scanner schema.
3. **DashboardPolicy** - XPOL-* (S012).
4. **DashboardStateMachine** - X009 (XSTM-001).

## XR003 - Registry Flow

```text
Declare (SPEC-014 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Dashboard goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime Results (Store).
- HealthScore history (Result Store).
- Dashboard Event (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-014
