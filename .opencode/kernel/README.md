---
name: runtime-kernel
description: >
  Runtime Kernel v14.0 — tách runtime thành kernel giống hệ điều hành.
  Scheduler, State Machine, Resource Manager, Context Manager, Event Dispatcher,
  Capability Resolver, Workflow Runtime, Recovery, Transaction.
  Mọi thứ chạy qua kernel — không module nào gọi nhau trực tiếp.
agent: general
---

# Runtime Kernel v14.0

## 1. Vai trò

Tách Runtime thành **Kernel** — trung tâm điều phối mọi hoạt động AIOS.

```text
AIOS Kernel
├── Scheduler
├── State Machine
├── Resource Manager
├── Context Manager
├── Event Dispatcher
├── Capability Resolver
├── Workflow Runtime
├── Recovery Manager
└── Transaction Manager
```

## 2. Nguyên tắc

- Mọi thứ chạy qua Kernel.
- Không module nào gọi nhau trực tiếp.
- Kernel = single entry point cho mọi hoạt động.

## 3. Kernel modules

| Module | Vai trò |
|--------|---------|
| `scheduler.md` | điều phối phase/agent |
| `state-machine.md` | transition |
| `resource-manager.md` | token/memory/time budget |
| `context-manager.md` | cấp context qua Context Engine |
| `event-dispatcher.md` | phát event |
| `capability-resolver.md` | resolve capability → agent |
| `workflow-runtime.md` | chạy workflow |
| `recovery.md` | retry/failover |
| `transaction.md` | atomic workflow |

## 4. Kernel flow

```text
Kernel.Execute(workflow)
  → Scheduler (lên lịch phase)
  → Capability Resolver (chọn agent)
  → Context Manager (cấp context)
  → Resource Manager (check budget)
  → Workflow Runtime (chạy agent)
  → Event Dispatcher (publish event)
  → State Machine (transition)
  → Recovery (nếu lỗi)
  → Transaction (commit/rollback)
```

## 5. Tương tác

- Phase 1 (Workflow Runtime) — nền tảng, kernel bao quanh.
- Phase 4 (Context) — qua Context Manager.
- Phase 6 (Event) — qua Event Dispatcher.
- Phase 17 (Model Router) — kernel quyết định model.