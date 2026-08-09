---
name: SPEC-016-x002-requirements
description: SPEC-016 X002 - CLI Requirements. 16 FR, 12 NFR, 6 constraints.
agent: general
---

# X002 - CLI Requirements

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI phai lam gi (va khong lam gi)?**

## XR001 - Philosophy

- CLI doc du lieu tu S011 metrics (P005).
- CLI khong thay doi he thong - read-only (XC-001).
- CLI khong tao nguon moi (XC-002).
- CLI khong chua Business Data (S011 OB003A).

## XR002 - Functional Requirements (16)

| ID | Ten | Mo ta | Priority |
|----|-----|-------|----------|
| XFR-001 | Run Command | hien thi widget tu S011 | Critical |
| XFR-002 | Parse Flags | ghep widget thanh panel | Critical |
| XFR-003 | Resolve Alias | tao view theo vai tro | Critical |
| XFR-004 | Show Help | loc theo thoi gian/scope | Critical |
| XFR-005 | Refresh | lam moi dinh ky | High |
| XFR-006 | Export | xuat JSON/markdown | High |
| XFR-007 | Shell Integration | hien thi Health Score (SPEC-011) | High |
| XFR-008 | Parse Args | hien thi event (SPEC-008) | High |
| XFR-009 | Validate Command | chi tiet widget -> metric | Medium |
| XFR-010 | Track CLI | theo doi lifecycle (S011) | High |
| XFR-011 | Publish Events | phat Event moi thay doi | High |
| XFR-012 | Bind Policy | tham so Policy (S012) | High |
| XFR-013 | Register | Registry (SPEC-005) | Medium |
| XFR-014 | CLI Chain | view cha-con | Medium |
| XFR-015 | Manage Lifecycle | create -> archive | Critical |
| XFR-016 | Audit CLI | ghi audit (S011) | High |

## XR003 - Non-Functional Requirements (12)

| ID | Ten | Mo ta | Priority |
|----|-----|-------|----------|
| XNF-001 | Read-Only | khong thay doi he thong | Critical |
| XNF-002 | Metrics Driven | widget doc tu S011 | Critical |
| XNF-003 | No Business Data | chi metadata | Critical |
| XNF-004 | Observable | quan sat qua S011 | High |
| XNF-005 | Responsive | hien thi moi kich thuoc | High |
| XNF-006 | Compatible | backward compatible | High |
| XNF-007 | Recoverable | phuc hoi sau loi | High |
| XNF-008 | Testable | kiem thu tu dong | High |
| XNF-009 | Performant | target render time | High |
| XNF-010 | Governed | chiu Governance (S013) | Critical |
| XNF-011 | Reusable | pattern tai su dung | Medium |
| XNF-012 | Traceable | truy vet (S011) | High |

## XR004 - Constraints (6)

1. XC-001 Read-Only Only (P005).
2. XC-002 No New Data Source (P005).
3. XC-003 No Business Data (P001).
4. XC-004 No Redefine S011.
5. XC-005 No Redefine Policy (S012).
6. XC-006 Archive Before Delete (P011).

## XR005 - Acceptance Criteria

- CLI render duoc widget tu S011 metrics.
- CLI khong thay doi he thong.
- CLI khong tao nguon moi.
- CLI khong chua Business Data.

## Tham chieu

- S011 Metrics - SPEC-001
- P005 Observability First
- SPEC-005 Registry
