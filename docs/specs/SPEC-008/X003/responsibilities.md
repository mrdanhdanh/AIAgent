---
name: spec-008-x003-responsibilities
description: SPEC-008 X003 - Event Responsibilities. Event Bus vs Producer vs Subscriber.
agent: general
---

# X003 - Event Responsibilities

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai chiu trach nhiem gi trong Event Bus?**

## XRM001 - Philosophy

- Event Bus chiu trach nhiem Lifecycle Event.
- Producer phat Event - khong quan ly.
- Subscriber nhan Event - khong so huu.
- Policy (S012) quyet dinh - Event Bus thuc thi.

## XRM002 - Responsibility Matrix

| Trach nhiem | Event Bus | Producer | Subscriber | Policy |
|-------------|-----------|----------|------------|--------|
| Publish | OWNER | EMITTER | - | - |
| Route | OWNER | - | - | - |
| Deliver | OWNER | - | RECEIVER | - |
| Subscribe | API | - | REQUESTER | - |
| Unsubscribe | API | - | REQUESTER | - |
| Replay | OWNER | - | - | - |
| Archive | OWNER | - | - | Retention |
| Validate | OWNER | - | - | - |
| Lineage | OWNER | - | - | - |
| Policy | THUC THI | - | - | OWNER |
| Registry | REGISTER | - | - | - |
| Audit | EMITTER | - | - | - |

## XRM003 - Owner Principles

- Event Bus la OWNER duy nhat cua Event.
- Producer la EMITTER - khong so huu sau publish.
- Khong co Owner transfer (P010).
- Event immutable - khong thay doi.

## XRM004 - Boundaries

- Event Bus: publish, route, deliver, replay, archive, audit.
- Producer: phat Event.
- Subscriber: nhan Event.
- Registry (SPEC-005): luu definition.

## Tham chieu

- S011 Event Model - SPEC-001
- X004 Boundaries - SPEC-008
- S012 Policy - SPEC-001
