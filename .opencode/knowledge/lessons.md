---
last_updated: 2026-08-01
total_lessons: 25
---

# Lessons Learned

Kho bài học kinh nghiệm được tích lũy qua các workflow.

> **LƯU Ý MIGRATION (HISTORICAL):** Các lesson LSN-001, LSN-002, LSN-003, LSN-006, LSN-008, LSN-009
> mô tả lỗi và fix của framework **MudBlazor** — dự án đã migrate sang **FluentUI 4.14.3**.
> Chúng được giữ lại với trạng thái `deprecated` cho mục đích lịch sử và KHÔNG được áp dụng
> cho codebase hiện tại. Xem `knowledge/framework/fluentu/`, `knowledge/ui/fluentui-components.md`
> và `knowledge/ui/dark-mode-theming.md` cho pattern FluentUI hiện tại.

## Cấu trúc entry

```yaml
- lesson_id: LSN-{number}
  type: "success | failure | improvement | warning"
  workflow: "Yêu cầu gốc"
  situation: "Bối cảnh xảy ra"
  observation: "Điều đã quan sát được"
  action: "Hành động đã làm hoặc sẽ làm"
  tags: ["tag1", "tag2"]
```

## Danh sách bài học

- lesson_id: LSN-001
  type: "failure"
  status: "deprecated"
  framework: "MudBlazor (historical — migrated to FluentUI 4.14.3)"
  workflow: "Fix build lỗi Blazor WASM"
  situation: "Build gặp 5 lỗi: FontWeight int→string, App type not found, Defaults namespace"
  observation: "MudBlazor 9.7.0 dùng string cho FontWeight thay vì int; Program.cs cần `using JapaneseLearner;` để tìm App type; `using MudBlazor;` cần thiết cho Defaults.Classes"
  action: "Đổi FontWeight thành string (\"400\", \"700\", \"600\"), thêm using JapaneseLearner và using MudBlazor trong Program.cs"
  tags: ["blazor", "mudblazor", "build-error", "fontweight"]

- lesson_id: LSN-002
  type: "failure"
  status: "deprecated"
  framework: "MudBlazor (historical — migrated to FluentUI 4.14.3)"
  workflow: "Fix runtime IndexOutOfRangeException trong MudThemeProvider"
  situation: "App crash với System.IndexOutOfRangeException khi MudThemeProvider.GenerateTheme chạy"
  observation: "Shadow.Elevation array trong MudBlazor 9.7.0 phải có đúng 25 phần tử (index 0-24), nếu khai báo thiểu sẽ gây IndexOutOfRangeException vì MudBlazor truy cập tất cả indices để tạo CSS variables"
  action: "Xoá custom Shadows khỏi theme, dùng `Shadows = new Shadow()` mặc định"
  tags: ["blazor", "mudblazor", "runtime-error", "shadow", "theme"]

- lesson_id: LSN-003
  type: "failure"
  status: "deprecated"
  framework: "MudBlazor (historical — migrated to FluentUI 4.14.3)"
  workflow: "Fix runtime missing MudPopoverProvider"
  situation: "PopoverService báo lỗi Missing <MudPopoverProvider /> trong render tree"
  observation: "MudBlazor yêu cầu <MudPopoverProvider /> trong layout để popover/dropdown hoạt động"
  action: "Thêm <MudPopoverProvider /> sau <MudThemeProvider /> trong MainLayout.razor"
  tags: ["blazor", "mudblazor", "runtime-error", "popover"]

- lesson_id: LSN-004
  type: "success"
  workflow: "Setup Dev Agent Team - Self-Improver Agent"
  situation: "Cần thêm agent self-improver vào opencode.json nhưng không biết cấu trúc đúng là object key hay array"
  observation: "Thực tế opencode.json dùng object với key là tên agent (analyst, planner, ...), không phải array. Mỗi agent là một object con với các trường description, mode, model, permission."
  action: "Đã thêm key 'self-improver' vào object 'agent' với permission giống builder (read, grep, glob, edit, bash đều allow) và model giống các agent khác."
  tags: ["opencode", "configuration", "agent-setup", "json-structure"]

