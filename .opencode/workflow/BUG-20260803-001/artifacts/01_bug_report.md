# BUG-20260803-001 — Bug Report

**Workflow ID:** BUG-20260803-001
**Project:** AIHub (Blazor WASM, FluentUI 4.14.3)
**Branch:** NewVersion
**Phase:** 1 (Reproduce — RED confirmed)

## Bug Report (chuẩn hóa)

```yaml
bug_report:
  title: "AIHub không load được hoặc load toàn nội dung ra rỗng"
  module: "AIHub"
  screen: "/ (AIHub Home)"
  severity: "P1"
  description: >
    AIHub không load được (spinner treo) hoặc load ra toàn nội dung rỗng
    (empty state "No trending items" không kèm thông báo lỗi).
  steps_to_reproduce:
    - "Mở AIHub tại localhost:5190"
    - "OnInitializedAsync -> TrendingService.GetTrendingAsync gọi GitHub Search API (3 sources)"
    - "GitHub API trả 403 (rate limit unauth = 10 req/min) hoặc lỗi mạng"
    - "Service trả list rỗng im lặng; UI hiển thị empty state 'No trending items'"
  expected: "App load và hiển thị danh sách trending items; khi API lỗi -> error state + retry"
  actual: "Không load được (spinner treo tới 100s do không có HTTP timeout) HOẶC empty state rỗng im lặng"
  environment: "Giả định: browser (Blazor WASM client-side)"
  evidence: "RED test AIHub.Tests/HomeErrorStateTests.cs"
```

## Field validation

| Field | Trạng thái |
|-------|-----------|
| title | OK |
| module | OK (AIHub — project riêng, map ngoài danh sách chuẩn) |
| description | OK |
| expected | Giả định (từ product semantics) — cần user xác nhận |
| actual | OK (từ description) |
| steps_to_reproduce | Giả định từ code — xác nhận bằng RED test |
