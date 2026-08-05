# Phase 3: Plan — AIHub Execution Plan

## Output Contract

```yaml
status: "READY"
summary: >
  Kế hoạch thực thi AIHub gồm 16 steps chia thành 4 chunks: Chunk 1 (project skeleton),
  Chunk 2 (models + services), Chunk 3 (components + UI), Chunk 4 (integration).
  Tất cả steps là CREATE mới — không sửa file cũ. Build validate sau mỗi chunk.
effort: "Medium"
blocking_issues: []
non_blocking_issues: []
open_questions: []
next_action: "Chuyển sang Review phase"
artifacts: ["03_plan.md"]

steps:
  - order: 1
    description: "Tạo project skeleton: .csproj với FluentUI + Icons packages"
    action: "CREATE"
    file: "AIHub/AIHub.csproj"
    logic: >
      Sdk="Microsoft.NET.Sdk.BlazorWebAssembly", TargetFramework=net10.0, Nullable=enable, ImplicitUsings=enable.
      PackageReference: Microsoft.FluentUI.AspNetCore.Components 4.14.3, Microsoft.FluentUI.AspNetCore.Components.Icons 4.14.3.
    expected_result: "dotnet restore thành công"
    check: "dotnet restore AIHub/AIHub.csproj"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "dotnet restore AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 2
    description: "Tạo Properties/launchSettings.json (port 5190)"
    action: "CREATE"
    file: "AIHub/Properties/launchSettings.json"
    logic: >
      profiles.AIHub.commandName=Project, applicationUrl=http://localhost:5190, launchBrowser=true, environmentVariables.ASPNETCORE_ENVIRONMENT=Development.
    expected_result: "JSON parseable, port 5190 confirmed"
    check: "Verify JSON structure + port number"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "Test-Path AIHub/Properties/launchSettings.json"
    risk_level: "LOW"

  - order: 3
    description: "Tạo wwwroot/index.html host page"
    action: "CREATE"
    file: "AIHub/wwwroot/index.html"
    logic: >
      HTML5 với charset utf-8, viewport, base href="/", title AIHub,
      link css/app.css, div#app loading="Loading...", script _framework/blazor.webassembly.js.
    expected_result: "HTML valid với các tag bắt buộc"
    check: "Kiểm tra div#app, blazor.webassembly.js"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "Test-Path AIHub/wwwroot/index.html"
    risk_level: "LOW"

  - order: 4
    description: "Tạo _Imports.razor + App.razor"
    action: "CREATE"
    file: "AIHub/_Imports.razor"
    logic: >
      _Imports: @using cho System.Net.Http, Components, FluentUI, AIHub.Models/Services/Components/Pages.
      App.razor: FluentDesignTheme wrapping Router với MainLayout, NotFound template.
    expected_result: "dotnet build PASS"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 1
    requires_backup: false
    depends_on: [1, 2, 3]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 5
    description: "Tạo Models/TrendingItem.cs"
    action: "CREATE"
    file: "AIHub/Models/TrendingItem.cs"
    logic: >
      12 properties: Id, Title, Description, Url, Source, SourceIcon, AvatarUrl, Stars, Forks,
      Language, PublishedAt, Score. Enum CardSize + computed GetCardSize() → Small/Medium/Large.
    expected_result: "dotnet build PASS, TrendingItem accessible"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 6
    description: "Tạo Models/TrendingSource.cs + TimeFilter.cs"
    action: "CREATE"
    file: "AIHub/Models/TrendingSource.cs"
    logic: >
      TrendingSource: Name, ApiEndpoint, ApiType enum {GitHub, RestApi, Rss}, Enabled, Headers, ResponseMapping.
      TimeFilter enum: Last24Hours, Last7Days, Last30Days + extension GetDateRange().
    expected_result: "dotnet build PASS"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [5]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 7
    description: "Tạo Services/ITrendingService.cs interface"
    action: "CREATE"
    file: "AIHub/Services/ITrendingService.cs"
    logic: >
      Task<List<TrendingItem>> GetTrendingAsync(TimeFilter, int page, int pageSize),
      Task<List<TrendingSource>> GetSourcesAsync(), void ClearCache().
    expected_result: "Interface compile OK"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 8
    description: "Tạo Services/TrendingService.cs implementation"
    action: "CREATE"
    file: "AIHub/Services/TrendingService.cs"
    logic: >
      Constructor: HttpClient DI + load sources from wwwroot/data/sources.json.
      Cache: ConcurrentDictionary, TTL 5 phút.
      Score formula: Stars*0.4 + Forks*0.3 + recency_bonus*0.2 + desc_bonus*0.1.
      GitHub API call: User-Agent header, parse JSON, map to TrendingItem, parallel fetch Task.WhenAll.
      Error handling: try/catch → return cache fallback.
    expected_result: "dotnet build PASS, service sẵn sàng inject"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [7]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "MEDIUM"

  - order: 9
    description: "Tạo Components/SearchBar.razor + CSS"
    action: "CREATE"
    file: "AIHub/Components/SearchBar.razor"
    logic: >
      FluentSearch + FluentButton clear. Debounce 300ms via CancellationTokenSource.
      EventCallback<string> OnSearchChanged. CSS: sticky top, z-index 10, glassmorphism.
    expected_result: "SearchBar render với search input + clear button"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 10
    description: "Tạo Components/TimeFilterTabs.razor"
    action: "CREATE"
    file: "AIHub/Components/TimeFilterTabs.razor"
    logic: >
      3 FluentButton tabs: "24h" | "7 ngày" | "30 ngày". Appearance.Accent khi active.
      EventCallback<TimeFilter> OnFilterChanged. Flex row, centered.
    expected_result: "3 tabs render, clickable"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 11
    description: "Tạo Components/TrendCard.razor + CSS (3 size variants + animations)"
    action: "CREATE"
    file: "AIHub/Components/TrendCard.razor"
    logic: >
      3 card sizes dựa trên Item.GetCardSize(). Click → JS interop open(url, _blank).
      CSS: fadeInUp animation, hover scale(1.02) + shadow, transition 0.2s.
    expected_result: "Card render 3 size variants đúng, click mở tab mới"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [5]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "MEDIUM"

  - order: 12
    description: "Tạo Components/TrendGrid.razor + CSS (4 cột + infinite scroll + stagger animation)"
    action: "CREATE"
    file: "AIHub/Components/TrendGrid.razor"
    logic: >
      CSS Grid 4 cột, responsive breakpoints. IntersectionObserver sentinel → OnLoadMore.
      Stagger delay: --delay index*50ms. Filter transition: opacity 0.3s, collapse. Loading spinner.
    expected_result: "Grid 4 cột render, infinite scroll trigger, stagger animation"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "HIGH"

  - order: 13
    description: "Tạo Layout/MainLayout.razor + CSS"
    action: "CREATE"
    file: "AIHub/Layout/MainLayout.razor"
    logic: >
      FluentDesignTheme, header: logo AIHub + subtitle, NavMenu, @Body max-width 1400px, footer.
      CSS: gradient header, centered content, responsive.
    expected_result: "Layout render header + body + footer"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 14
    description: "Tạo Pages/Home.razor — compose tất cả + state management"
    action: "CREATE"
    file: "AIHub/Pages/Home.razor"
    logic: >
      @page "/". Inject ITrendingService. State: searchQuery, currentFilter, allItems, displayItems,
      currentPage, isLoading, hasMore. OnInitializedAsync → fetch page 1.
      OnSearchChanged → filter allItems by Title/Description/Source. OnFilterChanged → reset + reload.
      OnLoadMore → fetch page+1, append, re-filter. Tri-state rendering.
    expected_result: "Full flow: load → grid → search filter → tab filter → infinite scroll"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [9, 10, 12, 13]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "HIGH"

  - order: 15
    description: "Tạo wwwroot/css/app.css (animations, variables, responsive)"
    action: "CREATE"
    file: "AIHub/wwwroot/css/app.css"
    logic: >
      CSS variables: --bg-primary, --card-bg, --text-primary, --accent. @keyframes fadeInUp, fadeOutDown.
      Body styles, scrollbar custom, responsive grid. Animations cho card stagger, filter transition.
    expected_result: "CSS file loaded by index.html, styles active"
    check: "Test-Path AIHub/wwwroot/css/app.css"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "Get-Content AIHub/wwwroot/css/app.css"
    risk_level: "LOW"

  - order: 16
    description: "Tạo wwwroot/data/sources.json (default source configs)"
    action: "CREATE"
    file: "AIHub/wwwroot/data/sources.json"
    logic: >
      JSON array 3 sources: GitHub Trending, GitHub AI Topics, GitHub LLM Topics.
      Mỗi source có Name, ApiType=GitHub, ApiEndpoint template với {date} và {page}, Enabled=true.
    expected_result: "Valid JSON loaded by TrendingService"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [8]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

per_step_validation:
  - step: 4
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Chunk 1 hoàn tất"
  - step: 8
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Chunk 2 hoàn tất"
  - step: 14
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Chunk 3 hoàn tất"
  - step: 16
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS cuối cùng"

per_chunk_validate:
  - chunk: 1
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — skeleton + imports + App.razor"
  - chunk: 2
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Models + Services"
  - chunk: 3
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Components + Pages + CSS"

final_validation:
  - command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — 0 errors, 0 warnings"
  - command: "dotnet run --project AIHub/AIHub.csproj --urls http://localhost:5190"
    expected: "Server start trên port 5190"

rollback_strategy:
  enabled: true
  trigger_conditions:
    - type: "catastrophic_failure"
      description: "Build fail không recover được"
    - type: "max_retry_reached"
      description: "Retry > 3 lần"
      threshold: 3
    - type: "user_request"
      description: "User yêu cầu hủy"
  restore_order:
    - step: 16
      action: "delete"
      file: "AIHub/"
    - step: 1
      action: "delete"
      file: "AIHub/"
  requires_user_confirmation: true
  conditions:
    - "catastrophic failure"
    - "max retry reached"
  steps:
    - "Xóa toàn bộ thư mục AIHub/ — an toàn vì chỉ CREATE, không sửa file cũ"

validate:
  - command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build thành công"
```

---

## Plan Metrics
| Metric | Value |
|--------|-------|
| Total steps | 16 |
| Chunks | 3 (chunk 4 gộp vào chunk 3 validation) |
| CREATE actions | 16 |
| MODIFY/DELETE actions | 0 |
| Backup required | 0 (all CREATE) |
| Risk HIGH | 2 (steps 12, 14) |
| Risk MEDIUM | 2 (steps 8, 11) |
| Risk LOW | 12 |
| Estimate time | ~10-15 min |
