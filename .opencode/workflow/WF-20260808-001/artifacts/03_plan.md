---
name: plan
description: >
  Ke hoach thuc thi chi tiet cho dragon-website template: 6 buoc tao file
  (index.html, style.css, script.js), moi buoc co expected_result.
agent: planner
---

# Phase 03 — Lap ke hoach thuc thi (WF-20260808-001)

## Ke hoach (6 buoc)

| Order | Mo ta | File | Expected result |
|-------|-------|------|-----------------|
| 1 | Tao thu muc `templates/dragon-website/` va index.html: shell semantic (hero + 4 sections), inline SVG dragon group (#head #body #tail #legs), script/style refs | `templates/dragon-website/index.html` | File HTML hop le, dragon SVG co 1 group node `#dragon-group`, co hit-area |
| 2 | Tao style.css: layout fixed dragon-layer, hero 100vh, sections cao, idle fly keyframes, CSS vars (mau rong, toc do), sleep coil + Zzz | `templates/dragon-website/style.css` | CSS co `#dragon-layer { position: fixed }`, `@keyframes fly`, `.dragon-sleep`, `@keyframes zzz` |
| 3 | Tao script.js phan 1: ScrollEngine (scrollY -> p, rAF loop + lerp) va DragonRenderer (catmull-rom waypoints -> transform) | `templates/dragon-website/script.js` | JS parse khong loi; ScrollEngine tinh p tu scrollY; Renderer set transform theo smoothP |
| 4 | Tao script.js phan 2: StateMachine (IDLE/SCROLL/ESCAPE/SLEEP) + EscapeSequence (click -> thoat -> return) | `templates/dragon-website/script.js` | Click dragon -> escape animation 1.4s + return 0.6s; scroll pause trong luc escape; state ve SCROLL |
| 5 | Tao script.js phan 3: SleepSequence (p>0.97 -> coil ve goc phai duoi + Zzz; p<0.90 -> thuc day) | `templates/dragon-website/script.js` | Cuoi trang rong cuon tron goc phai duoi co Zzz; cuon len thi rong thuc day ve path |
| 6 | Kiem tra tong hop: mo template (file://) kiem tra 5 yeu cau F1-F5 + Viet README.md nho | `templates/dragon-website/README.md` | F1-F5 hoat dong; README ghi cach dung + tuy chinh |

## Phu thuoc

- Buoc 1,2 doc lap; buoc 3-5 phu thuoc buoc 1,2 (can DOM + style co san).
- Moi buoc chay xong -> chay `node --check script.js` (neu co node) hoac parse bang JS engine de verify syntax.

## Output

```yaml
status: PASS
steps:
  - order: 1
    description: Tao templates/dragon-website/ + index.html (shell + SVG dragon)
    file: templates/dragon-website/index.html
  - order: 2
    description: Tao style.css (layout, idle fly, sleep, Zzz, CSS vars)
    file: templates/dragon-website/style.css
  - order: 3
    description: Tao script.js (ScrollEngine + DragonRenderer)
    file: templates/dragon-website/script.js
  - order: 4
    description: Tao script.js (StateMachine + EscapeSequence)
    file: templates/dragon-website/script.js
  - order: 5
    description: Tao script.js (SleepSequence)
    file: templates/dragon-website/script.js
  - order: 6
    description: Verify F1-F5 + README.md
    file: templates/dragon-website/README.md
```
