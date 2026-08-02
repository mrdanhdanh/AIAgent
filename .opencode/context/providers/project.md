---
name: context-provider-project
description: Project Provider — khớp Project Context từ AGENTS.md, launchSettings, csproj, source tree.
agent: general
---

# Project Provider

## 1. Vai trò

Cung cấp thông tin cố định dự án (framework, language, architecture, rules). **Không load toàn bộ**, chỉ liệt kê + đọc metadata cần.

## 2. dtype

| Item | Nguồn | type |
|------|-------|---------|
| AGENTS.md | gốc rule/convention | text |
| Directory core | code structure | list |
| launchSettings.json | ngôn ngữ/framework | json |
| Project.csproj | framework | xml |

## 3. Interface (theo provider.schema)

- `discover()` → list candidate (path, size, type).
- `resolve(type)`: đọc nội dung một item.
- `size()`: token estimate.
- `validate()`: đảm bảo AGENTS.md tồn tại.

## 4. Ví dụ output (chunk project)

```
project:
  framework: [blazor, wasm]
  language: [csharp]
  architecture: [cache-first, DI]
  rules: [ "FluentUI, not MudBlazor", "UTF-8 no-BOM, 2-space" ]
```

## 5. Cache

Đây là nguồn rẻ nhất cache: content cố định, không thay đổi trong workflow → Cache Hit cao. Xem `cache/`.

## 6. Tương tác

- Builder cần `required` mặc định.
- Profile định nghĩa đâu là `optional` (eg knowledge).
- Token rẻ nhất: nguồn này nên cache nhiều.