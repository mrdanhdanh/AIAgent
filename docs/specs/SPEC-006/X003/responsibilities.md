---
name: spec-006-x003-responsibilities
description: SPEC-006 X003 - Context Responsibilities. Context Engine vs Runtime vs Agent.
agent: general
---

# X003 - Context Responsibilities

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Context Engine?**

## XRM001 - Philosophy

- Context Engine chiu trach nhiem Lifecycle Context.
- Runtime (SPEC-001) chiu trach nhiem Execution.
- Agent/Capability dung Context theo Grant - khong quan ly.
- Policy (S012) quyet dinh - Context Engine thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Context Engine | Runtime | Agent | Policy |
|-------------|---------------|---------|-------|--------|
| Allocate | OWNER | Trigger | - | - |
| Populate | OWNER | - | Cung cap metadata | - |
| Distribute | OWNER | - | Nhan grant | Scope |
| Mutate | Guard | - | OWNER (trong scope) | Scope |
| Merge | OWNER | - | - | - |
| Collect | OWNER | - | - | - |
| Release | OWNER | Trigger (end) | - | - |
| Audit | OWNER | Event store | - | - |
| Policy eval | Thuc thi | - | - | OWNER |

## XRM003 - Owner Principles

- Context Engine la OWNER duy nhat cua Context.
- Agent/Capability chi la GRANTEE (khong so huu).
- Runtime la TRIGGER (khong so huu Context).
- Khong co Owner transfer (P006).

## XRM004 - Boundaries

- Context Engine: tao, cap, thu hoi, guard, audit.
- Agent: doc/ghi trong grant scope.
- Runtime: gan Execution lifecycle.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S010 EF008 - SPEC-001
- X004 Boundaries - SPEC-006
- S012 Policy - SPEC-001
