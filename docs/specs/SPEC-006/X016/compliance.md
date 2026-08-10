---
name: spec-006-x016-compliance
description: SPEC-006 X016 - Context Compliance. 6 rules, score, certification, checklist.
agent: general
---

# X016 - Context Compliance

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao biet Context Engine tuan thu quy tac?**

## XC001 - Philosophy

- Compliance do duoc (score 0-100).
- Check tu dong (validator + Doctor X019).
- Vi pham -> ghi nhan + action.
- Khong pass gate -> BLOCKED.

## XC002 - Compliance Rules (6)

| Rule | Ten | Requirement | Source |
|------|-----|-------------|--------|
| COMP-001 | Isolation | Mot Execution mot Context | P006 |
| COMP-002 | No Business Data | Context chi metadata | P001 |
| COMP-003 | Transient | Khong persist | P009 |
| COMP-004 | Observable | Moi thay doi co Event | P005 |
| COMP-005 | Owned | Chi Context Engine tao | EF008 |
| COMP-006 | Released | Release truoc Execution end | EF008 |

## XC003 - Matrix

Moi rule co check trong Doctor X019 + artifact context-*.
Gate: khong pass -> BLOCKED.

## XC004 - Health Score (5 dimensions)

- spec_consistency 30%
- cross_reference_valid 20%
- schema_valid 20%
- completeness 15%
- governance 15%

## XC005 - Report

Scope X001-X020, format markdown + JSON, moi thay doi SPEC-006.
Content: score, violations, evidence, actions.
Tool: spec006-validator.ps1.

## XC006 - Certification

Certified khi: validator PASS + Doctor PASS.
Issued by: Context Team + Governance (S013).

## XC007 - Readiness Checklist

X001-X020 day du, validator PASS 5/5, cross-ref hop le,
schema hop le, Doctor PASS, compliance >= 80%.

## Tham chieu

- X019 Doctor - SPEC-006
- spec006-validator.ps1
- S013 Governance - SPEC-001
