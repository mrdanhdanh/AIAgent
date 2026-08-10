---
name: spec-016-x016-compliance
description: SPEC-016 X016 - CLI Compliance. 6 rules, score, certification, checklist.
agent: general
---

# X016 - CLI Compliance

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao biet CLI tuan thu quy tac?**

## XC001 - Philosophy

- Compliance do duoc (score 0-100).
- Check tu dong (validator + CLI X019).
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

Moi rule co check trong CLI X019 + artifact cli-*.
Gate: khong pass -> BLOCKED.

## XC004 - Health Score (5 dimensions)

- spec_consistency 30%
- cross_reference_valid 20%
- schema_valid 20%
- completeness 15%
- governance 15%

## XC005 - Report

Scope X001-X020, format markdown + JSON, moi thay doi SPEC-016.
Content: score, violations, evidence, actions.
Tool: spec012-validator.ps1.

## XC006 - Certification

Certified khi: validator PASS + CLI PASS.
Issued by: CLI Team + Governance (S013).

## XC007 - Readiness Checklist

X001-X020 day du, validator PASS 5/5, cross-ref hop le,
schema hop le, CLI PASS, compliance >= 80%.

## Tham chieu

- X019 CLI - SPEC-016
- spec012-validator.ps1
- S013 Governance - SPEC-001
