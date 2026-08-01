---
name: visual-regression
description: Visual regression testing — expect(page).toHaveScreenshot(), multi-viewport (Desktop/Tablet/Mobile/Dark/Light), pixel diff, threshold, ignore animation và dynamic content. Sử dụng câu lệnh /test-visual.
schema_version: "1.0"
---

# Visual Regression — Kiểm Tra Giao Diện Bằng Screenshot

Skill phát hiện thay đổi giao diện không mong muốn bằng cách so sánh screenshot với baseline.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [QUY TRÌNH](#quy-trình)
- [BASELINE MANAGEMENT](#baseline-management)
- [MULTI-VIEWPORT](#multi-viewport)
- [DARK & LIGHT THEME](#dark--light-theme)
- [PIXEL DIFF & THRESHOLD](#pixel-diff--threshold)
- [IGNORE ANIMATION & DYNAMIC CONTENT](#ignore-animation--dynamic-content)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Visual regression dùng `toHaveScreenshot()` của Playwright. Lần chạy đầu tạo baseline, các lần sau so sánh pixel-by-pixel. Phát hiện: thay đổi layout, màu, font, spacing không mong muốn.

### Command

| Command | Mô tả |
|---------|-------|
| `/test-visual` | Chạy pipeline: screenshot → compare → diff → report |

### Kiến thức liên quan

- Theme: `.opencode/knowledge/ui/dark-mode-theming.md`
- FluentUI components: `.opencode/knowledge/ui/fluentui-components.md`

---

## QUY TRÌNH

1. **Chụp baseline** — lần đầu, xác nhận UI đúng, lưu ảnh gốc
2. **Chạy compare** — chụp màn hình hiện tại, so với baseline
3. **Sinh diff** — tạo ảnh diff đánh dấu vùng khác biệt
4. **Đánh giá** — phân loại: intentional change / regression / flaky
5. **Báo cáo** — danh sách file thay đổi + ảnh diff

```csharp
[Fact]
public async Task HomePage_Visual_Matches_Baseline()
{
    await _page.GotoAsync("/");
    await Expect(_page).ToHaveScreenshotAsync("home-desktop-light.png");
}
```

---

## BASELINE MANAGEMENT

- Baseline lưu tại `test-results/` hoặc thư mục snapshot cạnh test
- Lần chạy đầu: `--update-snapshots` tạo baseline
- Cập nhật baseline khi UI thay đổi **có chủ đích**
- KHÔNG cập nhật baseline để "che" regression

```powershell
# Tạo/cập nhật baseline
dotnet test -- --update-snapshots
```

---

## MULTI-VIEWPORT

Sinh baseline tự động cho các viewport:

| Viewport | Kích thước |
|----------|-----------|
| Desktop | 1366×768 |
| Tablet | 768×1024 |
| Mobile | 375×667 |
| Mobile nhỏ | 320×568 |

```csharp
[Theory]
[InlineData(1366, 768)]
[InlineData(768, 1024)]
[InlineData(375, 667)]
[InlineData(320, 568)]
public async Task Page_Visual_At_Viewport(int width, int height)
{
    await _page.SetViewportSizeAsync(width, height);
    await _page.GotoAsync("/");
    await Expect(_page).ToHaveScreenshotAsync($"page-{width}x{height}.png");
}
```

---

## DARK & LIGHT THEME

Test cả 2 theme vì màu sắc khác nhau:

```csharp
[Fact]
public async Task HomePage_DarkTheme_Matches_Baseline()
{
    // Bật dark mode qua ThemeService
    await _page.GetByRole(AriaRole.Button, new() { Name = "Dark" }).ClickAsync();
    await Expect(_page).ToHaveScreenshotAsync("home-desktop-dark.png");
}
```

**Lưu ý:** dark mode persist qua `Blazored.LocalStorage` — cần set localStorage trước khi reload:
```csharp
await _page.EvaluateAsync("localStorage.setItem('theme', 'dark')");
```

---

## PIXEL DIFF & THRESHOLD

- `maxDiffPixelRatio` — tỉ lệ pixel khác (mặc định 0.01 = 1%)
- `maxDiffPixels` — số pixel khác tối đa
- `threshold` — ngưỡng màu khác biệt (0-1, mặc định 0.2)

```csharp
await Expect(_page).ToHaveScreenshotAsync("page.png",
    new() { MaxDiffPixelRatio = 0.02, Threshold = 0.3 });
```

**Quy tắc:**
- Animation/font rendering khác máy → tăng threshold vừa phải (không quá 0.4)
- KHÔNG tăng threshold để che lỗi layout thật

---

## IGNORE ANIMATION & DYNAMIC CONTENT

**Animation:**
- Dùng `animation: none` qua CSS injection trước khi chụp
- Hoặc `page.emulateMedia({ reducedMotion: 'reduce' })`

```csharp
await _page.EmulateMediaAsync(new() { ReducedMotion = ReducedMotion.Reduce });
```

**Dynamic content (clock, random, live data):**
- Mock thời gian: freeze clock trước khi chụp
- Mask vùng động bằng `mask` option

```csharp
await Expect(_page).ToHaveScreenshotAsync("page.png",
    new() { Mask = new[] { _page.Locator(".live-clock") } });
```

**Các nguồn flaky cần xử lý:**
- DateTime hiển thị → freeze clock / mask
- Random data → seed cố định
- Progress ring / spinner → chờ hết animation
- Font loading → `document.fonts.ready`

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "PASS | CHANGES_NEEDED"
summary: "Tóm tắt kết quả visual regression"
baselines:
  - file: "home-desktop-light.png"
    status: "MATCH"
  - file: "home-mobile-dark.png"
    status: "DIFF"
    diff_ratio: 0.15
    threshold: 0.1
    diff_file: "home-mobile-dark.diff.png"
issues:
  - severity: "MAJOR"
    description: "Button padding thay đổi 8px → 12px"
    suggestion: "Kiểm tra CSS thay đổi"
next_action: "Xác nhận change có chủ đích hay regression"
```
