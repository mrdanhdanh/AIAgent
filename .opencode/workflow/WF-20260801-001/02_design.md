# 02_design.md — WF-20260801-001

```yaml
status: READY
summary: >
  Thiết kế kiến trúc QA System gồm 12 skills + 12 commands, tổ chức theo
  mô hình "Skill cung cấp năng lực, Command cung cấp quy trình". Skills
  chia thành 4 nhóm: Generation (sinh test), Validation (đánh giá), Analysis
  (phân tích), Support (hỗ trợ). Commands chia thành 3 lớp: Execution (chạy),
  Orchestration (điều phối), Governance (gate/health).
effort: Large
design:
  architecture: >
    QA System 2 tầng. Tầng 1 (Skills): năng lực tái sử dụng, mỗi skill 1 chuyên
    môn. Tầng 2 (Commands): quy trình nghiệp vụ, mỗi command triệu hồi 1+ skill
    và đóng gói thành quy trình QA hoàn chỉnh. Không tạo agent mới — đúng yêu
    cầu user. Tận dụng knowledge base hiện có (playwright-e2e, xunit-bunit,
    fluentui, dark-mode, tri-state). Tuân thủ convention: YAML frontmatter,
    schema_version, output contract YAML, tiếng Việt.
  components:
    - name: "playwright-e2e"
      path: ".opencode/skills/playwright-e2e/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "playwright-component"
      path: ".opencode/skills/playwright-component/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "visual-regression"
      path: ".opencode/skills/visual-regression/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "ui-review"
      path: ".opencode/skills/ui-review/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "design-system-validator"
      path: ".opencode/skills/design-system-validator/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "accessibility"
      path: ".opencode/skills/accessibility/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "responsive-layout"
      path: ".opencode/skills/responsive-layout/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "browser-compatibility"
      path: ".opencode/skills/browser-compatibility/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "screenshot-analyzer"
      path: ".opencode/skills/screenshot-analyzer/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "test-data-generator"
      path: ".opencode/skills/test-data-generator/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "test-report"
      path: ".opencode/skills/test-report/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "flaky-test-detector"
      path: ".opencode/skills/flaky-test-detector/SKILL.md"
      action: "CREATE"
      category: "skill"
    - name: "test-plan"
      path: ".opencode/commands/test-plan.md"
      action: "CREATE"
      category: "command"
    - name: "test-e2e"
      path: ".opencode/commands/test-e2e.md"
      action: "CREATE"
      category: "command"
    - name: "test-ui"
      path: ".opencode/commands/test-ui.md"
      action: "CREATE"
      category: "command"
    - name: "test-visual"
      path: ".opencode/commands/test-visual.md"
      action: "CREATE"
      category: "command"
    - name: "test-accessibility"
      path: ".opencode/commands/test-accessibility.md"
      action: "CREATE"
      category: "command"
    - name: "test-cross-browser"
      path: ".opencode/commands/test-cross-browser.md"
      action: "CREATE"
      category: "command"
    - name: "test-regression"
      path: ".opencode/commands/test-regression.md"
      action: "CREATE"
      category: "command"
    - name: "doctor-test"
      path: ".opencode/commands/doctor-test.md"
      action: "CREATE"
      category: "command"
    - name: "approve-test"
      path: ".opencode/commands/approve-test.md"
      action: "CREATE"
      category: "command"
    - name: "test-bootstrap"
      path: ".opencode/commands/test-bootstrap.md"
      action: "CREATE"
      category: "command"
    - name: "test-evolve"
      path: ".opencode/commands/test-evolve.md"
      action: "CREATE"
      category: "command"
    - name: "test-audit"
      path: ".opencode/commands/test-audit.md"
      action: "CREATE"
      category: "command"
    - name: "AGENTS.md"
      path: "AGENTS.md"
      action: "MODIFY"
      category: "docs"
  data_flow: >
    User gọi /test-* command → command triệu hồi skill tương ứng → skill thực
    thi chuyên môn (sinh test / chạy test / phân tích) → output YAML contract
    → command tổng hợp báo cáo → user. /doctor-test + /approve-test đóng vai
    trò governance cuối pipeline.
  security_concerns:
    - description: "Test không được commit secret/token vào repo"
      severity: HIGH
      mitigation: "Skill test-data-generator sinh dữ liệu fake, không dùng credential thật"
    - description: "E2E chạy dev server — không được đụng production"
      severity: MEDIUM
      mitigation: "Skill e2e luôn dùng port 5173 local, cảnh báo nếu phát hiện URL production"
    - description: "XSS/screenshot chứa dữ liệu nhạy cảm"
      severity: MEDIUM
      mitigation: "Visual regression cảnh báo khi screenshot chứa PII; doctor-test quét secret trong screenshot"
  edge_cases:
    - description: "Project chưa có Playwright cấu hình"
      handling: "test-bootstrap tự sinh cấu hình"
    - description: "Không có screenshot baseline"
      handling: "visual-regression lần đầu tạo baseline, không fail"
    - description: "Selectors dễ vỡ (auto-generated id)"
      handling: "flaky-test-detector phát hiện + đề xuất data-testid"
    - description: "Màn hình không có route (component-only)"
      handling: "playwright-component test trực tiếp qua bUnit"
    - description: "Feature chưa có test"
      handling: "doctor-test báo missing → test-evolve sinh test"
blocking_issues: []
non_blocking_issues:
  - id: "#01"
    severity: MINOR
    category: CONSISTENCY
    description: "Cần đồng bộ port convention (5173) giữa skill e2e và AppFixture"
    suggestion: "Ghi rõ trong skill playwright-e2e"
  - id: "#02"
    severity: MINOR
    category: STYLE
    description: "Browser path hardcoded PlaywrightFixture.cs:24"
    suggestion: "doctor-test cảnh báo cấu hình máy"
open_questions: []
next_action: "Chuyển sang Plan phase"
artifacts: ["02_design.md"]
```
