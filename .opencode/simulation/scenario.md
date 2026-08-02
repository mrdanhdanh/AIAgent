---
name: simulation-scenario
description: Scenario Engine — chạy nhiều kịch bản (success/retry/abort/rollback) để đánh giá workflow.
agent: general
---

# Scenario Engine

## 1. Khái niệm

Scenario = một **nhánh** của workflow. Multi-scenario simulation đánh giá nhiều khả năng.

## 2. Scenario types

| Scenario | Mô tả |
|----------|-------|
| Success | mọi step OK |
| Retry | agent fail → retry → success |
| Abort | agent fail hết retry → abort |
| Rollback | artifact conflict → rollback |
| Timeout | agent timeout → fail |

## 3. Ví dụ (Builder phase)

```text
Scenario A: Builder OK      → Complete
Scenario B: Builder Fail    → Retry (2) → Complete
Scenario C: Builder Timeout → Abort
Scenario D: Builder Fail × 3 → Disabled → Rollback
```

## 4. Multi-scenario

```text
Workflow
    │
  ┌─┼─┐
  A B C
  │ │ │
Suc Retry Abort
```

Mỗi scenario → riêng risk + confidence → tổng hợp.

## 5. Output

```yaml
scenarios:
  - { id: A, outcome: success, risk: 5,  confidence: 98 }
  - { id: B, outcome: retry,  risk: 30, confidence: 88 }
  - { id: C, outcome: abort,  risk: 65, confidence: 60 }
```

## 6. Lợi ích

- Doctor biết điểm yếu workflow trước khi dùng.
- Evolution (Phase 10) dùng kết quả đề xuất cải tiến.

## 7. Tương tác

- `simulator.md` — chạy scenarios.
- `risk-engine.md` — risk per scenario.
- `confidence.md` — confidence per scenario.