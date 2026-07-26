# Japanese Learner — Agent Guide

## Project structure

- `JapaneseLearner/` — .NET 10 Blazor WebAssembly app (FluentUI 4.14.3)
- `JapaneseLearner.Tests/` — xUnit + bUnit unit tests (Moq)
- `JapaneseLearner.E2ETests/` — Playwright E2E tests (auto-starts dev server)
- `TestOneDrive/` — unrelated Blazor WASM app; ignore
- `.opencode/` — dev-team skill (Vietnamese), agent definitions, knowledge base

No `.sln` file. Build/run/test per-project with `dotnet`.

## Build & run

```powershell
dotnet build JapaneseLearner\JapaneseLearner.csproj
dotnet run --project JapaneseLearner\JapaneseLearner.csproj --urls "http://localhost:5173"
```

Default dev port is 5146 (launchSettings.json), but E2E tests hardcode 5173 in `AppFixture.cs`.

## Tests

```powershell
# Unit tests (fast, no server needed)
dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj

# E2E tests — AppFixture auto-starts the dev server (port 5173 hardcoded)
dotnet test JapaneseLearner.E2ETests\JapaneseLearner.E2ETests.csproj
```

- E2E Playwright browser path hardcoded in `PlaywrightFixture.cs:24` — will fail on other machines.
- `BunitTestBase` sets up **FluentUI** JSInterop mocks (8 modules). Use as base for bUnit component tests.
- `MockStorageService` implements `ILocalStorageService` for service-layer tests without browser storage.

## Architecture notes

- **FluentUI 4.14.3** — not MudBlazor. Main components: `FluentButton`, `FluentSelect<TOption>`, `FluentDialog`, `FluentProgressRing`, `FluentDesignTheme`, `FluentNavMenu`/`FluentNavLink`. Uses `Appearance` enum (`.Accent`, `.Lightweight`, `.Neutral`).
- **Service-Interface DI**: `ICharService`/`CharService`, `IWordService`/`WordService` — `AddScoped` in `Program.cs`. Adding a new service requires touching `Program.cs`.
- **Cache-first storage**: Services cache in-memory, persist to `Blazored.LocalStorage`. Seed data on first load. Write-through on every mutation.
- **Tri-state rendering**: Each page handles Loading → Empty → Data via `isLoading` + `list.Count == 0`.
- **Inline `<style>` blocks**: All pages define styles inline (not CSS isolation files).
- `JapaneseWord.Level` is set but **never read** by business logic — dead field.
- Vocabulary meanings are in **Vietnamese**.

## Routes

| Path | Component | Description |
|------|-----------|-------------|
| `/` | `Home.razor` | Hiragana/Katakana flashcard quiz |
| `/words` | `WordStudy.razor` | Vocabulary flashcard quiz (7 type tabs) |
| `/admin` | `Admin.razor` | CRUD for chars and words (2-tab layout) |

## .opencode conventions

- Agent definitions in `.opencode/agents/` (Vietnamese). Dev-team workflow in `.opencode/skills/dev-team/SKILL.md`.
- Knowledge base at `.opencode/knowledge/` stores lessons and patterns from past workflows.
- Model: `opencode/deepseek-v4-flash-free` (was `anthropic/claude-sonnet-4-6` — see `opencode.json.bak`).

## Pre-Push Review (GitGuard)

Trước khi commit/push lên git, chạy `/team-gitguard` để review:
- **Secrets scan**: API keys, tokens, passwords, private keys
- **Convention check**: FluentUI, DI, tri-state, style rules
- **Security scan**: XSS, SQL injection, unsafe patterns
- **Code quality**: null checks, magic values, dead code
- **Build/test**: dotnet build + test

Output verdict: `PASS` | `BLOCKED` | `WARNING`. CRITICAL issues → BLOCKED (không cho push).

Chi tiết: `.opencode/skills/gitguard/SKILL.md`

## Workspace Cleanup

Chạy `/team-cleanup` để dọn rác Workspace:
- **Cấp 1** (an toàn): `bin/`, `obj/`, `TestResults/`
- **Cấp 2** (cần backup): Backup cũ, log files, temp zip
- **Cấp 3** (cần xác nhận): `release/`, `publish/`, NuGet cache

Flags: `--dry-run`, `--force`, `--target <type>`, `--keep-backup <N>`, `--aggressive`, `--older-than <days>`

Chi tiết: `.opencode/skills/workspace-cleaner/SKILL.md`
