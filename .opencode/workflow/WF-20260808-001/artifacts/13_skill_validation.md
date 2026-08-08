---
name: skill_validation
description: >
  Self-improver de xuat cai tien cho dragon-website template va dev-team workflow
  (optional phase). Ghi nhan cac pattern co the luu vao knowledge base.
agent: self-improver
---

# Phase 13 — De xuat cai tien (WF-20260808-001)

## Suggestions

| Category | De xuat | Muc do |
|----------|---------|--------|
| Template enhancement | Them che do toc do scroll (config `LERP` public qua `window.DragonConfig`) | LOW |
| Template enhancement | Them 2-3 path khac nhau cho dragon (waypoint presets: serpentine, spiral, sine) | LOW |
| Template enhancement | Them hieu ung cloud/lam suong bay phia sau rong (decor SVG) | LOW |
| Template enhancement | Export SVG rong thanh file rieng `dragon.svg` de tai dung noi khac | LOW |
| Accessibility | Lam hit-area keyboard-focusable (`tabindex=0` + Enter/Space) cho P2 | MEDIUM |
| Performance | Neu content dai > 10x viewport, co the dung IntersectionObserver de giam tinh toan | LOW |
| Workflow | Luu pattern "scroll-driven SVG via Catmull-Rom + lerp + state machine" vao `.opencode/knowledge/` cho cac task UI tuong tu | MEDIUM |

## Knowledge base suggestion

- **Pattern**: scroll-driven animation voi vanilla JS = `scrollY -> progress -> spline -> transform` + rAF lerp + state machine (IDLE/SCROLL/ESCAPE/SLEEP) + hysteresis cho trang thai cuoi trang.
- **Anti-pattern trach**: `position: fixed` trong container co transform; transform animation trung nhau (idle vs scroll); pointer-events chan noi dung.

## Output

```yaml
status: PASS
suggestions:
  - category: template
    items:
      - "Them che do toc do scroll (DragonConfig)"
      - "Waypoint presets (serpentine/spiral/sine)"
      - "Decor cloud phia sau rong"
      - "Export dragon.svg rieng"
  - category: accessibility
    items:
      - "Keyboard-focusable hit-area (tabindex + Enter/Space)"
  - category: performance
    items:
      - "IntersectionObserver cho content rat dai"
  - category: knowledge
    items:
      - "Luu scroll-driven SVG pattern vao knowledge base"
summary: >
  Optional phase hoan tat — 6 de xuat cai tien (LOW/MEDIUM), khong co de xuat
  BLOCKER. Khong thuc hien thay doi code trong workflow nay.
```
