---
name: multi-workspace
description: >
  Multi Workspace v23.0 — nhiều workspace chung một runtime. Mỗi workspace có registry/context/artifact riêng.
agent: general
---

# Multi Workspace v23.0

## 1. Vai trò

Hỗ trợ nhiều workspace (project) chạy trên **chung Runtime**.

```text
Workspace A ──┐
Workspace B ──┼── Shared Runtime
Workspace C ──┘
```

## 2. Isolated per workspace

| Component | Scope |
|-----------|-------|
| Registry | riêng (plugin/capability per workspace) |
| Context | riêng (profile, budget) |
| Artifacts | riêng |
| Memory | riêng (working/session) |
| Knowledge | chia sẻ hoặc riêng |
| Workflows | riêng |

## 3. Shared

- Kernel + Runtime.
- Event Bus (workspace-scoped events).
- Doctor/Evolution (aggregate).
- Resources (shared budget pool).

## 4. Tương tác

- `workspaces.schema.yaml`.
- `workspace-manager.md`.
- `kernel/` — shared runtime.
- `resources/` — shared budget.