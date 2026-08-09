---
name: SPEC-013-x003-responsibilities
description: SPEC-013 X003 - Evolution Responsibilities. Evolution Engine vs Workflow vs User.
agent: general
---

# X003 - Evolution Responsibilities

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Evolution Engine?**

## XRM001 - Philosophy

- Evolution Engine chiu trach nhiem mo phong workflow.
- Workflow bi mo phong - khong tu chay.
- User dinh nghia Diff.
- Policy (S012) quyet dinh - Evolution thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Evolution | Workflow | User | Policy |
|-------------|------------|----------|------|--------|
| Diffed Diff | OWNER | - | REQUESTER | - |
| Planure | OWNER | - | - | - |
| Run | OWNER | SIMULATED | - | - |
| Observe | OWNER | - | - | - |
| Compare | OWNER | - | - | - |
| Report | OWNER | - | - | - |
| Diff types | SIMULATOR | BOUND | - | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |

## XRM003 - Owner Principles

- Evolution Engine la OWNER cua viec mo phong.
- Workflow la SUBJECT - chi bi mo phong.
- User la REQUESTER - dinh nghia Diff.
- Evolution khong doi he thong that (RULE-007).

## XRM004 - Boundaries

- Evolution: Diffed, Planure, run, observe, compare, report.
- Workflow: bi mo phong.
- User: dinh nghia Diff.
- Registry (SPEC-005): luu definition.

## Tham chieu

- SPEC-002 Workflow
- X004 Boundaries - SPEC-013
- S012 Policy - SPEC-001
