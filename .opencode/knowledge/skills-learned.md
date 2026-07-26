---
last_updated: 2026-07-25
total_skills: 15
---

# Skills Learned

Kho kiến thức về kỹ năng đã được phát hiện và sử dụng trong các workflow.

## Cấu trúc entry

Mỗi kỹ năng được ghi nhận theo format:

```yaml
- skill_id: SK-{number}
  name: "Tên kỹ năng"
  category: "tool | framework | pattern | domain | process"
  source_workflow: "Yêu cầu gốc đã phát hiện"
  usage_count: 1
  confidence: "new | learning | mastered"
  related_files: []
  notes: ""
```

## Danh sách kỹ năng

- skill_id: SK-001
  name: "Agent configuration in opencode.json"
  category: "process"
  source_workflow: "Setup Dev Agent Team - Self-Improver Agent"
  usage_count: 2
  confidence: "learning"
  related_files: ["opencode.json"]
  notes: "Cấu hình agent trong opencode.json dùng object với key là tên agent. Mỗi agent có mode: subagent, model, và permission object với 5 quyền: read, grep, glob, edit, bash."

- skill_id: SK-002
  name: "MudBlazor 9.x UI Framework"
  category: "framework"
  source_workflow: "Fix build lỗi Blazor WASM + runtime errors"
  usage_count: 4
  confidence: "learning"
  related_files: ["JapaneseLearner/Program.cs", "JapaneseLearner/Layout/MainLayout.razor", "JapaneseLearner/_Imports.razor", "JapaneseLearner/JapaneseLearner.csproj"]
  notes: "MudBlazor 9.7.0: FontWeight dùng string (\"400\", \"700\") thay vì int; Shadow.Elevation yêu cầu đúng 25 phần tử; cần MudPopoverProvider trong layout; Defaults.Classes namespace qua MudBlazor global using."

- skill_id: SK-003
  name: "Blazor WebAssembly .NET 10"
  category: "framework"
  source_workflow: "Fix build lỗi Blazor WASM"
  usage_count: 1
  confidence: "new"
  related_files: ["JapaneseLearner/Program.cs", "JapaneseLearner/App.razor", "JapaneseLearner/JapaneseLearner.csproj"]
  notes: "Blazor WASM trên .NET 10: RootComponents.Add vs builder.Build().RunAsync(); cần using namespace cho App type trong Program.cs; ImplicitUsings enable giúp giảm using."

- skill_id: SK-004
  name: "Blazored.LocalStorage for Blazor"
  category: "framework"
  source_workflow: "Thêm Word Service cho JapaneseLearner"
  usage_count: 2
  confidence: "learning"
  related_files: ["JapaneseLearner/Services/CharService.cs", "JapaneseLearner/Services/WordService.cs", "JapaneseLearner/Program.cs"]
  notes: "Dùng ILocalStorageService để CRUD dữ liệu JSON trong browser LocalStorage. Pattern: GetItemAsync<T> load, SetItemAsync save. Cache in-memory + persistence pattern."

- skill_id: SK-005
  name: "xUnit testing for Blazor models"
  category: "framework"
  source_workflow: "Thêm Word Service cho JapaneseLearner"
  usage_count: 1
  confidence: "new"
  related_files: ["JapaneseLearner.Tests/JapaneseCharTests.cs", "JapaneseLearner.Tests/JapaneseLearner.Tests.csproj"]
  notes: "xUnit với [Fact] cho unit test model. Kiểm tra default values, property assignment, và edge cases (max length, all enum values). Chạy với dotnet test."

- skill_id: SK-006
  name: "CRUD with local-first architecture"
  category: "domain"
  source_workflow: "Thêm Word Service cho JapaneseLearner"
  usage_count: 2
  confidence: "learning"
  related_files: ["JapaneseLearner/Services/CharService.cs", "JapaneseLearner/Services/WordService.cs", "JapaneseLearner/Pages/Admin.razor"]
  notes: "Full CRUD (Create, Read, Update, Delete) với local storage backend. Pattern: Interface → Implementation → DI registration → Razor page consumption. ID auto-increment via _nextId tracking."

- skill_id: SK-007
  name: "Service-Interface pattern in Blazor"
  category: "pattern"
  source_workflow: "Thêm Word Service cho JapaneseLearner"
  usage_count: 2
  confidence: "learning"
  related_files: ["JapaneseLearner/Services/ICharService.cs", "JapaneseLearner/Services/CharService.cs", "JapaneseLearner/Services/IWordService.cs", "JapaneseLearner/Services/WordService.cs"]
  notes: "Tách interface (ICharService, IWordService) và implementation. DI inject trong Program.cs với AddScoped. Helper local function pattern (void Add(...)) cho seed data."

- skill_id: SK-008
  name: "bUnit MudBlazor JSInterop mocking"
  category: "framework"
  source_workflow: "Fix 14 skipped bUnit tests - JS interop giới hạn"
  usage_count: 1
  confidence: "new"
  related_files: ["JapaneseLearner.Tests/TestHelpers/BunitTestBase.cs", "JapaneseLearner.Tests/HomeTests.cs", "JapaneseLearner.Tests/WordStudyTests.cs"]
  notes: "MudBlazor 9.7 yêu cầu JSInterop.SetupVoid cho: mudInput.initialize/destroy, mudRipple.connect/disconnect, mudSelect.addScrollListener/removeScrollListener, mudInputElement.select/selectRange. Dùng cut.InvokeAsync() để gọi method chứa StateHasChanged() vì nó yêu cầu Blazor Dispatcher."

