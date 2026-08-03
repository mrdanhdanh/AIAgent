# Phase 1: Analyze — AI Agent Hub (Trending Aggregator)

## Output Contract

```yaml
status: "READY"
summary: >
  Yêu cầu là tạo một web app Blazor WASM mới, tách biệt hoàn toàn với JapaneseLearner,
  hiển thị trending repos/skills/agents dạng grid 4 cột với infinite scroll, animations,
  search/filter realtime. Đây là greenfield project — không có code base hiện tại để phân tích,
  nhưng có thể tham khảo patterns từ JapaneseLearner (cùng repo).
details: >
  ## Phân tích chi tiết

  ### Đầu vào
  - Goal: Tạo web thứ 2 tách biệt JapaneseLearner, tổng hợp trending repos/skills/agents
  - Scope: Greenfield project mới, không ảnh hưởng JapaneseLearner
  - Criteria: Hiển thị grid 4 cột, infinite scroll, animations, search/filter, click → source
  - Allowed scope: Toàn bộ workspace, tham khảo JapaneseLearner patterns

  ### Khám phá
  - JapaneseLearner: .NET 10 Blazor WASM, FluentUI 4.14.3, Blazored.LocalStorage, DI pattern
  - Entry: Program.cs → App.razor → MainLayout.razor → Pages/*.razor
  - Patterns: cache-first services, tri-state rendering (Loading/Empty/Data), inline styles
  - Project structure: Models/ Services/ Pages/ Layout/ wwwroot/

  ### Yêu cầu chi tiết
  REQ-001: Trang web mới tách biệt, project .csproj riêng
  REQ-002: Nguồn dữ liệu từ GitHub trending, các trang AI tool, có thể mở rộng
  REQ-003: Grid 4 cột, card size dynamic theo "sức hấp dẫn" (stars, forks, activity)
  REQ-004: Infinite scroll / load more khi scroll xuống
  REQ-005: Animation khi load, filter, hover
  REQ-006: Search/filter bar ở top, lọc realtime, non-match biến mất với animation
  REQ-007: Click card → mở trang gốc (target="_blank")
  REQ-008: Cơ chế thêm nguồn dữ liệu sau này

  ### Rủi ro
  RISK-001 (MEDIUM): GitHub API rate limit (60 req/h không auth, 5000 auth) → caching strategy
  RISK-002 (LOW): Cross-origin issues khi fetch từ nhiều nguồn → server-side proxy hoặc CORS handling
  RISK-003 (LOW): Performance với lượng lớn cards + animations → virtual scrolling
  RISK-004 (LOW): FluentUI không có sẵn grid masonry → custom CSS grid

scanned_paths:
  - "JapaneseLearner/"
  - "JapaneseLearner/Pages/"
  - "JapaneseLearner/Services/"
  - "JapaneseLearner/Models/"
  - "JapaneseLearner/Layout/"
  - "JapaneseLearner/wwwroot/"
ignored_paths:
  - path: "JapaneseLearner/bin/"
    reason: "Build artifacts"
  - path: "JapaneseLearner/obj/"
    reason: "Build artifacts"
  - path: ".opencode/"
    reason: "Agent config, không liên quan"
  - path: "JapaneseLearner.Tests/"
    reason: "Test project, tham khảo pattern sau"
  - path: "JapaneseLearner.E2ETests/"
    reason: "E2E test project"
discovered_modules:
  - "JapaneseLearner (tham khảo patterns)"
  - "AIHub (project mới — đề xuất)"
structure:
  root: "AIHub"
  language: "C#"
  framework: "Blazor WebAssembly (.NET 10)"
  entry_points:
    - path: "AIHub/Program.cs"
      type: "app"
    - path: "AIHub/wwwroot/index.html"
      type: "config"
    - path: "AIHub/App.razor"
      type: "app"
  main_directories:
    - path: "AIHub/Pages/"
      description: "Razor pages (Home, Trending...)"
      relevance: "HIGH"
    - path: "AIHub/Services/"
      description: "Data fetching, caching, aggregation"
      relevance: "HIGH"
    - path: "AIHub/Models/"
      description: "TrendingItem, Source config models"
      relevance: "HIGH"
    - path: "AIHub/Components/"
      description: "Shared components (TrendCard, SearchBar, Grid)"
      relevance: "HIGH"
    - path: "AIHub/Layout/"
      description: "MainLayout, NavMenu"
      relevance: "MEDIUM"
    - path: "AIHub/wwwroot/"
      description: "Static assets, CSS, JS"
      relevance: "MEDIUM"
requirements:
  - id: "REQ-001"
    description: "Tạo project Blazor WASM mới AIHub, tách biệt JapaneseLearner"
    priority: "HIGH"
  - id: "REQ-002"
    description: "Service lấy dữ liệu trending từ GitHub API (repos), OpenCode agents/skills, configurable sources"
    priority: "HIGH"
  - id: "REQ-003"
    description: "Grid 4 cột hiển thị cards, kích thước card variant (small/medium/large) dựa trên sức hấp dẫn"
    priority: "HIGH"
  - id: "REQ-004"
    description: "Infinite scroll — IntersectionObserver load thêm khi scroll cuối trang"
    priority: "HIGH"
  - id: "REQ-005"
    description: "Animations: fade-in khi load card, stagger animation grid, hover scale, filter transition"
    priority: "MEDIUM"
  - id: "REQ-006"
    description: "Search bar filter realtime — non-matching items ẩn với animation collapse, matching items rearrange"
    priority: "HIGH"
  - id: "REQ-007"
    description: "Click card → mở URL gốc trong tab mới"
    priority: "HIGH"
  - id: "REQ-008"
    description: "Cấu trúc source config cho phép thêm nguồn dữ liệu mới (plugin pattern)"
    priority: "MEDIUM"
risks:
  - id: "RISK-001"
    description: "GitHub API rate limit 60 req/h không auth"
    severity: "MEDIUM"
    mitigation: "Cache kết quả trong localStorage 5 phút; cho phép thêm GitHub token qua UI"
  - id: "RISK-002"
    description: "CORS khi fetch từ nhiều nguồn khác nhau"
    severity: "LOW"
    mitigation: "WASM có thể fetch GitHub API trực tiếp; các nguồn khác dùng JSONP hoặc proxy nếu cần"
  - id: "RISK-003"
    description: "Performance grid lớn + animation có thể lag"
    severity: "LOW"
    mitigation: "Dùng CSS content-visibility, virtualization, batch render"
  - id: "RISK-004"
    description: "FluentUI không có masonry grid layout"
    severity: "LOW"
    mitigation: "Custom CSS grid với grid-template-columns repeat(4, 1fr) + grid-auto-rows masonry-like"
assumptions:
  - id: "ASM-001"
    description: "Dùng .NET 10 Blazor WASM + FluentUI 4.14.3 như JapaneseLearner để đồng bộ stack"
  - id: "ASM-002"
    description: "Dữ liệu chính: GitHub trending repos (API), mock data ban đầu cho skills/agents"
  - id: "ASM-003"
    description: "Không cần backend — WASM standalone, fetch API trực tiếp"
  - id: "ASM-004"
    description: "Port dev mặc định 5190 (khác JapaneseLearner 5146/5173)"
  - id: "ASM-005"
    description: "Sức hấp dẫn = composite score từ stars, forks, recent activity, description length"
dependencies: []
patterns:
  naming:
    pattern: "PascalCase cho class/component, camelCase cho biến local"
    location: "JapaneseLearner/"
    notes: "Tuân theo convention .NET/C#"
  routing:
    pattern: "Blazor @page directive"
    location: "JapaneseLearner/Pages/"
    notes: "Pages có @page route, MainLayout cho layout chung"
  state_management:
    pattern: "DI Service scoped + memory cache"
    location: "JapaneseLearner/Services/"
    notes: "Service inject qua DI, cache in-memory, không cần localStorage cho data trending"
  testing:
    framework: "xUnit + bUnit"
    locations: ["JapaneseLearner.Tests/"]
    notes: "Sẽ tạo AIHub.Tests/ sau"
impact_scope:
  - file: "AIHub/AIHub.csproj"
    level: "DIRECT"
    notes: "File project mới, tạo từ scratch"
  - file: "AIHub/Program.cs"
    level: "DIRECT"
    notes: "Entry point, đăng ký DI services + FluentUI"
  - file: "AIHub/Models/TrendingItem.cs"
    level: "DIRECT"
    notes: "Model chính cho trending item"
  - file: "AIHub/Models/SourceConfig.cs"
    level: "DIRECT"
    notes: "Cấu hình nguồn dữ liệu (extensible)"
  - file: "AIHub/Services/ITrendingService.cs"
    level: "DIRECT"
    notes: "Interface service lấy dữ liệu trending"
  - file: "AIHub/Services/TrendingService.cs"
    level: "DIRECT"
    notes: "Implementation: fetch + aggregate + cache"
  - file: "AIHub/Components/TrendCard.razor"
    level: "DIRECT"
    notes: "Component hiển thị 1 card trending"
  - file: "AIHub/Components/TrendGrid.razor"
    level: "DIRECT"
    notes: "Grid 4 cột + infinite scroll + animation"
  - file: "AIHub/Components/SearchBar.razor"
    level: "DIRECT"
    notes: "Search/filter bar + debounce"
  - file: "AIHub/Pages/Home.razor"
    level: "DIRECT"
    notes: "Trang chính hiển thị grid + search"
  - file: "AIHub/Layout/MainLayout.razor"
    level: "DIRECT"
    notes: "Layout chính"
  - file: "AIHub/App.razor"
    level: "DIRECT"
    notes: "Root component"
  - file: "JapaneseLearner/"
    level: "UNRELATED"
    notes: "Dự án tách biệt, không chỉnh sửa"
  - file: "AGENTS.md"
    level: "UNRELATED"
    notes: "Không cần chỉnh sửa guide cho project mới"
design_proposal:
  approach: >
    Tạo project Blazor WASM mới AIHub, dùng FluentUI cho UI framework.
    Architecture: Pages → Components → Services → Models.
    TrendingService fetch dữ liệu từ GitHub trending API + các nguồn khác,
    cache in-memory 5 phút. Grid dùng CSS Grid 4 cột với IntersectionObserver
    cho infinite scroll. Search dùng debounce + CSS transition cho filter.
    SourceConfig cho phép thêm nguồn mới qua config JSON.
  affected_modules:
    - "AIHub (toàn bộ project mới)"
  new_files:
    - "AIHub/AIHub.csproj"
    - "AIHub/Program.cs"
    - "AIHub/App.razor"
    - "AIHub/_Imports.razor"
    - "AIHub/Properties/launchSettings.json"
    - "AIHub/wwwroot/index.html"
    - "AIHub/wwwroot/css/app.css"
    - "AIHub/Models/TrendingItem.cs"
    - "AIHub/Models/TrendingSource.cs"
    - "AIHub/Models/TimeFilter.cs"
    - "AIHub/Services/ITrendingService.cs"
    - "AIHub/Services/TrendingService.cs"
    - "AIHub/Components/TrendCard.razor"
    - "AIHub/Components/TrendCard.razor.css"
    - "AIHub/Components/TrendGrid.razor"
    - "AIHub/Components/TrendGrid.razor.css"
    - "AIHub/Components/SearchBar.razor"
    - "AIHub/Components/SearchBar.razor.css"
    - "AIHub/Components/TimeFilterTabs.razor"
    - "AIHub/Pages/Home.razor"
    - "AIHub/Layout/MainLayout.razor"
    - "AIHub/Layout/MainLayout.razor.css"
    - "AIHub/wwwroot/data/sources.json"
  modified_files: []
  integration_points:
    - "GitHub Trending API: https://api.github.com/search/repositories?q=created:>DATE&sort=stars"
    - "GitHub API cho trending developers, topics"
    - "Mở rộng: thêm RSS, Reddit, HackerNews API sau"
tasks:
  - id: "TASK-001"
    description: "Tạo cấu trúc project AIHub (csproj, Program.cs, App.razor, _Imports, launchSettings, index.html)"
    files: ["AIHub/AIHub.csproj", "AIHub/Program.cs", "AIHub/App.razor", "AIHub/_Imports.razor"]
    depends_on: []
    why: "Project skeleton cần có trước khi code bất kỳ component nào"

  - id: "TASK-002"
    description: "Tạo Models: TrendingItem, TrendingSource, TimeFilter"
    files: ["AIHub/Models/TrendingItem.cs", "AIHub/Models/TrendingSource.cs", "AIHub/Models/TimeFilter.cs"]
    depends_on: ["TASK-001"]
    why: "Models là foundation cho Services và Components"

  - id: "TASK-003"
    description: "Tạo TrendingService (interface + implementation) — fetch GitHub API, aggregate, cache"
    files: ["AIHub/Services/ITrendingService.cs", "AIHub/Services/TrendingService.cs"]
    depends_on: ["TASK-002"]
    why: "Service cần Models để deserialize API response"

  - id: "TASK-004"
    description: "Tạo SearchBar component với debounce + filter logic"
    files: ["AIHub/Components/SearchBar.razor", "AIHub/Components/SearchBar.razor.css"]
    depends_on: ["TASK-001"]
    why: "Component độc lập, chỉ cần project skeleton"

  - id: "TASK-005"
    description: "Tạo TrendCard component với 3 size variants (small/medium/large) + animation"
    files: ["AIHub/Components/TrendCard.razor", "AIHub/Components/TrendCard.razor.css"]
    depends_on: ["TASK-002"]
    why: "Cần Model TrendingItem để binding data"

  - id: "TASK-006"
    description: "Tạo TrendGrid component — CSS Grid 4 cột, IntersectionObserver infinite scroll, stagger animation"
    files: ["AIHub/Components/TrendGrid.razor", "AIHub/Components/TrendGrid.razor.css"]
    depends_on: ["TASK-005"]
    why: "Grid chứa TrendCard, cần component card hoàn tất trước"

  - id: "TASK-007"
    description: "Tạo TimeFilterTabs component (24h / 7d / 30d)"
    files: ["AIHub/Components/TimeFilterTabs.razor"]
    depends_on: ["TASK-001"]
    why: "Component độc lập, chỉ emit event"

  - id: "TASK-008"
    description: "Tạo MainLayout + Home page tích hợp tất cả components"
    files: ["AIHub/Layout/MainLayout.razor", "AIHub/Layout/MainLayout.razor.css", "AIHub/Pages/Home.razor"]
    depends_on: ["TASK-004", "TASK-006", "TASK-007"]
    why: "Home page là nơi compose SearchBar + TimeFilterTabs + TrendGrid"

  - id: "TASK-009"
    description: "Tạo CSS animations + transitions toàn cục (app.css)"
    files: ["AIHub/wwwroot/css/app.css"]
    depends_on: ["TASK-004", "TASK-005", "TASK-006"]
    why: "Animation styles dùng chung cần tham khảo markup từ components"

  - id: "TASK-010"
    description: "Tạo sources.json (config mặc định các nguồn dữ liệu)"
    files: ["AIHub/wwwroot/data/sources.json"]
    depends_on: ["TASK-003"]
    why: "Service dùng config này để biết fetch từ đâu"

  - id: "TASK-011"
    description: "Build + test project, verify tất cả hoạt động"
    files: []
    depends_on: ["TASK-008", "TASK-009", "TASK-010"]
    why: "Integration test sau khi tất cả components hoàn tất"

conclusion:
  status: "READY"
  reason: >
    Yêu cầu rõ ràng, đầy đủ 8 requirements. Greenfield project → không có rủi ro phá vỡ codebase hiện tại.
    Stack xác định (Blazor WASM + FluentUI), architecture rõ ràng (Pages → Components → Services → Models).
    11 tasks được sắp xếp theo dependency order. Sẵn sàng chuyển sang phase design.
  missing_info: []
```
