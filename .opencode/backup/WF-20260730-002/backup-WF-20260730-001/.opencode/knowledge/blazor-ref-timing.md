# Blazor `@ref` Timing

## Vấn đề
`@ref` (component/ElementReference) **chỉ được set sau lần render đầu tiên**. Gọi `FocusAsync()` hoặc bất kỳ method nào trên ref trong `OnInitializedAsync` sẽ gây `NullReferenceException`.

## Nguyên nhân
- `OnInitializedAsync` chạy **trước khi** component được render
- `@ref` binding chỉ xảy ra trong quá trình render
- Luồng: `OnInitializedAsync` → `OnAfterRenderAsync` (lúc này ref mới có)

## Fix
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

## Lesson
Luôn null-check `@ref` trước khi gọi method trên nó, vì nó có thể được gọi từ `OnInitializedAsync` (hoặc bất kỳ đâu trước render lần đầu).
