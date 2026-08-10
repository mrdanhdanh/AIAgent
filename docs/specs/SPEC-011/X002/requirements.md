---
name: spec-011-x002-requirements
description: SPEC-011 X002 - Doctor Requirements. 16 FR, 12 NFR, 6 constraints.
agent: general
---

# X002 - Doctor Requirements

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor phai lam gi (va khong lam gi)?**

## XR001 - Philosophy

- Doctor kiem tra toan bo he sinh thai (SPEC-000..010).
- Doctor cham diem Health Score 0-100.
- Doctor self-repair an toan - chi sua doc (P015).
- Doctor khong tu quyet dinh - chi phat hien + de xuat (S013).

## XR002 - Functional Requirements (16)

| ID | Ten | Mo ta | Priority |
|----|-----|-------|----------|
| XFR-001 | Scan System | quet toan bo he sinh thai | Critical |
| XFR-002 | Diagnose | chan doan loi tu scan | Critical |
| XFR-003 | Score Health | cham diem 0-100 | Critical |
| XFR-004 | Repair Safe | tu sua an toan (doc only) | High |
| XFR-005 | Report | bao cao markdown/JSON | High |
| XFR-006 | Scan Environment | kiem tra moi truong | Critical |
| XFR-007 | Scan Agents | agents (SPEC-004) | High |
| XFR-008 | Scan Commands | commands | High |
| XFR-009 | Scan Skills | skills | High |
| XFR-010 | Scan Knowledge | knowledge base | High |
| XFR-011 | Scan Workflow | workflow (SPEC-002) | High |
| XFR-012 | Scan Contracts | contracts (SPEC-009) | High |
| XFR-013 | Runtime Simulation | gia lap runtime | High |
| XFR-014 | Capability Benchmark | benchmark (SPEC-003) | High |
| XFR-015 | Track Doctor | theo doi lifecycle (S011) | High |
| XFR-016 | Audit Doctor | ghi audit moi lan chay (S011) | High |

## XR003 - Non-Functional Requirements (12)

| ID | Ten | Mo ta | Priority |
|----|-----|-------|----------|
| XNF-001 | Non-Invasive | khong sua core | Critical |
| XNF-002 | Safe Repair | chi sua doc | Critical |
| XNF-003 | Measurable | moi check co diem | Critical |
| XNF-004 | Observable | quan sat qua S011 | High |
| XNF-005 | Comprehensive | scan toan bo | Critical |
| XNF-006 | Compatible | backward compatible | High |
| XNF-007 | Recoverable | phuc hoi sau loi | High |
| XNF-008 | Testable | kiem thu tu dong | High |
| XNF-009 | Performant | target scan time | High |
| XNF-010 | Governed | chiu Governance (S013) | Critical |
| XNF-011 | Reusable | pattern tai su dung | Medium |
| XNF-012 | Traceable | truy vet (S011) | High |

## XR004 - Constraints (6)

1. XC-001 No Core Modify (P015).
2. XC-002 Safe Repair Only (P015).
3. XC-003 No Business Data (P001).
4. XC-004 No Redefine System.
5. XC-005 No Redefine Policy (S012).
6. XC-006 No Auto-Decision (S013).

## XR005 - Acceptance Criteria

- Doctor scan va cham diem duoc toan bo he sinh thai.
- Doctor khong sua duoc core.
- Doctor sinh report day du (markdown/JSON).
- Doctor khong chua Business Data.

## Tham chieu

- SPEC-000..010 (toan bo he sinh thai)
- /doctor command
- S011 Observability
