# Phase 2: Design — AIHub Architecture

## Output Contract

```yaml
status: "READY"
summary: >
  Thiết kế kiến trúc cho AIHub — Blazor WASM standalone app hiển thị trending repos/skills/agents.
  Architecture 3-layer: Pages → Components → Services → Models. TrendingService fetch + aggregate +
  cache từ GitHub API và configurable sources. CSS Grid 4 cột với masonry-like layout, IntersectionObserver
  infinite scroll, CSS animations cho filter/fade. Effort: Medium (tất cả file mới, không sửa file cũ).
blocking_issues: []
non_blocking_issues:
  - id: "#01"
    severity: "MINOR"
    category: "DESIGN"
    description: "FluentUI không có masonry grid — dùng CSS Grid thuần với grid-auto-rows + JS tính row span"
    suggestion: "Dùng CSS Grid columns cố định + IntersectionObserver; row span tính từ attractiveness score"
  - id: "#02"
    severity: "INFO"
    category: "PERFORMANCE"
    description: "Nếu items > ~200, animation có thể lag — virtual scrolling cân nhắc"
    suggestion: "Dùng CSS content-visibility: auto + will-change: transform cho cards ngoài viewport"
  - id: "#03"
    severity: "INFO"
    category: "DESIGN"
    description: "Attractiveness score formula chủ quan — có thể cần tune sau"
    suggestion: "Khởi tạo công thức: score = stars*0.4 + forks*0.3 + recent_activity*0.2 + description_completeness*0.1"
open_questions: []
next_action: "Chuyển sang Plan phase"
artifacts: ["02_design.md"]
effort: "Medium"
design:
  architecture: >
    ## AIHub Architecture

    ### Tổng quan
    AIHub là Blazor WebAssembly standalone app (.NET 10), tách biệt hoàn toàn khỏi JapaneseLearner.
    Không cần backend — fetch dữ liệu trực tiếp từ GitHub API và các nguồn khác qua HttpClient.

    ### Layer Architecture (3-layer)
    ```
    ┌─────────────────────────────────────────────────┐
    │  Pages (Home.razor)                             │
    │  ┌─────────────┐ ┌──────────────┐ ┌──────────┐ │
    │  │ SearchBar   │ │TimeFilterTabs│ │TrendGrid │ │
    │  └─────────────┘ └──────────────┘ └──────────┘ │
    │                      │                          │
    ├──────────────────────┼──────────────────────────┤
    │  Services            │                          │
    │  ┌───────────────────▼───────────────────────┐  │
    │  │ ITrendingService ← TrendingService        │  │
    │  │ - FetchTrendingAsync(filter, page)        │  │
    │  │ - AggregateScore(item)                    │  │
    │  │ - Cache management (5 min TTL)            │  │
    │  └───────────────────────────────────────────┘  │
    │                      │                          │
    ├──────────────────────┼──────────────────────────┤
    │  Models              │                          │
    │  ┌───────────────────▼───────────────────────┐  │
    │  │ TrendingItem, TrendingSource, TimeFilter  │  │
    │  └───────────────────────────────────────────┘  │
    └─────────────────────────────────────────────────┘
    ```

    ### DI Setup (Program.cs)
    ```csharp
    builder.Services.AddFluentUIComponents();
    builder.Services.AddScoped<ITrendingService, TrendingService>();
    ```

    ### Route design
    | Path | Component | Description |
    |------|-----------|-------------|
    | `/` | `Home.razor` | Main trending page |
    | `/sources` | (future) | Source management page |

    ### State management
    - TrendingService: scoped DI, in-memory cache (Dictionary<TimeFilter, List<TrendingItem>>)
    - Cache TTL: 5 phút
    - Search state: trong Home.razor (string query + debounce 300ms)
    - TimeFilter: trong Home.razor (enum 24h/7d/30d)
    - Pagination: page number trong TrendingService

  components:
    - name: "TrendingItem"
      path: "AIHub/Models/TrendingItem.cs"
      action: "CREATE"
      description: "Main data model — title, description, url, source, stars, forks, language, avatar, publishedAt, score"

    - name: "TrendingSource"
      path: "AIHub/Models/TrendingSource.cs"
      action: "CREATE"
      description: "Cấu hình nguồn dữ liệu — name, apiEndpoint, apiType (github/rest/rss), enabled, params"

    - name: "TimeFilter"
      path: "AIHub/Models/TimeFilter.cs"
      action: "CREATE"
      description: "Enum: Last24Hours, Last7Days, Last30Days"

    - name: "ITrendingService"
      path: "AIHub/Services/ITrendingService.cs"
      action: "CREATE"
      description: "Interface — Task<List<TrendingItem>> GetTrendingAsync(TimeFilter, int page, int pageSize), Task<List<TrendingSource>> GetSourcesAsync()"

    - name: "TrendingService"
      path: "AIHub/Services/TrendingService.cs"
      action: "CREATE"
      description: "Implementation — parallel fetch from sources, aggregate, score, cache, pagination"

    - name: "SearchBar"
      path: "AIHub/Components/SearchBar.razor"
      action: "CREATE"
      description: "Search input với debounce 300ms, EventCallback<string> OnSearchChanged"

    - name: "SearchBar"
      path: "AIHub/Components/SearchBar.razor.css"
      action: "CREATE"
      description: "Styles cho search bar (sticky, z-index)"

    - name: "TimeFilterTabs"
      path: "AIHub/Components/TimeFilterTabs.razor"
      action: "CREATE"
      description: "3 tabs: 24h, 7 days, 30 days — EventCallback<TimeFilter> OnFilterChanged"

    - name: "TrendCard"
      path: "AIHub/Components/TrendCard.razor"
      action: "CREATE"
      description: >
        Card hiển thị 1 trending item. 3 size variants (small/medium/large) dựa trên score.
        Small: compact (avatar + title + stars badge).
        Medium: avatar + title + description (2 lines) + stars + language.
        Large: avatar + title + description (full) + stars + forks + language + published date.
        Click → window.open(url, '_blank').
        Animation: fadeInUp on mount, hover: scale(1.02) + shadow.

    - name: "TrendCard"
      path: "AIHub/Components/TrendCard.razor.css"
      action: "CREATE"
      description: "Styles cho 3 card sizes + hover animation + fadeInUp keyframes"

    - name: "TrendGrid"
      path: "AIHub/Components/TrendGrid.razor"
      action: "CREATE"
      description: >
        CSS Grid container 4 cột. Nhận List<TrendingItem>.
        IntersectionObserver ở cuối grid → trigger load more.
        Stagger animation: mỗi card fadeInUp với delay incremental (index * 50ms).
        Filter animation: cards có CSS transition opacity + transform, non-matching cards collapse.

    - name: "TrendGrid"
      path: "AIHub/Components/TrendGrid.razor.css"
      action: "CREATE"
      description: "CSS Grid styles, stagger delays, filter transition, loading spinner"

    - name: "MainLayout"
      path: "AIHub/Layout/MainLayout.razor"
      action: "CREATE"
      description: "Layout chính — header với logo + nav, body container, footer. FluentUI FluentDesignTheme."

    - name: "MainLayout"
      path: "AIHub/Layout/MainLayout.razor.css"
      action: "CREATE"
      description: "Layout styles — max-width 1400px, center, padding"

    - name: "Home"
      path: "AIHub/Pages/Home.razor"
      action: "CREATE"
      description: "Main page compose SearchBar + TimeFilterTabs + TrendGrid. Manages state: query, timeFilter, items."

    - name: "App"
      path: "AIHub/App.razor"
      action: "CREATE"
      description: "Root component — Router + MainLayout"

    - name: "Program"
      path: "AIHub/Program.cs"
      action: "CREATE"
      description: "Entry point — builder config, DI registration (FluentUI, TrendingService)"

    - name: "AIHub.csproj"
      path: "AIHub/AIHub.csproj"
      action: "CREATE"
      description: "Project file — Blazor WASM .NET 10, FluentUI 4.14.3, FluentUI Icons"

    - name: "_Imports"
      path: "AIHub/_Imports.razor"
      action: "CREATE"
      description: "Global usings cho Razor files"

    - name: "launchSettings"
      path: "AIHub/Properties/launchSettings.json"
      action: "CREATE"
      description: "Dev server config — port 5190 (khác JapaneseLearner 5146/5173)"

    - name: "index.html"
      path: "AIHub/wwwroot/index.html"
      action: "CREATE"
      description: "HTML host page — title AIHub, CSS/JS refs"

    - name: "app.css"
      path: "AIHub/wwwroot/css/app.css"
      action: "CREATE"
      description: "Global CSS — reset, animations, variables, scrollbar styles"

    - name: "sources.json"
      path: "AIHub/wwwroot/data/sources.json"
      action: "CREATE"
      description: "Default source configs (GitHub trending repos, etc.)"

  data_flow: >
    ## Data Flow (Main Flow)

    ```
    User Action                    Component                  Service              External
    ────────────                   ─────────                  ───────              ────────

    1. Page load
    Home.OnInitializedAsync()  →  TrendingService.GetTrendingAsync(24h, 1, 50)
                                    │
                                    ├─ Check cache (memory)
                                    │  ├─ HIT → return cached
                                    │  └─ MISS ↓
                                    ├─ Fetch GitHub API ────────────────────────────→ api.github.com
                                    │  └─ GET /search/repositories?q=created:>DATE&sort=stars
                                    │     ← JSON response
                                    ├─ Parse + map → List<TrendingItem>
                                    ├─ Calculate score cho mỗi item
                                    ├─ Sort by score desc
                                    ├─ Cache in-memory (TTL 5 min)
                                    └─ return List<TrendingItem>
                                    │
    TrendGrid receives items   ←  items (first 50)
    Render TrendCard × N       ←  each item → card (size variant by score)

    2. User scrolls to bottom
    IntersectionObserver fires  →  TrendingService.GetTrendingAsync(filter, page+1, 50)
                                    └─ return next 50 items
    Append to existing grid    ←  new items → animate in (stagger)

    3. User types in search
    SearchBar.OnInput           →  debounce 300ms → Home.OnSearchChanged(query)
    Home filters items          →  items.Where(i => i.Title.Contains(query) ||
                                       i.Description.Contains(query) ||
                                       i.Source.Contains(query))
    TrendGrid receives filtered →  non-matching cards fade out + collapse
                                    matching cards rearrange (CSS transition)

    4. User clicks time filter
    TimeFilterTabs.OnClick(7d)  →  Home.OnFilterChanged(TimeFilter.Last7Days)
    Home.OnFilterChanged        →  TrendingService.GetTrendingAsync(7d, 1, 50)
                                    └─ cache MISS → fetch new data
    TrendGrid receives new data →  cards fade out old → fade in new (stagger)

    5. User clicks card
    TrendCard.OnClick           →  window.open(item.Url, '_blank')
    ```

  security_concerns:
    - description: "GitHub API rate limit (60 req/h không auth)"
      severity: "MEDIUM"
      mitigation: "Cache 5 phút TTL; hiển thị warning khi rate limit exceeded; cho phép user nhập GitHub token trong future"

    - description: "XSS qua description/content từ nguồn bên ngoài"
      severity: "LOW"
      mitigation: "Blazor tự escape HTML trong Razor markup; không dùng MarkupString cho content từ API"

    - description: "Open redirect khi click card → external URL"
      severity: "LOW"
      mitigation: "Luôn dùng target='_blank' + rel='noopener noreferrer'; chỉ link đến URL từ API response"

    - description: "CORS restrictions khi fetch từ domain khác"
      severity: "LOW"
      mitigation: "GitHub API hỗ trợ CORS; các source khác kiểm tra CORS headers; fallback dùng serverless proxy nếu cần"

  edge_cases:
    - description: "GitHub API trả về lỗi / timeout"
      handling: "Hiển thị banner warning 'Không thể tải dữ liệu từ GitHub. Đang hiển thị dữ liệu cache.' Nếu có cache cũ → hiển thị cache. Nếu không → hiển thị empty state với nút 'Thử lại'."

    - description: "Không có trending items (API trả về empty)"
      handling: "Hiển thị empty state: 'Chưa có trending items nào trong khoảng thời gian này.' + icon"

    - description: "Tất cả items bị filter bởi search query"
      handling: "Hiển thị 'Không tìm thấy kết quả nào cho \"{query}\"' + nút clear search"

    - description: "Người dùng gõ search rất nhanh (rapid input)"
      handling: "Debounce 300ms — chỉ filter sau khi người dùng ngừng gõ 300ms"

    - description: "Scroll rất nhanh → nhiều trang load cùng lúc"
      handling: "Loading flag trong TrendingService — nếu đang load trang N thì bỏ qua trigger load trang N+1 cho đến khi hoàn tất"

    - description: "Network offline (WASM vẫn chạy nhưng không fetch được)"
      handling: "Bắt HttpRequestException → hiển thị offline banner; nếu có cache → hiển thị cache"

    - description: "Attractiveness score quá thấp → không card nào size large"
      handling: "Phân phối score theo percentile: top 10% = large, top 40% = medium, rest = small. Đảm bảo luôn có mix."

    - description: "Màn hình mobile / tablet"
      handling: "Responsive grid: 4 cột desktop (>=1024px), 3 cột tablet (768-1023px), 2 cột mobile (<768px), 1 cột small mobile (<480px)"
```

