---
name: dotnet
description: >
  .NET ecosystem notes cho AIOS dev — .NET 10, Blazor WASM, DI, build/test workflows.
  Áp dụng khi làm việc với JapaneseLearner hoặc code .NET nói chung.
tags: [dotnet, csharp, blazor, wasm, build, test]
---

# .NET

## Runtime & Target

- Dự án dùng **.NET 10** (Blazor WebAssembly) — không dùng .NET 5-9.
- Build per-project (không có `.sln`): `dotnet build JapaneseLearner\JapaneseLearner.csproj`.
- Run dev server: `dotnet run --project JapaneseLearner\JapaneseLearner.csproj --urls "http://localhost:5173"`.

## Cấu trúc project

| Project | Vai trò |
|---------|---------|
| `JapaneseLearner/` | Blazor WASM app (FluentUI 4.14.3) |
| `JapaneseLearner.Tests/` | xUnit + bUnit unit tests (Moq) |
| `JapaneseLearner.E2ETests/` | Playwright E2E tests (auto-start dev server) |

## Dependency Injection

- Service-Interface DI: `ICharService`/`CharService`, `IWordService`/`WordService` — `AddScoped` trong `Program.cs`.
- Thêm service mới bắt buộc đăng ký ở `Program.cs` (điểm hay quên).
- Services cache-first: cache in-memory → persist `Blazored.LocalStorage` → seed data lần đầu.
- Progress: `GetAllAsync` nhận optional `IProgress<int>` cho seed data lớn.

## Test conventions

- Unit test: `dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj` — không cần server/browser.
- Filter 1 class: `--filter "FullyQualifiedName~WordQuizTests"`.
- bUnit: `BunitTestBase` setup sẵn 9 FluentUI JSInterop mocks.
- E2E: `AppFixture` chờ server tối đa 90s; port 5173 hardcode — không đổi.
