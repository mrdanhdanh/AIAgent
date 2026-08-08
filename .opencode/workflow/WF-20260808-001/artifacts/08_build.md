---
name: build
description: >
  Thuc thi code dragon-website template — tao 4 file (index.html, style.css,
  script.js, README.md). Da ap dung LUU-Y-01..04 tu review. Verify: node
  syntax PASS, structural checks PASS, math simulation PASS.
agent: builder
---

# Phase 08 — Thuc thi code (WF-20260808-001)

## File tao moi

| File | Mo ta | Yeu cau |
|------|-------|---------|
| `templates/dragon-website/index.html` | Shell trang + SVG rong inline (dau, than, duoi, chan, gai, hit-area) | F1 (idle fly), F2 (bao boc), F4 (click) |
| `templates/dragon-website/style.css` | Layout + idle fly keyframes + sleep coil + Zzz + content | F1, F5 |
| `templates/dragon-website/script.js` | ScrollEngine + Renderer + StateMachine + Escape + Sleep | F2, F3, F4, F5 |
| `templates/dragon-website/README.md` | Huong dan dung + tuy chinh | — |

## Ap dung luu y review (LUU-Y-01..04)

- **LUU-Y-01** (`#dragon-layer` child truc tiep body): DONE — layer dat ngay trong `<body>`, khong nam trong container co transform. CSS: `position: fixed`.
- **LUU-Y-02** (tach idle vs scroll transform): DONE — `#dragon-outer` (transform scroll/escape/sleep do JS) > `#dragon-inner` (animation `dragon-fly` idle do CSS). 2 node tach biet.
- **LUU-Y-03** (aria-hidden + pointer-events chon loc): DONE — `aria-hidden="true"` tren dragon-layer; SVG `pointer-events: none`, chi `.hit-body` nhan `pointer-events: stroke`.
- **LUU-Y-04** (returnPoint tinh tai finish): DONE — escape tinh `ret` ngay khi click (vi tri hien tai), quay ve chinh xac tai t=1; neu scroll tiep tuc trong luc escape, sau finish state ve SCROLL va tiep tuc path follow.

## Verify

| Kiem tra | Ket qua |
|----------|---------|
| `node --check script.js` | PASS (JS syntax OK) |
| Structural check (ids, refs, hooks, tag balance) | ALL CHECKS PASS |
| pathTransform finite [0,1] | PASS — p=0: (700,198); p=1: (1204,828) goc phai duoi |
| Escape return-to-origin | PASS — t=0 va t=1 deu == ret (sai so 0) |
| Hysteresis ngu/thuc (0.97/0.90) | Da code trong `tick()` |
| No-JS fallback | CSS dat dragon o dau trang, noi dung doc duoc |

## Output

```yaml
status: PASS
summary: >
  Tao hoan chinh 4 file template dragon-website. Toan bo F1-F5 duoc implement
  va verify qua node syntax check + structural check + math simulation.
  Khong co loi build; khong cham toi code .NET/Blazor hien tai.
changed_files: []
created_files:
  - templates/dragon-website/index.html
  - templates/dragon-website/style.css
  - templates/dragon-website/script.js
  - templates/dragon-website/README.md
verification:
  - "node --check script.js: PASS"
  - "structural checks: PASS"
  - "math simulation: PASS (path finite, escape return-to-origin)"
```
