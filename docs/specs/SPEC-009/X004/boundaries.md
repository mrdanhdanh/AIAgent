---
name: spec-009-x004-boundaries
description: SPEC-009 X004 - Contract Boundaries. Scope Contract, implementation ngoai.
agent: general
---

# X004 - Contract Boundaries

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Contract = interface input/output (TERM-014).
- KHONG chua implementation (TERM-014).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | input/output interface | - | - |
| Metadata | contract_id, version, provider | - | - |
| Provider | thanh phan khai bao | - | - |
| Caller | thanh phan goi qua Contract | - | - |
| Policy | retention, compat | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Implementation | - | implementation | implementation |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Contract: input/output + metadata.
2. Ngoai Contract: implementation (o thanh phan khac).
3. Cam tuyet doi: implementation, secret, PII, business data.
4. Mot item vi pham -> Contract reject + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Interface | Contract Registry | immutable |
| Metadata | Contract Registry | versioned |
| Provider | thanh phan khai bao | declare |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc publish (XFR-002).
- Vi pham -> CONTRACT_REJECTED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- TERM-014 - Glossary
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-009
