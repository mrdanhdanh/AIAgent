---
name: workflow-runtime-kernel
description: kernel — Runtime Kernel (Phase 1.2): cung cấp 8 services thuần, không business logic. "Operating System" của framework.
agent: general
---

# kernel.md — Runtime Kernel

> "Operating System" của Agent Framework. Cung cấp **service thuần** — không business logic.

## 1. Định nghĩa

Kernel chỉ cung cấp service. Nó **không biết** AI/Agent/Skill. Business logic nằm ở lớp trên (Compiler/Executor), kernel là hạ tầng thuần.

```text
Runtime Kernel
├── Workflow Service
├── Phase Service
├── Instance Service
├── State Service
├── Recovery Service
├── Validation Service
├── Metrics Service
└── Persistence Service
```

## 2. Danh sách service

| Service | API | Trách nhiệm |
|---------|-----|-------------|
| Workflow Service | `registerDefinition`, `getDefinition` | quản lý definition, gọi repo |
| Phase Service | `getPhase`, `markCompleted`, `markFailed` | trạng thái phase |
| Instance Service | `create`, `get`, `save` | lifecycle instance |
| State Service | `transition`, `get` | state machine transition |
| Recovery Service | `apply(strategy)` | retry/rollback/skip/resume/abort/escalate |
| Validation Service | `validate(definition)`, `validate(output)` | validate compile + runtime |
| Metrics Service | `record`, `snapshot` | metric thu thập |
| Persistence Service | `load`, `store`, `archive` | lưu/đọc instance |

## 3. Kernel không có business

- Không có AI call.
- Không có agent metadata.
- Không có prompt.
- Không có workflow cụ thể (feature/bugfix...).

## 4. Ai gọi Kernel

```text
api.md → kernel → services
  ↑
sdk.md (public)
```

Kernel là tầng trung gian; core (Compiler/Scheduler/Executor) gọi qua kernel services thay vì gọi trực tiếp store/transaction.

## 5. Thành phần Kernel

```text
service
  ├── execute(call)
  └── wrap transaction + lock + metric + persist
```

Mỗi service method nên chạy trong transaction và được lock (transaction.md, lock-manager.md) để đảm bảo đúng consistency.

## 6. Tại sao tách kernel

- Tách business (core) khỏi infra (kernel) → mở rộng v5 dễ.
- Plugin/Simulation/Doctor/Dashboard dùng qua SDK.
- Test kernel độc lập (Protocol Test).

## 7. Ví dụ gọi

```text
api.CreateWorkflow() → kernel.WorkflowService.store(def) → repo.Save()
api.ExecuteWorkflow() → kernel.InstanceService.create() → scheduler → executor
```

Không module ngoài kernel gọi trực tiếp state-store/event-queue.