---
name: testplan
description: >
  Lap ke hoach test cho dragon-website template — chia 2 lop: unit/logic test
  (Node, khong can browser) va E2E smoke test (Playwright tai cac viewport).
  Ghi chu: template HTML doc lap, khong thuoc du an .NET — khong chay dotnet test.
agent: test-planner
---

# Phase 11 — Lap ke hoach test (WF-20260808-001)

## Test types

| Loai | Cong cu | Tai sao |
|------|---------|---------|
| Logic test (math) | Node script (da chay o build) | Catmull-Rom finite, escape return-to-origin |
| Syntax test | `node --check` | JS khong loi parse |
| Static structural | Node script | IDs, refs, tag balance, no-BOM |
| E2E smoke (manual/headless) | Trinh duyet / Playwright | F1-F5 hoat dong khi scroll + click |

## Test cases

| ID | Mo ta | Expected | Uu tien |
|----|-------|----------|---------|
| T01 | Mo index.html, dragon hien thi dau trang | Dragon SVG visible, idle animation chay | P0 |
| T02 | Scroll xuong 50% | Dragon di chuyen xuong, doi vi tri (x/y doi) | P0 |
| T03 | Scroll len/xuong lien tuc | Chuyen dong muot, khong giat/nhay | P0 |
| T04 | Click vao than rong (hit-area) | Escape animation (thoat→loop→return), quay ve dung vi tri | P0 |
| T05 | Scroll toi 100% (cuoi trang) | Dragon bay ve goc phai duoi, cuon tron, Zzz hien | P0 |
| T06 | Scroll len tu cuoi trang | Dragon thuc day (bo sleeping class), bay ve path | P1 |
| T07 | Viewport mobile 375px | Dragon nho gon, van hoat dong, khong tran | P1 |
| T08 | prefers-reduced-motion | Idle + Zzz dung animation | P2 |
| T09 | Click khi dang ngu | Khong kich hoat escape (guard) | P2 |
| T10 | No-JS (tat JS) | Noi dung van doc duoc, dragon dung yen | P2 |

## Coverage target

- F1-F5: 100% (moi yeu cau co test P0/P1)
- Logic math: 100% (da verify o build)
- Duong code JS: > 90% qua T01-T10

## Output

```yaml
status: PASS
test_types:
  - "logic/math test (Node)"
  - "syntax test (node --check)"
  - "static structural test"
  - "E2E smoke test (browser)"
test_cases:
  - "T01 dragon visible + idle (P0)"
  - "T02 scroll 50% dragon moves (P0)"
  - "T03 scroll smoothness (P0)"
  - "T04 click escape -> return (P0)"
  - "T05 scroll 100% sleep + Zzz (P0)"
  - "T06 wake on scroll up (P1)"
  - "T07 mobile 375px (P1)"
  - "T08 reduced-motion (P2)"
  - "T09 click guard while sleeping (P2)"
  - "T10 no-JS fallback (P2)"
coverage_target: 100% F1-F5, >90% JS code
```
