---
category: testing
last_updated: 2026-08-01
---

# xUnit + bUnit Testing

## Tổng quan

- Project test: `JapaneseLearner.Tests/` — xUnit + bUnit + Moq
- Chạy nhanh không cần server: `dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj`

## BunitTestBase

Base class cho bUnit component tests — set up **FluentUI JSInterop mocks** (9 modules).
Mọi test component nên kế thừa để tránh lỗi JS interop của FluentUI components.

## MockStorageService

Implement `ILocalStorageService` cho service-layer tests không cần browser storage.

## Quy tắc

- Component test: kế thừa `BunitTestBase`
- Service test: dùng `MockStorageService` thay `Blazored.LocalStorage`
- Gọi method chứa `StateHasChanged()` qua `cut.InvokeAsync()` (yêu cầu Blazor Dispatcher)
- Dùng Moq cho dependencies (IProgress<int>, services khác)
