# Phase 10: Test Plan

```yaml
status: "PASS"
summary: >
  Greenfield project — no existing tests. Recommended: create AIHub.Tests/ project with bUnit
  component tests for TrendCard, TrendGrid, SearchBar, Home page. E2E tests with Playwright
  for full flow. Priority: HIGH — add bUnit tests for at least TrendCard.
test_types:
  - "Unit (bUnit): TrendCard rendering, SearchBar debounce, Home page state"
  - "Integration: TrendingService GitHub API mock tests"
  - "E2E (Playwright): full flow load → search → filter → scroll"
test_cases:
  - "TC001: TrendCard renders Small/Medium/Large based on Score"
  - "TC002: TrendCard click opens URL in new tab"
  - "TC003: SearchBar debounce 300ms"
  - "TC004: Home page shows loading → data → empty states"
  - "TC005: TimeFilterTabs switch triggers data reload"
  - "TC006: TrendGrid infinite scroll loads next page"
```
