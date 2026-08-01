---
workflow_id: "WF-20260801-001"
step: 1
step_name: "analyze"
agent: "analyst"
schema_version: "2.0"
timestamp: "2026-08-01T17:20:00Z"
---

# Bước 1: Phân tích yêu cầu — Knowledge Assistant

```yaml
status: "READY"
summary: >
  Yêu cầu xây dựng Knowledge Assistant — hệ thống AI hiểu toàn bộ codebase
  và trả lời các câu hỏi về module, API, dependency, data model, impact analysis
  qua 10 skills + 11 commands. Phát hiện quan trọng: yêu cầu gốc mô tả stack
  Oracle/Angular/PL-SQL nhưng dự án thực tế là Blazor WASM + C# + FluentUI
  (không có database — cache-first + Blazored.LocalStorage).
  Do đó thiết kế phải ADAPT các skill sang ngữ cảnh C#/Razor/Blazor.
  Kết luận: READY — đủ thông tin để thiết kế (điểm adapt được ghi rõ trong assumptions).

details: |
  ## Khám phá codebase

  Dự án **JapaneseLearner** — .NET 10 Blazor WebAssembly + FluentUI 4.14.3.
  Cấu trúc 3 project: `JapaneseLearner/` (app), `JapaneseLearner.Tests/` (xUnit+bUnit),
  `JapaneseLearner.E2ETests/` (Playwright). Không có .sln — build/test per-project.

  ### Entry points
  - `JapaneseLearner/Program.cs` — DI container, đăng ký 5 services (ICharService,
    IWordService, IKanjiService, IGrammarService, IThemeService) qua AddScoped.
  - `JapaneseLearner/App.razor` — root component.
  - `JapaneseLearner/Layout/MainLayout.razor` — layout + nav.
  - `JapaneseLearner.Tests/BunitTestBase.cs` — base bUnit test (mock 9 FluentUI JS modules).
  - `JapaneseLearner.E2ETests/AppFixture.cs` — auto-start dev server (port 5173 hardcoded).

  ### Data model (4 entities — Models/)
  - `JapaneseChar` (Id, Character, Romaji, Type=Hiragana/Katakana)
  - `JapaneseWord` (Id, Characters, Romaji, Meaning, Type, Level) — Meaning là tiếng Việt
  - `JapaneseKanji` (Id, Character, Onyomi, Kunyomi, Meaning, Examples...)
  - `JapaneseGrammar` (Id, Pattern, Explanation, Examples...)

  ### Services (Service-Interface DI pattern)
  - 5 interface + 5 implementation trong Services/, AddScoped trong Program.cs
  - Cache-first: in-memory cache + persist qua Blazored.LocalStorage, seed on first load
  - WordService/KanjiService/GrammarService nhận `IProgress<int>` cho load data lớn

  ### Routes (13 pages + Admin CRUD 4-tab)
  - Home `/`, AlphabetStudy `/alphabet`, AlphabetQuiz `/alphabet/quiz`,
    WordStudy `/words`, WordQuiz `/words/quiz`, KanjiStudy `/kanji`,
    KanjiDetail `/kanji/{Id}`, KanjiQuiz `/kanji/quiz`,
    GrammarStudy `/grammar`, GrammarDetail `/grammar/{Id}`,
    Practice `/practice`, Training `/practice/train`, Admin `/admin`

  ### Patterns
  - Tri-state rendering: isLoading → list.Count==0 (Empty) → Data
  - FluentUI: FluentButton (Appearance enum .Accent/.Lightweight/.Neutral),
    FluentSelect<TOption>, FluentDialog, FluentProgressRing, FluentDesignTheme
  - CSS: MainLayout.razor.css (isolation), pages dùng inline <style>
  - ThemeService: dark mode toggle qua Blazored.LocalStorage + FluentDesignTheme

  ### Framework AI (điểm tích hợp mới)
  - `.opencode/` — 17 agents, 33 commands, 17 skills, scripts (backup/rollback/
    doctor/sync-system-docs), knowledge base (7 categories, 17 files)
  - Convention skill: frontmatter YAML (name, description, schema_version) + SKILL.md
  - Convention command: frontmatter (description, agent) + template + Output Contract

  ### Yêu cầu gốc vs thực tế (gap analysis)
  | Yêu cầu gốc (mô tả stack) | Thực tế dự án | Quyết định adapt |
  |---|---|---|
  | Oracle / PL/SQL / Stored Procedure | Không có DB — LocalStorage | database-reader → data-model-reader (Models + Services + LocalStorage) |
  | Angular | Blazor WASM + Razor | code-understanding đọc .razor + .cs |
  | API → Angular → Screen | Service DI → Page | dependency-analyzer xây call graph Service→Page |
  | /where CustomerId (Oracle field) | /where dùng tên property C# | search-engine + /where tìm trong Models/Services/Pages |
  | /trace Login (UI→API→Service→Repo→DB) | /trace theo route: Page→Service→Model→LocalStorage | flow-reader adapt |
  | /compare-doc code vs design | Có docs trong knowledge/ + PRODUCT.md | giữ nguyên |

scanned_paths:
  - "JapaneseLearner/Program.cs"
  - "JapaneseLearner/Models/"
  - "JapaneseLearner/Services/"
  - "JapaneseLearner/Pages/"
  - "JapaneseLearner.Tests/"
  - "JapaneseLearner.E2ETests/"
  - ".opencode/agents/"
  - ".opencode/commands/"
  - ".opencode/skills/"
  - ".opencode/scripts/"
  - ".opencode/knowledge/"
ignored_paths:
  - path: "**/bin/"
    reason: "Build artifacts"
  - path: "**/obj/"
    reason: "Build intermediates"
  - path: ".git/"
    reason: "VCS metadata (git-history skill đọc qua git log, không quét thư mục)"
  - path: "node_modules/"
    reason: "Dependencies (nếu có)"
discovered_modules:
  - "JapaneseLearner"
  - "JapaneseLearner.Tests"
  - "JapaneseLearner.E2ETests"
  - ".opencode (Agent Framework)"

structure:
  root: "JapaneseLearner"
  language: "C#"
  framework: "Blazor WebAssembly + FluentUI 4.14.3"
  entry_points:
    - path: "JapaneseLearner/Program.cs"
      type: "app"
    - path: "JapaneseLearner/App.razor"
      type: "app"
    - path: "JapaneseLearner.Tests/BunitTestBase.cs"
      type: "test"
    - path: "JapaneseLearner.E2ETests/AppFixture.cs"
      type: "test"
  main_directories:
    - path: "JapaneseLearner/Models/"
      description: "4 entity classes"
      relevance: "HIGH"
    - path: "JapaneseLearner/Services/"
      description: "5 service-interface pairs, cache-first + LocalStorage"
      relevance: "HIGH"
    - path: "JapaneseLearner/Pages/"
      description: "13 .razor pages + tri-state rendering"
      relevance: "HIGH"
    - path: ".opencode/"
      description: "AI Agent Framework — agents, commands, skills, scripts, knowledge"
      relevance: "HIGH (nơi tạo hệ thống mới)"

requirements:
  - id: "REQ-001"
    description: "Tạo 10 skill chuyên biệt: code-understanding, document-understanding, dependency-analyzer, workflow-reader, search-engine, architecture-reader, database-reader (adapt thành data-model-reader), git-history, impact-analyzer, answer-builder"
    priority: "HIGH"
  - id: "REQ-002"
    description: "Tạo 11 command: /ask, /where, /why, /flow, /impact, /explain, /trace, /compare-doc, /knowledge-health, /knowledge-index (+ /ask routing)"
    priority: "HIGH"
  - id: "REQ-003"
    description: "Xây tầng Knowledge Index: /knowledge-index xây chỉ mục (Code/Symbol/API/Dependency Graph/Document Index) + --update khi source thay đổi"
    priority: "HIGH"
  - id: "REQ-004"
    description: "Pipeline: Intent Analyzer → Knowledge Planner → Code/Doc Skill → Dependency Skill → Impact Analyzer → Answer Builder (evidence-based, có nguồn)"
    priority: "HIGH"
  - id: "REQ-005"
    description: "Đăng ký commands + skills vào opencode.json, agent cần thiết (knowledge-agent), theo convention .opencode hiện có"
    priority: "HIGH"
  - id: "REQ-006"
    description: "Đảm bảo không phá vỡ hệ thống hiện có: /doctor vẫn PASS, sync-system-docs hoạt động, build + test dự án vẫn xanh"
    priority: "MEDIUM"

risks:
  - id: "RISK-001"
    description: "Yêu cầu gốc mô tả stack Oracle/Angular — nếu copy nguyên văn sẽ tạo skill không khớp dự án thực tế"
    severity: "HIGH"
    mitigation: "Adapt mọi skill sang ngữ cảnh C#/Razor/Blazor + LocalStorage; ghi rõ trong từng SKILL.md phần 'Stack mapping'"
  - id: "RISK-002"
    description: "Tạo 10 skill + 11 command + index layer = khối lượng lớn (Large effort) — dễ vượt scope"
    severity: "MEDIUM"
    mitigation: "Chia 3 phase: Phase 1 (core commands + index), Phase 2 (skills sâu), Phase 3 (integration + test). Mỗi phase có expected_result"
  - id: "RISK-003"
    description: "Sửa opencode.json sai cú pháp → phá vỡ toàn bộ command framework hiện có"
    severity: "HIGH"
    mitigation: "Backup opencode.json trước khi sửa; validate JSON sau mỗi lần edit; chạy /doctor để verify"
  - id: "RISK-004"
    description: "Xây Knowledge Index bằng script có thể đọc quá nhiều file → chậm hoặc bỏ sót"
    severity: "MEDIUM"
    mitigation: "Index riêng từng category, ignore bin/obj/.git, sử dụng glob có kiểm soát; script có dry-run mode"
  - id: "RISK-005"
    description: "Command mới trùng tên/thuộc tính với command hiện có trong opencode.json"
    severity: "LOW"
    mitigation: "Quét opencode.json hiện có trước khi thêm; dùng tên namespace knowledge-*"

assumptions:
  - id: "ASM-001"
    description: "Mọi skill được thiết kế cho ngôn ngữ chính là C#/.NET + Blazor/Razor + (optional) SQL — KHÔNG hardcode Oracle/Angular vì dự án không dùng"
  - id: "ASM-002"
    description: "'Database' trong yêu cầu gốc được map sang 'data layer' thực tế: Models + Services (cache-first) + Blazored.LocalStorage key"
  - id: "ASM-003"
    description: "Command được đăng ký trực tiếp trong opencode.json (giống các command team-* hiện có)"
  - id: "ASM-004"
    description: "Cần 1 agent mới 'knowledge-agent' (hoặc tái sử dụng general) để xử lý intent + routing — đơn giản hơn là tạo 10 agent riêng"
  - id: "ASM-005"
    description: "Knowledge Index ban đầu là chỉ mục Markdown/JSON (code index, symbol index, route index) do script sinh, không cần vector DB"

dependencies:
  - from: ".opencode/commands/team.md (orchestrator)"
    to: "commands knowledge-*.md mới"
    type: "import"
    evidence_file: ".opencode/commands/team.md"
    evidence_line: 1
    reason: "Command mới phải theo cùng convention (frontmatter description + agent + Output Contract)"
  - from: "opencode.json"
    to: "command mới + skill mới"
    type: "service"
    evidence_file: "opencode.json"
    evidence_line: 209
    reason: "Mọi command/skill phải đăng ký trong opencode.json để opencode nhận diện"
  - from: "script index (mới)"
    to: ".opencode/scripts/ (thư mục hiện có)"
    type: "import"
    evidence_file: ".opencode/scripts/backup-utility.ps1"
    evidence_line: 1
    reason: "Script mới (knowledge-index.ps1) đặt cùng thư mục scripts hiện có"
  - from: "JapaneseLearner/Models/*.cs"
    to: "skill code-understanding"
    type: "data"
    evidence_file: "JapaneseLearner/Models/JapaneseChar.cs"
    evidence_line: 3
    reason: "Skill phải đọc được entity models để trả lời câu hỏi data model"

patterns:
  naming:
    pattern: "PascalCase (class), kebab-case (file), knowledge-* (command)"
    location: "JapaneseLearner/Models/, .opencode/commands/"
    notes: "Model class dùng PascalCase; command mới đặt prefix knowledge-"
  routing:
    pattern: "@page directive trong .razor"
    location: "JapaneseLearner/Pages/"
    notes: "13 routes — /knowledge-index phải quét @page để xây route index"
  state_management:
    pattern: "DI Service + Blazored.LocalStorage, cache-first"
    location: "JapaneseLearner/Services/"
    notes: "data-model-reader phải mô tả pattern cache-first này"
  testing:
    framework: "xUnit + bUnit + Playwright"
    locations: ["JapaneseLearner.Tests/", "JapaneseLearner.E2ETests/"]
  framework_skill:
    pattern: "SKILL.md với frontmatter YAML (name, description, schema_version)"
    location: ".opencode/skills/*/SKILL.md"
    notes: "10 skill mới phải theo đúng convention này"

impact_scope:
  - file: "opencode.json"
    level: "DIRECT"
    notes: "Thêm 11+ command mới + 10 skill paths (nếu cần) — phải backup trước"
  - file: ".opencode/commands/*.md (11 file mới)"
    level: "DIRECT"
    notes: "Tạo mới: ask.md, where.md, why.md, flow.md, impact.md, explain.md, trace.md, compare-doc.md, knowledge-health.md, knowledge-index.md (+ knowledge-help.md)"
  - file: ".opencode/skills/*/SKILL.md (10 thư mục mới)"
    level: "DIRECT"
    notes: "Tạo mới 10 skill theo yêu cầu"
  - file: ".opencode/scripts/knowledge-index.ps1 (mới)"
    level: "DIRECT"
    notes: "Script xây Knowledge Index"
  - file: ".opencode/agents/knowledge-agent.md (mới)"
    level: "DIRECT"
    notes: "Agent intent analyzer + router (hoặc tái sử dụng general)"
  - file: ".opencode/knowledge/knowledge-assistant/ (mới)"
    level: "DIRECT"
    notes: "Docs + index output + lessons cho Knowledge Assistant"
  - file: ".opencode/scripts/sync-system-docs.ps1"
    level: "INDIRECT"
    notes: "Nếu command/skill mới không có section trong SYSTEM_MAP — sync sẽ log warning; cần chạy /team-syncdocs sau khi tạo"
  - file: "AGENTS.md"
    level: "INDIRECT"
    notes: "Có thể cập nhật bảng lệnh để tài liệu hóa command mới (optional)"

design_proposal:
  approach: >
    Xây Knowledge Assistant như một lớp mới trong .opencode framework:
    (1) 10 SKILL.md theo convention hiện có, mỗi skill một chuyên môn đọc hiểu
    codebase; (2) 11 command knowledge-* đăng ký trong opencode.json, routing
    qua 1 agent knowledge-agent (intent analyzer + planner); (3) Knowledge Index
    layer: script knowledge-index.ps1 sinh chỉ mục JSON/MD vào
    .opencode/knowledge/knowledge-assistant/index/, có --update;
    (4) Pipeline trả lời: Intent → Plan → Gather evidence (code/doc/data/git) →
    Dependency → Impact → Answer Builder (có nguồn trích dẫn).
    Tất cả adapt cho stack C#/Blazor — không Oracle/Angular.
  affected_modules:
    - ".opencode/commands"
    - ".opencode/skills"
    - ".opencode/scripts"
    - ".opencode/agents"
    - ".opencode/knowledge"
    - "opencode.json"
  new_files:
    - ".opencode/commands/knowledge.md (help + routing)"
    - ".opencode/commands/knowledge-ask.md"
    - ".opencode/commands/knowledge-where.md"
    - ".opencode/commands/knowledge-why.md"
    - ".opencode/commands/knowledge-flow.md"
    - ".opencode/commands/knowledge-impact.md"
    - ".opencode/commands/knowledge-explain.md"
    - ".opencode/commands/knowledge-trace.md"
    - ".opencode/commands/knowledge-compare-doc.md"
    - ".opencode/commands/knowledge-health.md"
    - ".opencode/commands/knowledge-index.md"
    - ".opencode/agents/knowledge-agent.md"
    - ".opencode/skills/knowledge/code-understanding/SKILL.md"
    - ".opencode/skills/knowledge/document-understanding/SKILL.md"
    - ".opencode/skills/knowledge/dependency-analyzer/SKILL.md"
    - ".opencode/skills/knowledge/workflow-reader/SKILL.md"
    - ".opencode/skills/knowledge/search-engine/SKILL.md"
    - ".opencode/skills/knowledge/architecture-reader/SKILL.md"
    - ".opencode/skills/knowledge/data-model-reader/SKILL.md"
    - ".opencode/skills/knowledge/git-history/SKILL.md"
    - ".opencode/skills/knowledge/impact-analyzer/SKILL.md"
    - ".opencode/skills/knowledge/answer-builder/SKILL.md"
    - ".opencode/scripts/knowledge-index.ps1"
    - ".opencode/knowledge/knowledge-assistant/README.md"
    - ".opencode/knowledge/knowledge-assistant/index/.gitkeep"
  modified_files:
    - "opencode.json"
  integration_points:
    - "opencode.json command registry"
    - ".opencode/skills (skill paths)"
    - "/team-syncdocs (SYSTEM_MAP cập nhật)"
    - "/doctor (health check không regress)"

tasks:
  - id: "TASK-001"
    description: "Tạo 10 skill Knowledge Assistant (code-understanding, document-understanding, dependency-analyzer, workflow-reader, search-engine, architecture-reader, data-model-reader, git-history, impact-analyzer, answer-builder)"
    files: [".opencode/skills/knowledge/*/SKILL.md"]
    depends_on: []
    why: "Nền tảng kiến thức — các command gọi các skill này"
  - id: "TASK-002"
    description: "Tạo knowledge-agent.md (intent analyzer + router)"
    files: [".opencode/agents/knowledge-agent.md"]
    depends_on: ["TASK-001"]
    why: "Agent routing dựa trên skill đã định nghĩa"
  - id: "TASK-003"
    description: "Tạo 11 command knowledge-* (ask, where, why, flow, impact, explain, trace, compare-doc, health, index, help)"
    files: [".opencode/commands/knowledge-*.md"]
    depends_on: ["TASK-002"]
    why: "Command gọi agent + skill theo pipeline"
  - id: "TASK-004"
    description: "Tạo script knowledge-index.ps1 (build/update/status index)"
    files: [".opencode/scripts/knowledge-index.ps1"]
    depends_on: []
    why: "Tầng Knowledge Index — script độc lập, command knowledge-index gọi"
  - id: "TASK-005"
    description: "Đăng ký agent + 11 command vào opencode.json (backup trước)"
    files: ["opencode.json"]
    depends_on: ["TASK-003", "TASK-004"]
    why: "Cần command/skill tồn tại trước khi đăng ký; backup trước khi sửa file cấu hình"
  - id: "TASK-006"
    description: "Chạy knowledge-index.ps1 lần đầu — sinh index cho JapaneseLearner"
    files: [".opencode/knowledge/knowledge-assistant/index/"]
    depends_on: ["TASK-004"]
    why: "Tạo index thực tế để test các command đọc được"
  - id: "TASK-007"
    description: "Test toàn bộ: build dự án + dotnet test (unit) + chạy /doctor + validate opencode.json + smoke test 2-3 command"
    files: []
    depends_on: ["TASK-005", "TASK-006"]
    why: "Đảm bảo không regress hệ thống hiện có"
  - id: "TASK-008"
    description: "Chạy /team-syncdocs cập nhật SYSTEM_MAP + ghi lessons vào knowledge"
    files: [".opencode/knowledge/"]
    depends_on: ["TASK-007"]
    why: "Đồng bộ tài liệu hệ thống sau khi thêm command/skill mới"

conclusion:
  status: "READY"
  reason: >
    Yêu cầu rõ ràng, đủ chi tiết để thiết kế. Điểm cần adapt (Oracle→C#/Blazor,
    database→data layer) được xác định rõ trong assumptions và gap analysis.
    Không cần thêm thông tin từ user — các quyết định adapt đều dựa trên
    evidence từ codebase thực tế.
  missing_info: []
