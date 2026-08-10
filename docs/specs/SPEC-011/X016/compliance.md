---
name: spec-011-x016-compliance
description: SPEC-011 X016 - Doctor Compliance. 6 rules, score, certification, checklist.
agent: general
---

# X016 - Doctor Compliance

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao biet Doctor tuan thu quy tac?**

## XC001 - Philosophy

- Compliance do duoc (score 0-100).
- Check tu dong (validator + Doctor X019).
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

Moi rule co check trong Doctor X019 + artifact doctor-*.
Gate: khong pass -> BLOCKED.

## XC004 - Health Score (5 dimensions)

- spec_consistency 30%
- cross_reference_valid 20%
- schema_valid 20%
- completeness 15%
- governance 15%

## XC005 - Report

Scope X001-X020, format markdown + JSON, moi thay doi SPEC-011.
Content: score, violations, evidence, actions.
Tool: spec011-validator.ps1.

## XC006 - Certification

Certified khi: validator PASS + Doctor PASS.
Issued by: Doctor Team + Governance (S013).

## XC007 - Readiness Checklist

X001-X020 day du, validator PASS 5/5, cross-ref hop le,
schema hop le, Doctor PASS, compliance >= 80%.

## Tham chieu

- X019 Doctor - SPEC-011
- spec011-validator.ps1
- S013 Governance - SPEC-001
