---
name: observability-tracing
description: Tracing — span per agent/step; trace xuyên workflow; biết thời gian mỗi bước.
agent: general
---

# Tracing

## 1. Trace model

```text
Trace (workflow)
└── Span (planner) — duration, tokens, status
└── Span (builder) — duration, tokens, status
└── Span (reviewer) — duration
└── Span (tester) — duration, coverage
```

## 2. Span fields

```yaml
span:
  id, trace_id, parent_span
  agent, capability, phase
  duration_ms, tokens, status
  error_code (nếu fail)
```

## 3. Reuse Event Lineage

- Event chain (Phase 6 lineage) = trace backbone.
- Gắn duration/tokens vào mỗi event.

## 4. Waterfall view

Dashboard hiển thị waterfall — mỗi bước thời gian + trạng thái.

## 5. Tương tác

- `events/lineage.md` — trace ID.
- `observability.schema.yaml`.
- Dashboard Timeline.