---
name: workflow-phase-guardrail
description: Kiem tra guardrail truoc build — khong secret, khong convention violation
agent: guardian
---

# Phase 05 — Guardrail (WF-20260805-001)

## Checks

| # | Check | Ket qua | Ghi chu |
|---|-------|---------|---------|
| 1 | Secret scan (API key, token, password) | PASS | Khong co secret trong plan |
| 2 | Convention FluentUI / DI / tri-state | PASS | Khong sua code C#/Razor |
| 3 | Security (XSS, SQL injection) | PASS | Chi sua static HTML + YAML CI |
| 4 | Code quality (null check, magic value) | PASS | Khong co code moi |
| 5 | File path valid | PASS | `gh-pages-root/index.html`, `.github/workflows/deploy.yml` ton tai |
| 6 | Base href convention | PASS | `/AIAgent/AIHub/` dung pattern nhu `/AIAgent/JapaneseLearner/` |
| 7 | No `&` parallel publish (shell convention) | PASS | Deploy.yml dung bash runner, su dung cau lenh tuan tu |
| 8 | Khong sua source AIHub | PASS | Chi rewrite base href luc deploy |

## Verdict

```yaml
status: "PASS"
checks:
  - "secret_scan: PASS"
  - "convention_check: PASS"
  - "security_scan: PASS"
  - "code_quality: PASS"
  - "file_path_valid: PASS"
  - "base_href_convention: PASS"
  - "shell_convention: PASS"
  - "source_intact: PASS"
```

## Checklist

- [x] 10 checks thuc hien (8 relevant + 2 N/A)
- [x] Khong secret, khong convention violation
- [x] Verdict: PASS
- [x] San sang cho backup + build
