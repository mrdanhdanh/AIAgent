---
name: context-builder
description: builder — sinh Context Package object từ các context đã resolve + validate.
agent: general
---

# Context Builder

## 1. Vai trò

Bước **Package** — sinh object Context Package đúng `schemas/context.schema.yaml`, không gọi LLM trừ compress.

## 2. Input → Output

```text
candidates (resolved + filtered + ranked)
        ↓
Context Builder
        ↓
Context Package (yaml/json)
```

## 3. Thứ tự build

1. Bắt đầu với header: version, agent_id, budget.
2. Fill từng section: project / workflow / task / artifacts / knowledge / memory / runtime.
3. Chỉ fill section có dữ liệu (không thêm rỗng).
4. Assemble casing JSON object.

## 4. Validation tại build

- Đảm bảo `task.goal` present.
- Đủ `required` trong profile → thiếu được đánh dấu `missing` để validator xử lý.
- Track `budget.used` (ước tính token đã gom).

## 5. Đầu ra

Package là plain object (không method). Agent nhận & dùng trực tiếp.

## 6. Logging

- Ghi delivery: size (token), sections count, execution time (metrics/).

## 7. Tương tác

- `validator/` chạy TRƯỚC `builder` finalize (hoặc builder gọi validator).
- `compression/` đã giảm size trước khi build nếu cần.