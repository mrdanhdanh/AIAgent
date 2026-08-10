---
name: spec-007-x016-compliance
description: SPEC-007 X016 - Artifact Compliance. 6 rules, score, certification, checklist.
agent: general
---

# X016 - Artifact Compliance

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao biet Artifact Manager tuan thu quy tac?**

## XC001 - Philosophy

- Compliance do duoc (score 0-100).
- Check tu dong (validator + Doctor X019).
- Vi pham -> ghi nhan + action.
- Khong pass gate -> BLOCKED.

## XC002 - Compliance Rules (6)

| Rule | Ten | Requirement | Source |
|------|-----|-------------|--------|
| COMP-001 | Immutable | Khong thay doi sau publish | P010 |
| COMP-002 | No Overwrite | Khong bao gio overwrite | TERM-008 |
| COMP-003 | Checksum | Moi Artifact co checksum | P010 |
| COMP-004 | Observable | Moi thay doi co Event | P005 |
| COMP-005 | Owned | Thuoc mot Execution | S008 |
| COMP-006 | Archived | Archive theo retention | S012 |

## XC003 - Matrix

Moi rule co check trong Doctor X019 + artifact artifact-*.
Gate: khong pass -> BLOCKED.

## XC004 - Health Score (5 dimensions)

- spec_consistency 30%
- cross_reference_valid 20%
- schema_valid 20%
- completeness 15%
- governance 15%

## XC005 - Report

Scope X001-X020, format markdown + JSON, moi thay doi SPEC-007.
Content: score, violations, evidence, actions.
Tool: spec007-validator.ps1.

## XC006 - Certification

Certified khi: validator PASS + Doctor PASS.
Issued by: Artifact Team + Governance (S013).

## XC007 - Readiness Checklist

X001-X020 day du, validator PASS 5/5, cross-ref hop le,
schema hop le, Doctor PASS, compliance >= 80%.

## Tham chieu

- X019 Doctor - SPEC-007
- spec007-validator.ps1
- S013 Governance - SPEC-001
