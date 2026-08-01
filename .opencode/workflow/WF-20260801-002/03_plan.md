# 03_plan.md — WF-20260801-002

```yaml
status: READY
summary: >
  Kế hoạch 7 chunk / 24 steps: (1) 10 skills knowledge chuyên biệt, (2) orchestrator skill
  knowledge-assistant, (3) 10 commands, (4) script build index, (5) knowledge-index data,
  (6) AGENTS.md + knowledge/README.md, (7) final validation + build + test. Effort Large
  → chia chunks theo Chunk Rules (1=config/skill nền tảng, 2=logic orchestrator, 3=commands,
  4=script+docs, 5=test). Không cần backup (tất cả file CREATE mới, chỉ MODIFY AGENTS.md
  + knowledge/README.md có backup).
blocking_issues: []
non_blocking_issues: []
open_questions: []
next_action: "Chuyển sang Review phase"
artifacts: ["03_plan.md"]
steps:
  - order: 1
    description: "Tạo skill code-understanding"
    action: CREATE
    file: ".opencode/skills/code-understanding/SKILL.md"
    logic: "Frontmatter YAML (name, description, schema_version 1.0). Nội dung: đọc C#/Razor/JS/SQL, trả lời class/method/call-graph/dependency/lifecycle/DI/interface/inheritance, output contract YAML"
    expected_result: "File SKILL.md hợp lệ frontmatter + nội dung đầy đủ 6 mục"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\code-understanding\\SKILL.md"
    risk_level: LOW
  - order: 2
    description: "Tạo skill document-understanding"
    action: CREATE
    file: ".opencode/skills/document-understanding/SKILL.md"
    logic: "Đọc README/SPEC/Design/Wiki/Markdown/PDF/Excel/Word — trích xuất requirement, business rule, flow, constraint, decision"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\document-understanding\\SKILL.md"
    risk_level: LOW
  - order: 3
    description: "Tạo skill dependency-analyzer"
    action: CREATE
    file: ".opencode/skills/dependency-analyzer/SKILL.md"
    logic: "Xây call graph, module graph, reference graph, database graph, service graph (DI từ Program.cs)"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\dependency-analyzer\\SKILL.md"
    risk_level: LOW
  - order: 4
    description: "Tạo skill workflow-reader"
    action: CREATE
    file: ".opencode/skills/workflow-reader/SKILL.md"
    logic: "Đọc flow/diagram/mermaid/sequence/state machine — trả lời user flow, business flow, API flow"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\workflow-reader\\SKILL.md"
    risk_level: LOW
  - order: 5
    description: "Tạo skill search-engine"
    action: CREATE
    file: ".opencode/skills/search-engine/SKILL.md"
    logic: "Semantic search — dùng grep + index; ví dụ: tìm đoạn xử lý upload, export excel, nơi dùng package"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\search-engine\\SKILL.md"
    risk_level: LOW
  - order: 6
    description: "Tạo skill architecture-reader"
    action: CREATE
    file: ".opencode/skills/architecture-reader/SKILL.md"
    logic: "Hiểu layer/DDD/Clean/CQRS/MVC/MVVM — trả lời module nằm layer nào, vi phạm architecture"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\architecture-reader\\SKILL.md"
    risk_level: LOW
  - order: 7
    description: "Tạo skill database-reader"
    action: CREATE
    file: ".opencode/skills/database-reader/SKILL.md"
    logic: "Đọc table/view/package/procedure/trigger/index/FK — trả lời bảng dùng ở đâu, procedure gọi bởi ai, field nullable"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\database-reader\\SKILL.md"
    risk_level: LOW
  - order: 8
    description: "Tạo skill git-history"
    action: CREATE
    file: ".opencode/skills/git-history/SKILL.md"
    logic: "git log/blame — trả lời ai sửa, khi nào, lý do, commit nào"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\git-history\\SKILL.md"
    risk_level: LOW
  - order: 9
    description: "Tạo skill impact-analyzer"
    action: CREATE
    file: ".opencode/skills/impact-analyzer/SKILL.md"
    logic: "Quan trọng nhất — phân tích nếu sửa X ảnh hưởng API/screen/batch/report nào"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [3]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\impact-analyzer\\SKILL.md"
    risk_level: LOW
  - order: 10
    description: "Tạo skill answer-builder"
    action: CREATE
    file: ".opencode/skills/answer-builder/SKILL.md"
    logic: "Ghép evidence thành câu trả lời có nguồn, không suy đoán — format nguồn: README→Screen→Repository→Procedure→Result"
    expected_result: "File SKILL.md hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 1
    requires_backup: false
    depends_on: [1]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\answer-builder\\SKILL.md"
    risk_level: LOW
  - order: 11
    description: "Tạo orchestrator skill knowledge-assistant (intent analyzer + planner)"
    action: CREATE
    file: ".opencode/skills/knowledge-assistant/SKILL.md"
    logic: "Pipeline 9 tầng: Assistant→Intent Analyzer→Knowledge Planner→Code/Doc Skill→Dependency Skill→Search/Impact→Answer Builder. Phân loại intent: explain/where/why/flow/impact/trace/compare/health. Mapping câu hỏi → skill. Output contract YAML."
    expected_result: "File SKILL.md hợp lệ — pipeline đầy đủ"
    check: "frontmatter YAML parse OK"
    chunk: 2
    requires_backup: false
    depends_on: [1,2,3,4,5,6,7,8,9,10]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\knowledge-assistant\\SKILL.md"
    risk_level: MEDIUM
  - order: 12
    description: "Tạo command /ask"
    action: CREATE
    file: ".opencode/commands/ask.md"
    logic: "Frontmatter (description, agent: general). Nội dung: gọi skill knowledge-assistant, intent=ask, output contract YAML"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\ask.md"
    risk_level: LOW
  - order: 13
    description: "Tạo command /where"
    action: CREATE
    file: ".opencode/commands/where.md"
    logic: "Tìm mọi nơi sử dụng symbol — gọi skill search-engine + dependency-analyzer"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\where.md"
    risk_level: LOW
  - order: 14
    description: "Tạo command /why"
    action: CREATE
    file: ".opencode/commands/why.md"
    logic: "Giải thích lý do thiết kế — gọi document-understanding + git-history"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\why.md"
    risk_level: LOW
  - order: 15
    description: "Tạo command /flow"
    action: CREATE
    file: ".opencode/commands/flow.md"
    logic: "Sinh sequence/mermaid — gọi workflow-reader + search-engine"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\flow.md"
    risk_level: LOW
  - order: 16
    description: "Tạo command /impact"
    action: CREATE
    file: ".opencode/commands/impact.md"
    logic: "Sinh affected API/screen/job/SP — gọi impact-analyzer + dependency-analyzer"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\impact.md"
    risk_level: LOW
  - order: 17
    description: "Tạo command /explain"
    action: CREATE
    file: ".opencode/commands/explain.md"
    logic: "Giải thích từng method — gọi code-understanding"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\explain.md"
    risk_level: LOW
  - order: 18
    description: "Tạo command /trace"
    action: CREATE
    file: ".opencode/commands/trace.md"
    logic: "Truy vết UI→API→Service→Repository→DB→Response — gọi dependency-analyzer + code-understanding"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\trace.md"
    risk_level: LOW
  - order: 19
    description: "Tạo command /compare-doc"
    action: CREATE
    file: ".opencode/commands/compare-doc.md"
    logic: "So sánh code vs design doc — gọi document-understanding + code-understanding"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\compare-doc.md"
    risk_level: LOW
  - order: 20
    description: "Tạo command /knowledge-health"
    action: CREATE
    file: ".opencode/commands/knowledge-health.md"
    logic: "Đánh giá thiếu README/diagram/flow/ADR/comment — gọi document-understanding + search-engine"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 3
    requires_backup: false
    depends_on: [11]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\knowledge-health.md"
    risk_level: LOW
  - order: 21
    description: "Tạo command /knowledge-index"
    action: CREATE
    file: ".opencode/commands/knowledge-index.md"
    logic: "Build/update index — gọi script build-knowledge-index.ps1, flags --update --rebuild --status"
    expected_result: "File command hợp lệ"
    check: "frontmatter YAML parse OK"
    chunk: 4
    requires_backup: false
    depends_on: [22]
    validation_command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\commands\\knowledge-index.md"
    risk_level: MEDIUM
  - order: 22
    description: "Tạo script build-knowledge-index.ps1"
    action: CREATE
    file: ".opencode/scripts/build-knowledge-index.ps1"
    logic: "PowerShell: quét *.cs/*.razor/*.csproj + knowledge docs → sinh 7 index JSON (code, symbol, api, database, dependency, document, business-rule) vào .opencode/knowledge-index/. Flags: -Update, -Rebuild, -Status. Handle UTF-8, try/catch, report."
    expected_result: "Script chạy được — tạo index JSON hợp lệ"
    check: "Chạy script -Status và kiểm tra output"
    chunk: 4
    requires_backup: false
    depends_on: [11]
    validation_command: "powershell -ExecutionPolicy Bypass -File .opencode\\scripts\\build-knowledge-index.ps1 -Status"
    risk_level: MEDIUM
  - order: 23
    description: "Tạo cấu trúc knowledge-index data (7 file index mẫu)"
    action: CREATE
    file: ".opencode/knowledge-index/"
    logic: "Tạo thư mục + README.md + 7 file index JSON mẫu (code-index.json, symbol-index.json, api-index.json, database-index.json, dependency-graph.json, document-index.json, business-rule-index.json) + .gitkeep"
    expected_result: "Thư mục knowledge-index tồn tại với 7 index + README"
    check: "Test-Path .opencode/knowledge-index"
    chunk: 4
    requires_backup: false
    depends_on: [22]
    validation_command: "Test-Path .opencode\\knowledge-index\\README.md"
    risk_level: LOW
  - order: 24
    description: "Cập nhật AGENTS.md + knowledge/README.md"
    action: MODIFY
    file: "AGENTS.md"
    logic: "Bổ sung bảng Knowledge Assistant Commands (10 commands) + kiến trúc knowledge index + lưu ý /knowledge-index --update"
    expected_result: "AGENTS.md có bảng commands mới + mục knowledge assistant"
    check: "grep 'knowledge' AGENTS.md"
    chunk: 5
    requires_backup: true
    depends_on: [21, 23]
    validation_command: "grep -c 'knowledge' AGENTS.md"
    risk_level: MEDIUM
  - order: 25
    description: "Cập nhật .opencode/knowledge/README.md"
    action: MODIFY
    file: ".opencode/knowledge/README.md"
    logic: "Bổ sung mục Knowledge Index — hướng dẫn /knowledge-index --update + cấu trúc index"
    expected_result: "README.md có mục Knowledge Index"
    check: "grep 'Knowledge Index' .opencode/knowledge/README.md"
    chunk: 5
    requires_backup: true
    depends_on: [23]
    validation_command: "grep -c 'Knowledge Index' .opencode/knowledge/README.md"
    risk_level: LOW
per_step_validation:
  - step: 1-10
    command: ".opencode\\scripts\\schema-validator.ps1 -path <skill-file>"
    expected: "Frontmatter YAML parse OK"
  - step: 11
    command: ".opencode\\scripts\\schema-validator.ps1 -path .opencode\\skills\\knowledge-assistant\\SKILL.md"
    expected: "Frontmatter YAML parse OK"
  - step: 12-21
    command: ".opencode\\scripts\\schema-validator.ps1 -path <command-file>"
    expected: "Frontmatter YAML parse OK"
  - step: 22
    command: "powershell -ExecutionPolicy Bypass -File .opencode\\scripts\\build-knowledge-index.ps1 -Status"
    expected: "Status report — 7 index files"
  - step: 23
    command: "Test-Path .opencode\\knowledge-index\\README.md"
    expected: "True"
  - step: 24-25
    command: "grep <keyword> <file>"
    expected: "Match found"
per_chunk_validate:
  - chunk: 1
    command: "Get-ChildItem .opencode/skills/code-understanding,.opencode/skills/document-understanding,.opencode/skills/dependency-analyzer,.opencode/skills/workflow-reader,.opencode/skills/search-engine,.opencode/skills/architecture-reader,.opencode/skills/database-reader,.opencode/skills/git-history,.opencode/skills/impact-analyzer,.opencode/skills/answer-builder -Filter SKILL.md"
    expected: "10 files tồn tại"
  - chunk: 2
    command: "Test-Path .opencode/skills/knowledge-assistant/SKILL.md"
    expected: "True"
  - chunk: 3
    command: "Get-ChildItem .opencode/commands/ask.md,.opencode/commands/where.md,.opencode/commands/why.md,.opencode/commands/flow.md,.opencode/commands/impact.md,.opencode/commands/explain.md,.opencode/commands/trace.md,.opencode/commands/compare-doc.md,.opencode/commands/knowledge-health.md,.opencode/commands/knowledge-index.md"
    expected: "10 files tồn tại"
  - chunk: 4
    command: "Test-Path .opencode/scripts/build-knowledge-index.ps1; Test-Path .opencode/knowledge-index/README.md"
    expected: "True; True"
  - chunk: 5
    command: "grep -c 'knowledge' AGENTS.md; grep -c 'Knowledge Index' .opencode/knowledge/README.md"
    expected: ">=1; >=1"
final_validation:
  - command: "dotnet build JapaneseLearner\\JapaneseLearner.csproj"
    expected: "Build thành công (source không đổi nhưng kiểm tra regression)"
  - command: "dotnet test JapaneseLearner.Tests\\JapaneseLearner.Tests.csproj"
    expected: "Test PASS (154 tests)"
  - command: "powershell -ExecutionPolicy Bypass -File .opencode\\scripts\\build-knowledge-index.ps1 -Update"
    expected: "7 index files sinh thành công"
rollback_strategy:
  enabled: true
  trigger_conditions:
    - type: "catastrophic_failure"
      description: "Lỗi không recover được khi chạy script/index"
    - type: "max_retry_reached"
      description: "Retry > 3 lần"
      threshold: 3
    - type: "user_request"
      description: "User yêu cầu dừng"
  restore_order:
    - step: 25
      action: "restore"
      file: ".opencode/knowledge/README.md"
    - step: 24
      action: "restore"
      file: "AGENTS.md"
    - step: 21-23
      action: "delete"
      file: ".opencode/commands/knowledge-index.md, .opencode/scripts/build-knowledge-index.ps1, .opencode/knowledge-index/"
    - step: 12-20
      action: "delete"
      file: ".opencode/commands/ask.md ... knowledge-health.md"
    - step: 11
      action: "delete"
      file: ".opencode/skills/knowledge-assistant/SKILL.md"
    - step: 1-10
      action: "delete"
      file: ".opencode/skills/<10 skills>/SKILL.md"
  requires_user_confirmation: true
  conditions:
    - "catastrophic failure"
    - "max retry reached"
    - "user request"
  steps:
    - "Bước 25-24: restore AGENTS.md + knowledge/README.md từ backup"
    - "Bước 21-23: xóa command knowledge-index + script + folder index"
    - "Bước 12-20: xóa 9 commands"
    - "Bước 11: xóa skill orchestrator"
    - "Bước 1-10: xóa 10 skills"
validate:
  - "Chạy dotnet build"
  - "Chạy unit tests"
  - "Chạy build-knowledge-index.ps1 -Update"
  - "Validate frontmatter YAML 20 file mới"
```
