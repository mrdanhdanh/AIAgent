---
name: spec-012-x003-responsibilities
description: SPEC-012 X003 - Simulation Responsibilities. Simulation Engine vs Workflow vs User.
agent: general
---

# X003 - Simulation Responsibilities

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Simulation Engine?**

## XRM001 - Philosophy

- Simulation Engine chiu trach nhiem mo phong workflow.
- Workflow bi mo phong - khong tu chay.
- User dinh nghia scenario.
- Policy (S012) quyet dinh - Simulation thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Simulation | Workflow | User | Policy |
|-------------|------------|----------|------|--------|
| Define Scenario | OWNER | - | REQUESTER | - |
| Configure | OWNER | - | - | - |
| Run | OWNER | SIMULATED | - | - |
| Observe | OWNER | - | - | - |
| Compare | OWNER | - | - | - |
| Report | OWNER | - | - | - |
| Scenario types | SIMULATOR | BOUND | - | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |

## XRM003 - Owner Principles

- Simulation Engine la OWNER cua viec mo phong.
- Workflow la SUBJECT - chi bi mo phong.
- User la REQUESTER - dinh nghia scenario.
- Simulation khong doi he thong that (RULE-007).

## XRM004 - Boundaries

- Simulation: define, configure, run, observe, compare, report.
- Workflow: bi mo phong.
- User: dinh nghia scenario.
- Registry (SPEC-005): luu definition.

## Tham chieu

- SPEC-002 Workflow
- X004 Boundaries - SPEC-012
- S012 Policy - SPEC-001