--- 
## Designer Checklist
- [x] Architecture mô tả 3-layer rõ ràng
- [x] 23 components được liệt kê với path + action CREATE
- [x] Data flow đầy đủ: load → cache → fetch → render → scroll → paginate → search → filter
- [x] 3 security concerns (rate limit, XSS, open redirect, CORS) + mitigation
- [x] 8 edge cases (API error, empty, filter all, rapid input, fast scroll, offline, low score, responsive)
- [x] Effort: Medium (greenfield, ~23 files, 2-3 chunks)
- [x] Non-blocking issues documented
- [x] Sẵn sàng chuyển Plan phase
```

---

## PHASE 3: PLAN

Now producing the Plan from the Design:

```yaml
status: "READY"
summary: >
  Kế hoạch thực thi AIHub gồm 16 steps chia thành 4 chunks.
  Chunk 1: Project skeleton + config (4 steps).
  Chunk 2: Models + Services (4 steps).
  Chunk 3: Components + UI (6 steps).
  Chunk 4: Final integration + validate (2 steps).
  Tất cả là CREATE mới — không có requires_backup. Build validate sau mỗi chunk.
effort: "Medium"
blocking_issues: []
non_blocking_issues: []
open_questions: []
next_action: "Chuyển sang Review phase"
artifacts: ["02_design.md", "03_plan.md"]

