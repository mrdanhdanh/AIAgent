---
name: spec-006-x004-boundaries
description: SPEC-006 X004 - Context Boundaries. Scope Context, gioi han Business Data.
agent: general
---

# X004 - Context Boundaries

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Context bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Context = metadata Execution (S008).
- KHONG chua Business Data (P001, S011 OB003A).
- Gioi han ro: trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Execution | execution_id, state, phase | - | - |
| Agent | agent_id, role, capability list | - | - |
| Policy | policy refs, quota | policy logic | - |
| Data | metadata key-value | business data | business data |
| Registry | definition refs | runtime entries | - |
| Event | correlation_id, trace_id | event history | - |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |

## XB003 - Scope Rules

1. Vao Context: chi metadata lien quan Execution.
2. Ngoai Context: business data (luu o noi khac).
3. Cam tuyet doi: secret, PII, credential, business data.
4. Mot item vi pham -> Context reject + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Context id | Context Engine | tao/delete |
| Items | Context Engine | guard mutate |
| Grants | Context Engine | cap/thu hoi |
| Events | Runtime (S011) | append-only |

## XB005 - Enforcement

- Populate/Mutate check scope (XFR-009).
- Vi pham -> CONTEXT_REJECTED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- P001 - Constitution
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-006
