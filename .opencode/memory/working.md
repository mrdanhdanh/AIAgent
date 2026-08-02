---
name: memory-working
description: Working + Session Memory — bộ nhớ ngắn hạn cho task/session.
agent: general
---

# Working & Session Memory

## 1. Working Memory

- Context của task hiện tại (goal, state, artifacts ref).
- TTL: task end.
- Nguồn: Context Engine (Phase 4).

## 2. Session Memory

- Trạng thái phiên làm việc (conversation, decisions).
- TTL: session end.
- Giúp agent nhớ quyết định trước đó.

## 3. Format

```yaml
working:
  task_id, goal, phase, artifacts: [], context_ref
session:
  session_id, decisions: [], history: []
```

## 4. Tương tác

- `context/` (Phase 4) — tạo working memory.
- `memory.schema.yaml`.