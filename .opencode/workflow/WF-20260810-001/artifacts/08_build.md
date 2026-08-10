---
name: build
description: >
  Builder thuc hien tao 4 file cho homepage Gaming Console NEXA X1 tai
  templates/gaming-console-homepage/ theo plan S1-S4. Build pass, cac gate kiem tra OK.
agent: builder
---

# Phase 08 — Thuc thi code (WF-20260810-001)

## 1. File da tao

| # | File | Dung luong | Mo ta |
|---|------|-----------|-------|
| S1 | `templates/gaming-console-homepage/index.html` | 13,873 B | Shell: nav sticky (logo NEXA X1 + 3 link + CTA + hamburger), Hero `#intro` (badge, h1 grad, sub, 2 CTA, 4 stats, SVG console), Services `#services` (6 cards + SVG icon inline), Contact `#contact` (3 contact cards + social + form mailto), Footer. Link `style.css` + `script.js` o cuoi body. |
| S2 | `templates/gaming-console-homepage/style.css` | 11,769 B | Design tokens `:root` (5 colors neon + typography + spacing + effects); component styles C1-C7: nav sticky blur, hero grid + float animation + grid lines + orbs, card hover glow lift, contact cards, form neon focus; scroll reveal (.js .reveal/.in-view); responsive 1024px/720px; prefers-reduced-motion. |
| S3 | `templates/gaming-console-homepage/script.js` | 2,805 B | 4 module: mobile nav toggle (aria-expanded), scroll reveal (IntersectionObserver + fallback), form mailto handler, dynamic year. Vanilla, IIFE strict. |
| S4 | `templates/gaming-console-homepage/README.md` | 3,020 B | Frontmatter (name, description, agent: general), huong dan mo, cau truc file, 3 sections, tuy chinh (ten san pham/theme tokens/them section), ghi chu ky thuat. |

## 2. Gate kiem tra sau build

| Check | Ket qua |
|-------|---------|
| 4/4 file ton tai | PASS |
| 3 section co id anchor: #intro, #services, #contact | PASS |
| `<link rel="stylesheet" href="style.css">` + `<script src="script.js">` dung duong dan tuong doi | PASS |
| Khong dependency ngoai (http/https/cdn/@import) | PASS (chi match la http://localhost:8080 trong README = huong dan server local) |
| HTML tag balance (section/div/nav/header/main/footer/form/ul/li/a/svg/g/span/p/h1-h3) | PASS 122 open = 122 close |
| JS syntax (node --check) | PASS |

## 3. Ghi chu

- Toan bo thay doi la CREATE (4 file moi), khong sua file hien co.
- Theme: dark `#07070d` + neon cyan `#00e5ff` / magenta `#ff2d78` / purple `#7b2dff`.
- Scroll reveal dung progressive enhancement: content chi an khi `html.js` co san
  (reviewer LOW issue da xu ly).

## Output

```yaml
status: PASS
summary: >
  Tao thanh cong 4 file tai templates/gaming-console-homepage/ — homepage NEXA X1
  voi 3 sections (Introduction/Services/Contact). Vanilla stack, offline-safe,
  responsive, khong dependency ngoai. Cac gate kiem tra deu PASS.
changed_files: []
created_files:
  - templates/gaming-console-homepage/index.html
  - templates/gaming-console-homepage/style.css
  - templates/gaming-console-homepage/script.js
  - templates/gaming-console-homepage/README.md
validation:
  - 4 file ton tai
  - 3 section co id anchor
  - link css/js dung
  - khong dependency ngoai
  - HTML tag balance 122/122
  - JS syntax OK
```
