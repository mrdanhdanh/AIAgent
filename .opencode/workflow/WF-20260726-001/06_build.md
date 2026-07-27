# 06 — Build Report

**Workflow:** WF-20260726-001
**Step:** 6 — Build
**Agent:** builder
**Timestamp:** 2026-07-26

## Output YAML (Build)

```yaml
status: "PASS"
summary: "7/7 steps PASS — tất cả edits đã áp dụng thành công vào .opencode/agents/analyst.md"
issues:
  - severity: INFO
    category: CONSISTENCY
    description: "Cần cập nhật team-analyze.md để đồng bộ với output contract mới"
    suggestion: "Sau workflow, chạy /team-syncdocs hoặc tự cập nhật team-analyze.md"
next_action: "Chuyển sang Static Analysis"
artifacts: ["06_build.md"]
steps:
  - order: 1
    status: "PASS"
    file: ".opencode/agents/analyst.md"
    description: "TASK-001: Ràng buộc đầu vào — thêm NEED_MORE_INFO khi thiếu field"
  - order: 2
    status: "PASS"
    file: ".opencode/agents/analyst.md"
    description: "TASK-002: Assumptions — thêm vào Bước 3 + output contract"
  - order: 3
    status: "PASS"
    file: ".opencode/agents/analyst.md"
    description: "TASK-003: Evidence — thêm yêu cầu evidence vào Bước 2 + details"
  - order: 4
    status: "PASS"
    file: ".opencode/agents/analyst.md"
    description: "TASK-004: Risk levels — định nghĩa HIGH/MEDIUM/LOW"
  - order: 5
    status: "PASS"
    file: ".opencode/agents/analyst.md"
    description: "TASK-005: Task dependency — thêm depends_on + why"
  - order: 6
    status: "PASS"
    file: ".opencode/agents/analyst.md"
    description: "TASK-006: Design proposal chi tiết — approach, affected_modules, new_files, modified_files, integration_points"
  - order: 7
    status: "PASS"
    file: ".opencode/agents/analyst.md"
    description: "TASK-007: YAML safety — quy tắc YAML hợp lệ, không tab, |/>, NEED_MORE_INFO đầu"
overall: "PASS"
```
