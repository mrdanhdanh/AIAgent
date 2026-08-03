# BUG-20260803-001 — Phase 1: Reproduce (RED)

## Test tái hiện

- **Test project (tạo mới):** `AIHub.Tests/` (bUnit 2.7.2 + xUnit + Moq — pattern từ `JapaneseLearner.Tests`)
- **File test:** `AIHub.Tests/HomeErrorStateTests.cs`
- **Test name:** `Home_WhenServiceThrows_ShowsErrorStateWithRetry`
- **Cách tái hiện:** Mock `ITrendingService.GetTrendingAsync` throw `HttpRequestException` (mô phỏng GitHub API 403/network fail) → render `Home` → assert UI hiển thị error message + Retry button.

## Kết quả

```
Home_WhenServiceThrows_ShowsErrorStateWithRetry [FAIL]
Assert.Contains() Failure: Sub-string not found
Not found: "Failed to load trending items"
```

**Kết quả: FAIL (RED) — bug đã tái hiện đúng vị trí.**

UI hiện tại render empty state "No trending items" im lặng khi data fetch thất bại — không có error message, không có nút Retry.

## Ghi chú hạ tầng test

- BunitTestBase cần setup JSInterop module `FluentSearch.razor.js` + `searchModule.SetupVoid("addAriaHidden", ...)` (FluentSearch import module và gọi hàm export của module — không phải global call).
