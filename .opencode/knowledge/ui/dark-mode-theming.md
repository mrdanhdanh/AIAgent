---
category: ui
last_updated: 2026-08-01
---

# Dark Mode Theming

## Tổng quan

Dark mode qua **ThemeService** (IThemeService/ThemeService), persist bằng `Blazored.LocalStorage`,
render bằng `FluentDesignTheme`.

## ThemeService

- `GetCurrentModeAsync()` — nạp mode đã lưu khi khởi tạo (gọi trong `OnInitializedAsync` của MainLayout)
- `ToggleAsync()` — đổi light/dark + persist
- `IsDarkMode` — trạng thái hiện tại
- `OnThemeChanged` — event để component subscribe re-render (nhớ unsub trong `Dispose`)

## Layout pattern

```razor
<FluentDesignTheme CustomColor="#E63946"
                   Mode="@(ThemeService.IsDarkMode ? DesignThemeModes.Dark : DesignThemeModes.Light)"
                   StorageName="japanese-learner-theme" />
<div class="app-layout" data-theme="@(ThemeService.IsDarkMode ? "dark" : "light")">
```

## Lưu ý

- Dùng `data-theme` attribute trên root + CSS theo `[data-theme="dark"]` nếu cần
- Luôn test cả 2 mode khi thêm style mới (contrast, hover, focus)
