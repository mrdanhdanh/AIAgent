---
name: workflow-runtime-compiler
description: compiler — Workflow Compiler (bổ sung): validate schema, resolve dependency, build DAG, detect cycle, sinh execution plan. Runtime chỉ thực thi.
agent: planner
---

# compiler.md — Workflow Compiler

> Thành phần bổ sung. Runtime không phân tích lại workflow mỗi lần — compiler làm trước.

## 1. Pipeline compile

```text
workflow.yaml
        ↓
Workflow Compiler
   ├── Validate schema
   ├── Resolve dependency
   ├── Build DAG
   ├── Detect cycle
   └── Generate execution plan
        ↓
Compiled Workflow
        ↓
Workflow Runtime (thực thi)
```

## 2. Output: Compiled Workflow

| Trường | Nguồn |
|--------|-------|
| id, version | definition |
| DAG | dependency graph đã build |
| execution_plan | thứ tự phase tối ưu |
| cycle_free | DAG xích tố, đã detect |
| manifest_compat | framework version hợp lệ |

## 3. Khác nhau Runtime vs Compiler

| Compiler (lúc load) | Runtime (mỗi phase) |
|---------------------|---------------------|
| build DAG | chọn phase kế (scheduler) |
| detect cycle 1 lần | validate dependency Completed |
| sinh plan | thực thi |

→ Runtime không chứa logic DAG/cycle, đọc plan đã có.

## 4. Manifest → threshold check

Trước khi compile, compiler kiểm tra `manifest`:

- `schema` đúng `workflow.v1`.
- `minimum_framework_version` ≤ framework hiện tại.
- `required_components` có mặt.
- Không hợp → từ chối (WF-001).

## 5. Execution Plan

```text
[analyze, design, review, backup, build, test, complete]  # với depends_on xét
```

Compiler sắp xếp topological: phase nào đủ dependency đứng trước.

## 6. Tương tác

- Chạy sau `loader.md`, trước `validator.md` chạy kiểm tra sâu (hoặc compiler tự, dùng validator).
- Output đưa cho `runtime.md` → CreateInstance.
- Reference: `workflow.schema.yaml`, manifest (xem workflow definitions).