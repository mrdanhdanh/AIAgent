---
name: sdk-workflow
description: Workflow SDK — chạy/pause/resume/stop/replay workflow + simulation.
agent: general
---

# Workflow SDK

## 1. Vai trò

Giao diện điều khiển workflow.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Workflow.Start(def, inputs)` | chạy workflow |
| `Workflow.Pause(id)` | tạm dừng |
| `Workflow.Resume(id)` | tiếp tục |
| `Workflow.Stop(id)` | dừng |
| `Workflow.Replay(id)` | replay từ history |
| `Workflow.GetState(id)` | trạng thái |
| `Workflow.Simulate(def)` | simulation trước |

## 3. DTO

```yaml
WorkflowState:
  id, phase, state, retry, variables
```

## 4. Permission

- Start/Replay: `workflow.execute`.
- Pause/Resume/Stop: `workflow.execute` (operator+).
- Simulate: `simulation.run`.

## 5. Tương tác

- `workflow-runtime/` (Phase 1).
- `simulation/` (Phase 7).
- Dashboard control dùng workflow-sdk.