- lesson_id: LSN-005
  type: "warning"
  workflow: "Thêm Word Service cho JapaneseLearner"
  situation: "Khi thêm IWordService/WordService mới, Program.cs cần được cập nhật với AddScoped đăng ký service, nếu không sẽ gây runtime lỗi DI resolution"
  observation: "Backup Program.cs chỉ có AddScoped<ICharService, CharService>() mà thiếu WordService. Service interface-implementation pair cần được đăng ký đồng bộ."
  action: "Thêm builder.Services.AddScoped<IWordService, WordService>(); sau dòng CharService. Luôn kiểm tra DI registration khi thêm service mới."
  tags: ["blazor", "di", "service-registration", "program.cs"]

- lesson_id: LSN-006
  type: "success"
  status: "deprecated"
  framework: "MudBlazor (historical — migrated to FluentUI 4.14.3)"
  workflow: "Thêm Word Study page + drawer navigation"
  situation: "Cần nâng cấp MainLayout từ layout đơn giản thành full drawer navigation với các nav link"
  observation: "MainLayout.razor cần thêm MudDrawer, MudNavMenu, MudNavLink và biến _drawerOpen để quản lý trạng thái drawer toggle. Home.razor cần icon button để mở drawer."
  action: "Đã thêm drawer layout với 3 nav links: Hiragana/Katakana, Word Study, Admin. Sử dụng @bind-Open và DrawerVariant.Temporary cho responsive."
  tags: ["blazor", "mudblazor", "navigation", "drawer", "layout"]

- lesson_id: LSN-007
  type: "improvement"
  workflow: "Thêm Word Service cho JapaneseLearner"
  situation: "Cần seed data cho JapaneseWord với đầy đủ 6 loại âm (Seion, Dakuon, Handakuon, Yoon, Sokuon, Choon) và nhiều từ vựng thực tế"
  observation: "WordService.GetDefaultData() dùng local function void Add(...) pattern để seed data gọn gàng. Mỗi từ có Characters, Romaji, Meaning, Type. Dữ liệu được tổ chức theo từng loại âm rõ ràng."
  action: "Áp dụng pattern: local function helper + block comments phân loại + id auto-increment. Seed data đa dạng (ngữ cảnh thực tế: trường học, động vật, đồ vật, v.v.)"
  tags: ["csharp", "pattern", "seed-data", "local-function", "japanese"]

- lesson_id: LSN-008
  type: "warning"
  status: "deprecated"
  framework: "MudBlazor (historical — migrated to FluentUI 4.14.3)"
  workflow: "Fix runtime IndexOutOfRangeException trong MudThemeProvider"
  situation: "App crash không rõ nguyên nhân khi load; không có stack trace chi tiết trong Blazor WASM release mode"
  observation: "Blazor WASM runtime errors (IndexOutOfRangeException, NullReferenceException) cần được debug bằng cách: 1) Chạy debug build, 2) Kiểm tra browser dev console, 3) Thử loại bỏ dần code để xác định nguyên nhân."
  action: "Khi gặp runtime crash Blazor WASM: build Debug, mở browser dev tools (F12) → Console tab → kiểm tra stack trace; nếu lỗi từ thư viện (MudBlazor), thử minimal config trước."
  tags: ["blazor", "debugging", "runtime-error", "wasm"]

