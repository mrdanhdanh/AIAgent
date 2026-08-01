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
