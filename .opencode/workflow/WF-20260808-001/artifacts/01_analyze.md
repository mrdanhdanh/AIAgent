---
name: analyze
description: >
  Phan tich yeu cau tao 1 trang web Template voi con rong Chau A duoc dieu khien
  boi scroll (bay luon dau trang, bao boc content khi cuon, click de bay thoat roi
  quay lai, cuoi trang bay ve goc ngu). Deliverable: standalone HTML template.
agent: analyst
---

# Phase 01 — Phan tich yeu cau (WF-20260808-001)

## 1. Yeu cau nguoi dung (raw)

Tao 1 trang web Template:
- Phan dau trang la hinh anh dong mot con rong Chau A dang bay luon.
- Khi scroll xuong thi con rong cung di chuyen xuong theo va bao boc noi dung container.
- Scroll len/xuong thi con rong cung di chuyen toi/lui muot ma.
- Khi click vao than con rong thi no thuc hien loat chuyen dong thoat ra bay luon roi quay lai vi tri hien tai.
- Den cuoi trang thi con rong bay vo goc va cuon tron lai ngu o goc duoi ben phai.

## 2. Chuyen yeu cau thanh requirements (F1..F5)

| ID | Mo ta | Do uu tien | Chap nhan duoc? (Definition of Done) |
|----|-------|-----------|----------------------------------------|
| F1 | Rong bay luon o dau trang (idle fly animation) | Must | Rong SVG co animation bay luon lien tuc, nhin ro la rong Chau A (than dai uon luon, mai, râu, vay) |
| F2 | Scroll xuong -> rong di chuyen xuong theo va bao boc noi dung container | Must | Khi scroll, rong di chuyen theo scroll progress doc theo mot duong cong (serpentine) vong qua/bao quanh container noi dung |
| F3 | Scroll len/xuong -> rong toi/lui muot ma | Must | Scroll driver tinh toan vi tri theo scrollY; dung rAF + easing (lerp) -> chuyen dong muot, khong giat, khong lag |
| F4 | Click than rong -> thoat ra bay luon (loop) roi quay lai vi tri hien tai | Must | Click vao hit-area than rong -> animation thoat (dung vong bay vong tron/so 8 trong 1.2-2s) roi ve dung vi tri da ghi nho, tiep tuc scroll-driven |
| F5 | Cuoi trang -> rong bay vao goc phai duoi, cuon tron ngu | Must | Khi scroll gan 100% -> rong di chuyen tu tu den goc duoi phai, cuon tron (scale/rotate ve hinh xoan oc), hien thi chu "Zzz" |

## 3. Pham vi / Ngoai pham vi

- **Trong pham vi:** 1 template HTML doc lap (index.html), CSS inline/external, JS scroll engine, SVG rong, noi dung demo (hero + 4 sections) de minh hoa scroll.
- **Ngoai pham vi:** Khong sua code Blazor .NET hien tai; khong dung thu vien ngoai (GSAP...) — dung vanilla JS + CSS keyframes + SVG; khong responsive mobile phuc tap (debase responsive toi thieu).

## 4. Rui ro & giai phap

| Rui ro | Anh huong | Giai phap |
|--------|-----------|-----------|
| Scroll-driven dong bo chua du -> giat/lag (F3) | Trung binh | Dung single `requestAnimationFrame` loop + lerp ve target; chi update style khi delta > epsilon; `will-change: transform` |
| Click + scroll xung dot vi tri | Cao (F4) | Khi animation thoat dang chay -> khoa scroll-driven (pause), ghi nho offset hien tai, sau khi quay ve thi mo lai; hoac cho phep chen (interrupt) an toan |
| Rong SVG qua don gian, khong nhan ra la rong | Trung binh | Ve SVG path serpentine day du chi tiet: dau (sung, râu, mieng), than nhieu doan uon luon co vay, chan co mang, duoi nhon. Body tu 1 path tham chieu thep doi (stroke + overlay) |
| Cuoi trang cuon tron ngu nhin cung/nhan tao (F5) | Thap | Chuyen doi tu tu: rotate + scale thu nho + ve hinh xoan oc (spiral), opacity nhe, them chu "Zzz" xuat hien de xuat ngu |

## 5. Stack ky thuat

- HTML5 semantic + CSS3 (flexbox, keyframes, transform) + Vanilla JS (rAF, lerp, easing).
- SVG inline (khong can file ngoai) — de co the dung 1 file duy nhat.
- Khong dependency ngoai -> chay duoc offline, mo bang double-click.

## 6. Kich thuoc / Vi tri file

- Thu muc moi: `templates/dragon-website/`
  - `index.html` — cau truc trang + SVG rong (inline)
  - `style.css` — toan bo styling + animation idle + sleep
  - `script.js` — scroll engine, click escape animation, sleep-on-end
- README nho trong template ghi cach dung / tuy chinh.

## Output

```yaml
status: PASS
summary: >
  Hieu ro yeu cau: 1 standalone HTML template voi rong Chau A SVG duoc dieu khien
  boi scroll (F1-F5). Stack: vanilla JS + CSS + SVG, khong dependency ngoai.
requirements:
  - F1: Idle fly animation rong dau trang
  - F2: Scroll xuong -> rong bao boc container
  - F3: Scroll toi/lui muot ma (lerp + rAF)
  - F4: Click than rong -> thoat bay luon -> quay ve
  - F5: Cuoi trang -> cuon tron ngu goc phai duoi
risks:
  - Scroll dong bo -> lag (giai: rAF + lerp + will-change)
  - Xung dot click/scroll (giai: pause scroll trong luc thoat)
  - Rong SVG nhan dang (giai: ve chi tiet serpentine day du)
```