- lesson_id: LSN-009
  type: "success"
  status: "deprecated"
  framework: "MudBlazor (historical — migrated to FluentUI 4.14.3)"
  workflow: "Fix 14 skipped bUnit tests - JS interop giới hạn"
  situation: "14 bUnit tests bị skip vì 'MudBlazor input interaction requires JS interop mock'"
  observation: "StateHasChanged() yêu cầu Blazor Dispatcher thread. Gọi private method qua reflection từ test thread gây InvalidOperationException. Cần dùng cut.InvokeAsync() để chạy code trên dispatcher. Wrong-answer path không gọi StateHasChanged() nên markup không tự render."
  action: "Dùng cut.InvokeAsync() wrapper cho mọi gọi hàm chứa StateHasChanged(). Dùng cut.Render() sau InvokeAsync để force render cho wrong-answer tests. Reflection pattern: SetField/GetField/RunAsync helpers."
  tags: ["bunit", "mudblazor", "blazor-testing", "dispatcher", "reflection"]

- lesson_id: LSN-010
  type: "failure"
  workflow: "Fix 14 skipped bUnit tests - JS interop giới hạn"
  situation: "WordStudyTests use PickRandomWord() chọn ngẫu nhiên từ 3 words, khiến correct-answer tests fail không deterministic"
  observation: "Component dùng new Random() để chọn currentWord từ list. Với 3 words, chỉ 1/3 có romaji = 'asa', 2/3 còn lại fail. HomeTests chỉ có 1 char nên luôn deterministic."
  action: "Giảm _testWords từ 3 xuống 1 word (romaji='asa') để đảm bảo deterministic. Nếu cần test nhiều word, override mock GetByTypeAsync per test."
  tags: ["bunit", "random", "deterministic-test", "flaky-test"]

- lesson_id: LSN-011
  type: "improvement"
  workflow: "Self-Improvement: phân tích knowledge base tổng thể"
  situation: "Phát hiện inconsistency giữa self-improver agent definition (self-improver.md) và SKILL.md: agent definition có `edit: allow` + bash: allow, nhưng nội dung prompt lại ghi 'KHÔNG được edit bất kỳ file nào'. Trong khi SKILL.md khuyến nghị approval gate cho mọi suggestion impact > LOW."
  observation: "self-improver.md permission (edit: allow, bash: allow) mâu thuẫn với nội dung prompt cấm edit. Agent prompt cần đồng bộ với permission thực tế. SKILL.md mô tả Design và Plan là 2 bước riêng (step 2, step 3) nhưng self-improver.md gộp chung thành review_design_result + review_plan_result."
  action: "Đã đồng bộ self-improver.md: frontmatter permission set `edit: allow, bash: allow`, prompt đổi 'KHÔNG được edit' thành 'KHÔNG tự ý edit file code — chỉ edit knowledge base sau khi suggestion được approve', gộp review_design_result + review_plan_result thành review_result duy nhất."
  tags: ["opencode", "consistency", "agent-config", "self-improver", "workflow"]
  resolved: true

- lesson_id: LSN-012
  type: "warning"
  workflow: "Self-Improvement: phân tích knowledge base tổng thể"
  situation: "Phát hiện thiếu kỹ năng E2E Playwright trong khi dự án đã có JapaneseLearner.E2ETests/ với PlaywrightFixture.cs"
  observation: "Dự án có E2E test dùng Playwright (port 5173 hardcode, browser path hardcode), nhưng không có skill entry nào về Playwright. E2E tests được nhắc đến trong AGENTS.md và SKILL.md nhưng không được document trong knowledge base. Khi builder/tester cần chạy E2E test, không có reference pattern nào."
  action: "Thêm SK-010 Playwright E2E Testing vào skills-learned.md. Cập nhật agent prompts để include E2E test patterns. E2E tests cồng kềnh hơn unit test, cần hướng dẫn cụ thể."
  tags: ["e2e", "playwright", "testing", "knowledge-gap", "documentation"]

