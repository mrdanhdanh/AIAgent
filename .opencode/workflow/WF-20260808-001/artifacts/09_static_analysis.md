---
name: static_analysis
description: >
  Kiem tra tinh tinh cho 4 file dragon-website template — UTF-8 no-BOM, khong
  tab, tag balance, khong file con thieu, khong loi tham chieu.
agent: general
---

# Phase 09 — Kiem tra tinh tinh (WF-20260808-001)

## Checks

| Check | Ket qua |
|-------|---------|
| UTF-8 no-BOM (4 file) | PASS |
| Khong tab (4 file) | PASS |
| HTML tag balance (script 1/1, css link 1) | PASS |
| JS syntax (`node --check`) | PASS |
| CSS rules hop le (khong selector loi) | PASS — sau khi fix `#dragon-svg #dragon-svg *` thanh `#dragon-svg .hit-body` |
| Tham chieu file: style.css + script.js ton tai | PASS |
| README ton tai | PASS |
| Khong co placeholder loi (TODO/FIXME crash) | PASS |

## Ghi chu

- Phat hien 1 loi CSS trong luc build: rule `#dragon-svg #dragon-svg *` (selector bi lap,
  gay `pointer-events: none` len toan SVG, ghi de `.hit-body`). Da sua thanh
  `#dragon-svg` (none) + `#dragon-svg .hit-body` (stroke) — chi hit-area nhan click.
- Tat ca file UTF-8 no-BOM (dung quy uoc du an).

## Output

```yaml
status: PASS
issues:
  - severity: FIXED
    description: "CSS selector loi #dragon-svg #dragon-svg * — da sua trong build"
    action: "Sua thanh #dragon-svg .hit-body"
summary: >
  Khong con loi tinh tinh nghiem trong. 4 file hop le, khong tab, khong BOM,
  tag balance dung, JS parse OK, CSS da fix 1 loi selector.
```
