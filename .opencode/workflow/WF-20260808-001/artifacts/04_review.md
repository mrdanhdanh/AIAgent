---
name: review
description: >
  Reviewer danh gia ke hoach thuc thi dragon-website template — kiem tra phu hop
  yeu cau F1-F5, tinh kha thi ky thuat, rui ro, va dua quyet dinh.
agent: reviewer
---

# Phase 04 — Danh gia ke hoach (WF-20260808-001)

## 1. Danh gia theo yeu cau F1-F5

| Yeu cau | Ke hoach co giai quyet? | Nhan xet |
|---------|------------------------|----------|
| F1 Idle fly | Co — `@keyframes fly` tren dragon-group | OK. Dragon-group la 1 node duy nhat nen animation idle de ap dung; can dam bao khong xung dot voi scroll transform (dung the lang con `.dragon-inner` cho idle fly, group ngoai cho scroll transform) |
| F2 Bao boc container | Co — waypoints catmull-rom xen ke cot noi dung | OK. Can dam bao dragon-layer `position:fixed` + waypoints duoc tinh theo vi tri thuc cua container (dung getBoundingClientRect hoac offset da biet). Luu y: `position:fixed` voi parent co transform se bi relative — nen de dragon-layer lam con truc tiep cua body |
| F3 Scroll muot | Co — rAF + lerp 0.12 + epsilon gate | OK. Passive scroll listener + 1 rAF loop duy nhat. Diem cong: khong dung thu vien ngoai |
| F4 Click thoat | Co — EscapeSequence 3 pha (T1 thoat / T2 loop / T3 return) | OK. Can lock scroll trong luc escape (state = ESCAPE -> ScrollEngine pause). Risk: neu escape dai > thoi gian user cuon tiep, dragon se "nhay" ve vi tri moi — chap nhan duoc, nhung nen tinh returnPoint luc finish de tranh nhay dot ngot |
| F5 Sleep | Co — SleepSequence p>0.97 coil + Zzz | OK. Nguong 0.97/0.90 co hysteresis tranh flap. Nen dung CSS transition hoac tween cho coil de muot |

## 2. Van de ky thuat can luu y

1. **`position: fixed` trong container co transform** — tranh dat dragon-layer ben trong phan tu co `transform`, `filter`, `will-change` — se lam fixed bi relative. Giai phap: dragon-layer la child truc tiep cua `body`.
2. **Xung dot transform**: idle fly (`.dragon-inner`) phai tach khoi scroll transform (`.dragon-outer`) — 2 node, khong ghi de len nhau.
3. **Hit-area**: click vao "than rong" — nen dung `#dragon-group` voi pointer-events auto, cac phan khac cua layer `pointer-events: none` de khong chan scroll/noi dung.
4. **Performance**: transform-only, `will-change: transform`, lerp epsilon — da co trong design. OK.
5. **Accessibility**: rong la decor, khong phai noi dung — them `aria-hidden="true"` tren dragon-layer; dam bao noi dung van doc duoc khi JS tat (no-JS fallback: dragon dung yen, noi dung hien day du).

## 3. Cham diem

- Overall score: 8.5/10
- Tinh day du so voi yeu cau: 5/5
- Kha thi ky thuat: 9/10
- Rui ro ton tai: 2/10 (fixed-in-transform, transform xung dot — de xu ly)

## 4. Quyet dinh

- **APPROVED** voi 4 luu y can thuc hien trong build:
  - LUU-Y-01: dragon-layer la child truc tiep cua body (tranh fixed-in-transform).
  - LUU-Y-02: tach idle animation (`.dragon-inner`) khoi scroll transform (`.dragon-outer`).
  - LUU-Y-03: dragon-layer `aria-hidden="true"` + pointer-events chi tren hit-area.
  - LUU-Y-04: returnPoint tinh tai thoi diem finish escape (khong dung returnPoint cu) de tranh nhay dot ngot.

## Output

```yaml
status: PASS
decision: APPROVED
scores:
  overall: 8.5
  completeness: 5
  feasibility: 9
  risk: 2
issues:
  - severity: MAJOR
    description: "fixed-in-transform risk (dragon-layer trong container co transform)"
    action: "LUU-Y-01: dragon-layer la child truc tiep cua body"
  - severity: MAJOR
    description: "Transform xung dot idle/scroll"
    action: "LUU-Y-02: tach .dragon-inner (idle) vs .dragon-outer (scroll)"
  - severity: MINOR
    description: "Accessibility + hit-area chan noi dung"
    action: "LUU-Y-03: aria-hidden + pointer-events chon loc"
  - severity: MINOR
    description: "Escape return bi nhay dot ngot khi scroll tiep tuc"
    action: "LUU-Y-04: returnPoint tinh tai finish"
```
