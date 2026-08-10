---
name: spec-012-x004-boundaries
description: SPEC-012 X004 - Simulation Boundaries. Scope Simulation, production ngoai.
agent: general
---

# X004 - Simulation Boundaries

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Simulation = mo phong workflow (RULE-007).
- KHONG doi he thong that (RULE-007).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | scenario + report | - | - |
| Metadata | simulation_id, scenario, timestamp | - | - |
| Workflow | workflow bi mo phong | - | - |
| Result | ket qua simulation | - | - |
| Policy | run scope | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Production | - | production | production change |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Simulation: scenario + config + result + report.
2. Ngoai Simulation: production (o Runtime).
3. Cam tuyet doi: doi production, secret, PII, business data.
4. Mot item vi pham -> Simulation reject + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Report | Simulation Engine | immutable |
| Metadata | Simulation Engine | versioned |
| Workflow | Workflow (SPEC-002) | bi mo phong |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc run (XFR-002).
- Vi pham -> SIMULATION_REJECTED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- RULE-007 - Rules
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-012
