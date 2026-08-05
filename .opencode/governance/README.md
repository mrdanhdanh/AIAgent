---
name: governance-engine
description: >
  Governance Engine v26.0 — quản trị toàn bộ hệ thống: naming, lifecycle, approval,
  review, security rules, compliance, audit. Enterprise feature cho AIOS.
agent: general
---

# Governance Engine v26.0

## 1. Vai trò

Quản trị AIOS cho nhiều tổ chức — quy tắc bắt buộc + audit.

```text
Governance
├── Naming Rules
├── Lifecycle Rules
├── Approval Rules
├── Review Rules
├── Security Rules
├── Compliance
└── Audit
```

## 2. Bắt buộc

| Đối tượng | Rule |
|-----------|------|
| Agent | phải có metadata đầy đủ |
| Capability | phải có owner |
| Workflow | phải có version |
| Plugin | phải được ký (signed) |
| Prompt | phải có version |
| Artifact | phải có checksum |

## 3. Governance checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | GOV-001 | naming convention (id format) |
| 2 | GOV-002 | lifecycle rules (deprecated phải có replacement) |
| 3 | GOV-003 | approval rules (tác động lớn cần approve) |
| 4 | GOV-004 | review rules (critical code cần review) |
| 5 | GOV-005 | security rules (plugin signed, secret scan) |
| 6 | GOV-006 | compliance (policy đầy đủ) |
| 7 | GOV-007 | audit (mọi hành động log) |

## 4. Tương tác

- `governance.schema.yaml`.
- `audit.md` — audit log.
- `compliance.md` — compliance rules.
- `doctor/` (Phase 8) — governance score.
- `policy/` (Phase 15) — enforce.