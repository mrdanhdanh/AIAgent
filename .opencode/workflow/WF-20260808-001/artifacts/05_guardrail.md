---
name: guardrail
description: >
  Kiem tra guardrail truoc build — secret scan, convention, security, code quality
  cho ke hoach dragon-website template. Verdict: PASS.
agent: guardian
---

# Phase 05 — Guardrail check (WF-20260808-001)

## Checks (ap dung cho ke hoach build 6 buoc)

| # | Check | Ket qua | Ghi chu |
|---|-------|---------|---------|
| 1 | Secrets scan (API keys, tokens, passwords) | PASS | Khong co secret trong plan; template khong dung API |
| 2 | Convention: Frontend (FluentUI/DotNet) | N/A | Template doc lap HTML/CSS/JS, khong lien quan FluentUI — khong vi pham convention .NET hien tai |
| 3 | Convention: file noi dung | PASS | Thu muc moi `templates/dragon-website/` khong sua file co san |
| 4 | Security: XSS / unsafe patterns | PASS | Design: no innerHTML-voi-user-input, no eval, no external CDN |
| 5 | Security: dependency | PASS | Khong dependency ngoai (offline-safe) |
| 6 | Code quality: null checks | PASS | JS se dung optional chaining / guard khi truy cap DOM |
| 7 | Code quality: magic values | PASS | Color/toc do qua CSS vars; waypoints config trong 1 object |
| 8 | Dead code / placeholder | PASS | Template dung placeholder noi dung demo co chu thich |
| 9 | Build feasibility | PASS | Chi tao 4 file moi (index.html, style.css, script.js, README.md) — khong anh huong build .NET |
| 10 | Impact toan bo du an | PASS | Khong sua file .NET/Blazor; thu muc template doc lap; git branch NewVersion (khong push master) |

## Verdict

- **PASS** — khong co CRITICAL/MAJOR issue.
- Luu y 4 yeu cau tu review (LUU-Y-01..04) phai duoc thuc hien trong build.

## Output

```yaml
status: PASS
checks:
  - "1. Secrets: PASS"
  - "2. Convention .NET: N/A (template doc lap)"
  - "3. File convention: PASS"
  - "4. XSS/unsafe: PASS"
  - "5. Dependency: PASS (no external)"
  - "6. Null checks: PASS (guard)"
  - "7. Magic values: PASS (CSS vars + config object)"
  - "8. Dead code: PASS"
  - "9. Build feasibility: PASS"
  - "10. Project impact: PASS (new folder only)"
verdict: PASS
followups:
  - "Thuc hien LUU-Y-01..04 tu review trong build"
```
