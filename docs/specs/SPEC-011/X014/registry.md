---
name: spec-011-x014-registry
description: SPEC-011 X014 - Doctor Registry. Dang ky Doctor definition qua SPEC-005.
agent: general
---

# X014 - Doctor Registry

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Doctor KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime findings (o Store).
- Registry resolve, Runtime thuc thi (RB004).
- Doctor definition la Entry cua Registry (SPEC-005).

## XR002 - Entry Types (4)

1. **DoctorDefinition** - dac ta Doctor (scanners, pipeline).
2. **ScannerDefinition** - scanner schema.
3. **DoctorPolicy** - XPOL-* (S012).
4. **DoctorStateMachine** - X009 (XSTM-001).

## XR003 - Registry Flow

```text
Declare (SPEC-011 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Doctor goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime findings (Store).
- HealthScore history (Score Store).
- Doctor Event (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-011
