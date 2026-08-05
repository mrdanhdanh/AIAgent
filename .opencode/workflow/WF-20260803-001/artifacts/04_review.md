# Phase 4: Review — AIHub Plan Evaluation

## Output Contract

```yaml
decision: "CHANGES_REQUESTED"
scores:
  completeness: 7
  accuracy: 9
  safety: 8
  efficiency: 9
  testability: 8
  overall: 8.2
score_rationale:
  completeness: >
    Thiếu step tạo Program.cs — file CRITICAL cho Blazor WASM entry point.
    Step 4 chỉ đề cập _Imports.razor và App.razor nhưng không có Program.cs.
    Cần bổ sung step riêng cho Program.cs (DI registration, FluentUI setup).
  safety: >
    Edge case API trả về 403 rate limit đã được mô tả ở design nhưng không có
    logic xử lý cụ thể trong TrendingService step. Service nên check HTTP status
    code và throw custom exception để UI hiển thị banner warning.
consistency_checks:
  contract_match: true
  file_path_match: false
  dependency_valid: true
issues:
  - id: "#01"
    severity: "MAJOR"
    category: "CONSISTENCY"
    blocking: true
    fix_priority: 1
    affected_phase: "PLAN"
    description: >
      Thiếu Program.cs trong danh sách steps. File này là entry point CRITICAL
      cho Blazor WASM — chứa DI registration (FluentUI, HttpClient, TrendingService).
      Nếu thiếu, project sẽ không thể chạy.
    suggestion: >
      Thêm step mới giữa step 4 và step 5: "Tạo Program.cs — entry point với DI registration".
      action: CREATE, file: AIHub/Program.cs.
      Logic: builder.Services.AddFluentUIComponents(), AddScoped<ITrendingService, TrendingService>(),
      AddScoped<HttpClient>, RootComponents.Add<App>("#app").

  - id: "#02"
    severity: "MINOR"
    category: "DESIGN"
    blocking: false
    fix_priority: 2
    affected_phase: "PLAN"
    description: >
      Step 4 description nói "Tạo _Imports.razor và App.razor" nhưng field file chỉ có
      "AIHub/_Imports.razor". App.razor không được liệt kê riêng. Nên tách thành
      2 step hoặc cập nhật field file thành danh sách.
    suggestion: "Tách step 4 thành: step 4a _Imports.razor, step 4b App.razor + Program.cs"

  - id: "#03"
    severity: "MINOR"
    category: "SECURITY"
    blocking: false
    fix_priority: 3
    affected_phase: "PLAN"
    description: >
      TrendingService step 8 không đề cập xử lý HTTP status code cụ thể.
      GitHub API rate limit trả về 403 với header X-RateLimit-Remaining=0.
      Cần check status code và throw custom RateLimitExceededException để UI xử lý.
    suggestion: >
      Thêm vào logic step 8: kiểm tra response.StatusCode, nếu 403,
      đọc X-RateLimit-Remaining, throw RateLimitExceededException.
      Home.razor catch exception này → hiển thị banner "API rate limit exceeded, showing cached data".

  - id: "#04"
    severity: "MINOR"
    category: "PERFORMANCE"
    blocking: false
    fix_priority: 3
    affected_phase: "PLAN"
    description: >
      Step 12 (TrendGrid) dùng JS interop cho IntersectionObserver nhưng chưa
      đề cập Dispose pattern để cleanup observer khi component dispose.
      Leak JS references có thể gây memory issue khi navigate away.
    suggestion: >
      Implement IDisposable/IAsyncDisposable trong TrendGrid, gọi JS interop
      để unobserve sentinel element trong DisposeAsync().

missing_info: []
required_updates:
  - "Thêm Program.cs vào step plan (bắt buộc)"
  - "Tách hoặc cập nhật step 4 để rõ file list"
edge_cases_checked:
  - "API error/offline → cache fallback ✅"
  - "Empty results → empty state ✅"
  - "All filtered → no results message ✅"
  - "Rapid search → debounce 300ms ✅"
  - "Rapid scroll → loading flag ✅"
  - "Mobile responsive → breakpoints ✅"
not_covered_risks:
  - "Rate limit 403 specific handling (có design nhưng thiếu plan detail)"
  - "Memory leak từ JS interop observer không cleanup"
recommendation: "REVISE_PLAN"
next_step: "Cập nhật plan (thêm Program.cs), sau đó re-review hoặc auto-approve nếu chỉ là MINOR issues"
summary: >
  Kế hoạch thiết kế tốt, 16 steps đủ rõ ràng, dependency tree hợp lý.
  Tuy nhiên thiếu CRITICAL file Program.cs — nếu không bổ sung, builder sẽ không tạo
  được entry point và project không chạy được. Ngoài ra có 3 MINOR issues về
  consistency (file list step 4), security (rate limit handling), performance (JS cleanup).
  Điểm overall 8.2 — quyết định CHANGES_REQUESTED với 1 issue MAJOR blocking.
  Sau khi sửa → APPROVED.
```
