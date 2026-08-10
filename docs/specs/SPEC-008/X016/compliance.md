---
name: spec-008-x016-compliance
description: SPEC-008 X016 - Event Compliance. 6 rules, score, certification, checklist.
agent: general
---

# X016 - Event Compliance

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao biet Event Bus tuan thu quy tac?**

## XC001 - Philosophy

- Compliance do duoc (score 0-100).
- Check tu dong (validator + Doctor X019).
- Vi pham -> ghi nhan + action.
- Khong pass gate -> BLOCKED.

## XC002 - Compliance Rules (6)

| Rule | Ten | Requirement | Source |
|------|-----|-------------|--------|
| COMP-001 | Immutable | Khong thay doi sau publish | P010 |
| COMP-002 | Append-Only | Khong xoa Event | P005 |
| COMP-003 | Lineage | Moi Event co lineage | RULE-007 |
| COMP-004 | Observable | Moi thay doi co Event | P005 |
| COMP-005 | Owned | Thuoc mot Execution | S011 |
| COMP-006 | Archived | Archive theo retention | S012 |

## XC003 - Matrix

Moi rule co check trong Doctor X019 + artifact event-*.
Gate: khong pass -> BLOCKED.

## XC004 - Health Score (5 dimensions)

- spec_consistency 30%
- cross_reference_valid 20%
- schema_valid 20%
- completeness 15%
- governance 15%

## XC005 - Report

Scope X001-X020, format markdown + JSON, moi thay doi SPEC-008.
Content: score, violations, evidence, actions.
Tool: spec008-validator.ps1.

## XC006 - Certification

Certified khi: validator PASS + Doctor PASS.
Issued by: Event Team + Governance (S013).

## XC007 - Readiness Checklist

X001-X020 day du, validator PASS 5/5, cross-ref hop le,
schema hop le, Doctor PASS, compliance >= 80%.

## Tham chieu

- X019 Doctor - SPEC-008
- spec008-validator.ps1
- S013 Governance - SPEC-001
