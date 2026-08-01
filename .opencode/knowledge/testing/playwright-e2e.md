---
category: testing
last_updated: 2026-08-01
---

# Playwright E2E Testing

## Tổng quan

- Project: `JapaneseLearner.E2ETests/` — Playwright E2E tests
- Chạy: `dotnet test JapaneseLearner.E2ETests\JapaneseLearner.E2ETests.csproj`
- `AppFixture` tự khởi động dev server (port **5173** hardcode)

## Cấu trúc fixture

- `AppFixture.cs` — khởi động dev server ở port 5173 (hardcoded, không đổi nếu không update cả hai nơi)
- `PlaywrightFixture.cs:24` — browser path Playwright **hardcoded** theo máy — sẽ fail trên máy khác (cần config lại)

## Quy tắc

- Route chính để test: `/`, `/alphabet`, `/words`, `/words/quiz`, `/kanji`, `/kanji/quiz`, `/grammar`, `/admin`
- Không thay đổi port 5173 trong E2E trừ khi sửa cả `AppFixture.cs` và launchSettings
- E2E phụ thuộc environment máy — chạy unit tests trước khi chạy E2E

## QA Commands (WF-20260801-001)

Bộ QA commands chuyên sâu — xem chi tiết tại `.opencode/commands/`:

| Command | Mô tả |
|---------|-------|
| `/test-plan` | Sinh kế hoạch test (matrix → scenario → boundary → priority) |
| `/test-e2e` | Pipeline E2E: requirement → Playwright → fixture → run → report |
| `/test-ui` | Review UI/UX/consistency/responsive/accessibility |
| `/test-visual` | Visual regression: screenshot → compare → diff → report |
| `/test-accessibility` | Axe scan → WCAG AA/AAA report → fix suggestion |
| `/test-cross-browser` | Chrome/Edge/Firefox/Safari + mobile |
| `/test-regression` | Chọn module ảnh hưởng → regression cases → run → report |
| `/doctor-test` | QA health: 12 tiêu chí + Health Score + Risk |
| `/approve-test` | Gate cuối: coverage ≥80%, no flaky, no a11y error, no visual diff |
| `/test-bootstrap` | Phát hiện framework UI, sinh cấu hình Playwright + PO + fixture |
| `/test-evolve` | Diff source vs test → cập nhật/lỗi thời/sinh test mới |
| `/test-audit` | Đánh giá tổng thể bộ test → improvement plan |

### Skills QA (12)

`.opencode/skills/` — mỗi skill 1 năng lực tái sử dụng:
`playwright-e2e`, `playwright-component`, `visual-regression`, `ui-review`, `design-system-validator`, `accessibility`, `responsive-layout`, `browser-compatibility`, `screenshot-analyzer`, `test-data-generator`, `test-report`, `flaky-test-detector`.
