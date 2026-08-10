---
name: plan
description: >
  Lap ke hoach thuc thi chi tiet cho homepage Gaming Console — 4 buoc tao file,
  moi buoc co expected_result. Nhan output phase design.
agent: planner
---

# Phase 03 — Lap ke hoach thuc thi (WF-20260810-001)

## 1. Ke hoach tong the

Tao 4 file moi tai `templates/gaming-console-homepage/`, khong sua code hien co,
khong chay build .NET (template HTML doc lap). Kiem tra cuoi bang mo file HTML.

## 2. Cac buoc thuc thi

| # | Buoc | File | Mo ta chi tiet | expected_result |
|---|------|------|----------------|-----------------|
| S1 | Tao shell HTML | `templates/gaming-console-homepage/index.html` | Semantic shell: `<head>` (meta, title, link css), StickyNav (logo NEXA/console brand, 4 link, CTA, hamburger), `<main>`: HeroIntro (badge, h1, p, 2 CTA, ConsoleVisual SVG), ServicesGrid (6 ServiceCard voi SVG icon inline), ContactSection (3 contact cards + social links + form mailto), Footer. Ket noi `style.css` + `script.js` o cuoi body. | HTML hop le, 5 sections ro rang, link den css/js dung duong dan tuong doi |
| S2 | Tao stylesheet | `templates/gaming-console-homepage/style.css` | Design tokens `:root` theo design phase; layout flex/grid; component styles: nav sticky blur, hero gradient text + glow, console visual idle animation, service card hover glow lift, contact cards, form inputs neon focus; scroll reveal classes (.reveal/.in-view); responsive breakpoints (mobile <720px hamburger, tablet <1024px). | CSS day du cho moi component C1-C7, responsive toi thieu, khong loi syntax |
| S3 | Tao script | `templates/gaming-console-homepage/script.js` | Mobile nav toggle (aria-expanded), smooth scroll cho anchor (neu can polyfill nhe), IntersectionObserver scroll reveal, form submit -> mailto handler, nam hien tai o footer. | JS chay khong loi, khong dependency ngoai |
| S4 | Tao README | `templates/gaming-console-homepage/README.md` | Frontmatter (name, description, agent), gioi thieu, cach mo, cau truc file, tuy chinh theme tokens, section layout. | README day du, dung quy uoc file .md (frontmatter) |

## 3. Kiem tra sau build (gate)

1. Kiem tra file ton tai: 4/4.
2. Grep cac the section: hero(hero/introduction), services, contact — co id anchor tuong ung.
3. Grep `<link rel="stylesheet"` + `<script src` — duong dan khong bi loi.
4. Kiem tra no-dependency: khong chua `https://`, `cdn`, `@import url(` ngoai.
5. Mo file bang playwright/headless neu co the; toi thieu kiem tra tinh hop le HTML.

## Output

```yaml
status: PASS
steps:
  - order: 1
    description: Tao templates/gaming-console-homepage/index.html (shell + 5 sections + SVG console)
    file: templates/gaming-console-homepage/index.html
  - order: 2
    description: Tao templates/gaming-console-homepage/style.css (tokens + components + responsive)
    file: templates/gaming-console-homepage/style.css
  - order: 3
    description: Tao templates/gaming-console-homepage/script.js (nav toggle, scroll reveal, mailto)
    file: templates/gaming-console-homepage/script.js
  - order: 4
    description: Tao templates/gaming-console-homepage/README.md (huong dan dung)
    file: templates/gaming-console-homepage/README.md
validation:
  - Kiem tra 4 file ton tai
  - Kiem tra 3 section co id anchor
  - Kiem tra khong dependency ngoai
  - Kiem tra HTML hop le + CSS/JS load
```
