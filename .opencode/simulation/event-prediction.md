---
name: simulation-event-prediction
description: Event Prediction — simulation sinh chuỗi event dự kiến mà không publish.
agent: general
---

# Event Prediction

## 1. Vai trò

Simulation **dự đoán** chuỗi event workflow sẽ phát (không publish thật).

## 2. Predicted chain

```text
WORKFLOW_STARTED
  → PHASE_ANALYSIS_STARTED
  → ANALYSIS_COMPLETED
  → PHASE_PLANNING_STARTED
  → PLAN_COMPLETED
  → PHASE_IMPLEMENTATION_STARTED
  → BUILD_COMPLETED
  → TEST_COMPLETED
  → WORKFLOW_COMPLETED
```

## 3. Cách tính

- Từ workflow phases + agent + artifact contract → predict event types.
- Mỗi phase → STARTED + COMPLETED.
- Agent fail (scenario) → AGENT_FAILED + RETRY.

## 4. Output

```yaml
events:
  count: 37
  predicted:
    - { order: 1, type: WORKFLOW_STARTED }
    - { order: 2, type: PHASE_STARTED }
    - { order: 3, type: PLAN_COMPLETED }
    ...
```

## 5. Không publish

- Event prediction chỉ là mô hình — không tương tác Event Bus.
- Giúp Dashboard preview timeline trước execute.

## 6. Tương tác

- `events/` — event types.
- `scenario.md` — event theo scenario.
- `report.md` — preview timeline.