- skill_id: SK-009
  name: "Dev Agent Team workflow orchestration v2"
  category: "process"
  source_workflow: "Restructure agent/skill set for SKILL.md v2"
  usage_count: 2
  confidence: "learning"
  related_files: [".opencode/skills/dev-team/SKILL.md"]
  notes: "Orchestrator điều phối 6 agent qua 11 bước: Analyze → Design → Plan → Review → Backup → Build → Smoke Test → TestPlan → Test → Self-Improve → Complete. Planner mở rộng đảm nhiệm cả Design và Plan. Có Approval Gate cho Self-Improvement. Có Smoke Test step. Backup path: .opencode\\backup\\{workflow_id}\\. Backup/Rollback do Backup Utility thực hiện. Error history với same_error_count ≥ 2 → catastrophic failure → rollback."

- skill_id: SK-010
  name: "Playwright E2E Testing"
  category: "framework"
  source_workflow: "Tích lũy từ: AGENTS.md hardcode port 5173 + PlaywrightFixture.cs"
  usage_count: 1
  confidence: "new"
  related_files: ["JapaneseLearner.E2ETests/PlaywrightFixture.cs", "JapaneseLearner.E2ETests/AppFixture.cs"]
  notes: "Playwright E2E test cho Blazor WASM. Cần app chạy trên port 5173 trước. Browser path hardcode trong PlaywrightFixture.cs — cần chỉnh sửa khi chạy trên máy khác. Test file trong JapaneseLearner.E2ETests/. Timer auto-advance (5s) cần E2E test để verify behavior thực tế với page.WaitForSelectorAsync timeout > 5s."

- skill_id: SK-011
  name: "Backup-Rollback Process"
  category: "process"
  source_workflow: "Tích lũy từ workflow orchestration (SKILL.md)"
  usage_count: 2
  confidence: "learning"
  related_files: [".opencode/skills/dev-team/SKILL.md"]
  notes: "Backup trước build: copy file vào .opencode/backup/{workflow_id}/ với SHA256 hash manifest. Rollback khi catastrophic failure (same_error >= 2, max retry, file mất). Dùng PowerShell script backup-utility.ps1 và rollback-utility.ps1."

- skill_id: SK-012
  name: "Same-Error Detection Pattern"
  category: "pattern"
  source_workflow: "Tích lũy từ workflow orchestration (SKILL.md)"
  usage_count: 1
  confidence: "new"
  related_files: [".opencode/skills/dev-team/SKILL.md"]
  notes: "Error normalization: loại bỏ line number, timestamp, memory address, lowercase. SHA256 hash 12 ký tự đầu. So sánh với error_history.review/build_failures/test_failures. Nếu same_error_count >= 2 → STOP, báo catastrophic failure, rollback."

- skill_id: SK-013
  name: "PowerShell Automation for Workflow"
  category: "tool"
  source_workflow: "Tích lũy từ SKILL.md backup script + dev environment"
  usage_count: 1
  confidence: "new"
  related_files: [".opencode/skills/dev-team/SKILL.md"]
  notes: "PowerShell 5.1 trên Windows: dùng Copy-Item, Get-FileHash, New-Item cho backup. Get-Date format yyyyMMdd_HHmmss cho timestamp. ConvertFrom-Json cho manifest parse. Join-Path/Split-Path cho path handling. Nên dùng `cmd1; if ($?) { cmd2 }` thay vì &&."

- skill_id: SK-014
  name: "Blazor Tri-State Rendering"
  category: "pattern"
  source_workflow: "Tích lũy từ: Thêm Word Service cho JapaneseLearner"
  usage_count: 2
  confidence: "learning"
  related_files: ["JapaneseLearner/Pages/Home.razor", "JapaneseLearner/Pages/WordStudy.razor", "JapaneseLearner/Pages/Admin.razor"]
  notes: "Mỗi page Blazor xử lý 3 trạng thái: 1) Loading → MudProgressCircular, 2) Empty (list.Count == 0) → hướng dẫn, 3) Data → nội dung chính. Điều khiển qua biến isLoading và list.Count. Pattern: @if (isLoading) { ... } else if (list.Count == 0) { ... } else { ... }."

- skill_id: SK-015
  name: "InternalsVisibleTo for Blazor unit testing"
  category: "pattern"
  source_workflow: "Tạo trang /words/quiz multiple-choice"
  usage_count: 1
  confidence: "new"
  related_files: ["JapaneseLearner.Tests/WordQuizTests.cs", "JapaneseLearner/Pages/WordQuiz.razor"]
  notes: "Dùng [assembly: InternalsVisibleTo(\"JapaneseLearner.Tests\")] trong JapaneseLearner.csproj hoặc trong file GlobalUsings để test internal component state mà không cần reflection. Pattern: expose IsCorrectAnswer(), GetCurrentOptions(), GetStats() như internal methods. Giảm reflection code, tăng maintainability."
