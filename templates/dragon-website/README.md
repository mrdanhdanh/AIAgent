# Long Vân — Dragon Scroll Template

Template trang web có con **rồng Châu Á** bay lượn theo scroll, thuần
**Vanilla JS + SVG + CSS** — không cần bất kỳ thư viện nào (offline-safe).

## Tính năng

| # | Tính năng | Mô tả |
|---|-----------|-------|
| F1 | Bay lượn đầu trang | Rồng có idle animation (keyframes `dragon-fly`) ở vị trí đầu hero |
| F2 | Bao bọc container | Rồng di chuyển theo scroll dọc theo đường cong Catmull-Rom, uốn lượn trái/phải bao quanh container nội dung |
| F3 | Mượt mà | Lerp qua `requestAnimationFrame` — rồng tới/lùi không giật, không lag |
| F4 | Click để bay thoát | Click vào thân rồng → chuỗi động tác: thoát ra (T1) → bay vòng lượn (T2) → quay về đúng vị trí (T3) |
| F5 | Ngủ cuối trang | Gần hết trang rồng bay vào góc phải dưới, cuộn tròn (coil) và ngủ với chữ "Zzz"; cuộn lên là thức dậy |

## Cách dùng

Chỉ cần mở `index.html` bằng trình duyệt (hoặc chạy web server đơn giản):

```powershell
# tùy chọn: nếu muốn chạy qua server
python -m http.server 8080
# rồi mở http://localhost:8080
```

## Cấu trúc

```
dragon-website/
├── index.html    # Shell trang + SVG rồng inline
├── style.css     # Layout, idle fly, sleep coil, Zzz
├── script.js     # ScrollEngine, Renderer, StateMachine, Escape, Sleep
└── README.md
```

## Tùy chỉnh

### Đổi đường bay (F2)
Trong `script.js`, mảng `WAYPOINTS` (phần trăm viewport) quyết định quỹ đạo
rồng đi theo khi cuộn. Sửa các điểm để đổi hình dạng đường bay.

### Đổi màu rồng
Trong `index.html`, đổi các gradient `#bodyGrad`, `#bellyGrad`, `#glowGrad`.

### Đổi độ mượt (F3)
Biến `LERP` trong `script.js` — giá trị càng nhỏ càng mượt nhưng bám càng chậm.

### Đổi ngưỡng ngủ (F5)
`SLEEP_IN` / `SLEEP_OUT` trong `script.js` (hysteresis chống rung lập).

### Thay nội dung
Chỉnh các `<section>` trong `index.html`; đường bay rồng tự thích ứng vì
waypoints tính theo viewport.

## Ghi chú kỹ thuật

- `#dragon-layer` là child trực tiếp của `body` (tránh lỗi `position: fixed`
  bị kẹt trong container có `transform`).
- Transform scroll nằm ở `#dragon-outer`; animation idle nằm ở `#dragon-inner`
  — tách biệt, không ghi đè lẫn nhau.
- Rồng là trang trí → `aria-hidden="true"`, không ảnh hưởng accessibility;
  click chỉ nhận qua hit-area dọc thân (`pointer-events: stroke`).
- Hỗ trợ `prefers-reduced-motion`: tắt idle animation, tắt Zzz.
