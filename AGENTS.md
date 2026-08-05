# Japanese Learner — Agent Guide

## Project structure

- `JapaneseLearner/` — .NET 10 Blazor WebAssembly app (FluentUI 4.14.3)
- `JapaneseLearner.Tests/` — xUnit + bUnit unit tests (Moq)
- `JapaneseLearner.E2ETests/` — Playwright E2E tests (auto-starts dev server)
- `.opencode/` — agent definitions (Vietnamese), skills, commands, knowledge base

No `.sln` file. Build/run/test per-project with `dotnet`.

## Build & run

```powershell
dotnet build JapaneseLearner\JapaneseLearner.csproj
dotnet run --project JapaneseLearner\JapaneseLearner.csproj --urls "http://localhost:5173"
```

Default dev port is 5146 (launchSettings.json), but E2E tests hardcode 5173 in `AppFixture.cs` — don't change that port.

## Tests

```powershell
# Unit tests (fast, no server needed)
dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj

# Single unit test class/method (xUnit --filter)
dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj --filter "FullyQualifiedName~WordQuizTests"

# E2E tests — AppFixture auto-starts the dev server (port 5173 hardcoded)
dotnet test JapaneseLearner.E2ETests\JapaneseLearner.E2ETests.csproj
```

- E2E tests share a single `AppFixture` via the `E2E` xUnit collection (`DisableParallelization = true`) — one dev server per run. Slow: `AppFixture` waits up to **90s** for the server to come up; a bad build fails loudly with the server's stderr.
- E2E Playwright browser path hardcoded in `PlaywrightFixture.cs:24` — will fail on other machines.
- E2E must run from a machine with Playwright browsers installed; unit tests need no server or browser.
- `BunitTestBase` sets up **FluentUI** JSInterop mocks (9 modules). Use as base for bUnit component tests.
- `MockStorageService` implements `ILocalStorageService` for service-layer tests without browser storage.

## Routes

| Path | Component | Description |
|------|-----------|-------------|
| `/` | `Home.razor` | Landing page with nav cards |
| `/alphabet` | `AlphabetStudy.razor` | Hiragana/Katakana flashcard quiz |
| `/alphabet/quiz` | `AlphabetQuiz.razor` | Hiragana/Katakana quiz |
| `/words` | `WordStudy.razor` | Vocabulary flashcard quiz (7 type tabs) |
| `/words/quiz` | `WordQuiz.razor` | Multiple-choice word quiz |
| `/kanji` | `KanjiStudy.razor` | Kanji study list |
| `/kanji/{Id:int}` | `KanjiDetail.razor` | Single kanji detail |
| `/kanji/quiz` | `KanjiQuiz.razor` | Multiple-choice kanji quiz |
| `/grammar` | `GrammarStudy.razor` | Grammar pattern study list |
| `/grammar/{Id:int}` | `GrammarDetail.razor` | Single grammar detail |
| `/practice` | `Practice.razor` | Practice hub |
| `/practice/train` | `Training.razor` | Guided training |
| `/admin` | `Admin.razor` | CRUD for chars, words, kanji, grammar (4-tab layout) |

## Architecture notes

- **FluentUI 4.14.3** — not MudBlazor. Main components: `FluentButton`, `FluentSelect<TOption>`, `FluentDialog`, `FluentProgressRing`, `FluentDesignTheme`, `FluentNavMenu`/`FluentNavLink`. Uses `Appearance` enum (`.Accent`, `.Lightweight`, `.Neutral`).
- **Service-Interface DI**: `ICharService`/`CharService`, `IWordService`/`WordService`, `IKanjiService`/`KanjiService`, `IGrammarService`/`GrammarService`, `IThemeService`/`ThemeService` — `AddScoped` in `Program.cs`. Adding a new service requires touching `Program.cs`.
- **Cache-first storage**: Services cache in-memory, persist to `Blazored.LocalStorage`. Seed data on first load. Write-through on every mutation.
- **Progress reporting**: `WordService`, `KanjiService`, and `GrammarService` all accept optional `IProgress<int>` in `GetAllAsync` for large seed data loads.
- **Failure Learning System** (`.opencode/memory/`): failure records (`failures/BUG-*.md`) → lessons (`lessons/`) + patterns (`patterns/`). Pipeline 1 lệnh: `/team-bug-learn` (normalize+hash → classify → root cause → ghi record → sinh lessons/patterns → self-improve). Chạy sau mỗi lần fix bug; tự động gợi ý sau `/team-bugfix` Phase 6. Workflow engine chạy 2 phase tự động: `failure_analysis` (failure-agent) + `learning` (learning-agent) trong `default.workflow.yaml`.
- **Tri-state rendering**: Each page handles Loading → Empty → Data via `isLoading` + `list.Count == 0`.
- **CSS**: `MainLayout.razor.css` (CSS isolation for layout); all pages use inline `<style>` blocks.
- **ThemeService**: dark mode toggle, persisted via `Blazored.LocalStorage`, uses `FluentDesignTheme` component.
- Vocabulary meanings are in **Vietnamese**.
- `JapaneseWord.Level` is set in Admin CRUD UI but never read by quiz/filter logic — display-only field.

