---
name: spec-013-x019-doctor
description: SPEC-013 X019 - Evolution Doctor. 10 checks, scoring, report, health gate.
agent: general
---

# X019 - Evolution Doctor

> **SPEC-013**: Evolution - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao kiem tra suc khoe SPEC-013 va Evolution?**

## XD001 - Philosophy

- Evolution kiem tra Dinh nghia (docs) + Runtime (thuc thi).
- Check tu dong, co diem so (0-100).
- < 80 -> BLOCKED (X016 gate).
- Self-repair an toan: chi sua doc, khong sua core.

## XD002 - Checks (10)

| ID | Check | Method | Priority |
|----|-------|--------|----------|
| XDOC-001 | SPEC.yaml | validator B1 | Critical |
| XDOC-002 | README | validator B2 | Critical |
| XDOC-003 | Sections | validator B3 | Critical |
| XDOC-004 | Schemas | validator B4 | High |
| XDOC-005 | Cross-ref | validator B5 | High |
| XDOC-006 | State Machine | X009 rules | High |
| XDOC-007 | Invariants | X008 rules | Critical |
| XDOC-008 | Policies | X012 rules | High |
| XDOC-009 | Safe Repair | X015 metrics | High |
| XDOC-010 | Events | X011 mapping | High |

## XD003 - Scoring (5 dimensions)

spec_consistency 30% + cross_reference_valid 20% + schema_valid 20%
+ completeness 15% + governance 15%.

Grade: 90-100 Excellent, 80-89 Good, 60-79 Fair, 0-59 Poor.
Gate: < 80 -> BLOCKED.

## XD004 - Report

Format markdown + JSON. Sections: summary, score, checks, violations, evidence, actions.
Tool: spec013-validator.ps1. Output: reports/.

## XD005 - Self-Repair

- Chi sua artifact doc (README bang, typo).
- Khong sua noi dung ky thuat tu dong.
- Moi sua co note + event (S011).

## Tham chieu

- X016 Compliance - SPEC-013
- spec013-validator.ps1
- /Evolution (AI Agent Framework)
- SPEC-001 Runtime Kernel
