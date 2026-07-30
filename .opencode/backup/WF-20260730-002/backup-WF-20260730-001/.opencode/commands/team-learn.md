---
name: team-learn
description: "Chạy Learning Pipeline — quét failure records, auto-generate lessons và patterns, cập nhật memory. Gọi learning-agent."
trigger: learn
args: "Optional: --force (xử lý lại tất cả failures kể cả đã có lesson), --framework <name> (chỉ xử lý failures của framework cụ thể)"
output: |
  learning_report: YAML contract
---

# team-learn

## Usage

```
/team-learn [--force] [--framework <name>]
```

## Flow

1. Gọi learning-agent: truyền tham số (force, framework)
2. learning-agent quét `.opencode/memory/failures/` và xử lý
3. Tạo lessons mới trong `.opencode/memory/lessons/{framework}/`
4. Tạo/cập nhật patterns trong `.opencode/memory/patterns/`
5. Cập nhật failure records với lesson/pattern references
6. Output learning_report YAML

## Output

```yaml
status: "READY"
summary: "Đã tạo 2 lessons, 1 pattern mới"
scan:
  total_failures: 10
  processed: 3
  skipped: 7
created:
  lessons:
    - id: "LSN-BLZ-002"
      path: ".opencode/memory/lessons/blazor/LSN-BLZ-002.md"
  patterns:
    - id: "PAT-002"
      path: ".opencode/memory/patterns/PAT-002.md"
suggestions:
  - action: "update_knowledge_base"
    impact: MEDIUM
    requires_approval: true
```

## Integration

- Tự động chạy sau Bước 11b (Root Cause) khi fix thành công
- Có thể chạy standalone với `/team-learn`
- Nếu `suggestions[].requires_approval == true` → chờ user approve trước khi ghi KB
