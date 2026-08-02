---
name: workflow-runtime-architecture
description: ARCHITECTURE — kiến trúc Runtime Core (Phase 1.1–1.15): Runtime chỉ quản lý Execution, không biết AI/Agent/Prompt/Skill.
agent: general
---

# ARCHITECTURE.md — Runtime Core

> Kiến trúc nội bộ của Workflow Runtime (Phase 1.1–1.15). Chỉ quản lý **Execution**.

## 1. Nguyên tắc Root

Runtime **không biết**:

```text
AI · Agent · Prompt · Skill
```

Chỉ biết:

```text
Workflow · Phase · State · Contract · Artifact
```

Điều này cho phép v5 (multiple frameworks chạy trên một Runtime), plugin, simulation.

## 2. Sơ đồ tổng thể (Phase 1.1)

```text
               Workflow Runtime
                    │
        ┌───────────┼───────────┐
        │           │           │
   Compiler     Scheduler    Executor
        │           │           │
        └───────────┼───────────┘
                    │
              Runtime Kernel
                    │
     ┌─────────┬────┴─────┬─────────┐
     │         │          │         │
State Store  Artifact  Event Queue
             Store
```

## 3. Phân tầng module

| Tầng | Module | Trách nhiệm |
|------|--------|-------------|
| Điều phối | `runtime.md`, `api.md`, `sdk.md` | lối vào, orchestrator |
| Compile | `compiler.md`, `loader.md`, `validator.md` | workflow.yaml → compiled.workflow.json |
| Execution | `scheduler.md`, `executor.md`, `dispatcher.md` | chạy phase theo plan |
| Kernel services | `kernel.md` | 8 dịch vụ thuần, không business |
| Hạ tầng | `state-store.md`, `artifact-store`, `event-queue`, `repository.md`, `persistence.md` | lưu trữ, repo abstraction |
| Quản trị | `transaction.md`, `lock-manager.md`, `recovery.md`, `metrics.md`, `health.md` | consistency, phục hồi, quan sát |

## 3. Runtime Kernel (Phase 1.2)

Kernel chỉ **cung cấp service**, không business logic:

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

## 4. Dòng dữ liệu

```text
workflow.yaml
   ↓ compile
compiled.workflow.json     (compile 1 lần, chạy nhiều)
   ↓
Execution Plan (DAG + order)
   ↓
Runtime chạy phase theo plan, mỗi phase qua transaction+lock
   ↓
Phase completed → artifact → state update → schedule next
```

## 5. Runtime chỉ biết Execution

- **Compiler** biến definition → plan.
- **Scheduler** chọn phase kế.
- **Executor** chạy phase (qua dispatcher adapter).
- **Kernel** cung cấp service để executor gọi.
- **Stores** lưu state/artifact/event an toàn.

Không module nào chứa tên `Planner`/`Builder` hoặc prompt.

## 6. Mở rộng v5

- Phase DAG → Parallel Execution (v5) ngay từ bây giờ compiler sinh DAG.
- Repository abstraction → File → Database → Cloud không sửa Runtime.
- SDK → Plugin/Simulation/Doctor/Dashboard dùng SDK, không truy cập Kernel trực tiếp.

## 7. Non-architectural quyết định

Chi tiết từng module ở file tương ứng trong thư mục này.