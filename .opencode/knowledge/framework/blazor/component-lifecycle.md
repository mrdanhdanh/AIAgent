---
migrated_from: .opencode/knowledge/blazor-ref-timing.md
migrated_at: 2026-07-30
category: framework/blazor
---

# Blazor Component Lifecycle & `@ref` Timing

## Overview

Blazor components go through a fixed lifecycle sequence. Understanding this sequence is critical for avoiding common pitfalls with `@ref`, async initialization, and DOM access.

## Lifecycle Order

```
SetParametersAsync
    → OnInitialized / OnInitializedAsync
    → OnParametersSet / OnParametersSetAsync
    → Render (build render tree)
    → OnAfterRender / OnAfterRenderAsync (first time)
```

Key rule: `@ref` bindings and DOM elements are ONLY available after the first render.

## `@ref` Timing

### Vấn đề
`@ref` (component/ElementReference) **chỉ được set sau lần render đầu tiên**. Gọi `FocusAsync()` hoặc bất kỳ method nào trên ref trong `OnInitializedAsync` sẽ gây `NullReferenceException`.

### Nguyên nhân
- `OnInitializedAsync` chạy **trước khi** component được render
- `@ref` binding chỉ xảy ra trong quá trình render
- Luồng: `OnInitializedAsync` → `OnAfterRenderAsync` (lúc này ref mới có)

### Fix
1. Null-check trước khi dùng:
```csharp
if (inputRef != null)
    await inputRef.FocusAsync();
```

2. Hoặc dùng `OnAfterRenderAsync` nếu cần focus ngay lần đầu:
```csharp
protected override async Task OnAfterRenderAsync(bool firstRender)
{
    if (firstRender)
        await inputRef.FocusAsync();
}
```

## StateHasChanged & Dispatcher

`StateHasChanged()` yêu cầu Blazor Dispatcher thread. Gọi từ test thread (bUnit) gây `InvalidOperationException`.

Fix: Dùng `cut.InvokeAsync()` wrapper:
```csharp
await cut.InvokeAsync(() => component.MethodWithStateHasChanged());
cut.Render(); // force render after InvokeAsync
```

## Tri-State Rendering Pattern

Mỗi page xử lý 3 trạng thái:
1. **Loading** — `FluentProgressRing` (hoặc tương đương)
2. **Empty** — `list.Count == 0` → hướng dẫn
3. **Data** — nội dung chính

```razor
@if (isLoading) {
    <FluentProgressRing />
} else if (items.Count == 0) {
    <p>Chưa có dữ liệu. Hãy thêm mới.</p>
} else {
    // render data
}
```

## Lesson
Luôn null-check `@ref` trước khi gọi method trên nó, vì nó có thể được gọi từ `OnInitializedAsync` (hoặc bất kỳ đâu trước render lần đầu). Sử dụng `InvokeAsync()` wrapper cho mọi gọi hàm chứa `StateHasChanged()` từ test thread.
