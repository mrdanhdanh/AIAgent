---
name: browser-compatibility
description: Kiểm tra tương thích trình duyệt — Chrome, Edge, Firefox, Safari + iPhone/Android. Phát hiện API/code không tương thích. Sử dụng câu lệnh /test-cross-browser.
schema_version: "1.0"
---

# Browser Compatibility — Kiểm Tra Tương Thích Trình Duyệt

Skill kiểm tra app chạy đúng trên nhiều trình duyệt khác nhau.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [TRÌNH DUYỆT HỖ TRỢ](#trình-duyệt-hỗ-trợ)
- [CẤU HÌNH PLAYWRIGHT](#cấu-hình-playwright)
- [HẠN CHẾ HIỆN TẠI](#hạn-chế-hiện-tại)
- [CÁC LỖI PHỔ BIẾN](#các-lỗi-phổ-biến)
- [QUY TRÌNH](#quy-trình)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Browser compatibility đảm bảo app chạy nhất quán trên Chrome, Edge, Firefox, Safari và mobile. Playwright hỗ trợ chạy test trên nhiều browser engine.

### Command

| Command | Mô tả |
|---------|-------|
| `/test-cross-browser` | Chạy test trên nhiều browser |

---

## TRÌNH DUYỆT HỖ TRỢ

| Browser | Engine | Playwright project |
|---------|--------|-------------------|
| Chrome | Chromium | `chromium` |
| Edge | Chromium | `chromium` + channel edge |
| Firefox | Gecko | `firefox` |
| Safari | WebKit | `webkit` |
| iPhone | WebKit (mobile) | `device = iPhone 14` |
| Android | Chromium (mobile) | `device = Pixel 7` |

---

## CẤU HÌNH PLAYWRIGHT

```json
{
  "projects": [
    { "name": "chromium", "use": { "browserName": "chromium" } },
    { "name": "firefox", "use": { "browserName": "firefox" } },
    { "name": "webkit", "use": { "browserName": "webkit" } },
    { "name": "edge", "use": { "browserName": "chromium", "channel": "msedge" } },
    { "name": "mobile-safari", "use": { "browserName": "webkit", ...devices["iPhone 14"] } }
  ]
}
```

---

## HẠN CHẾ HIỆN TẠI

> ⚠️ **LƯU Ý QUAN TRỌNG:** `JapaneseLearner.E2ETests/PlaywrightFixture.cs:24` có **browser path hardcoded** theo máy hiện tại. Trên máy khác, hoặc khi chạy Firefox/WebKit, sẽ fail nếu chưa cấu hình. Kiểm tra:
> 1. Browser được cài đúng phiên bản
> 2. Path trong `PlaywrightFixture.cs` khớp máy
> 3. `dotnet tool install Microsoft.Playwright.CLI` + `playwright install`

---

## CÁC LỖI PHỔ BIẾN

| Lỗi | Nguyên nhân | Cách tránh |
|-----|-------------|-----------|
| Layout khác nhau | CSS vendor prefix, flexbox khác engine | Dùng FluentUI (đã chuẩn hóa), test sớm |
| Font khác | Font fallback khác hệ thống | Dùng font system stack, kiểm tra visual |
| API không có | `Array.at`, `structuredClone`... chưa hỗ trợ Safari cũ | Kiểm tra caniuse, polyfill |
| Date/locale khác | `toLocaleDateString` khác locale | Fix locale rõ ràng |
| Scroll khác | Scrollbar khác kích thước | CSS `scrollbar-width`, test overflow |
| Blazor WASM lỗi Safari | Safari cache WASM | Kiểm tra version Safari ≥ 15 |

---

## QUY TRÌNH

1. **Xác định browser** — theo user/flag hoặc mặc định: chromium, firefox, webkit
2. **Cài browser** — `playwright install` nếu thiếu
3. **Chạy test** — E2E trên từng browser
4. **So sánh** — kết quả + screenshot từng browser
5. **Phân loại** — lỗi browser-specific / lỗi chung
6. **Báo cáo** — ma trận browser × test

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "PASS | CHANGES_NEEDED"
summary: "Tóm tắt kết quả cross-browser"
browsers_tested:
  - name: "chromium"
    status: "PASS"
    failed: 0
  - name: "firefox"
    status: "PASS"
    failed: 0
  - name: "webkit"
    status: "FAIL"
    failed: 2
failures:
  - browser: "webkit"
    test: "HomePage_Loads_Successfully"
    error: "toLocaleDateString không hỗ trợ locale vi-VN"
    fix_hint: "Dùng CultureInfo rõ ràng"
  - browser: "webkit"
    test: "Admin_Grid_Renders"
    error: "Overflow ngang do scrollbar width khác"
    fix_hint: "Thêm overflow-x auto container"
issues:
  - severity: "WARNING"
    description: "PlaywrightFixture.cs:24 browser path hardcoded"
    suggestion: "Cấu hình theo máy hoặc dùng env var"
score:
  compatibility: 88
next_action: "Fix webkit-specific issues hoặc xác nhận out-of-scope"
```
