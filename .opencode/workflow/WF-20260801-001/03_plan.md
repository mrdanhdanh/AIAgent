# 03_plan.md — WF-20260801-001

```yaml
status: READY
summary: >
  Kế hoạch 12 steps chia 4 chunks: Chunk 1 (config — tạo workflow dir, đã có),
  Chunk 2 (12 skill files), Chunk 3 (12 command files), Chunk 4 (docs + validation:
  AGENTS.md update, static analysis, doctor-test). Mỗi skill/command đều CREATE
  mới — không cần backup. Rollback: xóa file mới nếu cần.
blocking_issues: []
non_blocking_issues: []
open_questions: []
next_action: "Chuyển sang Review phase"
artifacts: ["03_plan.md"]
steps:
  - order: 1
    description: "Tạo skill playwright-e2e"
    action: CREATE
    file: ".opencode/skills/playwright-e2e/SKILL.md"
    logic: "Tạo SKILL.md với YAML frontmatter (name, description, schema_version) + quy trình sinh Playwright Test, Page Object, Fixture, Mock API, Login Helper + output contract"
    expected_result: "SKILL.md tồn tại, YAML frontmatter hợp lệ, có output contract"
    check: "Test-Path + YAML parse"
    chunk: 2
    requires_backup: false
    depends_on: []
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 2
    description: "Tạo skill playwright-component"
    action: CREATE
    file: ".opencode/skills/playwright-component/SKILL.md"
    logic: "Tạo SKILL.md — sinh test component (button/textbox/dropdown/dialog/grid/form) + validation, keyboard, focus, tab order, shortcut"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 2
    requires_backup: false
    depends_on: [1]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 3
    description: "Tạo skill visual-regression"
    action: CREATE
    file: ".opencode/skills/visual-regression/SKILL.md"
    logic: "Tạo SKILL.md — toHaveScreenshot(), multi-viewport, pixel diff, threshold, ignore animation/dynamic"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 2
    requires_backup: false
    depends_on: [1]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 4
    description: "Tạo skill ui-review"
    action: CREATE
    file: ".opencode/skills/ui-review/SKILL.md"
    logic: "Tạo SKILL.md — đọc HTML/Razor/CSS/FluentUI, đánh giá spacing/padding/margin/alignment/font/icon/whitespace/consistency, output warning"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 2
    requires_backup: false
    depends_on: [1]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 5
    description: "Tạo skill design-system-validator"
    action: CREATE
    file: ".opencode/skills/design-system-validator/SKILL.md"
    logic: "Tạo SKILL.md — kiểm tra design tokens (radius/spacing/elevation/shadow/text size) theo FluentUI"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 2
    requires_backup: false
    depends_on: [1]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 6
    description: "Tạo skill accessibility"
    action: CREATE
    file: ".opencode/skills/accessibility/SKILL.md"
    logic: "Tạo SKILL.md — ARIA, tab order, screen reader, keyboard, contrast, alt, label, focus ring + WCAG AA/AAA report"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 2
    requires_backup: false
    depends_on: [1]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 7
    description: "Tạo skill responsive-layout"
    action: CREATE
    file: ".opencode/skills/responsive-layout/SKILL.md"
    logic: "Tạo SKILL.md — test 320/375/768/1024/1366/1920, overflow, horizontal scroll, hidden control, flex/grid"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 3
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 8
    description: "Tạo skill browser-compatibility"
    action: CREATE
    file: ".opencode/skills/browser-compatibility/SKILL.md"
    logic: "Tạo SKILL.md — Chrome/Edge/Firefox/Safari + mobile, cảnh báo PlaywrightFixture.cs:24 hardcoded path"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 3
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 9
    description: "Tạo skill screenshot-analyzer"
    action: CREATE
    file: ".opencode/skills/screenshot-analyzer/SKILL.md"
    logic: "Tạo SKILL.md — đọc/phân tích screenshot: layout, alignment, color, missing icon, wrong font, blur, cropped, spacing"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 3
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 10
    description: "Tạo skill test-data-generator"
    action: CREATE
    file: ".opencode/skills/test-data-generator/SKILL.md"
    logic: "Tạo SKILL.md — sinh user/customer/order/invoice/large dataset/boundary/invalid/random, cấm secret thật"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 3
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 11
    description: "Tạo skill test-report"
    action: CREATE
    file: ".opencode/skills/test-report/SKILL.md"
    logic: "Tạo SKILL.md — sinh HTML/Markdown/JSON/JUnit/Allure, coverage/failed/passed/skipped/screenshot/video/trace"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 3
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 12
    description: "Tạo skill flaky-test-detector"
    action: CREATE
    file: ".opencode/skills/flaky-test-detector/SKILL.md"
    logic: "Tạo SKILL.md — retry/timeout/animation/network/wait/race condition → nguyên nhân + fix"
    expected_result: "SKILL.md tồn tại"
    check: "Test-Path"
    chunk: 3
    requires_backup: false
    depends_on: [6]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 13
    description: "Tạo command /test-plan"
    action: CREATE
    file: ".opencode/commands/test-plan.md"
    logic: "Tạo command md — requirement → matrix → scenario → boundary → edge → priority, agent: test-planner"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [1]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 14
    description: "Tạo command /test-e2e"
    action: CREATE
    file: ".opencode/commands/test-e2e.md"
    logic: "Tạo command md — requirement → playwright → fixture → run → report, tham chiếu skill playwright-e2e"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 15
    description: "Tạo command /test-ui"
    action: CREATE
    file: ".opencode/commands/test-ui.md"
    logic: "Tạo command md — review UI/UX/consistency/responsive/accessibility, tham chiếu skill ui-review + design-system-validator"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 16
    description: "Tạo command /test-visual"
    action: CREATE
    file: ".opencode/commands/test-visual.md"
    logic: "Tạo command md — screenshot → compare → diff → report, tham chiếu skill visual-regression + screenshot-analyzer"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 17
    description: "Tạo command /test-accessibility"
    action: CREATE
    file: ".opencode/commands/test-accessibility.md"
    logic: "Tạo command md — axe → report → fix suggestion, tham chiếu skill accessibility"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 18
    description: "Tạo command /test-cross-browser"
    action: CREATE
    file: ".opencode/commands/test-cross-browser.md"
    logic: "Tạo command md — Chrome/Edge/Firefox/Safari, tham chiếu skill browser-compatibility"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 19
    description: "Tạo command /test-regression"
    action: CREATE
    file: ".opencode/commands/test-regression.md"
    logic: "Tạo command md — chọn module ảnh hưởng → cases → run → report"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 20
    description: "Tạo command /doctor-test"
    action: CREATE
    file: ".opencode/commands/doctor-test.md"
    logic: "Tạo command md — QA health check 12 tiêu chí + health score + risk"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 21
    description: "Tạo command /approve-test"
    action: CREATE
    file: ".opencode/commands/approve-test.md"
    logic: "Tạo command md — gate cuối: coverage ≥80%, no flaky, no a11y error, no visual diff, no failed E2E, no broken responsive, no missing critical"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 22
    description: "Tạo command /test-bootstrap"
    action: CREATE
    file: ".opencode/commands/test-bootstrap.md"
    logic: "Tạo command md — phát hiện framework UI, sinh cấu hình Playwright + PO + fixture + thư mục"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 23
    description: "Tạo command /test-evolve"
    action: CREATE
    file: ".opencode/commands/test-evolve.md"
    logic: "Tạo command md — diff source vs test hiện có, xác định test cần cập nhật/lỗi thời, sinh test mới"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 24
    description: "Tạo command /test-audit"
    action: CREATE
    file: ".opencode/commands/test-audit.md"
    logic: "Tạo command md — đánh giá coverage/duplication/maintainability/runtime/flaky rate → improvement plan"
    expected_result: "Command file tồn tại"
    check: "Test-Path"
    chunk: 4
    requires_backup: false
    depends_on: [13]
    validation_command: "dotnet test JapaneseLearner.Tests"
    risk_level: LOW
  - order: 25
    description: "Cập nhật AGENTS.md — đăng ký QA commands"
    action: MODIFY
    file: "AGENTS.md"
    logic: "Thêm section QA Testing Commands vào AGENTS.md, liệt kê /test-* commands"
    expected_result: "AGENTS.md có danh sách QA commands"
    check: "grep test-e2e AGENTS.md"
    chunk: 1
    requires_backup: true
    depends_on: [24]
    validation_command: "grep 'test-e2e' AGENTS.md"
    risk_level: LOW
per_step_validation:
  - step: 1-12
    command: "Test-Path .opencode/skills/*/SKILL.md"
    expected: "12 files tồn tại"
  - step: 13-24
    command: "Test-Path .opencode/commands/test-*.md"
    expected: "12 files tồn tại"
  - step: 25
    command: "grep 'test-e2e' AGENTS.md"
    expected: "PASS"
per_chunk_validate:
  - chunk: 2
    command: "Get-ChildItem .opencode/skills/*/SKILL.md"
    expected: "6 skill files tồn tại"
  - chunk: 3
    command: "Get-ChildItem .opencode/skills/*/SKILL.md"
    expected: "12 skill files tồn tại"
  - chunk: 4
    command: "Get-ChildItem .opencode/commands/test-*.md"
    expected: "12 command files tồn tại"
final_validation:
  - command: "Get-ChildItem .opencode/skills/*/SKILL.md | Measure-Object"
    expected: "12 skill files"
  - command: "Get-ChildItem .opencode/commands/test-*.md | Measure-Object"
    expected: "12 command files"
  - command: "dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj"
    expected: "Unit tests PASS"
rollback_strategy:
  enabled: true
  trigger_conditions:
    - type: "catastrophic_failure"
      description: "Lỗi không recover được"
    - type: "max_retry_reached"
      description: "Retry > 3 lần"
      threshold: 3
    - type: "user_request"
      description: "User yêu cầu dừng"
  restore_order:
    - step: 25
      action: "restore"
      file: "AGENTS.md"
    - step: 1-24
      action: "delete"
      file: ".opencode/skills/*/SKILL.md, .opencode/commands/test-*.md"
  requires_user_confirmation: true
  conditions:
    - "catastrophic failure"
    - "max retry reached"
    - "user request"
  steps:
    - "Bước 1: restore AGENTS.md từ backup"
    - "Bước 2: xóa 24 file mới nếu tồn tại"
validate:
  - "Kiểm tra 12 skill files tồn tại"
  - "Kiểm tra 12 command files tồn tại"
  - "Chạy unit tests"
  - "Kiểm tra YAML frontmatter hợp lệ"
```
