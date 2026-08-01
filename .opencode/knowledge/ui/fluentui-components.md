---
category: ui
last_updated: 2026-08-01
---

# FluentUI Components (đã dùng trong project)

## Danh sách component chính

| Component | Công dụng | Ghi chú |
|-----------|-----------|---------|
| `FluentButton` | Nút bấm | `Appearance` enum: `.Accent`, `.Lightweight`, `.Neutral` |
| `FluentSelect<TOption>` | Dropdown | ItemType binding typed |
| `FluentDialog` | Modal | Dialog chung cho confirm/cảnh báo |
| `FluentProgressRing` | Spinner loading | Dùng trong tri-state rendering |
| `FluentNavMenu` | Navigation menu | Chứa `FluentNavLink` |
| `FluentNavLink` | Link điều hướng | `Href`, `Match="NavLinkMatch.All"`, `OnClick` |
| `FluentIcon` | Icon | `Icons.Regular.Size20.*` (vd `Home`, `Target`, `Settings`) |
| `FluentDesignTheme` | Theme provider | `CustomColor`, `Mode`, `StorageName` |

## Ví dụ nav

```razor
<FluentNavMenu>
    <FluentNavLink Href="words" OnClick="CloseDrawer">
        <FluentIcon Icon="@(Icons.Regular.Size20.Document)" /> Word Study
    </FluentNavLink>
</FluentNavMenu>
```

## Lưu ý

- Luôn dùng component có sẵn thay vì HTML thuần để giữ Fluent design
- Không dùng components của framework UI cũ (không có trong project)