- lesson_id: LSN-013
  type: "improvement"
  workflow: "Self-Improvement: phân tích knowledge base tổng thể"
  situation: "Các agent prompts (analyst, planner, builder, reviewer, tester, self-improver) có cấu trúc khác nhau: một số dùng YAML contract, một số dùng markdown. Một số agent có edge case section, một số không."
  observation: "analyst.md dùng YAML contract output. planner.md dùng YAML. reviewer.md dùng YAML. builder.md dùng YAML. tester.md dùng YAML. test-planner.md dùng YAML. codebase-explorer.md dùng markdown. self-improver.md dùng YAML. Không có template chuẩn cho agent definition."
  action: "Đã chuyển codebase-explorer.md từ markdown sang YAML contract format để đồng bộ với các agent khác."
  tags: ["opencode", "agent-design", "consistency", "template"]
  resolved: true

- lesson_id: LSN-014
  type: "improvement"
  workflow: "Tạo trang /words/quiz multiple-choice"
  situation: "WordQuizTests dùng reflection nhiều để test internal state (SetField, GetField, RunAsync)"
  observation: "Blazor component internal state (currentWord, _correctCount, _wrongCount, _remainingTime) chỉ có thể test qua reflection, khiến test code phức tạp và dễ hỏng khi refactor"
  action: "Thêm [InternalsVisibleTo] hoặc public/internal test helper methods trong component. Pattern: expose IsCorrectAnswer(string), GetCurrentOptions(), GetStats() cho unit test."
  tags: ["bunit", "testing", "reflection", "internalsvisibleto", "blazor-testing"]

- lesson_id: LSN-015
  type: "improvement"
  workflow: "Tạo trang /words/quiz multiple-choice"
  situation: "Timer 5s tự động chuyển câu chỉ được test qua unit test với InvokeAsync, không kiểm tra được timer behavior thực tế"
  observation: "bUnit có thể mock timer nhưng không verify được setTimeout behavior chính xác. Chỉ Playwright E2E test mới kiểm tra được luồng: chờ 5s → auto-next → card hiển thị câu mới."
  action: "Thêm E2E Playwright test: 1) Load trang /words/quiz, 2) Click tab, 3) Chờ 5 giây, 4) Verify câu mới xuất hiện, 5) Lặp lại. Dùng page.WaitForSelectorAsync với timeout > 5s."
  tags: ["e2e", "playwright", "timer", "testing", "blazor"]

- lesson_id: LSN-016
  type: "improvement"
  workflow: "Nâng cấp Agent System - 7 hướng (WF-20260726-001)"
  situation: "Workflow tạo deployment pipeline cho GitHub Pages (deploy.yml + 404.html + index.html redirect script) nhưng không có E2E test nào verify redirect, base href, page load sau redirect"
  observation: "Dự án đã có Playwright infrastructure (SK-010) và E2E test project (JapaneseLearner.E2ETests/), hoàn toàn có thể thêm test deployment verification. Thiếu E2E coverage khiến lỗi redirect loop hoặc base href sai không được phát hiện cho đến khi deploy fail."
  action: "Thêm E2E Playwright test cho deployment: 1) Verify 404.html redirect không tạo vòng lặp, 2) Dynamic base href hoạt động trên subpath, 3) App load được sau redirect, 4) SessionStorage redirect restore hoạt động."
  tags: ["e2e", "playwright", "deployment", "github-pages", "suggestion-approved"]

- lesson_id: LSN-017
  type: "improvement"
  workflow: "Nâng cấp Agent System - 7 hướng (WF-20260726-001)"
  situation: "Workflow khuyến nghị validate GitHub Actions YAML trước deploy (created knowledge/workflow/validate-github-actions-yaml.md), nhưng bản thân workflow không include step validate YAML syntax"
  observation: "GitHub Actions YAML syntax error không được phát hiện cho đến khi action chạy và fail trên GitHub. Cần thêm validate step vào dev-team workflow để phát hiện lỗi sớm."
  action: "Thêm YAML validation step vào SKILL.md workflow: dùng `dotnet tool install -g yamllint` hoặc action `github-actions-yaml-validator` để kiểm tra .github/workflows/*.yml trước khi commit/deploy."
  tags: ["github-actions", "yaml", "validation", "ci/cd", "suggestion-approved"]

