---
category: ui
last_updated: 2026-08-01
---

# Tri-State Rendering

## Khái niệm

Mỗi page/component hiển thị 1 trong 3 trạng thái:
**Loading → Empty → Data** qua `isLoading` + `list.Count == 0`.

## Pattern

```razor
@if (isLoading)
{
    <FluentProgressRing />
}
else if (list.Count == 0)
{
    <p>Chưa có dữ liệu. ...</p>   @* Empty state + hướng dẫn *@
}
else
{
    // Data — render nội dung chính
}
```

```csharp
private bool isLoading = true;
private List<T> list = new();

protected override async Task OnInitializedAsync()
{
    list = await _service.GetAllAsync(progress);
    isLoading = false;
}
```

## Quy tắc

- Loading state: luôn dùng `FluentProgressRing` (FluentUI), không dùng text "loading..."
- Empty state: kèm thông điệp hướng dẫn hoặc CTA
- Không quên set `isLoading = false` trong mọi nhánh (kể cả khi load lỗi)
