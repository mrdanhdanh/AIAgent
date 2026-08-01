---
name: responsive-layout
description: Kiểm tra layout responsive — viewports 320/375/768/1024/1366/1920, overflow, horizontal scroll, hidden control, broken layout, flex, grid. Sử dụng câu lệnh /test-ui --responsive.
schema_version: "1.0"
---

# Responsive Layout — Kiểm Tra Layout Đáp Ứng

Skill kiểm tra giao diện hiển thị đúng trên mọi kích thước màn hình, không vỡ layout.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [VIEWPORTS](#viewports)
- [6 HẠNG MỤC KIỂM TRA](#6-hạng-mục-kiểm-tra)
- [QUY TRÌNH](#quy-trình)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Responsive layout đảm bảo app dùng tốt trên desktop, tablet, mobile. Kiểm tra bằng Playwright với nhiều viewport size, phát hiện overflow, scroll ngang, control bị ẩn.

### Command

| Command | Mô tả |
|---------|-------|
| `/test-ui --responsive` | Kiểm tra responsive |

---

## VIEWPORTS

| Nhóm | Kích thước | Thiết bị |
|------|-----------|----------|
| Mobile nhỏ | 320×568 | iPhone SE |
| Mobile | 375×667 | iPhone 14 |
| Tablet | 768×1024 | iPad |
| Desktop nhỏ | 1024×768 | laptop cũ |
| Desktop | 1366×768 | laptop |
| Desktop lớn | 1920×1080 | màn hình lớn |

---

## 6 HẠNG MỤC KIỂM TRA

### 1. Overflow
```csharp
var overflow = await _page.EvaluateAsync<bool>(@"
    document.documentElement.scrollWidth > document.documentElement.clientWidth
");
Assert.False(overflow);  // Không overflow ngang
```

### 2. Horizontal Scroll
- `overflow-x` trên body/container phải là `hidden` hoặc không xảy ra
- Bảng dài → wrap trong container scroll ngang có chủ đích
- Card/grid không tràn ra ngoài

### 3. Hidden Control
- Control quan trọng (submit, nav, close) KHÔNG bị ẩn trên mobile
- Hamburger menu thay thế nav ngang khi thu nhỏ
- Dialog vẫn mở được và đóng được

```csharp
var visible = await _page.GetByRole(AriaRole.Button, new() { Name = "Lưu" }).IsVisibleAsync();
Assert.True(visible);
```

### 4. Broken Layout
- Card không chồng nhau
- Text không cắt xén (ellipsis hợp lý)
- Image không bị méo (aspect ratio giữ nguyên)

### 5. Flex
- `flex-wrap` trên container khi thu nhỏ
- Item flex không `min-width` chặn shrink
- Gap hợp lý khi wrap xuống dòng

### 6. Grid
- Grid tự chuyển cột khi thu nhỏ (media query hoặc auto-fit)
- FluentUI `FluentGrid` responsive breakpoints đúng

```csharp
// Kiểm tra số cột trên mobile
var cols = await _page.EvaluateAsync<int>("getComputedStyle(document.querySelector('.grid')).gridTemplateColumns.split(' ').length");
```

---

## QUY TRÌNH

1. **Chọn routes** — các route chính cần kiểm tra
2. **Lặp viewports** — 320 → 1920
3. **Chạy 6 checks** — overflow, h-scroll, hidden, broken, flex, grid
4. **Chụp screenshot** — lưu mỗi viewport để xem sau
5. **Phân loại** — ERROR (broken layout) / WARNING (minor)

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "PASS | CHANGES_NEEDED"
summary: "Tóm tắt kết quả responsive"
routes_checked:
  - "/"
  - "/words"
  - "/admin"
results:
  - viewport: "320x568"
    route: "/"
    overflow: false
    horizontal_scroll: false
    hidden_controls: []
    broken_layout: false
    screenshot: "screenshots/responsive-320-home.png"
  - viewport: "1920x1080"
    route: "/"
    overflow: false
    horizontal_scroll: false
    hidden_controls: []
    broken_layout: false
    screenshot: "screenshots/responsive-1920-home.png"
issues:
  - severity: "MAJOR"
    viewport: "375x667"
    route: "/admin"
    category: "overflow"
    description: "Bảng quản lý tràn ngang 40px"
    suggestion: "Wrap table trong container có overflow-x: auto"
score:
  responsive: 90
issues: []
next_action: "Fix MAJOR trước khi approve"
```