- lesson_id: LSN-018
  type: "improvement"
  workflow: "Nâng cấp Analyst Agent contract lên schema v2.0 (WF-20260727-001)"
  situation: "7 agent contracts (analyst, planner, builder, reviewer, tester, test-planner, self-improver) có schema khác nhau, thiếu versioning field dẫn đến khó theo dõi thay đổi và backward compatibility"
  observation: "Mỗi agent dùng YAML contract nhưng không có trường `schema_version`. Khi schema thay đổi, không có cách nào để biết version nào đang dùng. Ảnh hưởng đến orchestrator khi parse output từ nhiều version khác nhau."
  action: "Thêm trường `schema_version` bắt buộc vào tất cả agent contracts (analyst, planner, builder, reviewer, tester, test-planner, self-improver). Phiên bản hiện tại set `schema_version: 2.0`. Mọi thay đổi contract trong tương lai phải bump version."
  tags: ["opencode", "agent-contract", "versioning", "schema", "suggestion-approved"]

- lesson_id: LSN-019
  type: "improvement"
  workflow: "Nâng cấp Analyst Agent contract lên schema v2.0 (WF-20260727-001)"
  situation: "Các agent không kiểm tra đầu vào (arguments) trước khi xử lý, dẫn đến lỗi khi thiếu thông tin cần thiết"
  observation: "Analyst đã được nâng cấp với input validation (goal/scope/criteria/allowed_scope), nhưng các agent khác (planner, builder, tester, reviewer) chưa có validation pattern tương tự. Khi thiếu thông tin, agent vẫn cố xử lý thay vì trả NEED_MORE_INFO."
  action: "Thêm input validation pattern cho tất cả agents: kiểm tra required fields ngay đầu prompt, trả `NEED_MORE_INFO` kèm `missing_info` list nếu thiếu. Đồng bộ pattern từ analyst mới."
  tags: ["opencode", "agent-design", "input-validation", "error-handling", "suggestion-approved"]

- lesson_id: LSN-020
  type: "improvement"
  workflow: "Nâng cấp Analyst Agent contract lên schema v2.0 (WF-20260727-001)"
  situation: "YAML contract validation được thực hiện thủ công trong static analysis step, dễ bỏ sót lỗi syntax"
  observation: "Step 7 (Static Analysis) kiểm tra YAML frontmatter, internal links, code block balance thủ công. Không có tool tự động để validate YAML contract output của agents. Lỗi YAML syntax chỉ được phát hiện khi orchestrator parse output."
  action: "Tích hợp YAML validator vào static analysis step: dùng `dotnet tool run yamllint` hoặc PowerShell script `ConvertFrom-Yaml` để parse và validate tất cả YAML blocks. Thêm vào SKILL.md static analysis checklist."
  tags: ["opencode", "yaml", "validation", "automation", "static-analysis", "suggestion-approved"]

- lesson_id: LSN-021
  type: "improvement"
  workflow: "Nâng cấp Analyst Agent contract lên schema v2.0 (WF-20260727-001)"
  situation: "Analyst, team-analyze command, và SKILL.md đã được nâng cấp lên schema v2.0, nhưng 5 agents còn lại (planner, builder, reviewer, tester, test-planner) vẫn dùng schema cũ"
  observation: "Workflow WF-20260727-001 chỉ cập nhật 3 files (analyst.md, team-analyze.md, SKILL.md). Các agent contracts còn lại chưa được đồng bộ: planner.md (thiếu evidence-backed dependencies, entry points), builder.md (thiếu scan scope), reviewer.md (thiếu structured impact), tester.md (thiếu schema_version), test-planner.md (thiếu patterns section)."
  action: "Đồng bộ tất cả remaining agents (planner, builder, reviewer, tester, test-planner) lên schema v2.0: thêm schema_version, evidence-backed dependencies, entry points, scan scope, patterns chuẩn hóa, conclusion block."
  tags: ["opencode", "agent-contract", "schema-v2", "sync", "suggestion-approved"]

