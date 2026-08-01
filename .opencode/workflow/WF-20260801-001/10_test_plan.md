# 10_test_plan.md — WF-20260801-001

```yaml
status: READY
summary: >
  Test plan cho workflow tạo 24 QA documentation artifacts. Impact: hệ thống
  .opencode (skills + commands) + AGENTS.md. Không đụng source code JapaneseLearner.
  Test tập trung: (1) tính hợp lệ artifact, (2) không phá vỡ build/test hiện có.
impact_analysis:
  modified_files:
    - "AGENTS.md"
  dependencies:
    - ".opencode/skills/*" (12 mới)
    - ".opencode/commands/test-*.md" (12 mới)
  public_api_changed: false
  ui_changed: false
  database_changed: false
  config_changed: true
  breaking_changes: false
  affects:
    - "opencode_documentation"
    - "test_infrastructure_docs"
  does_not_affect:
    - "JapaneseLearner source"
    - "JapaneseLearner.Tests source"
    - "JapaneseLearner.E2ETests source"
requirements:
  - id: REQ-001
    description: "12 skill files hợp lệ (frontmatter + output contract)"
  - id: REQ-002
    description: "12 command files hợp lệ (frontmatter + tham chiếu skill)"
  - id: REQ-003
    description: "AGENTS.md cập nhật đúng QA commands section"
  - id: REQ-004
    description: "Không phá vỡ unit tests hiện có"
existing:
  framework: "xUnit + bUnit + Playwright"
  files:
    - "JapaneseLearner.Tests/"
  already_cover:
    - "application logic"
  missing: []
  duplicated: []
risk_assessment:
  risk_level: "low"
  reason: "Documentation only — không đụng code logic"
  coverage_target:
    unit: 80
    integration: 60
test_cases:
  - id: TC-001
    type: VALIDATION
    description: "YAML frontmatter hợp lệ trên 24 files"
    input: "24 file paths"
    expected: "Mỗi file có description + schema_version"
    file: "scripts/cross-ref-validator.ps1"
    priority: P0
  - id: TC-002
    type: VALIDATION
    description: "Code block balance trên 24 files"
    input: "24 file paths"
    expected: "Số ``` chẵn"
    priority: P0
  - id: TC-003
    type: VALIDATION
    description: "Internal skill links không broken"
    input: "24 file paths"
    expected: "0 broken links"
    priority: P0
  - id: TC-004
    type: VALIDATION
    description: "12 QA commands đều tồn tại"
    input: "commands dir"
    expected: "12 files present"
    priority: P0
  - id: TC-005
    type: UNIT
    description: "Unit tests vẫn pass sau thay đổi"
    input: "dotnet test JapaneseLearner.Tests"
    expected: "All pass"
    priority: P0
  - id: TC-006
    type: VALIDATION
    description: "AGENTS.md chứa QA Testing Commands section"
    input: "AGENTS.md"
    expected: "grep test-e2e PASS"
    priority: P0
  - id: TC-007
    type: SECURITY
    description: "Không secret leak trong docs"
    input: "24 files"
    expected: "0 secret patterns"
    priority: P0
  - id: TC-008
    type: VALIDATION
    description: "Secret fake credentials được ghi rõ là fake"
    input: "Login helper + test-data-generator"
    expected: "Test@123 chỉ xuất hiện trong ngữ cảnh test"
    priority: P1
regression_scope:
  direct: ["AGENTS.md"]
  indirect: ["opencode docs structure"]
  unaffected: ["JapaneseLearner app"]
  regression_cases: []
coverage_target:
  unit: 80
  integration: 60
  e2e: 50
  overall: 80
validation:
  checklist:
    - item: "All requirements covered?"
      status: PASS
    - item: "Regression exists?"
      status: PASS
    - item: "Positive test exists?"
      status: PASS
    - item: "Negative test exists?"
      status: PASS
    - item: "Framework detected?"
      status: PASS
  all_pass: true
```
