---
name: spec-014-x016-compliance
description: SPEC-014 X016 - Dashboard Compliance. 6 rules, score, certification, checklist.
agent: general
---

# X016 - Dashboard Compliance

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao biet Dashboard tuan thu quy tac?**

## XC001 - Philosophy

- Compliance do duoc (score 0-100).
- Check tu dong (validator + Dashboard X019).
- Vi pham -> ghi nhan + action.
- Khong pass gate -> BLOCKED.

## XC002 - Compliance Rules (6)

| Rule | Ten | Requirement | Source |
|------|-----|-------------|--------|
| COMP-001 | Non-Invasive | Khong sua core | P015 |
| COMP-002 | Safe Repair | Repair doc-only | P015 |
| COMP-003 | Measurable | Moi check co diem | XNF-003 |
| COMP-004 | Observable | Moi thay doi co Event | P005 |
| COMP-005 | Comprehensive | Scan toan bo | XNF-005 |
| COMP-006 | No Auto-Decision | Khong tu quyet dinh | S013 |

## XC003 - Matrix

Moi rule co check trong Dashboard X019 + artifact dashboard-*.
Gate: khong pass -> BLOCKED.

## XC004 - Health Score (5 dimensions)

- spec_consistency 30%
- cross_reference_valid 20%
- schema_valid 20%
- completeness 15%
- governance 15%

## XC005 - Report

Scope X001-X020, format markdown + JSON, moi thay doi SPEC-014.
Content: score, violations, evidence, actions.
Tool: spec014-validator.ps1.

## XC006 - Certification

Certified khi: validator PASS + Dashboard PASS.
Issued by: Dashboard Team + Governance (S013).

## XC007 - Readiness Checklist

X001-X020 day du, validator PASS 5/5, cross-ref hop le,
schema hop le, Dashboard PASS, compliance >= 80%.

## Tham chieu

- X019 Dashboard - SPEC-014
- spec014-validator.ps1
- S013 Governance - SPEC-001
