---
name: spec-008-x004-boundaries
description: SPEC-008 X004 - Event Boundaries. Scope Event, Business Data cam.
agent: general
---

# X004 - Event Boundaries

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Event = thong bao bat bien (P010).
- KHONG chua Business Data (P001, S011 OB003A).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | event payload immutable | - | - |
| Metadata | id, type, severity, correlation | - | - |
| Producer | moi thanh phan phat Event | - | - |
| Subscriber | Doctor/Dashboard/Simulation | - | - |
| Policy | retention, quota | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Event Store | append-only log | - | - |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Event: state change + metadata.
2. Ngoai Event: business data (luu noi khac).
3. Cam tuyet doi: secret, PII, business data.
4. Mot item vi pham -> Event reject + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Content | Event Bus | append-only |
| Metadata | Event Bus | immutable |
| Producer | moi thanh phan | phat Event |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc publish (XFR-008).
- Vi pham -> EVENT_REJECTED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- P010 - Constitution
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-008
