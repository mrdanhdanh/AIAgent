---
name: workflow-phase-static-analysis
description: Kiem tra tinh tinh — frontmatter, link, code block balance, YAML indentation
agent: general
---

# Phase 08 — Static Analysis (WF-20260805-001)

## Checks

| # | Check | File | Ket qua |
|---|-------|------|---------|
| 1 | HTML valid, 2 cards, link dung | `gh-pages-root/index.html` | PASS — 2 `<a class="card">` (`/AIAgent/JapaneseLearner/`, `/AIAgent/AIHub/`) |
| 2 | UTF-8 no BOM | `gh-pages-root/index.html` | PASS — first bytes 60 33 68 (`<!D`) |
| 3 | YAML no tabs | `.github/workflows/deploy.yml` | PASS — 0 tabs |
| 4 | YAML indentation nhat quan | `.github/workflows/deploy.yml` | PASS — steps 8-space, same pattern nhu original |
| 5 | sed base href rewrite | `.github/workflows/deploy.yml` | PASS — 2 sed cho JL + AIHub |
| 6 | Hashed js copy loop | `.github/workflows/deploy.yml` | PASS — 2 loops (JL + AIHub) |
| 7 | Code block balance | N/A | PASS — khong co markdown code block trong file thay doi |
| 8 | Frontmatter | N/A | PASS — khong phai .md file |

## Issues

```yaml
status: "PASS"
issues: []
```

## Checklist

- [x] HTML: 2 cards, valid structure
- [x] No BOM, no tabs
- [x] YAML indentation nhat quan
- [x] sed base href cho ca 2 app
- [x] Hashed js copy cho ca 2 app
- [x] Khong con loi tinh tinh