- lesson_id: LSN-022
  type: "failure"
  workflow: "Evolution Mode - Sandbox / Simulation Engine (WF-20260731-003)"
  situation: "sync-system-docs.ps1 truyền report path vào health-score.ps1 và evolution-report.ps1 bằng pattern splatting inline: `$(if ($x) { \"-flag\", \"path\" } ...)`"
  observation: "Trong PowerShell 5.1, subexpression `$(if ...) { \"-a\", \"b\" }` trả về một string duy nhất (không phải array các argument) khi dùng làm argument list → health-score luôn nhận sai param và fallback score 50. Hệ quả: compatibility/knowledge/migration scores từ trước đến giờ KHÔNG BAO GIỜ nhận đúng report (pre-existing bug, mọi workflow trước dùng fallback)."
  action: "Chuyển sang hashtable splatting: tạo `@{}` chứa flag + value theo điều kiện, rồi `& script @hsArgs`. Verify bằng test: health-score phải trả real value (Compatibility=70, Knowledge=0) thay vì fallback 50. LƯU Ý: tương tự cho mọi call-site truyền optional flags theo điều kiện trong PowerShell."
  tags: ["powershell", "splatting", "argument-passing", "ps-5.1", "bug-fix", "suggestion-approved"]

- lesson_id: LSN-023
  type: "improvement"
  workflow: "Knowledge Assistant (WF-20260801-002)"
  situation: "Knowledge Assistant được xây dựng hoạt động độc lập (11 skills + 10 commands + Knowledge Index), chưa được tích hợp vào dev-team workflow"
  observation: "Các command /ask, /impact, /where chỉ được gọi thủ công khi dev muốn hỏi codebase. Trong workflow /team, khi cần phân tích codebase (tìm nơi dùng symbol, impact analysis, trace luồng), các agent không được gợi ý dùng Knowledge Assistant → thiếu tận dụng khả năng evidence-based của nó."
  action: "Tích hợp knowledge-assistant vào dev-team workflow như một capability phụ — các command /ask, /impact, /where nên được đề xuất khi cần phân tích codebase trong workflow /team. (Suggestion MEDIUM — user APPROVED)"
  tags: ["opencode", "knowledge-assistant", "dev-team", "integration", "workflow", "suggestion-approved"]

- lesson_id: LSN-024
  type: "improvement"
  workflow: "Knowledge Assistant (WF-20260801-002)"
  situation: "Toàn bộ 10 command knowledge mới dùng schema_version 1.0, nhưng một số command cũ (test-e2e.md...) dùng schema_version khác"
  observation: "Các command knowledge (ask.md, where.md, why.md, flow.md, impact.md, explain.md, trace.md, compare-doc.md, knowledge-health.md, knowledge-index.md) đồng nhất dùng schema_version 1.0. Tuy nhiên chưa có quy ước chung giữa các command trong hệ thống → dễ lệch lạc khi thêm command mới."
  action: "Chuẩn hóa schema_version cho các command knowledge (1.0) — đồng bộ với test-e2e.md hiện có. (Suggestion LOW — auto-approve)"
  tags: ["opencode", "schema-version", "command", "standardization", "suggestion-approved"]

- lesson_id: LSN-025
  type: "improvement"
  workflow: "Knowledge Assistant (WF-20260801-002)"
  situation: "cross-ref-validator.ps1 (nếu có) hiện chỉ quét QA commands khi validate cross-reference"
  observation: "Bộ 10 command knowledge mới chưa được đưa vào phạm vi quét cross-reference validator → các file mới có thể không được kiểm tra cross-reference như QA commands."
  action: "Cập nhật cross-ref-validator.ps1 để include các file knowledge mới trong quét cross-reference. (Suggestion LOW — auto-approve)"
  tags: ["opencode", "cross-reference", "validator", "knowledge", "suggestion-approved"]
