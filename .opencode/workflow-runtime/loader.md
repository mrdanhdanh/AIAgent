---
name: workflow-runtime-loader
description: loader — Thành phần 1: Load Workflow Definition (yaml → parse → object). Không chạy workflow.
agent: general
---

# loader.md — Loader

> Thành phần 1. Chỉ nạp dữ liệu, không chạy workflow.

```text
workflow.yaml
    ↓
 Parse YAML
    ↓
 Validate (cơ bản)
    ↓
Workflow Object
```

## 1. Công việc

| Bước | Mô tả |
|------|-------|
| Parse | đọc definition yaml → object |
| Map field | id/version/description/phases/variables/contracts/metadata |
| Validate cơ bản | yaml hợp lệ, đủ `id`, `phases` |
| Output | WorkflowDefinition object (đã sẵn sàng cho compiler) |

## 2. Không làm

- Không chạy phase.
- Không gọi agent.
- Không validate sâu (dependency/cycle → validator.md).

## 3. Input

- `id` của workflow (tra cứu file trong `.opencode/workflow/definitions/`)
- Hoặc đường dẫn file trực tiếp.

## 4. Output

`WorkflowDefinition`:

| Field | Type | Bắt buộc |
|-------|------|----------|
| id | string | ✅ |
| version | int/string | ✅ |
| description | string | ❌ |
| phases | PhaseRef[] | ✅ (≥1) |
| variables | map | ❌ |
| contracts | Contract[] | ❌ |
| metadata | map | ❌ |

## 5. Lỗi

| Lỗi | Mã | Xử lý |
|-----|-----|-------|
| File không tồn tại | WF-002 | báo, không tạo instance |
| YAML sai cú pháp | WF-001 | báo |
| Thiếu field bắt buộc | CFG-001 | báo |

## 6. Tương tác

- Gọi bởi `runtime.md` → `LoadWorkflow(id)`.
- Output đưa cho `validator.md` / `compiler.md`.