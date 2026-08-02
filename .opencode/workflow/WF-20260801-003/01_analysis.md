# 01_analysis.md — WF-20260801-003

```yaml
status: NEED_MORE_INFO
summary: >
  Yêu cầu: lập kế hoạch nâng cấp Agent Framework theo mô tả trong file Upgrade_System.md —
  roadmap "Agent Framework v4" gồm Baseline + 12 phases (Workflow Engine, Capability Registry,
  Agent Metadata, Context Engine, Artifact Manager, Event Bus, Simulation Engine, Doctor v2,
  Knowledge Graph, Self Evolution Engine, Plugin Architecture, Dashboard) + 10 command mới
  (/team-simulate, /team-profile, /team-registry, /team-context, /team-graph, /team-migrate,
  /team-plugin, /team-benchmark, /team-replay, /team-profiler) + cấu trúc .opencode v4 đề xuất.
  User xác nhận sẽ gửi nội dung chi tiết bổ sung sau — cần thông tin bổ sung trước khi Design/Plan.
details: >
  Khảo sát hiện trạng .opencode (baseline thực tế): 18 agents (*.md), 53 commands (*.md),
  29 skills (root dirs), 5 workflows (đã chạy), 9 scripts PowerShell (backup-utility,
  rollback-utility, doctor, schema-validator, sync-system-docs, build-knowledge-index,
  knowledge-index, cross-ref-validator, gitpush-utility), knowledge-index có 7 index JSON
  (api, business-rule, code, database, dependency-graph, document, symbol), knowledge base
  gồm 11 mục (framework, knowledge-assistant, patterns, project, skills, testing, ui, workflow,
  lessons.md, README.md, skills-learned.md). KHÔNG có thư mục contracts/ — đây là gap lớn
  so với cấu trúc v4 đề xuất. Upgrade_System.md đề xuất 10 phase ưu tiên: 1-Workflow Engine
  (nền tảng), 2-Capability Registry, 3-Context Engine, 4-Artifact Manager, 5-Simulation Engine,
  6-Doctor v2, 7-Knowledge Graph, 8-Plugin Architecture, 9-Dashboard, 10-Self Evolution Engine.
  File đã có thông tin khá chi tiết về từng phase (mục tiêu, cấu trúc thư mục, ví dụ YAML),
  tuy nhiên còn thiếu các quyết định phạm vi triển khai (phase nào làm trước, tiêu chí hoàn thành
  (DoD), timeline, nguồn lực) và xác nhận các chi tiết bổ sung mà user đề cập.
scanned_paths:
  - ".opencode/agents/"
  - ".opencode/commands/"
  - ".opencode/skills/"
  - ".opencode/scripts/"
  - ".opencode/knowledge/"
  - ".opencode/knowledge-index/"
  - ".opencode/workflow/"
  - "Upgrade_System.md"
ignored_paths:
  - path: "JapaneseLearner/"
    reason: "App code Blazor — không thuộc phạm vi nâng cấp framework agent (chỉ ảnh hưởng gián tiếp khi test)"
  - path: "JapaneseLearner.Tests/"
    reason: "Test app — không thuộc phạm vi nâng cấp framework"
discovered_modules:
  - ".opencode/agents (18 agents)"
  - ".opencode/commands (53 commands)"
  - ".opencode/skills (29 skills)"
  - ".opencode/scripts (9 scripts)"
  - ".opencode/knowledge (11 mục)"
  - ".opencode/knowledge-index (7 index)"
  - ".opencode/workflow (5 workflows)"
structure:
  root: ".opencode"
  language: "Markdown + YAML + PowerShell"
  framework: "opencode agent framework (prompt-based orchestration)"
  entry_points:
    - path: ".opencode/commands/team.md"
      type: "workflow orchestrator (13 bước, state machine)"
    - path: ".opencode/skills/dev-team/SKILL.md"
      type: "skill guide"
  main_directories:
    - path: ".opencode/agents/"
      description: "Định nghĩa 18 agents"
      relevance: "HIGH"
    - path: ".opencode/commands/"
      description: "53 lệnh opencode"
      relevance: "HIGH"
    - path: ".opencode/skills/"
      description: "29 skills chuyên biệt"
      relevance: "HIGH"
    - path: ".opencode/scripts/"
      description: "9 PowerShell utility"
      relevance: "MEDIUM"
    - path: ".opencode/knowledge/"
      description: "Knowledge base markdown"
      relevance: "MEDIUM"
requirements:
  - id: "REQ-001"
    description: "Nâng cấp Agent Framework thành AI Agent Platform (Agent Framework v4) theo roadmap trong Upgrade_System.md"
    priority: "HIGH"
  - id: "REQ-002"
    description: "Tách workflow cứng trong command team.md thành Workflow Engine khai báo (workflow.yaml + engine + phase-runner)"
    priority: "HIGH"
  - id: "REQ-003"
    description: "Xây Capability Registry (registry.yaml) cho phép dynamic routing Capability → Agent → Skill → Command"
    priority: "HIGH"
  - id: "REQ-004"
    description: "Thêm Agent Metadata (agent.yaml: version, owner, priority, capabilities, input/output contract, dependencies, estimated_tokens/time)"
    priority: "MEDIUM"
  - id: "REQ-005"
    description: "Xây Context Engine chia context thành 6 loại (Project, Task, Knowledge, Memory, Workflow, Artifact) để giảm 40-70% token"
    priority: "MEDIUM"
  - id: "REQ-006"
    description: "Xây Artifact Manager với metadata (id, version, author, agent, workflow, schema, checksum, depends_on, generated_at) + artifact-index.json"
    priority: "MEDIUM"
  - id: "REQ-007"
    description: "Xây Event Bus (PLAN_READY, BUILD_FINISHED, TEST_FAILED, REVIEW_APPROVED, KNOWLEDGE_UPDATED, ROLLBACK_REQUESTED)"
    priority: "MEDIUM"
  - id: "REQ-008"
    description: "Xây Simulation Engine (/team-simulate) — mock user/workflow/agent, phát hiện deadlock, retry vô hạn, context mất, contract sai, phase thiếu, artifact lỗi"
    priority: "MEDIUM"
  - id: "REQ-009"
    description: "Nâng cấp Doctor v2 — bổ sung Behavioral Test, Capability Coverage, Token Analysis"
    priority: "MEDIUM"
  - id: "REQ-010"
    description: "Xây Knowledge Graph (knowledge-index.json + graph) từ knowledge/memory/lesson"
    priority: "LOW"
  - id: "REQ-011"
    description: "Nâng Self Evolution Engine — Metrics → Suggestion → Simulation → Approval → Migration → Version (tự sinh migration.md, change-log.md, compatibility-report.md)"
    priority: "LOW"
  - id: "REQ-012"
    description: "Xây Plugin Architecture (plugins/: security, review, python, aws, oracle, blazor) với plugin.yaml + agent.md + skill.md"
    priority: "LOW"
  - id: "REQ-013"
    description: "Xây Dashboard (/team-dashboard, SYSTEM_DASHBOARD.md) — Health, Workflow, Agent, Skill, Knowledge, Memory, Doctor, Coverage, Token, Performance"
    priority: "LOW"
  - id: "REQ-014"
    description: "Tạo 10 command mới: /team-simulate, /team-profile, /team-registry, /team-context, /team-graph, /team-migrate, /team-plugin, /team-benchmark, /team-replay, /team-profiler"
    priority: "MEDIUM"
risks:
  - id: "RISK-001"
    description: "Phạm vi rất lớn (13 hạng mục, 10 command mới) — rủi ro scope creep, không hoàn thành được"
    severity: "HIGH"
    mitigation: "Chia phase theo mức ưu tiên trong file; mỗi phase có DoD rõ; đóng gói theo chunk"
  - id: "RISK-002"
    description: "Refactor Workflow Engine (bước 1) ảnh hưởng toàn bộ pipeline hiện có — rủi ro phá vỡ workflow /team đang chạy ổn"
    severity: "HIGH"
    mitigation: "Baseline đóng băng v3.x (tag + backup), backup utility trước mỗi phase, rollback strategy, Simulation Engine test trước khi migrate"
  - id: "RISK-003"
    description: "Chưa có thư mục contracts/ — schema contract nằm rải rác trong agent md; khó validate khi chuyển sang registry/engine"
    severity: "MEDIUM"
    mitigation: "Tạo contracts/ là phase sớm; chuyển schema YAML từ agent md sang contract chuẩn hóa"
  - id: "RISK-004"
    description: "Thiếu chi tiết từ user (sẽ gửi sau) — có thể phải làm lại Design/Plan nếu phạm vi thay đổi"
    severity: "MEDIUM"
    mitigation: "Chờ user bổ sung trước khi Design; checkpoint + workflow snapshot để rollback"
  - id: "RISK-005"
    description: "Tương thích ngược: workflow cũ (WF-2026*) dùng format cũ — engine mới phải đọc được artifact cũ"
    severity: "MEDIUM"
    mitigation: "Backward compatibility policy (missing field → default), /team-migrate"
assumptions:
  - id: "ASM-001"
    description: "Upgrade_System.md là tài liệu tham chiếu chính thức cho đợt nâng cấp"
  - id: "ASM-002"
    description: "Các phase sẽ được triển khai theo thứ tự ưu tiên trong file (1→10) trừ khi user điều chỉnh"
  - id: "ASM-003"
    description: "Không phá vỡ các command/skill/agent hiện đang hoạt động (giữ backward compatibility)"
  - id: "ASM-004"
    description: "User sẽ gửi thêm chi tiết phạm vi (phase nào làm trong đợt này, DoD, timeline) trước khi tiến hành Design"
dependencies:
  - from: "Workflow Engine"
    to: "Event Bus"
    type: "service"
    evidence_file: "Upgrade_System.md"
    evidence_line: 68
    reason: "Engine chạy phase qua event (PLAN_READY → Builder)"
  - from: "Capability Registry"
    to: "Agent Metadata"
    type: "data"
    evidence_file: "Upgrade_System.md"
    evidence_line: 144
    reason: "Registry cần agent.yaml (capabilities, priority) để dynamic routing"
  - from: "Simulation Engine"
    to: "Workflow Engine"
    type: "service"
    evidence_file: "Upgrade_System.md"
    evidence_line: 426
    reason: "Giả lập chạy đúng workflow.yaml qua engine"
  - from: "Doctor v2"
    to: "Capability Registry"
    type: "data"
    evidence_file: "Upgrade_System.md"
    evidence_line: 508
    reason: "Capability Coverage check cần registry để phát hiện mắt xích thiếu"
patterns:
  naming:
    pattern: "kebab-case + tiền tố team-"
    location: ".opencode/commands/"
    notes: "Command mới: /team-simulate, /team-registry... theo đúng convention"
  workflow:
    pattern: "State machine 13 bước trong team.md"
    location: ".opencode/commands/team.md"
    notes: "Sẽ thay bằng workflow.yaml + engine (Phase 1)"
  artifact:
    pattern: "NN_name.md theo số bước"
    location: ".opencode/workflow/<WF-ID>/"
    notes: "Phase 5 thêm metadata + artifact-index.json"
impact_scope:
  - file: ".opencode/commands/team.md"
    level: "DIRECT"
    notes: "Chuyển từ hardcode 13 bước sang gọi Workflow Engine đọc workflow.yaml"
  - file: ".opencode/commands/team-build.md"
    level: "INDIRECT"
    notes: "Builder gọi qua event bus thay vì trực tiếp (Phase 6)"
  - file: ".opencode/agents/*.md"
    level: "DIRECT"
    notes: "Thêm agent.yaml metadata cho từng agent (Phase 3)"
  - file: ".opencode/scripts/*.ps1"
    level: "INDIRECT"
    notes: "Doctor, schema-validator có thể gọi registry/engine (Phase 8)"
  - file: ".opencode/skills/"
    level: "UNRELATED"
    notes: "Skill nội dung không đổi; chỉ thay đổi cách gọi qua registry"
design_proposal:
  approach: "Refactor theo từng phase ưu tiên, giữ backward compatibility, mỗi phase có checkpoint + backup"
  affected_modules:
    - ".opencode/commands"
    - ".opencode/agents"
    - ".opencode/scripts"
    - ".opencode/workflow-engine (mới)"
    - ".opencode/registry (mới)"
    - ".opencode/context (mới)"
    - ".opencode/artifacts (mới)"
    - ".opencode/events (mới)"
    - ".opencode/simulator (mới)"
    - ".opencode/doctor (mới)"
    - ".opencode/metrics (mới)"
    - ".opencode/dashboard (mới)"
    - ".opencode/contracts (mới)"
  new_files:
    - ".opencode/workflow-engine/engine.md"
    - ".opencode/workflow-engine/executor.md"
    - ".opencode/workflow-engine/validator.md"
    - ".opencode/workflow-engine/phase-runner.md"
    - ".opencode/registry/registry.yaml"
    - ".opencode/contracts/*"
  modified_files:
    - ".opencode/commands/team.md"
    - ".opencode/agents/*.md"
  integration_points:
    - "Workflow Engine ↔ team.md (bước 1-13)"
    - "Capability Registry ↔ Doctor v2"
    - "Simulation Engine ↔ Workflow Engine"
tasks:
  - id: "TASK-000"
    description: "Baseline — tag v3.x, xuất sơ đồ Agent/Command/Skill, thống kê, sinh SYSTEM_BASELINE.md, ARCHITECTURE_MAP.md, DEPENDENCY_GRAPH.md"
    files: ["Upgrade_System.md", ".opencode/"]
    depends_on: []
    why: "Đóng băng hiện trạng để rollback (Giai đoạn 0)"
  - id: "TASK-001"
    description: "Phase 1 Workflow Engine — workflow.yaml + engine.md + executor.md + validator.md + phase-runner.md"
    files: [".opencode/workflow-engine/"]
    depends_on: ["TASK-000"]
    why: "Nền tảng cho mọi phase sau; thứ tự ưu tiên #1"
  - id: "TASK-002"
    description: "Phase 2 Capability Registry — registry.yaml + /team-registry"
    files: [".opencode/registry/"]
    depends_on: ["TASK-001"]
    why: "Dynamic routing; ưu tiên #2"
  - id: "TASK-003"
    description: "Phase 3 Agent Metadata — agent.yaml cho 18 agents"
    files: [".opencode/agents/*.md"]
    depends_on: ["TASK-002"]
    why: "Registry cần metadata để chọn agent"
  - id: "TASK-004"
    description: "Phase 4 Context Engine — 6 loại context + /team-context"
    files: [".opencode/context/"]
    depends_on: ["TASK-001"]
    why: "Tiết kiệm 40-70% token; ưu tiên #3"
  - id: "TASK-005"
    description: "Phase 5 Artifact Manager — metadata + artifact-index.json"
    files: [".opencode/artifacts/"]
    depends_on: ["TASK-001"]
    why: "Version/dependency/rollback/diff; ưu tiên #4"
  - id: "TASK-006"
    description: "Phase 6 Event Bus — events + các event constants"
    files: [".opencode/events/"]
    depends_on: ["TASK-001"]
    why: "Decouple agent gọi trực tiếp"
  - id: "TASK-007"
    description: "Phase 7 Simulation Engine — /team-simulate + simulator/"
    files: [".opencode/simulator/"]
    depends_on: ["TASK-001", "TASK-002"]
    why: "Giả lập workflow không sửa file; ưu tiên #5"
  - id: "TASK-008"
    description: "Phase 8 Doctor v2 — Behavioral Test, Capability Coverage, Token Analysis"
    files: [".opencode/doctor/", ".opencode/scripts/doctor.ps1"]
    depends_on: ["TASK-002", "TASK-004"]
    why: "Nâng cấp doctor hiện có; ưu tiên #6"
  - id: "TASK-009"
    description: "Phase 9 Knowledge Graph — knowledge-index.json + graph"
    files: [".opencode/knowledge/"]
    depends_on: ["TASK-005"]
    why: "Từ markdown sang graph; ưu tiên #7"
  - id: "TASK-010"
    description: "Phase 10 Plugin Architecture — plugins/ + /team-plugin"
    files: [".opencode/plugins/"]
    depends_on: ["TASK-002", "TASK-003"]
    why: "Cài agent bên thứ ba; ưu tiên #8"
  - id: "TASK-011"
    description: "Phase 11 Dashboard — SYSTEM_DASHBOARD.md"
    files: [".opencode/dashboard/"]
    depends_on: ["TASK-001", "TASK-002", "TASK-004"]
    why: "Hiển thị tổng quan hệ thống; ưu tiên #9"
  - id: "TASK-012"
    description: "Phase 12 Self Evolution Engine — Metrics → ... → Migration + /team-migrate"
    files: [".opencode/metrics/", ".opencode/scripts/"]
    depends_on: ["TASK-007"]
    why: "Tự evolution; ưu tiên #10"
conclusion:
  status: "NEED_MORE_INFO"
  reason: >
    Đã phân tích được roadmap v4 từ Upgrade_System.md và baseline hiện trạng .opencode
    (18 agents, 53 commands, 29 skills, 9 scripts, không có contracts/). Tuy nhiên user
    xác nhận sẽ gửi nội dung chi tiết bổ sung sau — cần thông tin phạm vi triển khai
    trước khi tiến hành Design/Plan để tránh phải làm lại.
  missing_info:
    - "Phạm vi đợt nâng cấp này: triển khai toàn bộ 13 hạng mục hay chỉ 1-2 phase ưu tiên?"
    - "Nội dung chi tiết bổ sung mà user sẽ gửi sau là gì? (có phải chi tiết kỹ thuật từng phase?)"
    - "Tiêu chí hoàn thành (DoD) cho từng phase?"
    - "Timeline/nguồn lực: 6-8 tuần theo file hay rút gọn?"
    - "Có giữ nguyên thứ tự ưu tiên trong file (1-Workflow Engine → 10-Self Evolution) không?"
```
