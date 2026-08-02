---
name: workflow-runtime-readme
description: README — mục lục và tổng quan Workflow Runtime (Phase 1). Core framework chuyển workflow từ Prompt-driven sang Runtime-driven.
agent: general
---

# Workflow Runtime — Phase 1

> Core framework. Biến Workflow từ **Prompt-driven** thành **Runtime-driven**.

## 1. Vị trí

- **Phase**: 1 (Workflow Runtime)
- **Kiến trúc**: tuân theo `architecture/ARCHITECTURE.md`, `architecture/DATA_MODEL.md`
- **Thư mục**: `.opencode/workflow-runtime/`
- **Definitions**: `.opencode/workflow/definitions/`

## 2. Triết lý

Workflow Runtime **không biết Planner/Builder/Tester là gì**. Nó chỉ biết:

```text
Workflow → Phase → State → Contract → Artifact
```

Biến đổi thiết kế:

| Trước (Prompt-driven) | Sau (Runtime-driven) |
|-----------------------|----------------------|
| /team → Prompt → Planner → Builder → Reviewer | /team → Runtime → Definition → Instance → Executor → Agent → Artifact |

## 3. Kiến trúc

```text
                User
                 │
              Command
                 │
        ┌─ Workflow Runtime ───────┐
        │  Loader  Validator  Scheduler │
        └────────────┼──────────────┘
                 │
             Phase Executor
                 │
            Agent Dispatcher
                 │
            Output Artifact
                 │
          Workflow Instance
```

## 4. Mục lục

| File | Nội dung |
|------|----------|
| `runtime.md` | Thành phần trung tâm, API, event, metric, test |
| `loader.md` | Thành phần 3 — Loader (parse → validate → object) |
| `validator.md` | Thành phần 4 — Validator (schema/cycle/dependency/output) |
| `scheduler.md` | Thành phần 5 — Scheduler (phase nào chạy tiếp) |
| `dispatcher.md` | Thành phần 6 — Dispatcher (gọi Agent; Phase 2 thay bằng Capability Resolver) |
| `executor.md` | Thành phần 7 — Executor (vòng chạy instance) |
| `recovery.md` | Thành phần 8 — Recovery (retry/rollback/skip/abort) |
| `persistence.md` | Thành phần 9 — Persistence (instance/history/state/log) |
| `state-machine.md` | State machine Workflow + Phase |
| `compiler.md` | Workflow Compiler (2 thành phần bổ sung) |
| `workflow.schema.yaml` | Schema workflow definition |
| `phase.schema.yaml` | Schema phase |
| `instance.schema.yaml` | Schema workflow instance |

## 5. Pipeline biên dịch

```text
workflow.yaml
    ▼
Workflow Compiler  (validate schema, giải dependency, DAG, detect cycle, sinh execution plan)
    ▼
Compiled Workflow
    ▼
Workflow Runtime
```

Runtime chỉ thực thi, không phân tích lại workflow mỗi lần.

## 6. Phụ thuộc phase sau

- **Phase 2** (Capability Registry) → thay `dispatcher.md` bằng Capability Resolver.
- **Phase 4** (Context), **Phase 5** (Artifact), **Phase 6** (Event), **Phase 8** (Diagnostics/Doctor) → đọc/ghi qua Runtime API.
- **Phase 12** (Dashboard) → đọc persistence.