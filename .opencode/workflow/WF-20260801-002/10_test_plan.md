# 10_test_plan.md — WF-20260801-002

```yaml
status: READY
summary: >
  8 test cases cho Knowledge Assistant: frontmatter validation (21 files), internal links,
  code block balance, index script (build/status/rebuild), secret scan, build regression,
  test regression, cross-reference check. Type: validation + integration.
issues: []
next_action: "Thực thi test plan"
artifacts: ["10_test_plan.md"]
impact_analysis:
  modified_files:
    - "AGENTS.md"
    - ".opencode/knowledge/README.md"
  dependencies: []
  public_api_changed: []
  ui_changed: false
  database_changed: false
  config_changed: true
  breaking_changes: false
  affects:
    - opencode_framework
  does_not_affect:
    - japanese_learner_app_logic
requirements:
  - id: REQ-001
    description: "21 file mới có frontmatter YAML hợp lệ"
  - id: REQ-002
    description: "Internal links không broken"
  - id: REQ-003
    description: "Code blocks cân bằng"
  - id: REQ-004
    description: "Script index build/status/rebuild chạy được"
  - id: REQ-005
    description: "Không có secret trong file mới"
  - id: REQ-006
    description: "Build regression PASS"
  - id: REQ-007
    description: "Unit test regression PASS"
  - id: REQ-008
    description: "Cross-reference skills↔commands nhất quán"
existing:
  framework: "PowerShell validation scripts"
  files: []
  already_cover: []
  missing:
    - "Test cho knowledge assistant mới"
  duplicated: []
risk_assessment:
  risk_level: "medium"
  reason: "Nhiều file markdown + script PowerShell — rủi ro format/encoding"
  coverage_target:
    unit: 80
    integration: 60
testability:
  status: GOOD
  issues: []
  recommendations: []
coverage_matrix:
  - requirement: REQ-001
    test_cases: [TC-001]
  - requirement: REQ-002
    test_cases: [TC-002]
  - requirement: REQ-003
    test_cases: [TC-003]
  - requirement: REQ-004
    test_cases: [TC-004, TC-005]
  - requirement: REQ-005
    test_cases: [TC-006]
  - requirement: REQ-006
    test_cases: [TC-007]
  - requirement: REQ-007
    test_cases: [TC-007]
  - requirement: REQ-008
    test_cases: [TC-008]
test_cases:
  - id: TC-001
    type: VALIDATION
    description: "Frontmatter YAML hợp lệ — 11 skills (name/description/schema_version) + 10 commands (description/agent/schema_version)"
    input: "21 files trong .opencode/skills/ + .opencode/commands/"
    expected: "21/21 PASS"
    file: ".opencode/scripts/"
    priority: P0
    risk_level: high
    coverage:
      requirement: [REQ-001]
      component: "knowledge files"
  - id: TC-002
    type: VALIDATION
    description: "Internal links không broken — mọi [text](#anchor) có section tương ứng"
    input: "21 files"
    expected: "0 broken / 67 links"
    file: ".opencode/scripts/"
    priority: P0
    risk_level: high
    coverage:
      requirement: [REQ-002]
      component: "knowledge files"
  - id: TC-003
    type: VALIDATION
    description: "Code block balance — số ``` mở = đóng"
    input: "21 files"
    expected: "86 blocks, 0 unbalanced"
    file: ".opencode/scripts/"
    priority: P1
    risk_level: medium
    coverage:
      requirement: [REQ-003]
      component: "knowledge files"
  - id: TC-004
    type: INTEGRATION
    description: "Script build-knowledge-index.ps1 -Rebuild chạy thành công"
    input: "powershell -File build-knowledge-index.ps1 -Rebuild"
    expected: "7 index files, SUCCESS status"
    file: ".opencode/scripts/build-knowledge-index.ps1"
    priority: P0
    risk_level: high
    coverage:
      requirement: [REQ-004]
      component: "build-knowledge-index.ps1"
  - id: TC-005
    type: INTEGRATION
    description: "Script -Status báo đúng 7 index files"
    input: "powershell -File build-knowledge-index.ps1 -Status"
    expected: "7 [OK] lines"
    file: ".opencode/scripts/build-knowledge-index.ps1"
    priority: P1
    risk_level: medium
    coverage:
      requirement: [REQ-004]
      component: "build-knowledge-index.ps1"
  - id: TC-006
    type: SECURITY
    description: "Secret scan — không có api_key/password/private key/token trong file mới"
    input: "25 files (21 mới + script + README + index)"
    expected: "CLEAN — 0 found"
    file: ".opencode/scripts/"
    priority: P0
    risk_level: high
    coverage:
      requirement: [REQ-005]
      component: "all new files"
  - id: TC-007
    type: REGRESSION
    description: "dotnet build + dotnet test regression"
    input: "dotnet build JapaneseLearner; dotnet test JapaneseLearner.Tests"
    expected: "Build 0 error; 154/154 PASS"
    file: "JapaneseLearner/"
    priority: P0
    risk_level: high
    coverage:
      requirement: [REQ-006, REQ-007]
      component: "JapaneseLearner"
  - id: TC-008
    type: VALIDATION
    description: "Cross-reference — mỗi command trỏ skill tương ứng và ngược lại"
    input: "21 files"
    expected: "21/21 có reference"
    file: ".opencode/scripts/"
    priority: P1
    risk_level: low
    coverage:
      requirement: [REQ-008]
      component: "knowledge files"
regression_scope:
  direct:
    - ".opencode framework (commands/skills)"
  indirect:
    - "AGENTS.md docs"
  unaffected:
    - "JapaneseLearner app logic"
  regression_cases:
    - TC-007
coverage_target:
  unit: 80
  integration: 60
  e2e: 0
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
    - item: "Boundary test exists?"
      status: PASS
    - item: "Edge cases exist?"
      status: PASS
    - item: "Duplicate testcases?"
      status: PASS
    - item: "Existing tests reused?"
      status: PASS
    - item: "Coverage target satisfied?"
      status: PASS
    - item: "Risk level assigned?"
      status: PASS
    - item: "Test file path valid?"
      status: PASS
    - item: "Framework detected?"
      status: PASS
  all_pass: true
```
