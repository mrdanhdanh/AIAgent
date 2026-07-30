# Blazor Lessons from Failures

Kế thừa từ `.opencode/knowledge/lessons.md` nhưng tập trung vào bài học từ lỗi.

## Format

```yaml
- lesson_id: LSN-BLZ-{NNN}
  failure_id: "BUG-XXXX"
  error_hash: "a1b2c3d4e5f6"
  rule: "Quy tắc cần nhớ"
  applies_to: ["service", "component", "test"]
  tags: ["blazor", "wasm", "di"]
```

## Reference

Liên kết failure_id → lesson_id qua error_hash.