## .opencode conventions

- Agent definitions in `.opencode/agents/` (Vietnamese). Dev-team workflow runs via **Workflow Engine v4** (see below); `.opencode/skills/dev-team/SKILL.md` giữ bản 13 bước cũ làm reference.
- Knowledge base at `.opencode/knowledge/` stores lessons and patterns from past workflows.
- Default model: `opencode-go/deepseek-v4-pro` (Planner/Architect/Reviewer/Analyst tiers); `opencode-go/deepseek-v4-flash` (Coder/Tester/Routine tiers).
- **Free model toggle**: `/model-policy enable|disable|status` — bật/tắt `opencode-go/deepseek-v4-flash` cho toàn bộ agent. Nguồn sự thật: `.opencode/model-policy/settings.json` (`free_model_enabled`). Script `.opencode/scripts/model-policy.ps1` rewrite model trong `opencode.json` + `.opencode/agents/*.md`; phải restart opencode session sau khi đổi.

## Workflow Engine v4

- **`/team`** là thin launcher chạy qua **Workflow Engine v4** (`.opencode/workflow-engine/` 8 modules: README, engine, loader, validator, executor, phase-runner, state-machine, recovery) thay cho body 13 bước cũ. Cách dùng: `/team <yêu cầu> [--workflow <default|bugfix|feature|ui|docs|documentation>]`.
- **Definitions** tại `.opencode/workflow/definitions/*.yaml` — khai báo phase, agent/command, depends_on, retry. Schema contract tại `.opencode/workflow/schemas/workflow.schema.yaml` (v4.0, `default_workflow: default`).
- **Runtime contexts** (`workflow.json`, `state.json`, artifacts) nằm trong `.opencode/workflow/WF-*/` — do engine tạo, KHÔNG sửa tay. `WF_CONTEXT_ROOT` env override root (cho smoke-test chạy trong `$env:TEMP`).
- **Validator**: `.opencode/scripts/workflow-validator.ps1` (parser YAML subset, không dùng ConvertFrom-Yaml — module không available trên PS 5.1). Chạy PASS 6/6 definitions (default, bugfix, feature, ui, docs, documentation), exit 0. `schema-validator.ps1` là tool legacy false-positive — KHÔNG dùng làm gate cho engine docs.
- **Error codes**: WF-ERR-001..009 (không viết `#` trước WF-ID/WF-ERR trong tài liệu).
- **Quy ước file**: UTF-8 no-BOM, spaces (2-space indent) không tab, mọi .md có frontmatter (name, description, agent).
- **Migration/rollback**: `.opencode/workflow/MIGRATION_GUIDE.md` — restore nhanh team.md + sync-system-docs.ps1 từ `.opencode/backup/<WF-ID>/`.
- Các lệnh thành phần chạy riêng: `/team-analyze`, `/team-plan`, `/team-review`, `/team-build`, `/team-ui-audit`, `/team-testplan`, `/team-test`, `/team-selfimprove`, `/team-gitguard`, `/team-gitpush`, `/team-syncdocs`.
- **`/doctor`**: kiểm tra sức khỏe hệ thống AI Agent Framework — Environment, Agents, Commands, Skills, Knowledge, Workflow, Contracts, Runtime (simulation), Capability (benchmark). Có health score + self-repair an toàn. Alias: `/team-doctor`. Chi tiết: `.opencode/commands/doctor.md`.

## QA Testing Commands

Bộ QA commands (test E2E, màn hình, giao diện, màu sắc theo quy chuẩn) — chia thành Skill (năng lực) + Command (quy trình), không dùng agent test đơn lẻ:

