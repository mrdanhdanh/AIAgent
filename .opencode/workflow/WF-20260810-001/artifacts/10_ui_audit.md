---
name: ui_audit
description: >
  Audit UI/UX cho homepage NEXA X1 (standalone template) — 8 tieu chi: spacing,
  padding, margin, alignment, font, icon, white space, consistency + a11y + responsive.
agent: ui-beautifier
---

# Phase 10 — Kiem tra giao dien (WF-20260810-001)

## 1. 8 tieu chi danh gia (ui-review skill, ap dung cho template HTML)

| Tieu chi | Ket qua | Chi tiet |
|----------|---------|----------|
| Spacing | PASS | Dung spacing scale `--sp-1..7` (4/8/16/24/40/64/96px); gap giua button-input, section-section nhat quan |
| Padding | PASS | Card dung `var(--sp-5) var(--sp-4)` (40/24px) dong nhat; button 12/26px; form 40px; khong padding bat doi xung la |
| Margin | PASS | Section dung `padding: var(--sp-7)` (96px) tao breathing room; khong margin am; hero/sub margin hop ly |
| Alignment | PASS | Grid hero 2 cot can giua `align-items: center`; services-grid 3 cot; icons+label flex; nav items thang hang |
| Font | PASS | Font stack `--font-display`/`--font-body` (Segoe UI system stack); font scale nhat quan 12/14/15/16/18/20/22/26px + clamp(40-72px)/clamp(30-48px) cho h1/h2; khong font-size le kieu 13px tren title quan trong |
| Icon | PASS | 6 SVG icons services dung chung size 34px, stroke 1.6, dong nhat; logo 28px; social 22px; alt/aria-label day du |
| White Space | PASS | Section head cach grid 64px; card noi dung khong day dac; hero co nhieu whitespace quanh copy |
| Consistency | PASS | Cung loai component dung cung style: .btn-accent/.btn-ghost, .card nhat quan, .contact-card nhat quan; neon accent xuyen suot (cyan primary, magenta secondary) |

## 2. Accessibility

| Check | Ket qua |
|-------|---------|
| Semantic tags (header/nav/main/section/footer/h1-h3) | PASS |
| Alt/aria-label cho moi SVG icon | PASS (role="img" + aria-label hoac aria-hidden cho decorative) |
| Contrast (text-1 #aab0d0 vs bg-0 #07070d) | PASS (~9:1 > WCAG AA 4.5:1) |
| Focus-visible outline | PASS (`:focus-visible` cyan + offset 3px) |
| Label ket input (for/id) | PASS (cf-name/cf-email/cf-message) |
| aria-expanded + aria-controls cho hamburger | PASS |
| prefers-reduced-motion | PASS (tat animation + reveal) |

## 3. Responsive

| Breakpoint | Hanh vi |
|-----------|---------|
| >1024px | Hero 2 cot, services 3 cot, contact 2 cot |
| 1024px | Hero 1 cot (visual xuong duoi), services 2 cot |
| 720px | Hamburger nav, services 1 cot, contact 1 cot, stats 2x2, CTA full-width |

## 4. Findings

| Severity | Mo ta | Xu ly |
|----------|-------|-------|
| INFO | `.nav-cta` padding 9px 20px (le khong chia het 4) | Accept — CTA nho hon button chuan de vua nav; khong phai loi |
| INFO | Hamburger `margin: 5px 0` | Accept — can chinh 3 vach CSS doan bang; khong phai loi |

Khong co CRITICAL/MAJOR. Template dung tieu chuan UI/UX cho landing page gaming.

## Output

```yaml
status: PASS
summary: >
  Audit UI thanh cong: 8 tieu chi deu PASS, khong CRITICAL/MAJOR issue. Spacing
  dung scale 4px, font nhat quan, 6 icons dong nhat 34px, white space day du,
  consistency neon theme xuyen suot. A11y day du (semantic, aria, contrast AA,
  focus-visible, reduced-motion). Responsive 3 breakpoints.
phases:
  - Phase 1: 8 tieu chi UI PASS
  - Phase 2: Accessibility PASS
  - Phase 3: Responsive PASS
findings:
  - severity: INFO
    description: nav-cta padding 9px 20px khong thuoc scale 4px
    action: Accept (CTA nho de vua nav)
  - severity: INFO
    description: hamburger margin 5px 0
    action: Accept (can chinh 3 vach CSS)
```
