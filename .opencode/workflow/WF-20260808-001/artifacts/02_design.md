---
name: design
description: >
  Thiet ke kien truc cho dragon-website template: 3 lop (HTML/CSS/JS), SVG dragon
  serpentine, ScrollEngine (rAF+lerp), DragonStateMachine (idle|scroll|escape|sleep),
  EscapeSequence (click), SleepSequence (cuoi trang).
agent: planner
---

# Phase 02 — Thiet ke giai phap (WF-20260808-001)

## 1. Kien truc tong the

```
templates/dragon-website/
├── index.html          # HTML semantic: hero + sections + dragon SVG inline + 2 style/script tags
├── style.css           # CSS: layout, dragon idle animation, sleep animation, section styles
└── script.js           # JS: ScrollEngine, DragonRenderer, EscapeSequence, SleepSequence
```

3 lop doc lap, giao tiep qua 1 event bus nho:

| Lop | Nhiem vu | Giao tiep |
|-----|----------|-----------|
| HTML | Cau truc trang + placeholder `<svg id="dragon">` | DOM refs |
| CSS | Trang thai tinh + idle/sleep animation qua keyframes + CSS vars (toc do, mau) | class hooks: `.dragon-escape`, `.dragon-sleep` |
| JS | ScrollEngine doc scrollY -> progress p (0..1); DragonRenderer set transform theo p; StateMachine dieu phoi | event bus: `dragon:enter`, `dragon:leave`, `scroll:progress` |

## 2. Component design

### 2.1 Dragon SVG (serpentine, ~600x300 viewBox)
- **Dau** (dragon-head): sung (2 antlers), râu (2 whiskers), mieng, mat — nhom `<g id="head">`.
- **Than** (body): 1 path serpentine dai (S-curves), stroke day (co vay) + overlay mau xanh la/vang truyen thong.
- **Chan** (legs): 4 chan nho co mang (claws) — gan doc theo than tai cac moc.
- **Duoi** (tail): nhon dan, co tia (fin).
- Toan bo duoc bo trong `<g id="dragon-group">` de renderer chi can transform 1 node.

### 2.2 ScrollEngine (script.js)
```
init():  do scrollHeight, tinh progressRange = docHeight - viewportHeight
onScroll():  p = clamp(scrollY / progressRange, 0, 1)
frame loop (rAF):  smoothP += (p - smoothP) * 0.12   # lerp -> muot ma (F3)
emit scroll:progress {p, smoothP}
```
- Dung `position: fixed` cho dragon-layer (khong bi keo theo scroll tu nhien).
- Vi tri rong = f(smoothP): duong cong `waypoints[]` (tam diem tren/duoi/trong container) -> catmull-rom -> point (x,y) + goc xoay (tangent).
- Path duoc "bao boc container": cac waypoint xen ke giua cot noi dung (phai -> trai -> phai) tao hieu ung vong quanh.

### 2.3 DragonStateMachine
```
enum: IDLE | SCROLL | ESCAPE | SLEEP

IDLE     -> SCROLL : scrollY > 0
SCROLL   -> ESCAPE : click vao dragon hit-area
ESCAPE   -> SCROLL : escape sequence finish (quay ve vi tri hien tai)
SCROLL/IDLE -> SLEEP: p > 0.97
SLEEP    -> SCROLL: scrollY < 0.90 * progressRange (thuc day khi cuon len)
```
- Trong ESCAPE: ScrollEngine tam dung emit (pause), luu `returnPoint = vi tri hien tai`.
- Escape sequence: tween vong bay ra (translate ra ngoai + rotate + vong tron/so 8) bang rAF timeline 1.4s, sau do tween quay ve returnPoint (0.6s), roi mo khoa scroll.

### 2.4 EscapeSequence (click - F4)
```
onClick (hit-area = dragon-group):
  if state != SCROLL return
  state = ESCAPE; capture returnPoint
  T1 (0-40%):  bay thoat ra (scale 1.1, rotate 45deg, translate +250px cheo len phai)
  T2 (40-70%): vong bay luon (circle/loop, rotate 360)
  T3 (70-100%): quay ve returnPoint (ease-in-out)
  emit dragon:escape-done -> state = SCROLL
```

### 2.5 SleepSequence (F5)
- Khi p > 0.97: tween dragon ve goc phai duoi (viewport-relative: bottom-right, scale 0.45).
- Coil: rotate than thanh xoan oc (2 vong) + `border-radius` tuong tu boi transform (scale x<y).
- Them class `.dragon-sleep` -> CSS hien "Zzz..." (3 chu noi nhau bay len, fade).
- Khi cuon len -> tween ve lai path (reverse lerp), an Zzz.

## 3. Luong du lieu / event flow

```
user scroll ──> ScrollEngine.onScroll() ──> p
                  └─(rAF lerp)──> smoothP
                       └─> DragonRenderer.update(smoothP) ──> transform: translate + rotate
user click ──> DragonHitArea ──> StateMachine: SCROLL→ESCAPE
                  └─> EscapeSequence.timeline() ──> dragon:escape-done ──> back to SCROLL
scroll p>0.97 ──> SleepSequence.enter() ──> transform to corner + coil + Zzz
scroll p<0.90 ──> SleepSequence.exit()   ──> resume path follow
```

## 4. Security & performance

- Khong dung innerHTML voi input user; khong eval; chi DOM API.
- Performance: 1 rAF loop duy nhat, lerp chi update khi |smoothP - p| > 0.0005; `will-change: transform`; transform-only animation (khong dong cham layout); passive scroll listener.
- No external CDN -> offline, khong supply-chain risk.

## 5. Component list (final)

| Component | File | Mo ta |
|-----------|------|-------|
| PageShell | index.html | Hero + 4 sections (Nội dung 1-4) lam minh hoa scroll |
| DragonSVG | index.html (inline) | Serpentine dragon 6.0x3.0, group 1 node |
| DragonStyles | style.css | Layout, idle fly (keyframes fly), sleep coil, Zzz |
| ScrollEngine | script.js | Scroll progress + lerp + rAF loop |
| DragonRenderer | script.js | Path follow (catmull-rom waypoints) |
| StateMachine | script.js | 4 trang thai + transitions |
| EscapeSequence | script.js | Click escape + return |
| SleepSequence | script.js | Coil + Zzz o cuoi trang |

## Output

```yaml
status: PASS
architecture: >
  3 lop HTML/CSS/JS, dragon-layer position:fixed, ScrollEngine (rAF+lerp) -> progress p,
  DragonRenderer follow serpentine waypoints, StateMachine 4 trang thai
  (IDLE|SCROLL|ESCAPE|SLEEP), EscapeSequence click, SleepSequence cuoi trang.
components:
  - PageShell (index.html)
  - DragonSVG (inline SVG, group 1 node)
  - DragonStyles (style.css)
  - ScrollEngine (script.js)
  - DragonRenderer (script.js)
  - StateMachine (script.js)
  - EscapeSequence (script.js)
  - SleepSequence (script.js)
security: no-innerHTML-user-input, no-eval, no-external-CDN
performance: 1 rAF loop, lerp, transform-only, passive scroll, will-change
```
