# BUG-20260803-001 — Phase 3-6: Fix, Verify, Test, Report

## Phase 3 — Fix (GREEN)

**Backup (backup-utility.ps1):** 4/4 file SUCCESS — manifest `.opencode/backup/BUG-20260803-001/backup_manifest.json`

| File | Action | Thay đổi |
|------|--------|----------|
| `AIHub/Program.cs` | MODIFY | HttpClient `Timeout = TimeSpan.FromSeconds(20)` |
| `AIHub/Services/ITrendingService.cs` | MODIFY | Thêm `HasFailures`, `LastError`, `FailedSourceCount`, `ResetErrorState()` |
| `AIHub/Services/TrendingService.cs` | MODIFY | `RecordFailure()` per-source (403/exception); reset flags đầu request; **không cache kết quả fail** |
| `AIHub/Pages/Home.razor` | MODIFY | Error state (⚠️ + message + detail) + nút **Retry**; phân biệt no-data vs load-fail; pagination-fail giữ grid cũ |
| `AIHub.Tests/HomeErrorStateTests.cs` | MODIFY | 5 tests GREEN |
| `AIHub.Tests/TrendingServiceTests.cs` | CREATE | 6 unit tests service |

**Kết quả test tái hiện:** `Home_WhenServiceThrows_ShowsErrorStateWithRetry` — **PASS (GREEN)** ✅

## Phase 4 — Verify

- `dotnet build AIHub\AIHub.csproj`: **PASS** (0 warning, 0 error)
- Regression `dotnet test AIHub.Tests`: **PASS 11/11**
- Tác động phụ: `ITrendingService` chỉ có consumer duy nhất `Home.razor` (+ DI `Program.cs`) → **không ảnh hưởng INDIRECT files**
- `AIHub.E2ETests/` **không tồn tại** → E2E không áp dụng

## Phase 5 — Test

| Hạng mục | Kết quả |
|----------|---------|
| bUnit/xUnit (`AIHub.Tests`) | **11/11 PASS** (5 Home + 6 TrendingService) |
| E2E | **SKIP** — project `AIHub.E2ETests/` không tồn tại (chỉ có `JapaneseLearner.E2ETests` — project khác) |
| Coverage | Line **58.5%** overall; bug-path: GetTrendingAsync 100%, LoadPageAsync 86.8%, RetryAsync 100%, FetchFromSourceAsync 83.9%, TrendGrid 91.7%. Component chưa phủ: TrendCard/TimeFilterTabs/App/MainLayout (test project mới chỉ phủ bug path) |

## Phase 6 — Learning

- LSN-026 appended vào `.opencode/knowledge/lessons.md`
