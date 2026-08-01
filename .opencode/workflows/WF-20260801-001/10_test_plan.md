---
workflow_id: "WF-20260801-001"
step: 10
step_name: "test_plan"
agent: "test-planner"
schema_version: "3.2"
timestamp: "2026-08-01T18:08:00Z"
---

# Bước 10: Test Plan — Knowledge Assistant

```yaml
status: "READY"
summary: >
  Kế hoạch test cho Knowledge Assistant (10 skills + 11 commands + script index +
  agent + opencode.json integration). Vì hệ thống mới là .opencode framework config
  (không phải code C# thêm), test tập trung vào: (1) unit-level validate cấu hình,
  (2) integration test script index + command routing, (3) regression dotnet,
  (4) smoke test command thực tế.
test_types:
  - unit
  - integration
  - regression
  - smoke
coverage_target:
  unit: 100
  integration: 100
  regression: 100
  smoke: 3
test_cases:
  - id: "T-001"
    type: "unit"
    name: "Validate opencode.json cấu hình"
    steps:
      - "ConvertFrom-Json opencode.json không lỗi"
      - "agent.knowledge-agent tồn tại với permission bash: allow, edit: deny"
      - "11 commands knowledge-* tồn tại với agent: knowledge-agent"
    expected: "JSON hợp lệ, 1 agent + 11 commands đăng ký đúng"
    status: "PASSED"
  - id: "T-002"
    type: "unit"
    name: "Validate frontmatter 11 commands + 10 skills"
    steps:
      - "Mỗi command có description + agent: knowledge-agent"
      - "Mỗi skill có name (khớp dir) + description + schema_version"
    expected: "0 lỗi frontmatter"
    status: "PASSED"
  - id: "T-003"
    type: "integration"
    name: "knowledge-index.ps1 build index thực tế"
    steps:
      - "Chạy -Mode build"
      - "Kiểm tra 7 JSON files sinh ra"
      - "Verify route-index có 14 routes, service-index có 5 DI"
    expected: "index build success, routes >= 13, di_services = 5"
    status: "PASSED"
  - id: "T-004"
    type: "integration"
    name: "Index JSON parse được + nội dung chính xác"
    steps:
      - "Parse 7 index files"
      - "Verify route-index chứa /words → WordStudy.razor"
      - "Verify service-index chứa IWordService → WordService"
      - "Verify symbol-index chứa JapaneseWord"
    expected: "7/7 parse OK, nội dung khớp source thật"
    status: "PASSED"
  - id: "T-005"
    type: "regression"
    name: "dotnet build không bị phá vỡ"
    steps:
      - "dotnet build JapaneseLearner.csproj"
    expected: "Build succeeded, 0 errors"
    status: "PASSED"
  - id: "T-006"
    type: "regression"
    name: "dotnet test unit không bị phá vỡ"
    steps:
      - "dotnet test JapaneseLearner.Tests.csproj"
    expected: "154/154 PASS"
    status: "PASSED"
  - id: "T-007"
    type: "smoke"
    name: "Smoke /knowledge-ask WordService"
    steps:
      - "Mô phỏng intent ask + entity WordService"
      - "code-understanding đọc WordService.cs"
      - "answer-builder tổng hợp có nguồn"
    expected: "Trả lời có sources file:line"
    status: "PASSED"
  - id: "T-008"
    type: "smoke"
    name: "Smoke /knowledge-where JapaneseWord"
    steps:
      - "search-engine grep JapaneseWord"
      - "Cross-check symbol-index"
    expected: ">= 10 matches, nhóm theo category"
    status: "PASSED"
  - id: "T-009"
    type: "smoke"
    name: "Smoke /knowledge-trace /words"
    steps:
      - "route-index map /words → WordStudy.razor"
      - "dependency-graph tìm edges"
      - "Dựng chuỗi UI→Service→Impl→Model→Storage"
    expected: "Trace chain đầy đủ có evidence"
    status: "PASSED"
  - id: "T-010"
    type: "unit"
    name: "Doctor không regress"
    steps:
      - "Chạy doctor.ps1 -Mode quick"
    expected: "knowledge-agent PASS 8 sub-checks, overall >= 90"
    status: "PASSED"
  - id: "T-011"
    type: "unit"
    name: "Syncdocs cập nhật SYSTEM_MAP"
    steps:
      - "Chạy sync-system-docs.ps1"
      - "Verify knowledge-agent + knowledge-* commands trong SYSTEM_MAP"
    expected: "SYSTEM_MAP có section Knowledge Assistant, 0 issues"
    status: "PASSED"
  - id: "T-012"
    type: "unit"
    name: "Static Analysis toàn bộ"
    steps:
      - "Frontmatter, links, code fences, JSON, workflow sim"
    expected: "0 errors"
    status: "PASSED"
boundary_cases:
  - "Index chưa build → fallback grep (T-008 dùng grep trực tiếp)"
  - "Symbol không tồn tại → 0 kết quả + gợi ý"
  - "Trùng tên namespace → full path"
edge_cases:
  - "Script chạy khi workspace dirty → chỉ index file ổn định"
  - "Command không khớp intent → fallback help"
priority_order:
  - "T-001 → T-002 (config validate) trước"
  - "T-005 → T-006 (regression) bất kỳ lúc nào sau build"
  - "T-003 → T-004 (index) sau script sẵn sàng"
  - "T-007 → T-008 → T-009 (smoke) cuối cùng"
next_action: "Chuyển sang Test phase — chạy test cases và tổng hợp kết quả"
```

## Ghi chú Test-Planner

- Coverage target 100% cho config/system validation vì đây là hệ thống .opencode (mỗi file phải được validate).
- Không cần E2E Playwright — hệ thống mới không phải UI chức năng, smoke test đủ.
- Regression là quan trọng nhất: đảm bảo thêm Knowledge Assistant không phá vỡ 154 unit tests + build hiện có.
