---
name: context-provider-runtime
description: Runtime Provider — cung cấp retry, warnings, execution time, budget.
agent: general
---

# Runtime Provider

## 1. Vai trò

Cung cấp thông tin execution đã biết để agent quyết định hành vi (retry, budget).

## 2. Nguồn

- Workflow runtime state (retry, execution_time).
- Đo lường từ metrics.

## 3. Output chunk

```
runtime:
  retry: 1
  warnings: ["edge case LDP-3"]
  execution_time: 4120
  budget_remaining: 3
```

## 4. Điểm thấp

Runtime chỉ cần khi agent cần biết budget/retry. Không gửi nếu không có warning + retry.

## 5. Compress

Runtime có score (50) → trung bình; giữ ngắn gọn.

## 6. Tương tác

- Metrics lưu delivery_time (xem metrics/).
- Profile: thường không bắt buộc.