---
name: workflow-runtime-validator
description: validator — kiểm tra Workflow Schema, duplicate phase, cycle, missing phase, dependency, output. Lỗi → workflow không chạy.
agent: general
---

# validator.md — Validator

> Kiểm tra workflow **trước khi runtime chạy** (qua compiler). Lỗi → workflow **không chạy**.

## 1. Pipeline kiểm tra

```text
Workflow Schema
      ↓
Duplicate Phase
      ↓
Cycle (loop)
      ↓
Missing Phase
      ↓
Dependency
      ↓
Output
```

## 2. Bảng kiểm tra

| # | Kiểm tra | Chi tiết | Mã lỗi |
|---|----------|----------|--------|
| 1 | Schema | hợp lệ theo workflow.schema.yaml / phase.schema.yaml | WF-001 |
| 2 | Duplicate phase | không có phase trùng id | WF-001 |
| 3 | Cycle | không có dependency vòng (loop) | WF-001 |
| 4 | Missing phase | mọi `depends_on` trỏ phase tồn tại | WF-001 |
| 5 | Entry phase | có ≥ 1 phase không dependency | WF-001 |
| 6 | Output | contract output khai báo đúng | ART-003 |
| 7 | Manifest | tương thích framework (VERSIONING.md) | WF-001 |

## 3. Ví dụ lỗi

- Phase `design` có `depends_on: [design]` (phụ thuộc chính nó) → cycle.
- `build` có `depends_on: [missing_phase]` → missing phase.
- Hai phase cùng id → duplicate.

## 4. Hai giai đoạn validate

| Giai đoạn | Khi nào | Kiểm tra |
|-----------|---------|----------|
| Compile-time | load/compiled | schema, duplicate, cycle, missing |
| Runtime | bắt đầu mỗi phase | mọi `depends_on` ở trạng thái Completed |

## 5. Chiến lược

- Lỗi compile → không tạo instance (WF-001).
- Lỗi runtime → recovery (retry/skip/abort).

## 6. Tương tác

- Gọi bởi `runtime.md` → `ValidateWorkflow(wf)`.
- Chạy trước khi `compiler.md` sinh execution plan.
- Reference: `workflow.schema.yaml`, `phase.schema.yaml`, `ERROR_HANDLING.md`.