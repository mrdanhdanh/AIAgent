---
name: model-router
description: >
  Model Router v17.0 — runtime quyết định model, không phải agent.
  Planner → Capability → Router → GPT/Claude/Gemini/Qwen/DeepSeek/Local LLM.
agent: general
---

# Model Router v17.0

## 1. Vai trò

Agent không khai báo model cứng. **Runtime quyết định model** qua Router.

```text
Planner → Capability → Router → Model
```

## 2. Router factors

| Factor | Mô tả |
|--------|-------|
| token | độ dài context |
| cost | budget còn lại |
| difficulty | độ phức tạp task |
| latency | yêu cầu thời gian |
| policy | model policy |
| availability | model khả dụng |

## 3. Model pool

```text
GPT-5 · Claude · Gemini · Qwen · DeepSeek · Local LLM
```

## 4. Routing decision

```text
task (capability, context size, budget)
  → policy check (model policy)
  → score models (cost, latency, quality)
  → pick best
  → fallback nếu không available
```

## 5. Tương tác

- `model-router.schema.yaml`.
- `models.yaml` — model catalog.
- `resources/` (Phase 16) — cost budget.
- `kernel/` — router trong kernel.