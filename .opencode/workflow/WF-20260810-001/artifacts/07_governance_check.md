---
name: governance_check
description: >
  Governance gate truoc build cho homepage Gaming Console — naming, lifecycle,
  approval, security, compliance, audit (GOV-001..007).
agent: guardian
---

# Phase 07 — Kiem tra governance truoc build (WF-20260810-001)

## 1. Governance checks (GOV-001..007)

| # | Check | Ket qua | Ghi chu |
|---|-------|---------|---------|
| GOV-001 | Naming convention | PASS | `templates/gaming-console-homepage/` — kebab-case, dung pattern templates/ |
| GOV-002 | Lifecycle / scope | PASS | Tao moi 4 file, khong sua file hien co, khong push git trong pham vi |
| GOV-003 | Approval gate | PASS | Review phase APPROVED (score 8.6, khong MAJOR/CRITICAL) |
| GOV-004 | Security & secrets | PASS | Khong credential, khong network call, khong inline user data |
| GOV-005 | Compliance (license/copyright) | PASS | Noi dung goc tu tao, khong copy asset co ban quyen |
| GOV-006 | Audit trail | PASS | Toan bo quyet dinh ghi trong artifacts 01-06 + state.json checkpoint |
| GOV-007 | Rollback capability | PASS | Khong co file cu bi ghi de (backup NO_CHANGE); neu can xoa, chi can remove thu muc moi |

## 2. Verdict

**PASS** — governance checks day du, khong co vi pham. Cho phep tien hanh build.

## Output

```yaml
status: PASS
checks:
  - GOV-001: naming kebab-case dung pattern templates/
  - GOV-002: lifecycle tao moi 4 file, khong sua file cu
  - GOV-003: approval REVIEW APPROVED
  - GOV-004: khong secret / network call
  - GOV-005: noi dung goc tu tao
  - GOV-006: audit trail day du qua artifacts + state
  - GOV-007: rollback = remove thu muc moi (khong ghi de)
verdict: PASS
```
