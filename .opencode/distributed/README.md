---
name: distributed-runtime
description: >
  Distributed Runtime v24.0 — chạy AIOS trên nhiều machine; event bus kết nối.
  Agent phân tán: planner (A), builder (B), tester (C).
agent: general
---

# Distributed Runtime v24.0

## 1. Vai trò

Phân tán runtime nhiều machine:

```text
Machine A → Planner
Machine B → Builder
Machine C → Tester
     Event Bus kết nối
```

## 2. Components

```text
Distributed Kernel
├── Remote Scheduler
├── Node Registry
├── Distributed Event Bus
├── Remote Artifact Sync
├── Distributed State
└── Health/Failover
```

## 3. Node roles

| Node | Vai trò |
|------|---------|
| coordinator | điều phối workflow |
| worker | chạy agent |
| storage | artifact/memory |
| observer | dashboard/observability |

## 4. Tương tác

- `distributed.schema.yaml`.
- `nodes.md`.
- `events/` (Phase 6) — event bus nối nodes.
- `artifacts/` — sync.
- `kernel/` — remote dispatch.