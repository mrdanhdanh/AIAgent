---
name: spec-009-x016-compliance
description: SPEC-009 X016 - Contract Compliance. 6 rules, score, certification, checklist.
agent: general
---

# X016 - Contract Compliance

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao biet Contract System tuan thu quy tac?**

## XC001 - Philosophy

- Compliance do duoc (score 0-100).
- Check tu dong (validator + Doctor X019).
- Vi pham -> ghi nhan + action.
- Khong pass gate -> BLOCKED.

## XC002 - Compliance Rules (6)

| Rule | Ten | Requirement | Source |
|------|-----|-------------|--------|
| COMP-001 | Interface Only | Khong chua implementation | TERM-014 |
| COMP-002 | No Direct Call | Goi qua Contract | TERM-014 |
| COMP-003 | Versioned | Moi Contract co version | P004 |
| COMP-004 | Observable | Moi thay doi co Event | P005 |
| COMP-005 | Compatible | Backward compatible | S007 |
| COMP-006 | Retired | Retire theo retention | S012 |

## XC003 - Matrix

Moi rule co check trong Doctor X019 + artifact contract-*.
Gate: khong pass -> BLOCKED.

## XC004 - Health Score (5 dimensions)

- spec_consistency 30%
- cross_reference_valid 20%
- schema_valid 20%
- completeness 15%
- governance 15%

## XC005 - Report

Scope X001-X020, format markdown + JSON, moi thay doi SPEC-009.
Content: score, violations, evidence, actions.
Tool: spec009-validator.ps1.

## XC006 - Certification

Certified khi: validator PASS + Doctor PASS.
Issued by: Contract Team + Governance (S013).

## XC007 - Readiness Checklist

X001-X020 day du, validator PASS 5/5, cross-ref hop le,
schema hop le, Doctor PASS, compliance >= 80%.

## Tham chieu

- X019 Doctor - SPEC-009
- spec009-validator.ps1
- S013 Governance - SPEC-001
