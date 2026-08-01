# 01_analysis.md — WF-20260801-002

```yaml
status: READY
effort: Large
summary: >
  Yêu cầu xây dựng Knowledge Assistant — không phải một agent thông thường mà là một hệ
  thống kết hợp 10 skill chuyên biệt (code-understanding, document-understanding,
  dependency-analyzer, workflow-reader, search-engine, architecture-reader,
  database-reader, git-history, impact-analyzer, answer-builder) + 9 command hỏi đáp
  (/ask, /where, /why, /flow, /impact, /explain, /trace, /compare-doc, /knowledge-health)
  + tầng Knowledge Index (/knowledge-index --update). Hệ thống này nhắm mục tiêu trả lời
  mọi câu hỏi về codebase với bằng chứng (evidence-based, không suy đoán).
details: >
  Khảo sát hiện trạng: dự án JapaneseLearner là Blazor WASM (C# + Razor) với 5 services
  (CharService 122d, WordService 695d, KanjiService 253d, GrammarService 205d, ThemeService 31d),
  13 pages Razor, 4 models, DI đăng ký trong Program.cs, cache-first + Blazored.LocalStorage.
  Hệ thống .opencode hiện có 17 skills + 33 commands + knowledge base 18 file markdown +
  9 agent định nghĩa. CHƯA có bất kỳ hệ thống nào giúp trả lời câu hỏi về codebase:
  không có /ask, không có knowledge-index, không có dependency graph. Knowledge base hiện
  tại chỉ là tài liệu tĩnh (fluentu, dark-mode, playwright...) — không có cơ chế truy vấn,
  không có cross-reference giữa code và docs. Kế hoạch đề xuất: (1) tạo 10 skill knowledge
  trong .opencode/skills/, (2) tạo 10 command trong .opencode/commands/ (gồm /knowledge-index),
  (3) tạo knowledge-index/ với cấu trúc code-symbol-api-database-dependency-document-business
  index + script build-index, (4) tạo knowledge-assistant skill tổng hợp làm intent analyzer +
  pipeline điều phối, (5) cập nhật AGENTS.md + knowledge base với cross-reference.
scanned_paths:
  - ".opencode/agents/"
  - ".opencode/commands/"
  - ".opencode/skills/"
  - ".opencode/knowledge/"
  - "JapaneseLearner/"
  - "JapaneseLearner.Tests/"
  - "JapaneseLearner.E2ETests/"
ignored_paths:
  - path: "**/bin"
    reason: "Build artifacts"
  - path: "**/obj"
    reason: "Build artifacts"
  - path: ".opencode/backup"
    reason: "Backup storage"
discovered_modules:
  - "Knowledge Skills (10)"
  - "Knowledge Commands (10)"
  - "Knowledge Index layer"
  - "Knowledge Assistant orchestrator"
structure:
  root: "."
  language: "C# / Markdown / YAML / PowerShell"
  framework: "Blazor WebAssembly + OpenCode Agent Framework"
  entry_points:
    - path: "JapaneseLearner/Program.cs"
      type: "app"
    - path: ".opencode/commands/team.md"
      type: "orchestrator"
  main_directories:
    - path: "JapaneseLearner/Services/"
      description: "Business logic — cache-first services"
      relevance: "HIGH"
    - path: "JapaneseLearner/Pages/"
      description: "Blazor UI pages (13 pages)"
      relevance: "HIGH"
    - path: ".opencode/skills/"
      description: "Reusable agent skills"
      relevance: "HIGH"
    - path: ".opencode/commands/"
      description: "Agent commands"
      relevance: "HIGH"
    - path: ".opencode/knowledge/"
      description: "Knowledge base (18 files)"
      relevance: "HIGH"
requirements:
  - id: "REQ-001"
    description: "Skill code-understanding — đọc C#/Razor/JS/SQL, trả lời class/method/call-graph/dependency/lifecycle/DI/interface/inheritance"
    priority: "HIGH"
  - id: "REQ-002"
    description: "Skill document-understanding — đọc README/SPEC/design/wiki, trích xuất requirement/business-rule/flow/constraint/decision"
    priority: "HIGH"
  - id: "REQ-003"
    description: "Skill dependency-analyzer — xây call graph, module graph, reference graph, service graph (DI)"
    priority: "HIGH"
  - id: "REQ-004"
    description: "Skill workflow-reader — đọc flow/diagram/mermaid/sequence, trả lời user flow/business flow/API flow"
    priority: "MEDIUM"
  - id: "REQ-005"
    description: "Skill search-engine — semantic search code (upload handler, export excel, nơi dùng package)"
    priority: "HIGH"
  - id: "REQ-006"
    description: "Skill architecture-reader — xác định layer/architecture pattern, phát hiện vi phạm"
    priority: "MEDIUM"
  - id: "REQ-007"
    description: "Skill database-reader — đọc table/view/procedure/trigger/index/FK, trả lời bảng dùng ở đâu"
    priority: "MEDIUM"
  - id: "REQ-008"
    description: "Skill git-history — trả lời ai sửa/khi nào/lý do/commit nào (nếu có git)"
    priority: "LOW"
  - id: "REQ-009"
    description: "Skill impact-analyzer — quan trọng nhất: sửa X ảnh hưởng API/screen/batch/report nào"
    priority: "HIGH"
  - id: "REQ-010"
    description: "Skill answer-builder — ghép thông tin thành câu trả lời có nguồn, không suy đoán"
    priority: "HIGH"
  - id: "REQ-011"
    description: "Command /ask — hỏi đáp tự do về module/workflow"
    priority: "HIGH"
  - id: "REQ-012"
    description: "Command /where — tìm mọi nơi sử dụng symbol (class/sql/api)"
    priority: "HIGH"
  - id: "REQ-013"
    description: "Command /why — giải thích lý do tồn tại của component"
    priority: "MEDIUM"
  - id: "REQ-014"
    description: "Command /flow — sinh sequence/flow/mermaid cho luồng nghiệp vụ"
    priority: "MEDIUM"
  - id: "REQ-015"
    description: "Command /impact — sinh affected API/screen/job/SP khi sửa component"
    priority: "HIGH"
  - id: "REQ-016"
    description: "Command /explain — giải thích từng method của file"
    priority: "MEDIUM"
  - id: "REQ-017"
    description: "Command /trace — truy vết UI→API→Service→Repository→DB→Response"
    priority: "HIGH"
  - id: "REQ-018"
    description: "Command /compare-doc — so sánh code vs design doc"
    priority: "LOW"
  - id: "REQ-019"
    description: "Command /knowledge-health — đánh giá thiếu README/diagram/flow/ADR/comment"
    priority: "MEDIUM"
  - id: "REQ-020"
    description: "Command /knowledge-index — build/update Knowledge Index (7 loại index) từ source code"
    priority: "HIGH"
  - id: "REQ-021"
    description: "Knowledge Index layer — code-index, symbol-index, api-index, database-index, dependency-graph, document-index, business-rule-index"
    priority: "HIGH"
  - id: "REQ-022"
    description: "Knowledge Assistant orchestrator skill — intent analyzer + knowledge planner + điều phối pipeline"
    priority: "HIGH"
risks:
  - id: "RISK-001"
    description: "Index lỗi thời khi source thay đổi — trả lời sai dựa trên index cũ"
    severity: HIGH
    mitigation: "Command /knowledge-index --update phải được chạy sau mỗi build thay đổi source; ghi timestamp index"
  - id: "RISK-002"
    description: "Trả lời thiếu chính xác nếu chỉ đọc index — cần đọc file gốc khi cần chi tiết"
    severity: MEDIUM
    mitigation: "Thiết kế pipeline: index để định vị nhanh, luôn đọc file gốc trước khi trả lời"
  - id: "RISK-003"
    description: "Quá nhiều file tạo ra (10 skills + 10 commands + index layer) dễ thiếu nhất quán"
    severity: MEDIUM
    mitigation: "Tuân thủ schema YAML frontmatter chuẩn + cross-reference lẫn nhau + test hợp lệ"
  - id: "RISK-004"
    description: "Script PowerShell build index có thể fail trên Windows path/encoding"
    severity: MEDIUM
    mitigation: "Dùng UTF-8, test script trước khi merge, xử lý lỗi try/catch"
assumptions:
  - id: "ASM-001"
    description: "Knowledge Assistant chạy trên OpenCode Agent Framework (giống các skill/command hiện có)"
  - id: "ASM-002"
    description: "Dự án nhắm chính tới codebase JapaneseLearner nhưng skill thiết kế tổng quát (hỗ trợ Oracle/Angular nếu cần)"
  - id: "ASM-003"
    description: "Index lưu dạng JSON/markdown trong .opencode/knowledge-index/ — không cần database ngoài"
dependencies:
  - from: "Assistant"
    to: "Intent Analyzer"
    type: "call"
    evidence_file: ".opencode/skills/knowledge-assistant/SKILL.md"
    evidence_line: 0
    reason: "Điểm vào pipeline — phân tích intent câu hỏi"
  - from: "Intent Analyzer"
    to: "Knowledge Planner"
    type: "call"
    evidence_file: ".opencode/skills/knowledge-assistant/SKILL.md"
    evidence_line: 0
    reason: "Planner quyết định skill nào tham gia trả lời"
  - from: "Code Skill"
    to: "Answer Builder"
    type: "call"
    evidence_file: ".opencode/skills/knowledge-assistant/SKILL.md"
    evidence_line: 0
    reason: "Kết quả skill được ghép vào câu trả lời"
patterns:
  naming:
    pattern: "kebab-case skill/command files"
    location: ".opencode/skills/, .opencode/commands/"
    notes: "Skill: folder/SKILL.md, Command: folder.md"
  routing:
    pattern: "YAML frontmatter + description"
    location: ".opencode/commands/"
    notes: "Agent: general cho orchestrator commands"
  state_management:
    pattern: "Workflow JSON + artifacts"
    location: ".opencode/workflow/"
    notes: "Mỗi workflow có folder riêng"
  testing:
    framework: "PowerShell script + YAML validation"
    locations: [".opencode/scripts/"]
impact_scope:
  - file: ".opencode/skills/code-understanding/SKILL.md"
    level: "DIRECT"
    notes: "Tạo mới"
  - file: ".opencode/skills/dependency-analyzer/SKILL.md"
    level: "DIRECT"
    notes: "Tạo mới"
  - file: ".opencode/skills/impact-analyzer/SKILL.md"
    level: "DIRECT"
    notes: "Tạo mới"
  - file: ".opencode/commands/ask.md"
    level: "DIRECT"
    notes: "Tạo mới"
  - file: ".opencode/commands/knowledge-index.md"
    level: "DIRECT"
    notes: "Tạo mới"
  - file: "AGENTS.md"
    level: "INDIRECT"
    notes: "Bổ sung bảng command knowledge assistant"
  - file: "JapaneseLearner/"
    level: "UNRELATED"
    notes: "Không sửa source app"
design_proposal:
  approach: "Tạo 10 skills + 10 commands + knowledge-index layer + orchestrator skill — evidence-based Q&A"
  affected_modules: [".opencode/skills", ".opencode/commands", ".opencode/knowledge-index", ".opencode/knowledge"]
  new_files: [".opencode/skills/knowledge-assistant/SKILL.md", ".opencode/scripts/build-knowledge-index.ps1"]
  modified_files: ["AGENTS.md", ".opencode/knowledge/README.md"]
  integration_points: ["AGENTS.md commands table", "dev-team skill"]
tasks:
  - id: "TASK-001"
    description: "Tạo 10 skills knowledge chuyên biệt"
    files: [".opencode/skills/"]
    depends_on: []
    why: "Nền tảng năng lực — mỗi skill đóng 1 vai trò trong pipeline"
  - id: "TASK-002"
    description: "Tạo orchestrator skill knowledge-assistant (intent analyzer + planner)"
    files: [".opencode/skills/knowledge-assistant/SKILL.md"]
    depends_on: ["TASK-001"]
    why: "Điều phối pipeline cần các skill con đã tồn tại"
  - id: "TASK-003"
    description: "Tạo 10 commands (ask/where/why/flow/impact/explain/trace/compare-doc/knowledge-health/knowledge-index)"
    files: [".opencode/commands/"]
    depends_on: ["TASK-002"]
    why: "Commands gọi skill tương ứng"
  - id: "TASK-004"
    description: "Tạo script build-knowledge-index.ps1 + thư mục knowledge-index"
    files: [".opencode/scripts/build-knowledge-index.ps1"]
    depends_on: ["TASK-003"]
    why: "Script xây index từ source"
  - id: "TASK-005"
    description: "Cập nhật AGENTS.md + knowledge/README.md"
    files: ["AGENTS.md", ".opencode/knowledge/README.md"]
    depends_on: ["TASK-004"]
    why: "Tài liệu hóa hệ thống mới"
conclusion:
  status: "READY"
  reason: "Đã xác định đầy đủ phạm vi (10 skills + 10 commands + index layer), dependencies, risks, và impact. Yêu cầu rõ ràng với kiến trúc được mô tả chi tiết."
  missing_info: []
```
