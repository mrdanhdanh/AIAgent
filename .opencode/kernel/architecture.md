---
name: kernel-architecture
description: Kiến trúc Kernel — layers, kernel modules, data flow, single entry point.
agent: general
---

# Kernel — Architecture

## 1. Layers

```text
┌────────────────────────────────────┐
│       Kernel API (single entry)    │
│  Execute · Inspect · Control        │
├────────────────────────────────────┤
│       Kernel Core                   │
│  Scheduler · State Machine ·        │
│  Resource Manager · Recovery ·      │
│  Transaction                        │
├────────────────────────────────────┤
│       Kernel Integrations           │
│  Context Manager · Event Dispatcher │
│  Capability Resolver · Model Router │
├────────────────────────────────────┤
│       Domain Modules                │
│  Workflow Runtime · Agents          │
└────────────────────────────────────┘
```

## 2. Single entry point

Mọi hoạt động (execute, inspect, control) qua `Kernel.Execute()`:
- Validate.
- Check policy/resource.
- Dispatch.
- Track state.
- Publish event.
- Recovery nếu fail.

## 3. Kernel vs Workflow Runtime

| | Kernel | Workflow Runtime (P1) |
|--|--------|----------------------|
| Phạm vi | toàn AIOS | chỉ workflow |
| Scheduling | mọi task | phase |
| Resource | budget check | — |
| Policy | check | — |
| Model | router | — |

Kernel bao quanh + mở rộng Runtime.

## 4. Kernel state

```text
KernelState:
  active_tasks: []
  resources: { tokens, memory, time }
  events: [] (recent)
```

## 5. Tương tác

- `scheduler.md`, `resource-manager.md`, `recovery.md`, `transaction.md`.
- `context-manager.md`, `event-dispatcher.md`, `capability-resolver.md`.
- `workflow-runtime.md` — domain module.