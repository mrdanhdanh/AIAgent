---
name: design
description: >
  Thiet ke giai phap: homepage Gaming Console — kien truc layout, component,
  theme system, data flow. Nhan output phase analyze (F1-F5).
agent: planner
---

# Phase 02 — Thiet ke giai phap (WF-20260810-001)

## 1. Kien truc tong the

```
templates/gaming-console-homepage/
├── index.html   — semantic shell: nav + hero(intro) + services + contact + footer
├── style.css    — CSS custom properties (design tokens) + components + responsive
├── script.js    — mobile nav, scroll reveal, form mailto, glow parallax (optional)
└── README.md    — huong dan su dung / tuy chinh
```

Khong dependency ngoai. Tuan thu pattern WF-20260808-001 (standalone template trong `templates/`).

## 2. Component breakdown

| # | Component | Layer | Mo ta | Trach nhiem |
|---|-----------|-------|-------|-------------|
| C1 | StickyNav | UI | Thanh nav dinh top, logo + 4 link (Intro, Services, Contact) + CTA | Scroll to section (smooth), mobile hamburger toggle |
| C2 | HeroIntro | UI | Section 1 (Introduction): badge, title, slogan, description, 2 CTA, visual console SVG | Gioi thieu console, tao an tuong dau tien |
| C3 | ConsoleVisual | UI | SVG/CSS console render voi glow + idle animation | Minh hoa san pham khong can anh ngoai |
| C4 | ServicesGrid | UI | Section 2: 6 cards (icon + title + desc) — cloud gaming, game library, multiplayer, 4K/120fps, parental control, backward compat | Trinh bay dich vu/diem noi bat |
| C5 | ServiceCard | UI | Card con: icon SVG inline, title, description, hover glow effect | Hien thi 1 dich vu |
| C6 | ContactSection | UI | Section 3: contact cards (email/phone/address) + social links + contact form (mailto) | Cung cap thong tin lien he |
| C7 | Footer | UI | Footer: copyright, quick links, socials | Chan trang |

## 3. Design system (theme tokens)

```css
:root {
  /* Colors — gaming dark + neon */
  --bg-0: #07070d;        /* nen chinh */
  --bg-1: #0d0d1a;        /* section alt */
  --surface: #141428;     /* card nen */
  --line: rgba(120, 140, 255, 0.18);
  --neon-cyan: #00e5ff;   /* primary accent */
  --neon-magenta: #ff2d78;/* secondary accent */
  --neon-purple: #7b2dff;
  --text-0: #f2f4ff;      /* text chinh */
  --text-1: #aab0d0;      /* text phu */

  /* Typography */
  --font-display: 'Segoe UI', 'Trebuchet MS', system-ui, sans-serif;
  --font-body: 'Segoe UI', system-ui, -apple-system, sans-serif;

  /* Spacing */
  --sp-1: 4px; --sp-2: 8px; --sp-3: 16px; --sp-4: 24px; --sp-5: 40px; --sp-6: 64px; --sp-7: 96px;

  /* Effects */
  --glow-cyan: 0 0 24px rgba(0,229,255,.35);
  --glow-magenta: 0 0 24px rgba(255,45,120,.35);
  --radius: 14px;
  --max-w: 1200px;
}
```

## 4. Luong du lieu / Interaction

```
[User scroll/click nav] -> smooth scroll den section (scroll-behavior + scrollIntoView)
[Mobile]                -> toggle .nav-open -> hien menu
[Scroll reveal]         -> IntersectionObserver them .in-view -> fade/translate-up
[Form submit]           -> preventDefault -> window.location = mailto:... (subject/body)
```

Không co data persistence — tinh chat tinh (static marketing page).

## 5. Security & accessibility

- Alt text cho moi icon/visual (SVG role="img" + aria-label).
- Semantic tags: header/nav/main/section/footer/h1..h3.
- Contrast: neon accent tren nen toi dam bao WCAG AA (text-1 vs bg-0 >= 4.5:1).
- Focus-visible outline ro rang cho keyboard navigation.
- Form: label ket voi input qua `for`/`id`.
- Khong dung inline event handler nguy hiem; khong luu data nguoi dung.

## 6. Kich thuoc / Vi tri file

| File | Mo ta | Uoc tinh |
|------|-------|---------|
| `templates/gaming-console-homepage/index.html` | Shell + 5 sections + SVG | ~10-12 KB |
| `templates/gaming-console-homepage/style.css` | Tokens + components + responsive | ~8-10 KB |
| `templates/gaming-console-homepage/script.js` | Nav/reveal/mailto | ~2-3 KB |
| `templates/gaming-console-homepage/README.md` | Huong dan | ~1.5 KB |

## Output

```yaml
status: PASS
architecture: >
  Standalone HTML template tai templates/gaming-console-homepage/ — 4 file,
  vanilla stack, design tokens CSS custom properties, 7 components
  (StickyNav, HeroIntro, ConsoleVisual, ServicesGrid, ServiceCard,
  ContactSection, Footer), khong dependency ngoai, offline-safe.
components:
  - C1: StickyNav
  - C2: HeroIntro
  - C3: ConsoleVisual
  - C4: ServicesGrid
  - C5: ServiceCard
  - C6: ContactSection
  - C7: Footer
security_concerns:
  - Khong inline JS nguy hiem, form mailto khong gui data qua network
  - Alt text + aria-label cho icon
  - Focus-visible outline cho keyboard
```
