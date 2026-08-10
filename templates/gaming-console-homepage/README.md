---
name: gaming-console-homepage
description: >
  NEXA X1 — homepage template cho Gaming Console voi 3 sections: Introduction
  (hero), Services (6 cards), Contact details (cards + form mailto). Vanilla
  HTML/CSS/JS, offline-safe, khong dependency ngoai.
agent: general
---

# NEXA X1 — Gaming Console Homepage

Homepage template hoan chinh cho mot Gaming Console, duoc tao theo yeu cau
*"Design a homepage for a Gaming Console, with sections for introduction,
services, and contact details."*

## Cach mo

Mo `index.html` bang trinh duyet (double-click) hoac chay server tinh:

```powershell
python -m http.server 8080   # tai thu muc nay
# mo http://localhost:8080
```

## Cau truc file

| File | Vai tro |
|------|---------|
| `index.html` | Shell trang: nav sticky + Hero (Introduction) + Services (6 cards) + Contact (cards + form) + Footer |
| `style.css` | Design tokens (CSS custom properties) + component styles + responsive + scroll reveal |
| `script.js` | Mobile nav toggle, scroll reveal (IntersectionObserver), form mailto, nam tu dong |
| `README.md` | Tai lieu nay |

## 3 Sections chinh

1. **Introduction** (`#intro`) — Hero: badge, tieu de gradient, mo ta san pham,
   2 CTA, 4 stats (TFLOPS/8K/120fps/1TB), visual console SVG co idle float animation.
2. **Services** (`#services`) — 6 card dich vu: Cloud Gaming, Game Library,
   True Multiplayer, 4K·120fps, Family Controls, Backward Compatible — moi card co
   SVG icon inline + hover glow.
3. **Contact details** (`#contact`) — 3 contact cards (email, phone, address),
   social links, va form lien he (mailto handler mo mail client cua user).

## Tuy chinh

### Doi ten san pham / noi dung

Sua truc tiep trong `index.html`:

- Ten console: chu `NEXA X1` / `NEXA` (logo, title, footer).
- Email/phone/address: trong block `#contact` (`support@nexa-gaming.com`,
  `+1 (800) 555-0137`, `2120 Play Circuit...`).
- Cac dich vu: trong `.services-grid`, moi `.card` la 1 dich vu.

### Doi mau sac (theme tokens)

Tat ca mau tap trung o dau `style.css` trong `:root`:

```css
:root {
  --neon-cyan: #00e5ff;      /* accent chinh */
  --neon-magenta: #ff2d78;   /* accent phu */
  --bg-0: #07070d;           /* nen chinh */
  --bg-1: #0d0d1a;           /* nen section alt */
  --surface: #141428;        /* nen card */
}
```

### Them section moi

- Them `<section class="services">` moi trong `<main>` cua `index.html`.
- Neu muon scroll reveal: them class `reveal` cho block dau section.
- Them link vao `.nav-links` (desktop) va `.nav-mobile` (mobile).

## Ghi chu ky thuat

- **Khong dependency ngoai**: khong CDN, khong icon font, khong framework — chay
  offline hoan toan.
- **Accessibility**: semantic tags, `aria-label` cho icon/svg, `:focus-visible`
  outline, label ket input, tuong thich `prefers-reduced-motion`.
- **Responsive**: breakpoint 1024px (2 cot services) va 720px (1 cot + hamburger nav).
- **Progressive enhancement**: content chi an khi co class `js` tren `<html>`;
  neu JS loi, toan bo noi dung van hien thi.
