---
name: context-provider-task
description: Task Provider — cung cấp Task Context: goal, requirements, acceptance, constraints.
agent: general
---

# Task Provider

## 1. Vai trò

Quan trọng nhất (score 100). Cung cấp mục tiêu, yêu cầu, tiêu chí chấp nhận, ràng buộc của công việc hiện tại.

## 2. Nguồn

| type | nguồn |
|------|-------|
| workflow.task | câu hỏi/spec từ caller |
| artifacts.requirement | phân tích (analysis.requirement output) |
| prompt | khai báo trực tiếp |

| type | nguồn |
|------|-------|
| workflow.task | câu hỏi/spec từ caller |
| artifacts.requirement | phân tích (analysis.requirement output) |
| prompt | khai báo trực tiếp |

## 3. Interface

- `discover()`: lấy task object từ workflow state.
- `resolve()`: fill goal/requirements/acceptance/constraints.
- `size()`: token of task block.
- `validate()`: `goal` không rỗng (bắt buộc).

## 4. Output chunk

```
task:
  goal: "Thêm dark mode toggle cho page"
  requirements: [...]
  acceptance: ["dark theme persisted in localStorage"]
  constraints: ["FluentUI, WASM, .NET10"]
```

## 5. Điểm không bị compress

Task luôn **required**, Engine không loại bỏ khi budget hẹp.

## 6. Tương tác

- Intelligence Layer: task score=100 → giữ.
- Resolver: đọc `requires_context: [goal, task]` của planner.