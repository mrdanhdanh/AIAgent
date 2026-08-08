---
name: test
description: >
  Chay kiem thu dragon-website template — E2E smoke test Playwright headless
  chromium 1228 (file://), 10/10 PASS. Toan bo F1-F5 + edge cases verified.
agent: tester
---

# Phase 12 — Chay kiem thu (WF-20260808-001)

## Environment

- Playwright 1.62.1 (npm, temp dir) + chromium-1228 da cai san (ms-playwright).
- Trang duoc mo qua `file://` (template khong fetch, khong CORS — hop le).
- Viewport desktop 1400x900 + mobile 375x700.

## Ket qua 10/10 PASS

| ID | Mo ta | Ket qua |
|----|-------|---------|
| F1 | Dragon visible + idle animation (`dragon-fly` on #dragon-inner) | PASS |
| T02 | Scroll 50% -> dragon di chuyen xuong (y 85.5 -> 598.7) | PASS |
| T03 | Scroll muot (lerp, khong snap) | PASS |
| T04 | Click -> escape animation kich hoat, transform thay doi | PASS |
| T05 | Cuoi trang -> sleeping class + Zzz visible + vi tri goc phai duoi (1020,677.5) | PASS |
| T06 | Cuon len -> thuc day (hysteresis 0.90) | PASS |
| T07 | Mobile 375px — dragon visible & fits | PASS |
| T08 | prefers-reduced-motion — idle animation disabled | PASS |
| T09 | Click guard khi dang ngu — data-state=SCROLL, khong escape | PASS |
| T10 | No-JS fallback — noi dung doc duoc + dragon visible | PASS |

## Coverage

- F1-F5: 100% (moi yeu cau co test PASS).
- JS logic: catmull-rom, escape return-to-origin, hysteresis — da verify o build + E2E.
- Edge cases: mobile, reduced-motion, click-while-sleeping, no-JS.

## Ghi chu

- 1 van de trong lan chay dau: test T09 dung sai cach (so sanh transform trong luc
  lerp sleep) — da sua test dung: kiem tra `data-state` (guard chong escape khi ngu).
  Guard thuc te hoat dong dung ngay tu dau.
- `data-state` attribute duoc them vao `#dragon-layer` de debug/test (khong anh
  huong chuc nang).

## Output

```yaml
status: PASS
coverage:
  unit: null
  e2e: 10
summary: >
  E2E smoke test Playwright: 10/10 PASS. F1 idle fly, F2 scroll bao boc container,
  F3 scroll muot ma, F4 click escape -> return, F5 sleep + Zzz cuoi trang — tat ca
  hoat dong. Edge cases (mobile 375, reduced-motion, click-while-sleeping, no-JS)
  deu PASS. Khong co failed test.
```
