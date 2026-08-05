---
name: doctor-rule-engine
description: Rule Engine — quy tắc kiểm tra động (rules.yaml), plugin đăng ký thêm rule, không sửa code.
agent: general
---

# Doctor Rule Engine

## 1. Vai trò

Thay vì hard-code luật kiểm tra → dùng **rules.yaml**. Thêm rule mới không cần sửa code.

## 2. Rule format

```yaml
id: CTX-001
category: context
severity: warning
condition: average_context_tokens > 8000
recommendation: enable_context_compression
```

## 3. Rule fields

| Field | Mô tả |
|-------|-------|
| id | unique |
| category | group (context/registry/agent...) |
| severity | info/warning/critical |
| condition | biểu thức kiểm tra |
| recommendation | đề xuất khi match |
| penalty | điểm trừ (scoring) |

## 4. Rule evaluation

```text
for each rule in rules.yaml:
  evaluate condition with data
  if match → record issue + apply penalty
```

## 5. Lợi ích

- Bổ sung quy tắc không sửa code.
- Plugin tự đăng ký rule (Phase 11).
- Doctor + Evolution Engine dùng chung bộ rule.

## 6. Tương tác

- `rules/rules.yaml` — rule definitions.
- `scoring/scores.md` — penalty.
- `reports/` — issue list.