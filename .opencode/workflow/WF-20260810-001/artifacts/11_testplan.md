---
name: testplan
description: >
  Lap ke hoach test cho homepage Gaming Console NEXA X1 — unit (static), integration
  (smoke E2E qua Playwright), coverage target. Template HTML doc lap.
agent: test-planner
---

# Phase 11 — Lap ke hoach test (WF-20260810-001)

## 1. Pham vi test

Template HTML doc lap tai `templates/gaming-console-homepage/` — khong thuoc app Blazor,
nen test tap trung vao: (a) tinh hop le cau truc, (b) hoat dong chuc nang khi mo browser.

## 2. Test types

| Loai | Cach thuc | Muc dich |
|------|-----------|----------|
| Static / Unit | PowerShell + regex (da lam o static_analysis) | Tinh hop le HTML, CSS, JS, anchor, dependency |
| Integration / Smoke E2E | Playwright mo file `index.html` | Verify 5 chuc nang F1-F5 hoat dong thuc te trong browser |
| Responsive | Playwright viewports | Kiem tra layout mobile/desktop |

## 3. Test cases (smoke E2E, Playwright)

| ID | Tieu de | Steps | Expected |
|----|---------|-------|----------|
| T01 | Trang tai va tieu de dung | goto index.html | title "NEXA X1 — Gaming Console", khong console error |
| T02 | 3 sections hien thi | kiem tra #intro, #services, #contact | ca 3 visible, noi dung chinh (h1, 6 cards, contact info) co mat |
| T03 | Navigation scroll | click "Services" trong nav | scroll toi #services (hash doi) |
| T04 | Services grid | dem .card | 6 cards, moi card co h3 + p + svg icon |
| T05 | Contact form submit | dien 3 field, submit | preventDefault -> khong reload; `location.href` la mailto (mock/kiem tra khong crash) |
| T06 | Mobile nav toggle | viewport 375px, click .nav-toggle | .nav-mobile hien, aria-expanded=true; click link -> menu dong |
| T07 | Responsive services | viewport 375px | .services-grid 1 cot (grid-template-columns khong co 3 cot) |
| T08 | Scroll reveal | IntersectionObserver | sau khi scroll vao view, .reveal co class .in-view |
| T09 | Footer year | doc #year | bang nam hien tai |
| T10 | Khong dependency | audit requests | khong co request external (chi file local) |

## 4. Coverage target

- F1 (Hero/Intro): T01, T02, T03 — high
- F2 (Services): T02, T04 — high
- F3 (Contact): T02, T05 — high
- F4 (Theme/gaming): T01, T02, T07 (visual/consistent) — medium
- F5 (Standalone): T01, T10 — high

Target: tat ca test PASS, 0 CRITICAL issue.

## Output

```yaml
status: PASS
test_types:
  - Static/Unit (HTML/CSS/JS validity)
  - Integration (Playwright smoke E2E — 10 cases T01-T10)
  - Responsive (375/768/1024/1366 viewports)
test_cases:
  - T01: Trang tai, title dung, khong console error
  - T02: 3 sections (intro/services/contact) hien thi day du
  - T03: Navigation smooth scroll toi section dung
  - T04: Services grid 6 cards, moi card co icon+title+desc
  - T05: Contact form submit khong reload, mailto handler
  - T06: Mobile nav toggle (375px) dung aria-expanded
  - T07: Responsive services 1 cot tren mobile
  - T08: Scroll reveal them .in-view
  - T09: Footer year tu dong
  - T10: Khong request external (offline-safe)
coverage_target:
  F1-F5: high
  smoke: 10/10 PASS
```
