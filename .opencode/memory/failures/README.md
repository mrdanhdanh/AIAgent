# Failure Records

## Format (frontmatter YAML — schema thật, KHÔNG phải list)

```yaml
---
failure_id: BUG-{NNNN}
task: "Mô tả task gây lỗi"
attempts:
  - attempt: 1
    error: "Error message gốc"
    error_hash: "{16-hex SHA256(error_normalized) | legacy-slug}"
    error_type: "{enum trong contract failure-agent v2}"
error_detail: "slug ≤6 từ (optional)"
final_solution: "Mô tả solution cuối cùng"
root_cause: "Nguyên nhân gốc"
lesson_id: "LSN-{XXX}-{NNN}"
pattern_id: "PAT-{NNN}"
lesson: "Bài học rút ra"
tags: ["blazor", "authentication"]
reusable: true
created_at: "ISO8601"
resolved_at: "ISO8601"
---
```

## Quy tắc

- `error_hash` = **SHA256(error_normalized) 16 hex đầu** — tính bằng `.opencode/scripts/failure-analyzer.ps1`, KHÔNG tự đoán
- Records cũ (BUG-0001..3) dùng legacy slug — giữ nguyên, match qua `error_type` + `tags`
- Dùng `error_hash` + `error_type` + `tags` để search và dedup (xem failure-agent v2)
- Mỗi failure có thể có multiple attempts
- Chỉ ghi khi có root cause xác định — **do `learning-agent` ghi** (failure-agent edit:deny)
