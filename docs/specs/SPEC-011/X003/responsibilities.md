---
name: spec-011-x003-responsibilities
description: SPEC-011 X003 - Doctor Responsibilities. Doctor vs System vs Runtime.
agent: general
---

# X003 - Doctor Responsibilities

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Doctor?**

## XRM001 - Philosophy

- Doctor chiu trach nhiem kiem tra suc khoe.
- He thong duoc scan - khong tu sua.
- Runtime cung cap simulation.
- Policy (S012) quyet dinh - Doctor thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Doctor | He thong | Runtime | Policy |
|-------------|--------|----------|---------|--------|
| Scan | OWNER | BOUND | - | - |
| Diagnose | OWNER | - | - | - |
| Score | OWNER | - | - | - |
| Repair | OWNER (doc) | BOUND | - | Scope |
| Report | OWNER | - | - | - |
| Environment | SCANNER | BOUND | - | - |
| Agents | SCANNER | BOUND | - | - |
| Workflow | SCANNER | BOUND | - | - |
| Contracts | SCANNER | BOUND | - | - |
| Simulation | SIMULATOR | - | PROVIDER | - |
| Benchmark | BENCHMARKER | - | - | - |
| Policy | THUC THI | - | - | OWNER |
| Audit | EMITTER | - | Event Store | - |

## XRM003 - Owner Principles

- Doctor la OWNER cua viec kiem tra - khong phai he thong.
- He thong la SUBJECT - chi bi scan.
- Repair chi sua doc - khong sua core (P015).
- Doctor khong tu quyet dinh (S013).

## XRM004 - Boundaries

- Doctor: scan, diagnose, score, repair (doc), report.
- He thong: bi scan.
- Runtime: cung cap simulation.
- Policy (S012): quyet dinh pham vi repair.

## Tham chieu

- /doctor command
- X004 Boundaries - SPEC-011
- S012 Policy - SPEC-001
