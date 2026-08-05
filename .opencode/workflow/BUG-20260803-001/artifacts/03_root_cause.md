# BUG-20260803-001 — Phase 2: Root Cause + Fix Proposal

## Root Cause

**Cả 2 symptom ("không load được" + "nội dung rỗng") cùng một gốc: data-fetch pipeline nuốt lỗi im lặng — không timeout, không error state, không retry.**

Chuỗi nguyên nhân:

| # | File | Dòng | Vấn đề |
|---|------|------|--------|
| 1 | `AIHub/Services/TrendingService.cs` | 99-116 | `FetchFromSourceAsync` trả `new List<TrendingItem>()` im lặng khi HTTP 403 (GitHub Search API unauth rate-limit = 10 req/min) hoặc bất kỳ exception nào |
| 2 | `AIHub/Services/TrendingService.cs` | 159-162 | `ParseGitHubResponse` nuốt parse error, trả empty |
| 3 | `AIHub/Services/TrendingService.cs` | 42-45 | `GetTrendingAsync` gộp kết quả 3 sources — nếu tất cả fail → trả list rỗng, **không thông tin lỗi** |
| 4 | `AIHub/Pages/Home.razor` | 64-82 | `LoadPageAsync` catch `{ _hasMore = false; }` — nuốt exception, không set error state |
| 5 | `AIHub/Program.cs` | 10 | HttpClient **không cấu hình Timeout** (mặc định 100s) → khi API chậm, UI treo "Fetching trending items..." tới 100s |

**Hệ quả người dùng thấy:**
- **"Không load được":** spinner "Fetching trending items..." treo lâu (HttpClient timeout 100s, GitHub chậm/rate-limit) → rồi chuyển sang empty.
- **"Load toàn nội dung ra rỗng":** tất cả 3 sources fail (403 rate-limit) → `_allItems` rỗng → UI hiển thị empty state "No trending items" — **không thông báo lỗi, không nút retry, không phân biệt được "không có dữ liệu" vs "load thất bại"**.

## Impact Scope

- **DIRECT:** `AIHub/Pages/Home.razor`, `AIHub/Services/TrendingService.cs`, `AIHub/Services/ITrendingService.cs`, `AIHub/Program.cs`
- **INDIRECT:** `AIHub.Tests/` (mới tạo)
- Consumer duy nhất của `ITrendingService`: `Home.razor`. Không ảnh hưởng component khác.

## Fix Proposal

```yaml
fix_proposal:
  root_cause: "Data-fetch pipeline nuốt lỗi im lặng: không HTTP timeout, service trả empty khi fail, UI không có error state/retry"
  evidence:
    - file: "AIHub/Pages/Home.razor"
      line: 78
      snippet: "catch { _hasMore = false; }"
    - file: "AIHub/Services/TrendingService.cs"
      line: 100
      snippet: "return new List<TrendingItem>(); // Rate limited — skip this source"
    - file: "AIHub/Program.cs"
      line: 10
      snippet: "new HttpClient { BaseAddress = ... } // no Timeout"
  hypothesis_confidence: 0.92
  proposed_changes:
    - file: "AIHub/Program.cs"
      action: "MODIFY"
      logic: "Thêm Timeout = TimeSpan.FromSeconds(20) cho HttpClient — chống spinner treo vô hạn"
      requires_backup: true
    - file: "AIHub/Services/ITrendingService.cs"
      action: "MODIFY"
      logic: "Thêm HasFailures (bool), LastError (string?), FailedSourceCount (int), ResetErrorState()"
      requires_backup: true
    - file: "AIHub/Services/TrendingService.cs"
      action: "MODIFY"
      logic: >
        Theo dõi lỗi per-source trong FetchFromSourceAsync (403/exception -> ghi nhận tên source + lỗi);
        GetTrendingAsync reset flags đầu call, set HasFailures/LastError/FailedSourceCount khi source fail;
        giữ nguyên cache + fallback GetDefaultSources.
      requires_backup: true
    - file: "AIHub/Pages/Home.razor"
      action: "MODIFY"
      logic: >
        Thêm trạng thái _hasError/_errorMessage;
        LoadPageAsync catch -> set error state thay vì nuốt im lặng;
        sau load: nếu list rỗng + service.HasFailures -> hiển thị error state (message + nút Retry) thay vì empty state;
        nút Retry gọi reload lại trang 1;
        giữ tri-state Loading -> Error -> Empty -> Data.
      requires_backup: true
    - file: "AIHub.Tests/HomeErrorStateTests.cs"
      action: "MODIFY"
      logic: "Bổ sung test verify error state + retry hoạt động (GREEN), test empty state thật vẫn đúng"
      requires_backup: false
    - file: "AIHub.Tests/TrendingServiceTests.cs"
      action: "CREATE"
      logic: "Unit test TrendingService: mock HttpClient trả 403/exception -> HasFailures=true, LastError có giá trị, không nuốt im lặng"
      requires_backup: false
  risk_assessment: "low"
  alternative_fixes:
    - "Chỉ sửa Home.razor (UI error state) không sửa service — nhưng UI không phân biệt được 'no data' vs 'fail' vì service không expose failure → fix không triệt để."
    - "Thêm fallback data offline tĩnh — nặng nề, vượt phạm vi bug."
```

## Approval Gate

**Chờ user duyệt:** `APPROVE` → Phase 3 (backup + fix) | `REJECT` → dừng | `MODIFY` → sửa proposal
