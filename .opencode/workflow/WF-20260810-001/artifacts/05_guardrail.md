---
name: guardrail
description: >
  Kiem tra guardrail truoc build cho homepage Gaming Console — checks convention,
  security, scope, quality. Verdict PASS/WARNING/BLOCKED.
agent: guardian
---

# Phase 05 — Kiem tra guardrail truoc build (WF-20260810-001)

## 1. 10 checks

| # | Check | Ket qua | Ghi chu |
|---|-------|---------|---------|
| G1 | Scope nam trong plan | PASS | Chi tao 4 file trong `templates/gaming-console-homepage/`, khong sua code .NET |
| G2 | Khong cham toi file ngoai pham vi | PASS | Plan chi dinh dung 4 file moi |
| G3 | Khong secret/token trong noi dung | PASS | Noi dung chi la HTML/CSS/JS tinh, khong credential |
| G4 | Khong dependency ngoai (CDN/API) | PASS | Vanilla stack theo design; kiem tra se chay lai sau build |
| G5 | Convention: no-BOM, UTF-8, spaces | PASS | Ghi nhan quy uoc — kiem tra lai sau build |
| G6 | Frontmatter cho file .md | PASS | README.md co frontmatter (name, description, agent) |
| G7 | XSS / inline script nguy hiem | PASS | Khong data user; form mailto khong gui ra network; se grep lai sau build |
| G8 | Security: khong http-injection | PASS | Noi dung tinh, khong SQL/file IO |
| G9 | Kha nang build/test | PASS | Template HTML doc lap — khong can build .NET; kiem tra HTML hop le du |
| G10 | Backup truoc thay doi | PENDING | Se thuc hien o phase backup (khong co file cu de backup — 4 file moi) |

## 2. Verdict

**PASS** — khong co issue BLOCKED/CRITICAL. Plan an toan de thuc thi.

## Output

```yaml
status: PASS
checks:
  - G1: scope trong plan
  - G2: khong cham file ngoai pham vi
  - G3: khong secret
  - G4: khong dependency ngoai
  - G5: convention no-BOM/UTF-8/spaces
  - G6: frontmatter file md
  - G7: khong XSS
  - G8: khong http-injection
  - G9: kha nang build/test
  - G10: backup truoc thay doi (phase backup)
verdict: PASS
```
