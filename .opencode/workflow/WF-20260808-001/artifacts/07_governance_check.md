---
name: governance_check
description: >
  Governance gate truoc build — naming, lifecycle, approval, security, compliance,
  audit cho dragon-website template. Verdict: PASS.
agent: guardian
---

# Phase 07 — Governance check (WF-20260808-001)

## Checks GOV-001..007

| # | Check | Ket qua | Ghi chu |
|---|-------|---------|---------|
| GOV-001 | Naming convention (file/component snake_case) | PASS | `templates/dragon-website/` + index.html/style.css/script.js dung chuan web standard |
| GOV-002 | Lifecycle: tao moi chi o thu muc moi, khong dung cham scope | PASS | Khong sua file .NET; thu muc template doc lap |
| GOV-003 | Approval: workflow da qua review (Phase 04 APPROVED) + guardrail PASS (Phase 05) | PASS | Decision APPROVED, verdict PASS |
| GOV-004 | Security: khong secret, khong eval, khong innerHTML-user-input, no external dep | PASS | Da xac nhan o Phase 05 |
| GOV-005 | Compliance: code base (.NET Blazor) khong bi anh huong | PASS | Thu muc moi, khong cham Program.cs / service / pages |
| GOV-006 | Audit trail: moi phase co artifact + state.json checkpoint | PASS | 01-06 artifacts da luu, state.json da cap nhat tung phase |
| GOV-007 | Backup/rollback: backup manifest tao o Phase 06; rollback = xoa thu muc moi | PASS | Co snapshot diem build |

## Verdict

- **PASS** — 7/7 checks PASS. Du dieu kien de tien hanh build.

## Output

```yaml
status: PASS
checks:
  - "GOV-001 naming: PASS"
  - "GOV-002 lifecycle: PASS"
  - "GOV-003 approval: PASS (review APPROVED + guardrail PASS)"
  - "GOV-004 security: PASS"
  - "GOV-005 compliance: PASS (khong cham .NET)"
  - "GOV-006 audit: PASS (artifacts + state)"
  - "GOV-007 backup: PASS (manifest WF-20260808-001)"
verdict: PASS
```
