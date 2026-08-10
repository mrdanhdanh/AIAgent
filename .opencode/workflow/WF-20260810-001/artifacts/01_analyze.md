---
name: analyze
description: >
  Phan tich yeu cau tao 1 trang moi: homepage cho Gaming Console voi 3 sections
  introduction, services, contact details. Deliverable: standalone HTML template
  theo pattern templates/ (tuong tu WF-20260808-001 dragon-website).
agent: analyst
---

# Phase 01 — Phan tich yeu cau (WF-20260810-001)

## 1. Yeu cau nguoi dung (raw)

"Tạo 1 trang mới: Design a homepage for a Gaming Console, with sections for introduction, services, and contact details."

## 2. Chuyen yeu cau thanh requirements (F1..F5)

| ID | Mo ta | Do uu tien | Chap nhan duoc? (Definition of Done) |
|----|-------|-----------|----------------------------------------|
| F1 | Hero / Introduction section | Must | Section dau trang gioi thieu console: ten san pham, slogan, mo ta ngan, CTA (Xem san pham / Mua ngay), visual console (SVG/CSS) |
| F2 | Services section | Must | Section 2 gioi thieu cac dich vu/diem noi bat cua console (vd: cloud gaming, game library, multiplayer, parental control...) dang card grid, co icon |
| F3 | Contact details section | Must | Section 3 cung cap thong tin lien he: email, phone, address, social links, co form lien he don gian hoac contact cards |
| F4 | Gaming Console theme | Must | Toan trang dung theme gaming: mau toi + neon accent, typography modern, hieu ung glow/hover, responsive toi thieu |
| F5 | Standalone, offline-safe | Must | Vanilla HTML + CSS + JS, khong dependency ngoai (khong CDN), mo duoc bang double-click |

## 3. Pham vi / Ngoai pham vi

- **Trong pham vi:** 1 template HTML doc lap tai `templates/gaming-console-homepage/` gom
  `index.html`, `style.css`, `script.js` (optional), `README.md`.
- **Ngoai pham vi:** Khong sua code Blazor .NET hien tai; khong dung thu vien ngoai
  (framework CSS, icon lib, fonts CDN); khong tich hop vao route Blazor.

## 4. Rui ro & giai phap

| Rui ro | Anh huong | Giai phap |
|--------|-----------|-----------|
| Theme gaming kieu chu chung/de lam qua | Trung binh | Dung palette toi + neon (electric cyan/magenta), gradient glow, chut texture grid, typography goc canh + display font he thong |
| Form lien he khong co backend -> dead-end | Thap | Form mailto hoac chi hien thi contact cards + social links (khong bat buoc submit thanh cong) |
| Visual console kho ve bang CSS | Trung binh | Ve console bang CSS/SVG don gian (body + controller), dung glow + animation idle |
| Responsive phuc tap | Thap | Grid/flex co breakpoint toi thieu (mobile stacked, desktop grid) |

## 5. Stack ky thuat

- HTML5 semantic + CSS3 (flexbox, grid, keyframes, gradient) + Vanilla JS (scroll reveal, mobile nav).
- Inline SVG cho icons (khong icon font / CDN).
- Khong dependency ngoai -> chay duoc offline, mo bang double-click.

## 6. Kich thuoc / Vi tri file

- Thu muc moi: `templates/gaming-console-homepage/`
  - `index.html` — cau truc trang: nav + hero (intro) + services + contact + footer
  - `style.css` — theme gaming toi + neon, responsive
  - `script.js` — mobile nav toggle, scroll reveal, form mailto handler
  - `README.md` — huong dan dung / tuy chinh

## Output

```yaml
status: PASS
summary: >
  Hieu ro yeu cau: 1 standalone HTML template homepage cho Gaming Console voi 3
  sections (introduction, services, contact details). Stack: vanilla HTML/CSS/JS,
  theme gaming toi + neon, khong dependency ngoai, offline-safe.
requirements:
  - F1: Hero / Introduction section (ten san pham, slogan, CTA, visual console)
  - F2: Services section (card grid cac dich vu/diem noi bat, co icon)
  - F3: Contact details section (email, phone, address, social, form/lien he)
  - F4: Gaming Console theme (toi + neon, glow, typography, responsive toi thieu)
  - F5: Standalone, offline-safe (vanilla, khong CDN, double-click mo duoc)
risks:
  - Theme gaming chung (giai: palette toi + neon glow + texture grid)
  - Form lien he khong backend (giai: mailto + contact cards)
  - Visual console CSS phuc tap (giai: CSS/SVG don gian + glow idle)
```