| Command | Mô tả | Skill liên quan |
|---------|-------|-----------------|
| `/test-plan` | Sinh kế hoạch test: requirement → matrix → scenario → boundary → edge → priority | test-data-generator |
| `/test-e2e` | Pipeline E2E: requirement → Playwright → fixture → run → report (`--component` cho bUnit) | playwright-e2e, playwright-component, test-report |
| `/test-ui` | Review UI/UX/consistency/responsive/accessibility (`--validate`, `--responsive`, `--quick`) | ui-review, design-system-validator, responsive-layout, accessibility |
| `/test-visual` | Visual regression: screenshot → compare → diff → report (`--update-snapshots`, `--analyze`, `--dark`) | visual-regression, screenshot-analyzer |
| `/test-accessibility` | Axe scan → WCAG AA/AAA report → fix suggestion | accessibility |
| `/test-cross-browser` | Chrome/Edge/Firefox/Safari + mobile (`--browsers`, `--mobile`) | browser-compatibility |
| `/test-regression` | Chọn module ảnh hưởng → regression cases → run → report | test-data-generator |
| `/doctor-test` | QA health: thiếu test, duplicate, flaky, timeout, coverage thấp, hardcode wait... (Health Score) | flaky-test-detector, test-report |
| `/approve-test` | Gate cuối: coverage ≥80%, no flaky, no a11y error, no visual diff, no failed E2E | test-report |
| `/test-bootstrap` | Phát hiện framework UI, sinh cấu hình Playwright + PO + fixture ban đầu | playwright-e2e |
| `/test-evolve` | Diff source vs test hiện có → cập nhật/lỗi thời/sinh test mới | playwright-e2e, flaky-test-detector |
| `/test-audit` | Đánh giá coverage/duplication/maintainability/runtime/flaky → improvement plan | flaky-test-detector, test-report |

**Lưu ý QA:** port 5173 hardcode trong `AppFixture.cs` (không đổi), browser path hardcoded `PlaywrightFixture.cs:24` (fail trên máy khác). Chạy unit test trước E2E.

## Knowledge Assistant Commands

Hỏi đáp về codebase bằng bằng chứng (evidence-based, kèm `file:line`). Trước khi dùng, chạy `/knowledge-index` để build chỉ mục (7 loại index trong `.opencode/knowledge-index/`), sau đó `/knowledge-index --update` mỗi khi source thay đổi:

| Command | Mô tả | Skill liên quan |
|---------|-------|-----------------|
| `/ask <câu hỏi>` | Hỏi đáp tự do về module/API/screen/workflow | knowledge-assistant (pipeline tổng) |
| `/where <symbol>` | Tìm toàn bộ nơi sử dụng symbol (class/method/storage key) | search-engine, dependency-analyzer |
| `/why <component>` | Giải thích lý do thiết kế (doc + git history + code) | document-understanding, git-history |
| `/flow <nghiệp vụ>` | Sinh sequence + mermaid cho luồng hoạt động | workflow-reader, search-engine |
| `/impact <component>` | Sinh affected list (API/Screen/Batch/Report/SP/Model/Test) | impact-analyzer, dependency-analyzer |
| `/explain <file>` | Giải thích từng method của file | code-understanding |
| `/trace <chức năng>` | Truy vết UI → API → Service → Repository → DB → Response | dependency-analyzer, code-understanding, database-reader |
| `/compare-doc <component>` | So sánh code hiện tại vs tài liệu thiết kế | document-understanding, code-understanding |
| `/knowledge-health` | Đánh giá thiếu README/diagram/flow/ADR/comment (Health Score) | document-understanding, search-engine |
| `/knowledge-index` | Build/update 7 loại index (`--update`, `--rebuild`, `--status`) | build-knowledge-index.ps1 |

**Nguyên tắc Knowledge Assistant:**
- Index = định vị nhanh; file gốc = bằng chứng — luôn đọc file gốc trước khi kết luận.
- Mọi câu trả lời kèm nguồn `file:line`; không suy đoán; không biết → nói rõ.
- Chạy `/knowledge-index --update` sau mỗi lần sửa source để index không lỗi thời.
- Chi tiết: `.opencode/skills/knowledge-assistant/SKILL.md`, `.opencode/knowledge-index/README.md`

## CI / Deploy

- GitHub Pages via `.github/workflows/deploy.yml` — triggers on push to `master`, publishes to `gh-pages` branch. Active dev work is on other branches (e.g. `NewVersion`); don't push directly to `master` unless a release is intended.
- Deploy runs `dotnet publish -c Release`, copies output under `/JapaneseLearner/` subpath, merges `gh-pages-root/` (`404.html`, `index.html`) over it, and rewrites `<base href>` to `/AIAgent/JapaneseLearner/`.
- .NET 10 omits the unhashed `blazor.webassembly.js` copy; the workflow manually copies the hashed version.

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
