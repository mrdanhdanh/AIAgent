---
workflow_id: "WF-20260801-001"
step: 2
step_name: "design"
agent: "planner"
schema_version: "3.2"
timestamp: "2026-08-01T17:25:00Z"
---

# Bước 2: Design — Knowledge Assistant

```yaml
status: READY
summary: >
  Thiết kế Knowledge Assistant như một lớp mới trong .opencode framework:
  10 skills chuyên môn (adapt cho stack C#/Blazor/LocalStorage — không Oracle/Angular),
  1 agent knowledge-agent làm intent analyzer + router, 11 command knowledge-*,
  1 script knowledge-index.ps1 xây tầng Knowledge Index (JSON/MD — không cần vector DB),
  tích hợp vào opencode.json + .opencode/knowledge. Effort: LARGE — chia 4 phase.
blocking_issues: []
non_blocking_issues:
  - id: "#01"
    severity: MINOR
    category: SCOPE
    description: "Yêu cầu gốc mô tả Oracle/Angular — thiết kế này adapt sang C#/Blazor. Nếu sau này dự án chuyển stack, cần cập nhật skill mapping."
    suggestion: "Ghi rõ 'Stack mapping' trong từng SKILL.md để dễ adapt sau này."
  - id: "#02"
    severity: MINOR
    category: PERFORMANCE
    description: "Search-engine có 2 mode: (a) truy vấn Knowledge Index JSON (nhanh, cần index mới), (b) grep trực tiếp (luôn đúng, chậm hơn)."
    suggestion: "Mặc định dùng grep trực tiếp cho độ chính xác; index là cache tăng tốc cho câu hỏi lặp lại."
open_questions: []
next_action: "Chuyển sang Plan phase (Bước 3)"
artifacts: ["02_design.md", "03_plan.md"]
effort: "Large"
design:
  architecture: |
    Knowledge Assistant là một lớp chuyên biệt trong .opencode framework, hoạt động
    theo pipeline: User Question → Intent Analyzer (knowledge-agent) → Knowledge Planner
    (chọn skill) → Evidence Gathering (code-understanding | document-understanding |
    data-model-reader | git-history) → dependency-analyzer → search-engine →
    impact-analyzer (chỉ cho /impact, /trace) → answer-builder (tổng hợp, trích nguồn).

    Tầng Knowledge Index: script knowledge-index.ps1 quét JapaneseLearner/ + .opencode/
    sinh chỉ mục JSON vào .opencode/knowledge/knowledge-assistant/index/. Index gồm:
    code-index (file→symbols→lines), symbol-index (symbol→file:line),
    route-index (@page→component), service-index (interface→impl→methods),
    data-model-index (entity→properties), dependency-graph (Page→Service→Model),
    document-index (docs→sections→keywords). Command /knowledge-index --update chạy lại.

    Các command knowledge-* (ask, where, why, flow, impact, explain, trace,
    compare-doc, health, index, help) đều route qua knowledge-agent, mỗi command
    đọc skill tương ứng + optional index, sau đó answer-builder định dạng output
    có nguồn trích dẫn (file:line) — không tự suy đoán.
  components:
    - name: "knowledge-agent (Intent Analyzer + Router)"
      path: ".opencode/agents/knowledge-agent.md"
      action: CREATE
    - name: "knowledge.md (help + routing)"
      path: ".opencode/commands/knowledge.md"
      action: CREATE
    - name: "knowledge-ask.md"
      path: ".opencode/commands/knowledge-ask.md"
      action: CREATE
    - name: "knowledge-where.md"
      path: ".opencode/commands/knowledge-where.md"
      action: CREATE
    - name: "knowledge-why.md"
      path: ".opencode/commands/knowledge-why.md"
      action: CREATE
    - name: "knowledge-flow.md"
      path: ".opencode/commands/knowledge-flow.md"
      action: CREATE
    - name: "knowledge-impact.md"
      path: ".opencode/commands/knowledge-impact.md"
      action: CREATE
    - name: "knowledge-explain.md"
      path: ".opencode/commands/knowledge-explain.md"
      action: CREATE
    - name: "knowledge-trace.md"
      path: ".opencode/commands/knowledge-trace.md"
      action: CREATE
    - name: "knowledge-compare-doc.md"
      path: ".opencode/commands/knowledge-compare-doc.md"
      action: CREATE
    - name: "knowledge-health.md"
      path: ".opencode/commands/knowledge-health.md"
      action: CREATE
    - name: "knowledge-index.md"
      path: ".opencode/commands/knowledge-index.md"
      action: CREATE
    - name: "skill code-understanding"
      path: ".opencode/skills/knowledge/code-understanding/SKILL.md"
      action: CREATE
    - name: "skill document-understanding"
      path: ".opencode/skills/knowledge/document-understanding/SKILL.md"
      action: CREATE
    - name: "skill dependency-analyzer"
      path: ".opencode/skills/knowledge/dependency-analyzer/SKILL.md"
      action: CREATE
    - name: "skill workflow-reader"
      path: ".opencode/skills/knowledge/workflow-reader/SKILL.md"
      action: CREATE
    - name: "skill search-engine"
      path: ".opencode/skills/knowledge/search-engine/SKILL.md"
      action: CREATE
    - name: "skill architecture-reader"
      path: ".opencode/skills/knowledge/architecture-reader/SKILL.md"
      action: CREATE
    - name: "skill data-model-reader (adapt từ database-reader)"
      path: ".opencode/skills/knowledge/data-model-reader/SKILL.md"
      action: CREATE
    - name: "skill git-history"
      path: ".opencode/skills/knowledge/git-history/SKILL.md"
      action: CREATE
    - name: "skill impact-analyzer"
      path: ".opencode/skills/knowledge/impact-analyzer/SKILL.md"
      action: CREATE
    - name: "skill answer-builder"
      path: ".opencode/skills/knowledge/answer-builder/SKILL.md"
      action: CREATE
    - name: "script knowledge-index.ps1"
      path: ".opencode/scripts/knowledge-index.ps1"
      action: CREATE
    - name: "knowledge-assistant README"
      path: ".opencode/knowledge/knowledge-assistant/README.md"
      action: CREATE
    - name: "index output directory"
      path: ".opencode/knowledge/knowledge-assistant/index/"
      action: CREATE
    - name: "opencode.json (đăng ký agent + commands + skills paths)"
      path: "opencode.json"
      action: MODIFY
  data_flow: |
    /knowledge-ask "Module X hoạt động thế nào?"
      → knowledge-agent parse intent (ask) + entity (Module X)
      → Knowledge Planner chọn skill: code-understanding + dependency-analyzer + answer-builder
      → search-engine: grep "Module X" hoặc tra index
      → code-understanding: đọc file liên quan, xác định class/method
      → dependency-analyzer: xây call graph ngắn
      → answer-builder: tổng hợp markdown có nguồn file:line

    /knowledge-trace "Login"
      → intent: trace → search route-index → tìm page /alphabet
      → dependency-analyzer: Page → Service → Model → LocalStorage
      → answer-builder: chuỗi trace dạng cây

    /knowledge-where "CustomerId"
      → intent: where → search-engine grep symbol trong Models/Services/Pages
      → answer-builder: bảng file:line + số lượng
  security_concerns:
    - description: "Script index đọc source → có thể vô tình đọc file chứa secret"
      severity: MEDIUM
      mitigation: "Whitelist extension (.cs, .razor, .csproj, .md, .json, .ps1), ignore .git/bin/obj; index không lưu nội dung file — chỉ lưu symbol + line + signature; không index .env/appsettings chứa secret"
    - description: "Sửa opencode.json sai cú pháp → phá vỡ toàn bộ command framework"
      severity: HIGH
      mitigation: "Backup opencode.json trước khi sửa (requires_backup: true); validate JSON (ConvertFrom-Json) sau mỗi lần edit; chạy /doctor verify"
    - description: "Command knowledge-* có thể expose thông tin nội bộ nếu trả về nội dung file raw"
      severity: LOW
      mitigation: "answer-builder chỉ trả tóm tắt + nguồn file:line, không dump toàn bộ file; trích tối đa N dòng context"
    - description: "Cross-reference validation của sync-system-docs có thể fail nếu command mới thiếu section trong SYSTEM_MAP"
      severity: LOW
      mitigation: "Chạy /team-syncdocs sau khi thêm command/skill để cập nhật SYSTEM_MAP"
  edge_cases:
    - description: "Câu hỏi không khớp intent nào (ví dụ: 'chào bạn')"
      handling: "knowledge-agent fallback → hiển thị menu /knowledge help + gợi ý intent"
    - description: "Symbol không tồn tại (typo)"
      handling: "search-engine trả 0 kết quả → answer-builder đề xuất symbol gần giống (contains match)"
    - description: "Index chưa build (lần đầu chạy)"
      handling: "Command tự fallback sang grep trực tiếp + log 'Index chưa có — dùng grep. Chạy /knowledge-index để tăng tốc'"
    - description: "Nhiều file trùng tên symbol (namespace khác nhau)"
      handling: "search-engine trả về full path + namespace để phân biệt; answer-builder nhóm theo file"
    - description: "Project không có git history (dự án mới clone)"
      handling: "git-history skill kiểm tra git log trước, nếu lỗi → trả 'Không có git history' không crash"
    - description: "Command knowledge-index chạy khi source đang thay đổi (dirty workspace)"
      handling: "Chỉ index file ổn định; script ghi timestamp; --update chạy lại để làm mới"
  issues:
    blocking_issues: []
    non_blocking_issues:
      - id: "#01"
        severity: MINOR
        category: SCOPE
        description: "Adapt Oracle→C# stack"
        suggestion: "Stack mapping trong mỗi SKILL.md"
      - id: "#02"
        severity: MINOR
        category: PERFORMANCE
        description: "Index cần --update khi source thay đổi"
        suggestion: "Mặc định grep trực tiếp; index là cache"
    open_questions: []
```