steps:
  - order: 1
    description: "Tạo project skeleton: .csproj, launchSettings, index.html"
    action: "CREATE"
    file: "AIHub/AIHub.csproj"
    logic: >
      Tạo file AIHub.csproj với Sdk="Microsoft.NET.Sdk.BlazorWebAssembly", TargetFramework=net10.0,
      Nullable=enable, ImplicitUsings=enable. Thêm PackageReference: FluentUI 4.14.3, FluentUI Icons 4.14.3.
    expected_result: "File .csproj tồn tại, dotnet restore thành công"
    check: "dotnet restore AIHub/AIHub.csproj"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "dotnet restore AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 2
    description: "Tạo launchSettings.json cấu hình dev server port 5190"
    action: "CREATE"
    file: "AIHub/Properties/launchSettings.json"
    logic: >
      Tạo thư mục Properties/, tạo launchSettings.json với profiles.AIHub:
      applicationUrl "http://localhost:5190", launchBrowser=true.
    expected_result: "File launchSettings.json tồn tại với port 5190"
    check: "Verify JSON parseable + port 5190"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "Get-Content AIHub/Properties/launchSettings.json | ConvertFrom-Json"
    risk_level: "LOW"

  - order: 3
    description: "Tạo index.html host page cho Blazor WASM"
    action: "CREATE"
    file: "AIHub/wwwroot/index.html"
    logic: >
      Tạo index.html với <base href="/" />, <div id="app">, <script src="_framework/blazor.webassembly.js">,
      link tới app.css, title "AIHub - Trending AI Tools".
    expected_result: "File index.html tồn tại, HTML valid"
    check: "Kiểm tra các tag bắt buộc: base, div#app, blazor.webassembly.js"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "Get-Content AIHub/wwwroot/index.html"
    risk_level: "LOW"

  - order: 4
    description: "Tạo _Imports.razor và App.razor"
    action: "CREATE"
    file: "AIHub/_Imports.razor"
    logic: >
      _Imports.razor: @using System.Net.Http, @using Microsoft.AspNetCore.Components.*, @using Microsoft.FluentUI.AspNetCore.Components,
      @using AIHub, @using AIHub.Models, @using AIHub.Services, @using AIHub.Components, @using AIHub.Pages.
      App.razor: FluentDesignTheme + Router với MainLayout.
    expected_result: "Cả 2 file tồn tại, dotnet build PASS cho Chunk 1"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 1
    requires_backup: false
    depends_on: [1, 2, 3]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 5
    description: "Tạo Models: TrendingItem.cs"
    action: "CREATE"
    file: "AIHub/Models/TrendingItem.cs"
    logic: >
      Class TrendingItem với properties: string Id, string Title, string Description, string Url,
      string Source (tên nguồn), string SourceIcon, string AvatarUrl, int Stars, int Forks,
      string Language, DateTime PublishedAt, double Score (attractiveness).
      Thêm enum CardSize { Small, Medium, Large } và computed property CardSize GetCardSize()
      dựa trên Score percentile.
    expected_result: "TrendingItem compile OK, có đủ 12 properties"
    check: "Kiểm tra file tồn tại + compile qua dotnet build"
    chunk: 2
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 6
    description: "Tạo Models: TrendingSource.cs và TimeFilter.cs"
    action: "CREATE"
    file: "AIHub/Models/TrendingSource.cs"
    logic: >
      TrendingSource.cs: class với Name, ApiEndpoint, ApiType (enum: GitHub, RestApi, Rss),
      Enabled (bool), Headers (Dictionary), ResponseMapping (JSON path config).
      TimeFilter.cs: enum TimeFilter { Last24Hours, Last7Days, Last30Days }
      + extension method GetDateRange() → (DateTime from, DateTime to).
    expected_result: "Cả 2 model compile OK"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [5]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 7
    description: "Tạo ITrendingService interface"
    action: "CREATE"
    file: "AIHub/Services/ITrendingService.cs"
    logic: >
      Interface với 3 methods:
      Task<List<TrendingItem>> GetTrendingAsync(TimeFilter filter, int page = 1, int pageSize = 50);
      Task<List<TrendingSource>> GetSourcesAsync();
      void ClearCache();
    expected_result: "Interface compile OK"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 8
    description: "Tạo TrendingService implementation"
    action: "CREATE"
    file: "AIHub/Services/TrendingService.cs"
    logic: >
      Implementation ITrendingService:
      - Constructor: HttpClient (DI), load sources từ wwwroot/data/sources.json
      - GetTrendingAsync: check cache qua Dictionary<(TimeFilter, int), (List<TrendingItem>, DateTime)>,
        nếu cache valid (<5 phút) → return cache, nếu không → fetch từ tất cả enabled sources song song
        (Task.WhenAll), aggregate kết quả, tính Score = Stars*0.4 + Forks*0.3 +
        (DateTime.Now - PublishedAt).TotalHours < 24 ? 20 : 0 + Description?.Length > 100 ? 10 : 0,
        sort by Score desc, cache, return.
      - GitHub source: GET https://api.github.com/search/repositories?q=created:>{date}&sort=stars&order=desc&per_page=50&page={page}
        + User-Agent header required. Parse JSON → map to TrendingItem.
      - Xử lý lỗi: try/catch HttpRequestException → log, return cache nếu có.
      - Pagination: page * pageSize để skip items đã load.
    expected_result: "TrendingService compile OK, dotnet build PASS"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [7]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "MEDIUM"

  - order: 9
    description: "Tạo SearchBar component + CSS"
    action: "CREATE"
    file: "AIHub/Components/SearchBar.razor"
    logic: >
      FluentSearch (FluentUI) với placeholder "Tìm kiếm repos, skills, agents...",
      debounce 300ms qua System.Timers.Timer hoặc Task.Delay + CancellationTokenSource.
      EventCallback<string> OnSearchChanged, Parameter string Value.
      CSS: sticky top-0, z-index 10, glassmorphism background, backdrop-filter blur.
      SearchBar.razor.css: styles tương ứng.
    expected_result: "SearchBar component compile OK, hiển thị search input + clear button"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 10
    description: "Tạo TimeFilterTabs component"
    action: "CREATE"
    file: "AIHub/Components/TimeFilterTabs.razor"
    logic: >
      3 FluentButton tabs (Appearance.Accent khi active, Appearance.Neutral khi inactive):
      "24h", "7 ngày", "30 ngày". Parameter TimeFilter ActiveFilter,
      EventCallback<TimeFilter> OnFilterChanged.
      Inline style: display flex, gap 8px, justify-content center.
    expected_result: "TimeFilterTabs compile OK, 3 tabs hiển thị"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 11
    description: "Tạo TrendCard component + CSS + animations"
    action: "CREATE"
    file: "AIHub/Components/TrendCard.razor"
    logic: >
      Parameter TrendingItem Item. Compute CardSize từ Item.GetCardSize().
      Layout: FluentCard với 3 style variants.
      - Small: avatar (24px) + title (1 line, bold) + stars badge (FluentBadge)
      - Medium: avatar (32px) + title (2 lines) + description (2 lines, truncated) + stars + language badge
      - Large: avatar (48px) + title + description (full) + stars + forks + language + time ago
      Click handler: await JSRuntime.InvokeVoidAsync("open", Item.Url, "_blank", "noopener,noreferrer").
      CSS animations:
      - @keyframes fadeInUp: from opacity 0 transform translateY(20px) to opacity 1 transform translateY(0)
      - Card: animation fadeInUp var(--delay) both;
      - Hover: transform scale(1.02) box-shadow elevation; transition 0.2s ease
      TrendCard.razor.css: all above styles, color tokens, card sizes.
    expected_result: "TrendCard compile OK, 3 size variants render đúng layout"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [5]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "MEDIUM"

  - order: 12
    description: "Tạo TrendGrid component + infinite scroll + stagger animation"
    action: "CREATE"
    file: "AIHub/Components/TrendGrid.razor"
    logic: >
      Parameter List<TrendingItem> Items, EventCallback OnLoadMore, bool IsLoading, bool HasMore.
      Render: div.grid-container (CSS Grid 4 cột) chứa TrendCard × Items.Count.
      Mỗi card có style="--delay: {index * 50}ms".
      IntersectionObserver: div cuối grid có @ref="sentinel", dùng JS interop observe.
      Khi sentinel visible → OnLoadMore.InvokeAsync().
      Filter animation: items dùng CSS transition opacity 0.3s, transform 0.3s.
      Items bị ẩn → opacity 0, height 0, margin 0, padding 0 (collapse).
      Loading indicator: FluentProgressRing khi IsLoading=true.
      HasMore=false → "Đã tải hết" message.
      TrendGrid.razor.css: grid-template-columns repeat(4, 1fr), gap 16px, responsive.
    expected_result: "TrendGrid compile OK, grid 4 cột hiển thị, sentinel observer hoạt động"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "HIGH"

  - order: 13
    description: "Tạo MainLayout component + CSS"
    action: "CREATE"
    file: "AIHub/Layout/MainLayout.razor"
    logic: >
      FluentDesignTheme (dark mode support), header với logo "AIHub" + subtitle "Trending AI Tools & Repos",
      NavMenu đơn giản (Home), @Body container max-width 1400px margin auto padding 24px.
      Footer: "AIHub © 2026 — Aggregated from GitHub and other sources".
      MainLayout.razor.css: header gradient, footer subtle, responsive.
    expected_result: "MainLayout compile OK, header + body + footer render"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

  - order: 14
    description: "Tạo Home page — compose tất cả components + state management"
    action: "CREATE"
    file: "AIHub/Pages/Home.razor"
    logic: >
      @page "/". State: string _searchQuery, TimeFilter _currentFilter = Last24Hours,
      List<TrendingItem> _allItems, List<TrendingItem> _displayItems,
      int _currentPage = 1, bool _isLoading, bool _hasMore = true, const int PageSize = 50.

      OnInitializedAsync: _isLoading = true → _allItems = await TrendingService.GetTrendingAsync(_currentFilter, 1, PageSize)
      → _displayItems = _allItems → _isLoading = false.

      OnSearchChanged(string query): _searchQuery = query → FilterItems().
      FilterItems(): _displayItems = string.IsNullOrEmpty(_searchQuery) ? _allItems :
      _allItems.Where(i => i.Title.Contains(query, StringComparison.OrdinalIgnoreCase) ||
                           i.Description.Contains(query, StringComparison.OrdinalIgnoreCase) ||
                           i.Source.Contains(query, StringComparison.OrdinalIgnoreCase)).ToList().

      OnFilterChanged(TimeFilter filter): _currentFilter = filter, _currentPage = 1, ResetAndReload().

      OnLoadMore: _currentPage++, newItems = await TrendingService.GetTrendingAsync(_currentFilter, _currentPage, PageSize).
      Nếu newItems.Count < PageSize → _hasMore = false. _allItems.AddRange(newItems), FilterItems().

      Tri-state: _isLoading → FluentProgressRing. !_isLoading && _displayItems.Count == 0 → empty state.
      Has data → SearchBar + TimeFilterTabs + TrendGrid.

      Inline styles: page background, padding.
    expected_result: "Home page compile OK, full flow: load → render grid → search → filter tabs → load more"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 3
    requires_backup: false
    depends_on: [9, 10, 12, 13]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "HIGH"

  - order: 15
    description: "Tạo app.css global styles (animations, variables, reset)"
    action: "CREATE"
    file: "AIHub/wwwroot/css/app.css"
    logic: >
      CSS reset nhẹ, CSS variables cho theme (--bg-primary, --card-bg, --text-primary, --accent),
      @keyframes fadeInUp, @keyframes fadeOutDown, @keyframes staggerFadeIn.
      .grid-container styles, responsive breakpoints, scrollbar custom, .search-wrapper sticky.
      body font: system-ui, background var(--bg-primary), color var(--text-primary).
    expected_result: "app.css tồn tại, được reference trong index.html"
    check: "Kiểm tra file tồn tại + CSS valid"
    chunk: 3
    requires_backup: false
    depends_on: [4]
    validation_command: "Get-Content AIHub/wwwroot/css/app.css"
    risk_level: "LOW"

  - order: 16
    description: "Tạo sources.json config mặc định cho TrendingService"
    action: "CREATE"
    file: "AIHub/wwwroot/data/sources.json"
    logic: >
      JSON array các TrendingSource:
      [
        { "Name": "GitHub Trending", "ApiType": "GitHub", "ApiEndpoint": "https://api.github.com/search/repositories?q=created:>{date}&sort=stars&order=desc&per_page=50&page={page}", "Enabled": true, "Headers": { "User-Agent": "AIHub/1.0" } },
        { "Name": "GitHub AI Topics", "ApiType": "GitHub", "ApiEndpoint": "https://api.github.com/search/repositories?q=topic:ai+created:>{date}&sort=stars&order=desc&per_page=30&page={page}", "Enabled": true, "Headers": { "User-Agent": "AIHub/1.0" } },
        { "Name": "GitHub LLM Topics", "ApiType": "GitHub", "ApiEndpoint": "https://api.github.com/search/repositories?q=topic:llm+created:>{date}&sort=stars&order=desc&per_page=30&page={page}", "Enabled": true, "Headers": { "User-Agent": "AIHub/1.0" } }
      ]
    expected_result: "sources.json valid JSON, TrendingService load được khi khởi tạo"
    check: "dotnet build AIHub/AIHub.csproj"
    chunk: 2
    requires_backup: false
    depends_on: [8]
    validation_command: "dotnet build AIHub/AIHub.csproj"
    risk_level: "LOW"

