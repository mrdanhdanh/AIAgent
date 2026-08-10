---
name: test
description: >
  Tester chay smoke E2E (Playwright + MS Edge channel) cho homepage NEXA X1 —
  10/10 PASS, 0 console error. Khong can build .NET (template doc lap).
agent: tester
---

# Phase 12 — Chay kiem thu (WF-20260810-001)

## 1. Moi truong test

- **Playwright core 1.62.1** + channel `msedge` (khong can download browser moi).
- File: `templates/gaming-console-homepage/index.html` (file:// URL).
- Script: temp `pw-smoke/smoke-test.js`.

## 2. Ket qua 10 test cases

| ID | Tieu de | Ket qua | Chi tiet |
|----|---------|---------|----------|
| T01 | Trang tai, title dung | PASS | title = "NEXA X1 — Gaming Console" |
| T02 | 3 sections hien thi | PASS | #intro/#services/#contact visible, h1 = "Play Beyond Reality" |
| T03 | Nav scroll | PASS | click Services -> hash=#services |
| T04 | Services grid | PASS | 6 cards, moi card co h3+p+svg |
| T05 | Form submit -> mailto, khong reload | PASS | mailto=true reloaded=false |
| T06 | Mobile nav toggle (375px) | PASS | .nav-mobile open, aria-expanded=true |
| T07 | Responsive services 1 cot | PASS | grid-template-columns 1 cot tren mobile |
| T08 | Scroll reveal | PASS | .in-view duoc them khi scroll (2/10 ban dau hien, phan con lai theo scroll) |
| T09 | Footer year | PASS | #year = 2026 |
| T10 | Khong external request khi load | PASS | 0 external request (offline-safe) |

**Result: 10/10 PASS, 0 failed, 0 console error.**

## 3. Ghi chu dieu tra

- Lan chay dau 8/10: T05/T10 fail do **test script sai**, khong phai bug code:
  - T05: headless khong co mail client -> `location.href` khong doi; fix = check mailto request event (mailto=true).
  - T10: external request duy nhat la `mailto:` tu T05 chay truoc; fix = reload sach roi check.
- Sau fix: 10/10 PASS. Code template khong can sua.

## 4. Coverage

- F1 (Hero/Intro): T01, T02, T03 — PASS
- F2 (Services): T02, T04 — PASS
- F3 (Contact): T02, T05 — PASS
- F4 (Theme/gaming): T01, T02, T07 — PASS
- F5 (Standalone): T01, T10 — PASS

## Output

```yaml
status: PASS
summary: >
  Smoke E2E 10/10 PASS qua Playwright + MS Edge. Khong console error. 5 requirements
  F1-F5 deu duoc verify. Template offline-safe (0 external request), form mailto hoat
  dong dung, responsive dung, scroll reveal hoat dong.
coverage:
  unit: 0 (template HTML, khong co unit test .NET)
  smoke_e2e: "10/10 PASS"
  console_errors: 0
test_cases:
  - T01: PASS - title dung
  - T02: PASS - 3 sections
  - T03: PASS - nav scroll
  - T04: PASS - 6 cards
  - T05: PASS - form mailto
  - T06: PASS - mobile nav
  - T07: PASS - responsive 1 cot
  - T08: PASS - scroll reveal
  - T09: PASS - footer year
  - T10: PASS - offline-safe
```
