---
name: spec-007-x003-responsibilities
description: SPEC-007 X003 - Artifact Responsibilities. Artifact Store vs Agent vs Runtime.
agent: general
---

# X003 - Artifact Responsibilities

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Artifact Manager?**

## XRM001 - Philosophy

- Artifact Store chiu trach nhiem Lifecycle Artifact.
- Agent/Task la PRODUCER - tao output, khong quan ly.
- Agent/Doctor/Dashboard la CONSUMER - doc theo API.
- Policy (S012) quyet dinh - Artifact Store thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Artifact Store | Agent/Task | Runtime | Policy |
|-------------|---------------|-----------|---------|--------|
| Create | OWNER | Produce | - | - |
| Validate | OWNER | - | - | - |
| Checksum | OWNER | - | - | - |
| Publish | OWNER | - | - | - |
| Version | OWNER | - | - | - |
| Index | OWNER | - | - | - |
| Consume | API | - | - | - |
| Archive | OWNER | - | - | Retention |
| Events | EMITTER | - | Event Store | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | Event Store | - |

## XRM003 - Owner Principles

- Artifact Store la OWNER duy nhat cua Artifact.
- Agent la PRODUCER - khong so huu sau publish.
- Khong co Owner transfer (P010).
- Content immutable - chi version moi thay doi.

## XRM004 - Boundaries

- Artifact Store: tao, publish, version, index, archive, audit.
- Agent: produce + consume.
- Runtime: gan Execution lifecycle.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S008 ENT-008 - SPEC-001
- X004 Boundaries - SPEC-007
- S012 Policy - SPEC-001
