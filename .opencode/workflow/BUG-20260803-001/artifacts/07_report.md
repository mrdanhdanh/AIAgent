# BUG-20260803-001 — Final Report

```yaml
status: "COMPLETE"
workflow_id: "BUG-20260803-001"
summary: >
  Bug "AIHub không load được hoặc load toàn nội dung ra rỗng" đã được tái hiện
  bằng failing test (RED), fix root cause (data-fetch pipeline nuốt lỗi im lặng),
  verify regression 11/11 PASS. Bug-path coverage cao; E2E không áp dụng do
  project chưa có AIHub.E2ETests.

bug_report:
  title: "AIHub không load được hoặc load toàn nội dung ra rỗng"
  module: "AIHub"
  severity: "P1"

reproduce:
  test_project: "AIHub.Tests (tạo mới — bUnit 2.7.2 + Moq)"
  test_file: "AIHub.Tests/HomeErrorStateTests.cs"
  test_name: "Home_WhenServiceThrows_ShowsErrorStateWithRetry"
  result_before_fix: "FAIL (RED) — silent empty state 'No trending items'"
  result_after_fix: "PASS (GREEN)"

root_cause:
  description: >
    Data-fetch pipeline nuốt lỗi im lặng: TrendingService trả list rỗng khi
    GitHub API 403 (rate-limit unauth 10 req/min) / exception; Home.razor
    catch nuốt exception không error state; HttpClient không Timeout (100s
    mặc định) → spinner treo. Tri-state thiếu nhánh Error.
  evidence:
    - file: "AIHub/Services/TrendingService.cs"
      line: 100
      snippet: "return new List<TrendingItem>(); // Rate limited — skip this source"
    - file: "AIHub/Pages/Home.razor"
      line: 78
      snippet: "catch { _hasMore = false; }"
    - file: "AIHub/Program.cs"
      line: 10
      snippet: "new HttpClient { BaseAddress = ... } // no Timeout"

fix_applied:
  - file: "AIHub/Program.cs"
    action: "MODIFY"
    description: "HttpClient Timeout = 20s — chống spinner treo vô hạn"
  - file: "AIHub/Services/ITrendingService.cs"
    action: "MODIFY"
    description: "Thêm HasFailures, LastError, FailedSourceCount, ResetErrorState()"
  - file: "AIHub/Services/TrendingService.cs"
    action: "MODIFY"
    description: "RecordFailure per-source (403/exception); reset flags đầu request; không cache kết quả fail"
  - file: "AIHub/Pages/Home.razor"
    action: "MODIFY"
    description: "Error state (message + detail + nút Retry); phân biệt no-data vs load-fail; pagination-fail giữ grid cũ"
  - file: "AIHub.Tests/HomeErrorStateTests.cs"
    action: "MODIFY"
    description: "5 tests: error-on-throw, error-on-flag, empty-without-fail, data-grid, retry-reload"
  - file: "AIHub.Tests/TrendingServiceTests.cs"
    action: "CREATE"
    description: "6 tests: 403/exception → HasFailures; không cache fail; cache hit; ResetErrorState"
  - file: "AIHub.Tests/TestHelpers/MockHttpMessageHandler.cs"
    action: "CREATE"
    description: "HttpMessageHandler giả lập route theo URL + đếm request"

verify:
  regression_result: "PASS (11/11)"
  build: "PASS — 0 warning, 0 error"
  affected_components: ["Home.razor", "TrendingService", "ITrendingService", "Program.cs"]
  side_effects: "Không — ITrendingService chỉ 1 consumer (Home.razor)"

test_results:
  bunit:
    total: 11
    passed: 11
    failed: 0
    coverage_line: "58.5% (overall) — bug-path: GetTrendingAsync 100%, LoadPageAsync 86.8%, RetryAsync 100%, FetchFromSourceAsync 83.9%, TrendGrid 91.7%"
    thresholds_met: false  # overall < 80% do component chưa phủ (TrendCard/TimeFilterTabs/App/MainLayout) — test project mới
  e2e:
    total: 0
    passed: 0
    failed: 0
    note: "SKIP — project AIHub.E2ETests không tồn tại (chỉ có JapaneseLearner.E2ETests cho project khác)"

coverage: "58.5% line (overall); bug-path >= 83%"

next_steps:
  - "Mở rộng AIHub.Tests: component tests cho TrendCard, TimeFilterTabs, SearchBar, MainLayout (nâng coverage ≥ 80%)"
  - "Tạo AIHub.E2ETests (Playwright) nếu muốn E2E coverage cho AIHub"
  - "Xem xét thêm fallback data offline hoặc retry có backoff khi GitHub rate-limit"
  - "Chạy /team-gitguard trước khi commit (AIHub/ + AIHub.Tests/ hiện untracked)"

issues:
  - "Warning NU1902: bunit → AngleSharp 1.4.0 moderate vulnerability (dependency transitive — nằm ngoài phạm vi bug)"
