# Failure Records

## Format

```yaml
- failure_id: BUG-{NNNN}
  task: "Mô tả task gây lỗi"
  attempts:
    - attempt: 1
      error: "Sai DI registration"
      error_hash: "a1b2c3d4e5f6"
      error_type: "DI_REGISTRATION"
  final_solution: "Mô tả solution cuối cùng"
  root_cause: "Nguyên nhân gốc"
  lesson: "Bài học rút ra"
  tags: ["blazor", "authentication"]
  reusable: true
  created_at: "2026-07-30T10:00:00Z"
  resolved_at: "2026-07-30T14:00:00Z"
```

## Quy tắc

- error_hash = SHA256(error_normalized) 12 ký tự đầu
- Dùng error_hash để search và dedup
- Mỗi failure có thể có multiple attempts
- Chỉ ghi khi có root cause xác định
