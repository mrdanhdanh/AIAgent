---
last_updated: 2026-07-30
total_patterns: 8
migrated_from: .opencode/knowledge/patterns/common.md
category: skills/blazor
---

# Common Patterns

Các pattern phát triển đã được xác nhận và tái sử dụng.

## Cấu trúc entry

```yaml
- pattern_id: PTN-{number}
  name: "Tên pattern"
  category: "architecture | coding | testing | process"
  description: "Mô tả ngắn"
  when_to_use: "Khi nào nên dùng pattern này"
  example_workflow: "Yêu cầu gốc đã dùng pattern này"
  related_skills: ["SK-{number}"]
```

## Danh sách patterns

- pattern_id: PTN-001
  name: "Agent Registration Pattern"
  category: "process"
  description: "Khi thêm một agent mới vào Dev Agent Team, cần đăng ký trong opencode.json với đúng cấu trúc object key, kèm mode: subagent, model, và permission phù hợp với vai trò."
  when_to_use: "Khi cần thêm agent mới vào hệ thống, hoặc sửa permission/mode của agent hiện tại."
  example_workflow: "Setup Dev Agent Team - Self-Improver Agent"
  related_skills: ["SK-001"]

- pattern_id: PTN-002
  name: "Service-Interface DI Pattern"
  category: "architecture"
  description: "Tách interface (I{Name}Service) và implementation ({Name}Service), đăng ký qua DI container trong Program.cs với AddScoped, tiêm vào Razor page qua @inject directive."
  when_to_use: "Khi cần thêm business logic layer mới trong Blazor WASM app, cần khả năng mock/test, hoặc muốn tách biệt data access khỏi UI."
  example_workflow: "Thêm Word Service cho JapaneseLearner"
  related_skills: ["SK-004", "SK-007"]

- pattern_id: PTN-003
  name: "Blazor Component Tri-State Pattern"
  category: "coding"
  description: "Mỗi component có 3 trạng thái hiển thị: Loading (progress indicator), Empty (hướng dẫn/thông báo trống), Data (nội dung chính). Điều khiển qua isLoading và list.Count checks."
  when_to_use: "Khi viết Blazor component hiển thị dữ liệu từ async source (API, localStorage, database)."
  example_workflow: "Thêm Word Service cho JapaneseLearner"
  related_skills: ["SK-003"]

- pattern_id: PTN-004
  name: "Cache-First Data Access Pattern"
  category: "architecture"
  description: "In-memory cache (_cache field) kết hợp với persistence (localStorage). Khi khởi tạo: check cache → hit trả về, miss → load từ storage (fallback → seed data) → save cache. Write-through: mỗi lần write đều lưu cache + persist."
  when_to_use: "Khi cần data access layer cho Blazor WASM với localStorage backend, tránh đọc/ghi localStorage quá nhiều lần."
  example_workflow: "Thêm Word Service cho JapaneseLearner"
  related_skills: ["SK-004", "SK-006"]

- pattern_id: PTN-005
  name: "FluentUI Layout Bootstrap Pattern"
  category: "process"
  description: "Layout FluentUI app dùng 3 thành phần cốt lõi: 1) FluentDesignTheme (theme config, dark/light qua DesignThemeModes, persist qua StorageName), 2) header bar với FluentButton (Appearance.Lightweight) + FluentIcon (Icons.Regular.Size20.*), 3) FluentNavMenu chứa FluentNavLink cho navigation. Không dùng các component MudThemeProvider/MudPopoverProvider/MudLayout của framework UI cũ — project dùng FluentUI 4.14.3."
  when_to_use: "Khi tạo mới hoặc sửa layout trong dự án FluentUI Blazor WASM."
  example_workflow: "MainLayout.razor dark mode + nav drawer"
  related_skills: ["SK-002"]

- pattern_id: PTN-006
  name: "Backup-Rollback Pattern"
  category: "process"
  description: "Trước khi thực hiện thay đổi trên file cũ, tạo backup tại .opencode/backup/{workflow_id}/{file_path} kèm SHA256 hash. Lưu manifest JSON. Khi catastrophic failure (same_error >= 2, max retry, file mất), restore từ backup."
  when_to_use: "Khi workflow có step MODIFY file cũ (không chỉ CREATE). Khi thực hiện refactor lớn. Khi không chắc chắn về kết quả thay đổi."
  example_workflow: "Fix build lỗi Blazor WASM + runtime errors"
  related_skills: ["SK-011", "SK-013"]

- pattern_id: PTN-007
  name: "Same-Error Detection Pattern"
  category: "process"
  description: "Error hash được tính bằng: normalize error message (loại line number, timestamp, stack trace → lowercase) → SHA256 → lấy 12 ký tự đầu. So sánh với error_history. Nếu same_error_count >= 2 → STOP workflow, báo catastrophic failure, kích hoạt rollback."
  when_to_use: "Trong mọi workflow loop (review loop, build-fix loop, test-fix loop) để tránh retry mãi mà không tiến triển."
  example_workflow: "SKILL.md workflow orchestration (all workflows)"
  related_skills: ["SK-012"]

- pattern_id: PTN-008
  name: "State Machine Orchestration Pattern"
  category: "architecture"
  description: "Workflow được mô hình hóa như state machine với 11+ bước (Analyze → Design → Plan → Review → Backup → Build → Smoke Test → TestPlan → Test → Self-Improve → Complete). Mỗi bước có input/output contract YAML, retry tracking, và decision tree. Biến trạng thái workflow.step/step_name/status/retry duy trì xuyên suốt."
  when_to_use: "Khi thiết kế multi-agent orchestration system. Khi cần workflow có rollback, retry, và human-in-the-loop approval."
  example_workflow: "Setup Dev Agent Team - Self-Improver Agent"
  related_skills: ["SK-001", "SK-009"]