---

# Chi tiết thiết kế kỹ thuật

## 1. knowledge-agent.md

```
---
description: Intent Analyzer + Router cho Knowledge Assistant — phân loại câu hỏi, chọn skill pipeline, tổng hợp trả lời
mode: subagent
model: opencode/deepseek-v4-flash-free
permission: { read: allow, grep: allow, glob: allow, edit: deny, bash: deny }
schema_version: "1.0"
---
```

- Bảng intent mapping: ask → code-understanding + answer-builder; where → search-engine;
  why → document-understanding + git-history; flow → workflow-reader; impact → impact-analyzer +
  dependency-analyzer; explain → code-understanding; trace → dependency-analyzer + search-engine;
  compare-doc → document-understanding + code-understanding.
- Output YAML: `intent`, `entity`, `skills_selected[]`, `evidence[]`, `answer`, `sources[]`.

## 2. Cấu trúc SKILL.md chung (10 skill)

Mỗi skill theo convention hiện có (giống gitguard):
- frontmatter YAML: `name`, `description`, `schema_version`
- MỤC LỤC + sections: TỔNG QUAN, STACK MAPPING (adapt), QUY TRÌNH, ĐỊNH DẠNG ĐẦU RA, XỬ LÝ NGOẠI LỆ

| Skill | Nhiệm vụ chính | Input chính | Output chính |
|-------|---------------|-------------|--------------|
| code-understanding | Đọc C#/Razor, trả class/method/lifecycle/DI | .cs/.razor | Class summary, method list, DI graph |
| document-understanding | Đọc .md/README/PRODUCT, trích requirement/rule/flow | docs | Requirement, business rule |
| dependency-analyzer | Xây call graph Page→Service→Model | routes + services | Graph nodes/edges |
| workflow-reader | Đọc flow, sinh sequence/mermaid | routes + logic | User flow, mermaid |
| search-engine | Semantic + grep search, truy vấn index | query | Matches (file:line) |
| architecture-reader | Phân loại layer, detect violation | structure | Layer map, violations |
| data-model-reader | Đọc entity/Models + LocalStorage keys | Models/*.cs | Entity schema, storage keys |
| git-history | git log/blame, ai sửa/khi nào/lý do | git | Commit history |
| impact-analyzer | Ảnh hưởng dây chuyền khi sửa X | symbol + graph | Affected files/screens/APIs |
| answer-builder | Tổng hợp evidence thành trả lời có nguồn | evidence[] | Final answer + sources[] |

## 3. Command knowledge-* (11 file)

Mỗi file: frontmatter (description, agent: knowledge-agent) + HELP + prompt + Output Contract.
Naming trong opencode.json: `knowledge`, `knowledge-ask`, ..., `knowledge-index`.

## 4. Script knowledge-index.ps1

```powershell
# Tham số: -Mode build|update|status|clean  -ProjectRoot (mặc định workspace root) -DryRun
# 1. Quét JapaneseLearner/**.cs, **.razor, **.csproj + .opencode/**.md
# 2. Parse: @page directives (route-index), interface/class/method (symbol-index),
#    service registrations (service-index), Models (data-model-index),
#    dependency bằng regex Inject/AddScoped/using (dependency-graph)
# 3. Ghi JSON vào .opencode/knowledge/knowledge-assistant/index/
# 4. Output báo cáo: files_scanned, symbols_found, routes_found, duration
```

## 5. Tích hợp opencode.json

- Agent: thêm `knowledge-agent` (đọc/grep/glob, không edit/bash — như analyst)
- Commands: thêm 11 entry `knowledge*` template → agent knowledge-agent
- Skills: paths đã trỏ `.opencode/skills` — tự bao gồm `.opencode/skills/knowledge/*`

## 6. Test chiến lược

| Cấp | Cách test | Công cụ |
|-----|-----------|---------|
| Unit (hệ thống) | Validate opencode.json parse; validate frontmatter 11 commands + 10 skills; validate script chạy không lỗi | PowerShell |
| Integration | Chạy knowledge-index.ps1 trên dự án thật → index JSON đúng cấu trúc | PowerShell |
| Regression | dotnet build + dotnet test (unit) vẫn xanh; /doctor PASS | dotnet |
| Smoke | Mô phỏng 2-3 command (ask, where, trace) bằng cách gọi skill + grep thật | Agent |