per_step_validation:
  - step: 1
    command: "dotnet restore AIHub/AIHub.csproj"
    expected: "Restore thành công"
  - step: 4
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Chunk 1 hoàn tất"
  - step: 8
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Chunk 2 hoàn tất (sẽ thất bại nếu thiếu Models)"
  - step: 14
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Chunk 3 hoàn tất"
  - step: 16
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS cuối cùng"

per_chunk_validate:
  - chunk: 1
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Project skeleton + App.razor + _Imports"
  - chunk: 2
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Models + Services compile"
  - chunk: 3
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Tất cả components + pages compile"
  - chunk: 4
    command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build PASS — Integration hoàn chỉnh (chunk 4 gộp vào chunk 3)"

final_validation:
  - command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build thành công — 0 errors, 0 warnings"
  - command: "dotnet run --project AIHub/AIHub.csproj --urls http://localhost:5190"
    expected: "Server start thành công trên port 5190"

rollback_strategy:
  enabled: true
  trigger_conditions:
    - type: "catastrophic_failure"
      description: "Lỗi build không recover được"
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
    - "user request"
  steps:
    - "Xóa toàn bộ thư mục AIHub/ (tất cả file là CREATE mới, không ảnh hưởng codebase cũ)"

validate:
  - command: "dotnet build AIHub/AIHub.csproj"
    expected: "Build thành công"
```

---

## Planner Checklist
- [x] 16 steps, mỗi step có: action, file, logic, expected_result, check, chunk, depends_on, validation_command, risk_level
- [x] Chunk rules: 1=config/skeleton (steps 1-4), 2=models/services (steps 5-8,16), 3=components/UI (steps 9-15)
- [x] Per_step_validation cho 5 checkpoints
- [x] Per_chunk_validate cho 4 chunks
- [x] Final_validation: dotnet build + dotnet run
- [x] Rollback strategy: delete toàn bộ AIHub/ (an toàn vì tất cả là CREATE)
- [x] Depends_on xác định đúng: skeleton → models → services → components → pages
- [x] Effort: Medium → 3 chunks (16 steps)
- [x] Tất cả risk_level gán đúng (LOW cho CREATE, MEDIUM cho complex logic, HIGH cho integration)
