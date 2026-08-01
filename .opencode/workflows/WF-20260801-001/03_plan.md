---
workflow_id: "WF-20260801-001"
step: 3
step_name: "plan"
agent: "planner"
schema_version: "3.2"
timestamp: "2026-08-01T17:30:00Z"
---

# Bước 3: Plan — Knowledge Assistant

```yaml
status: READY
summary: >
  Kế hoạch thực thi 23 steps chia 4 chunk. Chunk 1 (config): backup opencode.json +
  tạo knowledge-agent + tạo thư mục skeleton. Chunk 2 (logic): 10 SKILL.md +
  script knowledge-index.ps1 + README. Chunk 3 (commands): 11 command knowledge-*.
  Chunk 4 (test): đăng ký opencode.json + validate + regression test + syncdocs.
  Mỗi step có action, expected_result, validation_command, risk_level.
blocking_issues: []
non_blocking_issues: []
open_questions: []
next_action: "Chuyển sang Review phase (Bước 4)"
artifacts: ["03_plan.md"]
effort: "Large"
design:
  architecture: "(tham chiếu 02_design.md — Knowledge Assistant pipeline + Knowledge Index)"
  components:
    - { name: "knowledge-agent", path: ".opencode/agents/knowledge-agent.md", action: CREATE }
    - { name: "10 skills", path: ".opencode/skills/knowledge/*/SKILL.md", action: CREATE }
    - { name: "11 commands", path: ".opencode/commands/knowledge*.md", action: CREATE }
    - { name: "knowledge-index.ps1", path: ".opencode/scripts/knowledge-index.ps1", action: CREATE }
    - { name: "README + index dir", path: ".opencode/knowledge/knowledge-assistant/", action: CREATE }
    - { name: "opencode.json", path: "opencode.json", action: MODIFY }
  data_flow: "Câu hỏi → knowledge-agent → skill pipeline → answer-builder (có nguồn)"
  security_concerns:
    - { description: "Sửa opencode.json sai → hỏng framework", severity: HIGH, mitigation: "backup + validate JSON" }
  edge_cases:
    - { description: "Index chưa build", handling: "fallback grep + gợi ý /knowledge-index" }
steps:
  # ───────────── CHUNK 1: CONFIG ─────────────
  - order: 1
    description: "Backup opencode.json trước khi sửa"
    action: CREATE
    file: ".opencode/backup/WF-20260801-001/opencode.json"
    logic: "Dùng Backup Utility: & .opencode/scripts/backup-utility.ps1 -action save -files @('opencode.json') -workflowId 'WF-20260801-001'"
    expected_result: "Manifest 05_backup_manifest.json tồn tại, SHA256 ghi nhận"
    check: "Test-Path .opencode/backup/WF-20260801-001/opencode.json"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "Test-Path .opencode/backup/WF-20260801-001/opencode.json"
    risk_level: "LOW"
  - order: 2
    description: "Tạo agent knowledge-agent.md — Intent Analyzer + Router"
    action: CREATE
    file: ".opencode/agents/knowledge-agent.md"
    logic: |
      frontmatter: description (Intent Analyzer + Router cho Knowledge Assistant), mode: subagent,
      model: opencode/deepseek-v4-flash-free, permission read/grep/glob/bash allow + edit deny,
      schema_version "1.0". (bash allow vì git-history chạy git log + knowledge-index chạy script;
      edit deny vì agent chỉ đọc, không sửa file.) Body: bảng intent mapping (ask/where/why/
      flow/impact/explain/trace/compare-doc → skill pipeline), quy trình xử lý 5 bước, output
      YAML contract (intent, entity, skills_selected[], evidence[], answer, sources[]).
    expected_result: "File hợp lệ theo convention agent .opencode hiện có"
    check: "Test-Path .opencode/agents/knowledge-agent.md"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "Test-Path .opencode/agents/knowledge-agent.md"
    risk_level: "LOW"
  - order: 3
    description: "Tạo thư mục skeleton cho 10 skills + index"
    action: CREATE
    file: ".opencode/skills/knowledge/*/ + .opencode/knowledge/knowledge-assistant/index/"
    logic: "Tạo 10 thư mục skill (code-understanding, document-understanding, dependency-analyzer, workflow-reader, search-engine, architecture-reader, data-model-reader, git-history, impact-analyzer, answer-builder) + thư mục knowledge-assistant/index/"
    expected_result: "11 thư mục tồn tại"
    check: "(Get-ChildItem .opencode/skills/knowledge -Directory).Count -eq 10"
    chunk: 1
    requires_backup: false
    depends_on: []
    validation_command: "(Get-ChildItem .opencode/skills/knowledge -Directory).Count -ge 10"
    risk_level: "LOW"

  # ───────────── CHUNK 2: LOGIC (skills + script + README) ─────────────
  - order: 4
    description: "Tạo skill code-understanding"
    action: CREATE
    file: ".opencode/skills/knowledge/code-understanding/SKILL.md"
    logic: |
      Skill đọc C#/Razor: class, method, call graph, DI, lifecycle Blazor, interface,
      inheritance. Stack mapping: C#/.NET/Blazor. Quy trình: locate → read → summarize.
      Output: class_summary, methods[], di_dependencies[], lifecycle_notes.
    expected_result: "SKILL.md đúng frontmatter + nội dung đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/code-understanding/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/code-understanding/SKILL.md"
    risk_level: "LOW"
  - order: 5
    description: "Tạo skill document-understanding"
    action: CREATE
    file: ".opencode/skills/knowledge/document-understanding/SKILL.md"
    logic: |
      Đọc docs (.md/README/PRODUCT/SPEC), trích requirement, business rule, flow,
      constraint, decision. Nguồn docs trong dự án: AGENTS.md, PRODUCT.md,
      .opencode/knowledge/**, gh-pages-root. Output: requirements[], business_rules[],
      decisions[], sources[].
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/document-understanding/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/document-understanding/SKILL.md"
    risk_level: "LOW"
  - order: 6
    description: "Tạo skill dependency-analyzer"
    action: CREATE
    file: ".opencode/skills/knowledge/dependency-analyzer/SKILL.md"
    logic: |
      Xây call graph: Page → Service (via @inject) → Interface → Impl → Model →
      LocalStorage. Regex patterns: @inject IWordService, AddScoped<IWordService,
      using JapaneseLearner.Services. Output: graph_nodes[], graph_edges[]
      (from, to, type, evidence_file, evidence_line).
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/dependency-analyzer/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/dependency-analyzer/SKILL.md"
    risk_level: "LOW"
  - order: 7
    description: "Tạo skill workflow-reader"
    action: CREATE
    file: ".opencode/skills/knowledge/workflow-reader/SKILL.md"
    logic: |
      Đọc flow từ code + docs, sinh user flow / business flow / API flow dạng mermaid
      sequenceDiagram. Output: flows[], mermaid_code.
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/workflow-reader/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/workflow-reader/SKILL.md"
    risk_level: "LOW"
  - order: 8
    description: "Tạo skill search-engine"
    action: CREATE
    file: ".opencode/skills/knowledge/search-engine/SKILL.md"
    logic: |
      Semantic + grep search. Mode 1: truy vấn Knowledge Index JSON
      (.opencode/knowledge/knowledge-assistant/index/). Mode 2: grep trực tiếp
      (luôn đúng). Output: matches[] (file, line, snippet, confidence).
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/search-engine/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/search-engine/SKILL.md"
    risk_level: "LOW"
  - order: 9
    description: "Tạo skill architecture-reader"
    action: CREATE
    file: ".opencode/skills/knowledge/architecture-reader/SKILL.md"
    logic: |
      Phân loại layer (Pages/UI, Services/Application, Models/Domain), detect violation
      (Page gọi thẳng Model khác service? Service phụ thuộc service?). Output:
      layer_map[], violations[].
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/architecture-reader/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/architecture-reader/SKILL.md"
    risk_level: "LOW"
  - order: 10
    description: "Tạo skill data-model-reader (adapt database-reader)"
    action: CREATE
    file: ".opencode/skills/knowledge/data-model-reader/SKILL.md"
    logic: |
      Adapt từ database-reader: đọc Models/*.cs (entity schema, nullable) + LocalStorage
      keys (japanese-learner-dark-mode, seed keys) + service persistence. Output:
      entities[], storage_keys[], persistence_pattern.
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/data-model-reader/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/data-model-reader/SKILL.md"
    risk_level: "LOW"
  - order: 11
    description: "Tạo skill git-history"
    action: CREATE
    file: ".opencode/skills/knowledge/git-history/SKILL.md"
    logic: |
      git log --oneline -- file, git log -p, git blame. Trả ai sửa/khi nào/lý do/
      commit nào. Nếu git fail → trả 'Không có git history' không crash. Output:
      commits[], author, date, message, file.
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/git-history/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/git-history/SKILL.md"
    risk_level: "LOW"
  - order: 12
    description: "Tạo skill impact-analyzer"
    action: CREATE
    file: ".opencode/skills/knowledge/impact-analyzer/SKILL.md"
    logic: |
      Nhận symbol/file cần sửa → dùng dependency-graph (từ index hoặc grep @inject/
      AddScoped) → liệt kê affected: screens (Pages), services, models, tests.
      Output: affected[] (type, file, impact_level, reason).
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/impact-analyzer/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/impact-analyzer/SKILL.md"
    risk_level: "LOW"
  - order: 13
    description: "Tạo skill answer-builder"
    action: CREATE
    file: ".opencode/skills/knowledge/answer-builder/SKILL.md"
    logic: |
      Ghép evidence[] thành câu trả lời markdown: tóm tắt + chi tiết + nguồn
      (file:line). QUY TẮC: không tự suy đoán — mọi phát biểu phải có nguồn;
      nếu không có evidence → nói rõ 'Không tìm thấy'. Output: answer, sources[].
    expected_result: "SKILL.md đầy đủ"
    check: "Test-Path .opencode/skills/knowledge/answer-builder/SKILL.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/skills/knowledge/answer-builder/SKILL.md"
    risk_level: "LOW"
  - order: 14
    description: "Tạo script knowledge-index.ps1"
    action: CREATE
    file: ".opencode/scripts/knowledge-index.ps1"
    logic: |
      PowerShell script: param (-Mode build|update|status|clean, -ProjectRoot, -DryRun).
      1. Quét *.cs, *.razor, *.csproj trong JapaneseLearner/ (ignore bin/obj/.git).
      2. Parse @page directives → route-index.json.
      3. Parse interface/class/method (regex) → code-index.json + symbol-index.json.
      4. Parse AddScoped → service-index.json.
      5. Parse Models → data-model-index.json.
      6. Parse @inject + AddScoped → dependency-graph.json.
      7. Parse .opencode/knowledge/**.md headings → document-index.json.
      8. Ghi JSON vào .opencode/knowledge/knowledge-assistant/index/.
      Output báo cáo: files_scanned, symbols_found, routes_found, duration, dry_run.
    expected_result: "Script chạy được, không lỗi syntax, output báo cáo JSON"
    check: "& .opencode/scripts/knowledge-index.ps1 -Mode status -DryRun"
    chunk: 2
    requires_backup: false
    depends_on: []
    validation_command: "powershell -NoProfile -Command \"& { param(...) }\" 2>&1 | Select-String 'error'"
    risk_level: "MEDIUM"
  - order: 15
    description: "Tạo README knowledge-assistant + index .gitkeep"
    action: CREATE
    file: ".opencode/knowledge/knowledge-assistant/README.md"
    logic: |
      README mô tả kiến trúc, 10 skills, 11 commands, cách dùng /knowledge-index,
      cấu trúc index/. Kèm .gitkeep trong index/ để giữ thư mục.
    expected_result: "README + .gitkeep tồn tại"
    check: "Test-Path .opencode/knowledge/knowledge-assistant/README.md"
    chunk: 2
    requires_backup: false
    depends_on: [3]
    validation_command: "Test-Path .opencode/knowledge/knowledge-assistant/README.md"
    risk_level: "LOW"

  # ───────────── CHUNK 3: COMMANDS ─────────────
  - order: 16
    description: "Tạo 11 command knowledge-*.md"
    action: CREATE
    file: ".opencode/commands/knowledge*.md (11 files)"
    logic: |
      Mỗi command: frontmatter (description, agent: knowledge-agent) + HELP section
      (mục đích, cách dùng, đầu vào, đầu ra) + prompt (đọc skill tương ứng) +
      Output Contract YAML. 11 files: knowledge.md (help+routing), knowledge-ask.md,
      knowledge-where.md, knowledge-why.md, knowledge-flow.md, knowledge-impact.md,
      knowledge-explain.md, knowledge-trace.md, knowledge-compare-doc.md,
      knowledge-health.md, knowledge-index.md.
    expected_result: "11 files tồn tại, frontmatter hợp lệ"
    check: "(Get-ChildItem .opencode/commands/knowledge*.md).Count -eq 11"
    chunk: 3
    requires_backup: false
    depends_on: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 2]
    validation_command: "(Get-ChildItem .opencode/commands/knowledge*.md).Count -eq 11"
    risk_level: "MEDIUM"

  # ───────────── CHUNK 4: TEST / INTEGRATION ─────────────
  - order: 17
    description: "Đăng ký agent knowledge-agent + 11 commands vào opencode.json"
    action: MODIFY
    file: "opencode.json"
    logic: |
      (1) Thêm agent 'knowledge-agent' vào 'agent' object (clone cấu trúc analyst:
      description, mode subagent, model, permission read/grep/glob/bash allow, edit deny).
      (2) Thêm 11 entries vào 'command' object: knowledge, knowledge-ask, knowledge-where,
      knowledge-why, knowledge-flow, knowledge-impact, knowledge-explain, knowledge-trace,
      knowledge-compare-doc, knowledge-health, knowledge-index — mỗi entry template
      'Bạn là Knowledge Agent... Đọc hướng dẫn tại: .opencode/commands/knowledge-X.md'
      + description + agent: knowledge-agent. Validate JSON sau khi ghi.
    expected_result: "opencode.json parse được (ConvertFrom-Json không lỗi), 11 commands + 1 agent mới"
    check: "Get-Content opencode.json -Raw | ConvertFrom-Json | Select-Object -ExpandProperty command | Get-Member -Name 'knowledge*'"
    chunk: 4
    requires_backup: true
    depends_on: [1, 2, 16, 14]
    validation_command: "powershell -NoProfile -Command \"$j = Get-Content opencode.json -Raw | ConvertFrom-Json; $j.agent.knowledge-agent -ne $null -and $j.command.'knowledge-ask' -ne $null\""
    risk_level: "HIGH"
  - order: 18
    description: "Chạy knowledge-index.ps1 lần đầu (build index thực tế)"
    action: CREATE
    file: ".opencode/knowledge/knowledge-assistant/index/*.json"
    logic: "Chạy & .opencode/scripts/knowledge-index.ps1 -Mode build — sinh 7 file index JSON từ source JapaneseLearner thật."
    expected_result: ">= 5 file JSON trong index/, routes_found >= 13"
    check: "(Get-ChildItem .opencode/knowledge/knowledge-assistant/index/*.json).Count -ge 5"
    chunk: 4
    requires_backup: false
    depends_on: [14, 17]
    validation_command: "(Get-ChildItem .opencode/knowledge/knowledge-assistant/index/*.json).Count -ge 5"
    risk_level: "MEDIUM"
  - order: 19
    description: "Validate toàn bộ file mới (frontmatter + JSON + link)"
    action: CREATE
    file: "(validation report)"
    logic: |
      Validate: (1) opencode.json parse OK; (2) 11 commands frontmatter có description
      + agent: knowledge-agent; (3) 10 skills frontmatter có name/description/schema_version;
      (4) code block balance trong các file .md mới; (5) index JSON parse được.
    expected_result: "Báo cáo validation 0 lỗi CRITICAL"
    check: "PowerShell script validate tất cả"
    chunk: 4
    requires_backup: false
    depends_on: [17, 18]
    validation_command: "powershell -NoProfile -Command \"$errors = 0; ...; Write-Output \\\"Validation errors: $errors\\\"\""
    risk_level: "MEDIUM"
  - order: 20
    description: "Chạy regression: dotnet build + dotnet test (unit)"
    action: MODIFY
    file: "(no file — validation)"
    logic: |
      dotnet build JapaneseLearner\JapaneseLearner.csproj (cấu hình không đổi — không
      đụng source C#). dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj.
      Mục đích: đảm bảo workflow không phá vỡ dự án.
    expected_result: "Build PASS + toàn bộ unit tests PASS"
    check: "$LASTEXITCODE -eq 0"
    chunk: 4
    requires_backup: false
    depends_on: [17, 18]
    validation_command: "dotnet build JapaneseLearner\JapaneseLearner.csproj"
    risk_level: "HIGH"
  - order: 21
    description: "Smoke test 3 command mô phỏng (ask, where, trace) bằng skill thật"
    action: CREATE
    file: "(smoke test output)"
    logic: |
      Mô phỏng: (1) /knowledge-ask 'WordService hoạt động thế nào?' → đọc
      WordService.cs + IWordService.cs + trả summary + sources.
      (2) /knowledge-where 'JapaneseWord' → grep Models + Services + Pages → bảng file:line.
      (3) /knowledge-trace '/words' → route-index + dependency-analyzer → chuỗi
      Page→Service→Model→LocalStorage. Ghi kết quả.
    expected_result: "3 câu trả lời có nguồn file:line hợp lệ"
    check: "Output chứa evidence_file + evidence_line"
    chunk: 4
    requires_backup: false
    depends_on: [18]
    validation_command: "(smoke test)"
    risk_level: "MEDIUM"
  - order: 22
    description: "Chạy /doctor để verify không regress framework"
    action: CREATE
    file: "(doctor report)"
    logic: "Chạy .opencode/scripts/doctor.ps1 -Mode full (hoặc /doctor) — kiểm tra Agents, Commands, Skills, Knowledge, Contracts không regress sau khi thêm hệ thống mới."
    expected_result: "Doctor health score không giảm so với trước (hoặc PASS các checks chính)"
    check: "Doctor report health_score >= baseline"
    chunk: 4
    requires_backup: false
    depends_on: [17, 19]
    validation_command: "powershell -NoProfile -ExecutionPolicy Bypass -File .opencode/scripts/doctor.ps1 -Mode quick"
    risk_level: "MEDIUM"
  - order: 23
    description: "Chạy /team-syncdocs cập nhật SYSTEM_MAP + ghi lessons"
    action: MODIFY
    file: ".opencode/SYSTEM_MAP.md + .opencode/knowledge/"
    logic: |
      Chạy sync-system-docs.ps1 → quét agent/command/skill mới → cập nhật SYSTEM_MAP.md,
      cross-references. Ghi lessons về Knowledge Assistant vào .opencode/knowledge/
      (pattern: knowledge-assistant.md).
    expected_result: "SYSTEM_MAP có section Knowledge Assistant; cross-ref validator PASS"
    check: "Grep 'knowledge' trong .opencode/SYSTEM_MAP.md"
    chunk: 4
    requires_backup: true
    depends_on: [17, 19, 20, 22]
    validation_command: "powershell -NoProfile -ExecutionPolicy Bypass -File .opencode/scripts/sync-system-docs.ps1"
    risk_level: "MEDIUM"
per_step_validation:
  - step: 17
    command: "powershell -NoProfile -Command \"$j = Get-Content opencode.json -Raw | ConvertFrom-Json; $j.agent.knowledge-agent -ne $null\""
    expected: "JSON parse OK, agent tồn tại"
  - step: 18
    command: "(Get-ChildItem .opencode/knowledge/knowledge-assistant/index/*.json).Count -ge 5"
    expected: "Index sinh đủ file"
  - step: 20
    command: "dotnet build JapaneseLearner\\JapaneseLearner.csproj"
    expected: "Build PASS"
per_chunk_validate:
  - chunk: 1
    command: "Test-Path .opencode/agents/knowledge-agent.md"
    expected: "Chunk 1 hoàn tất — agent + backup + skeleton"
  - chunk: 2
    command: "(Get-ChildItem .opencode/skills/knowledge -Directory).Count -ge 10"
    expected: "Chunk 2 hoàn tất — 10 skills + script + README"
  - chunk: 3
    command: "(Get-ChildItem .opencode/commands/knowledge*.md).Count -eq 11"
    expected: "Chunk 3 hoàn tất — 11 commands"
final_validation:
  - command: "dotnet build JapaneseLearner\\JapaneseLearner.csproj"
    expected: "Build PASS"
  - command: "dotnet test JapaneseLearner.Tests\\JapaneseLearner.Tests.csproj"
    expected: "Test PASS"
  - command: "powershell -NoProfile -Command \"$j = Get-Content opencode.json -Raw | ConvertFrom-Json; $j.agent.knowledge-agent -ne $null -and $j.command.'knowledge-ask' -ne $null\""
    expected: "opencode.json hợp lệ, agent + command đăng ký"
rollback_strategy:
  enabled: true
  trigger_conditions:
    - type: "catastrophic_failure"
      description: "opencode.json hỏng → toàn bộ framework lỗi"
    - type: "max_retry_reached"
      description: "Retry build/test > 3 lần"
      threshold: 3
    - type: "user_request"
      description: "User yêu cầu dừng"
  restore_order:
    - step: 17
      action: "restore"
      file: "opencode.json"
    - step: 23
      action: "restore"
      file: ".opencode/SYSTEM_MAP.md"
  requires_user_confirmation: true
  conditions:
    - "catastrophic failure"
    - "max retry reached"
    - "user request"
  steps:
    - "Bước 1: restore opencode.json từ .opencode/backup/WF-20260801-001/"
    - "Bước 2: xóa 11 commands knowledge-* + 10 skills + agent nếu cần (chỉ tạo mới — không ảnh hưởng code hiện có)"
validate:
  - command: "dotnet build JapaneseLearner\\JapaneseLearner.csproj"
    expected: "Build thành công"
  - command: "dotnet test JapaneseLearner.Tests\\JapaneseLearner.Tests.csproj"
    expected: "Test PASS"
```
