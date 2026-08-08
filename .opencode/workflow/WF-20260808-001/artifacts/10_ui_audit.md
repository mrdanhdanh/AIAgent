---
name: ui_audit
description: >
  Audit UI/UX + accessibility + responsive cho dragon-website template. Luu y:
  template HTML doc lap, KHONG dung FluentUI (chi ap dung cho code .NET) — audit
  theo chuan web chung + a11y WCAG co ban.
agent: ui-beautifier
---

# Phase 10 — Kiem tra giao dien (WF-20260808-001)

## Phase 1 — Static UI review

| Muc | Danh gia |
|-----|----------|
| Layout | Hero 100vh, sections padding 110px, container max 880px — thoang, co cau truc |
| Typography | `clamp()` responsive headings, line-height 1.7-1.8, contrast #57534e tren #fdfbf7 ~ 5.5:1 (AA) |
| Color | Palette cam nâu (amber/stone) dong bo voi rong vang — nhat quan |
| Spacing | Grid + gap 20px cards, timeline counter badges — can le deu |
| Dragon | SVG serpentine day du chi tiet (dau, sung, râu, than, chan, duoi), drop-shadow tao chieu sau |

## Phase 2 — Accessibility

| Check | Ket qua |
|-------|---------|
| `aria-hidden="true"` tren dragon-layer (decor) | PASS |
| Dragon khong chan noi dung doc | PASS (pointer-events none, chi hit-area nhan click) |
| Hit-area co cursor pointer + focus? | WARNING MINOR — path khong focusable bang keyboard; chi click chuot/touch. Chap nhan cho template demo (dragon la decor, khong phai noi dung chinh) |
| Form co `aria-label` tren inputs | PASS |
| `prefers-reduced-motion` tat idle/zzz | PASS |
| Contrast AA | PASS (do text to mau chinh) |
| Screen reader doc noi dung section | PASS — noi dung trong `<main>` binh thuong |

## Phase 3 — Responsive

| Viewport | Ket qua |
|----------|---------|
| Desktop 1400px | Dragon scale 0.84, waypoints deu, container 880px |
| Tablet 768px | Dragon scale 0.46 (vw/1500*0.9), van duong bay ro |
| Mobile 640px | `--dragon-w: 300px` (CSS media query), dragon nho gon |
| Mobile 375px | Dragon scale 0.225 — nho nhung con hien thi; Zzz co `top:-10%; right:4%` khong tran |

Luu y: waypoints tinh theo % viewport nen tu thich ung moi kich thuoc.

## Phase 4 — Consistency

- Khong dung FluentUI (template HTML doc lap, ngoai pham vi .NET) — ghi chu trong review.
- Phat hien 1 ISSUE: `#dragon-svg #dragon-svg *` CSS loi — DA FIX o static_analysis (khong con).
- Khong con CRITICAL/MAJOR issue.

## Output

```yaml
status: PASS
phases:
  - "Phase 1 Static UI: PASS — typography, color, spacing nhat quan"
  - "Phase 2 Accessibility: PASS (1 WARNING MINOR: hit-area khong keyboard-focusable, chap nhan cho decor)"
  - "Phase 3 Responsive: PASS — 375..1400px deu hoat dong"
  - "Phase 4 Consistency: PASS — khong CRITICAL/MAJOR issue"
warnings:
  - severity: MINOR
    description: "Hit-area click chi ho tro chuot/touch, khong phai keyboard — decor khong yeu cau"
```
