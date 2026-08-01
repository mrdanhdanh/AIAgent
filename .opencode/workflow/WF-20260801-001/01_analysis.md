# 01_analysis.md — WF-20260801-001

```yaml
status: READY
effort: Large
summary: >
  Yêu cầu tạo bộ QA Skill + Command (12 skills + 12 commands) để sinh test E2E,
  test màn hình, giao diện, màu sắc theo quy chuẩn. Không tạo agent test đơn lẻ
  mà chia nhỏ thành các skill/command tái sử dụng. Hiện hệ thống có 21 commands
  + 5 skills nhưng KHÔNG có bộ QA chuyên sâu nào. Đã xác định 24 requirements
  và 4 risks chính.
details: >
  Kiến trúc đề xuất gồm 2 nhóm: (1) Skills trong .opencode/skills/ — playwright-e2e,
  playwright-component, visual-regression, ui-review, design-system-validator,
  accessibility, responsive-layout, browser-compatibility, screenshot-analyzer,
  test-data-generator, test-report, flaky-test-detector. (2) Commands trong
  .opencode/commands/ — test-plan, test-e2e, test-ui, test-visual, test-accessibility,
  test-cross-browser, test-regression, doctor-test, approve-test, test-bootstrap,
  test-evolve, test-audit. Cần tuân thủ convention YAML frontmatter, schema_version,
  output contract, và tận dụng knowledge base hiện có (fluentui, playwright-e2e,
  xunit-bunit, dark-mode, tri-state).
scanned_paths:
  - ".opencode/commands/"
  - ".opencode/skills/"
  - ".opencode/agents/"
  - ".opencode/knowledge/testing/"
  - ".opencode/knowledge/ui/"
  - ".opencode/scripts/"
  - "JapaneseLearner.E2ETests/"
ignored_paths:
  - path: "JapaneseLearner.E2ETests/bin"
    reason: "Build artifacts"
  - path: "JapaneseLearner.E2ETests/obj"
    reason: "Build artifacts"
discovered_modules:
  - "QA Skills (12)"
  - "QA Commands (12)"
  - "Test Infrastructure (Playwright/xUnit/bUnit)"
structure:
  root: ".opencode"
  language: "Markdown/YAML"
  framework: "OpenCode Agent Framework"
  entry_points:
    - path: ".opencode/commands/team.md"
      type: "orchestrator"
    - path: ".opencode/skills/dev-team/SKILL.md"
      type: "skill"
  main_directories:
    - path: ".opencode/commands/"
      description: "Agent commands"
      relevance: "HIGH"
    - path: ".opencode/skills/"
      description: "Reusable skills"
      relevance: "HIGH"
    - path: ".opencode/knowledge/"
      description: "Knowledge base"
      relevance: "MEDIUM"
requirements:
  - id: "REQ-001"
    description: "Skill playwright-e2e"
    priority: "HIGH"
  - id: "REQ-002"
    description: "Skill playwright-component"
    priority: "MEDIUM"
  - id: "REQ-003"
    description: "Skill visual-regression"
    priority: "HIGH"
  - id: "REQ-004"
    description: "Skill ui-review"
    priority: "HIGH"
  - id: "REQ-005"
    description: "Skill design-system-validator"
    priority: "HIGH"
  - id: "REQ-006"
    description: "Skill accessibility"
    priority: "HIGH"
  - id: "REQ-007"
    description: "Skill responsive-layout"
    priority: "MEDIUM"
  - id: "REQ-008"
    description: "Skill browser-compatibility"
    priority: "MEDIUM"
  - id: "REQ-009"
    description: "Skill screenshot-analyzer"
    priority: "MEDIUM"
  - id: "REQ-010"
    description: "Skill test-data-generator"
    priority: "MEDIUM"
  - id: "REQ-011"
    description: "Skill test-report"
    priority: "MEDIUM"
  - id: "REQ-012"
    description: "Skill flaky-test-detector"
    priority: "MEDIUM"
  - id: "REQ-013"
    description: "Command /test-plan"
    priority: "HIGH"
  - id: "REQ-014"
    description: "Command /test-e2e"
    priority: "HIGH"
  - id: "REQ-015"
    description: "Command /test-ui"
    priority: "HIGH"
  - id: "REQ-016"
    description: "Command /test-visual"
    priority: "HIGH"
  - id: "REQ-017"
    description: "Command /test-accessibility"
    priority: "HIGH"
  - id: "REQ-018"
    description: "Command /test-cross-browser"
    priority: "MEDIUM"
  - id: "REQ-019"
    description: "Command /test-regression"
    priority: "MEDIUM"
  - id: "REQ-020"
    description: "Command /doctor-test"
    priority: "HIGH"
  - id: "REQ-021"
    description: "Command /approve-test"
    priority: "HIGH"
  - id: "REQ-022"
    description: "Command /test-bootstrap"
    priority: "MEDIUM"
  - id: "REQ-023"
    description: "Command /test-evolve"
    priority: "MEDIUM"
  - id: "REQ-024"
    description: "Command /test-audit"
    priority: "MEDIUM"
risks:
  - id: "RISK-001"
    description: "24 artifact files — dung lượng lớn, cần chunking"
    severity: HIGH
    mitigation: "Chunk 1: config; Chunk 2-3: skills (6+6); Chunk 4: commands; validate theo chunk"
  - id: "RISK-002"
    description: "Trùng lặp scope với team-testplan/team-test hiện có"
    severity: MEDIUM
    mitigation: "QA commands chuyên sâu (visual/a11y/cross-browser/doctor), team-testplan giữ vai trò dev-team"
  - id: "RISK-003"
    description: "Playwright browser path hardcoded (PlaywrightFixture.cs:24)"
    severity: MEDIUM
    mitigation: "Skill cross-browser/doctor-test cảnh báo + hướng dẫn config"
  - id: "RISK-004"
    description: "Port 5173 hardcoded trong E2E"
    severity: LOW
    mitigation: "Skill e2e ghi rõ convention port"
assumptions:
  - id: "ASM-001"
    description: "Các skill/command dùng ngôn ngữ tiếng Việt như convention hiện tại"
  - id: "ASM-002"
    description: "Không tạo agent mới — chỉ tạo skill/command (theo yêu cầu user)"
dependencies:
  - from: "QA commands"
    to: "QA skills"
    type: "documentation"
    evidence_file: ".opencode/commands/team-ui-audit.md"
    evidence_line: 1
    reason: "Commands tham chiếu skills tương ứng"
patterns:
  naming:
    pattern: "kebab-case"
    location: ".opencode/"
    notes: "Tên skill/command kebab-case"
  routing:
    pattern: "/command-name"
    location: ".opencode/commands/"
    notes: "Slash command"
  state_management:
    pattern: "YAML frontmatter + output contract"
    location: ".opencode/"
    notes: "description, agent, schema_version"
  testing:
    framework: "Playwright + xUnit + bUnit"
    locations: ["JapaneseLearner.E2ETests/", "JapaneseLearner.Tests/"]
impact_scope:
  - file: ".opencode/skills/playwright-e2e/SKILL.md"
    level: "CREATE"
    notes: "Skill mới"
  - file: ".opencode/commands/test-e2e.md"
    level: "CREATE"
    notes: "Command mới"
design_proposal:
  approach: "Tạo 12 skills + 12 commands theo kiến trúc đề xuất, mỗi skill có SKILL.md với YAML frontmatter + output contract, mỗi command tham chiếu skill"
  affected_modules: ["QA Skills", "QA Commands"]
  new_files: ["24 files mới"]
  modified_files: []
  integration_points: ["AGENTS.md update", "SYSTEM_MAP update"]
tasks:
  - id: "TASK-001"
    description: "Tạo 12 skill files"
    files: [".opencode/skills/*/SKILL.md"]
    depends_on: []
    why: "Skills là nền tảng"
  - id: "TASK-002"
    description: "Tạo 12 command files"
    files: [".opencode/commands/test-*.md"]
    depends_on: ["TASK-001"]
    why: "Commands tham chiếu skills"
  - id: "TASK-003"
    description: "Cập nhật AGENTS.md và SYSTEM_MAP"
    files: ["AGENTS.md"]
    depends_on: ["TASK-002"]
    why: "Đăng ký command mới vào hệ thống"
conclusion:
  status: "READY"
  reason: "Đã xác định đầy đủ 24 requirements, 4 risks, và 3 tasks"
  missing_info: []
```
