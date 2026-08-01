---
category: framework/fluentu
last_updated: 2026-08-01
---

# FluentUI 4.14.3 — Blazor WASM

## Tổng quan

Japanese Learner dùng **FluentUI 4.14.3** (Microsoft Fluent UI Blazor) làm UI framework.
**Không dùng framework UI cũ** — mọi code mới phải dùng FluentUI. Muốn check version:
`dotnet list JapaneseLearner package`.

## Component chính

- `FluentButton` — nút bấm; dùng `Appearance` enum (`.Accent`, `.Lightweight`, `.Neutral`)
- `FluentSelect<TOption>` — dropdown chọn option với binding typed
- `FluentDialog` — modal dialog
- `FluentProgressRing` — loading spinner
- `FluentDesignTheme` — theme provider (dark/light, custom color, persist storage)
- `FluentNavMenu` / `FluentNavLink` — navigation drawer
- `FluentIcon` — icon từ `Icons.Regular.Size20.*` (vd `Icons.Regular.Size20.Home`)

## Ví dụ

```razor
<FluentButton Appearance="@Appearance.Accent" OnClick="DoSave">Lưu</FluentButton>
<FluentSelect TOption="string" Items="@_options" @bind-Value="_selected" />
```

## Lưu ý

- Tham chiếu framework UI cũ trong knowledge cũ là lỗi thời (project đã migrate sang FluentUI)
- FluentUI components render theo Fluent design system — đừng cố override quá nhiều CSS
