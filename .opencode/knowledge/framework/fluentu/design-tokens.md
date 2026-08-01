---
category: framework/fluentu
last_updated: 2026-08-01
---

# FluentUI Design Tokens

## Khái niệm

FluentUI dùng **design tokens** (CSS variables) để điều khiển màu, spacing, typography.
Thay đổi theme qua `FluentDesignTheme` thay vì sửa từng component.

## FluentDesignTheme

```razor
<FluentDesignTheme CustomColor="#E63946"
                   Mode="@(ThemeService.IsDarkMode ? DesignThemeModes.Dark : DesignThemeModes.Light)"
                   StorageName="japanese-learner-theme" />
```

- `CustomColor` — màu chủ đạo (accent) của toàn app
- `Mode` — `DesignThemeModes.Dark | Light` từ binding
- `StorageName` — tên key localStorage để persist lựa chọn theme

## Quy tắc

- Thay đổi accent màu tập trung tại `CustomColor`, không hardcode màu lẻ tẻ
- Dark mode: dùng `DesignThemeModes.Dark` + attribute `data-theme` trên layout root
- Kiểm tra tương phản màu cho cả light và dark khi thêm style mới
