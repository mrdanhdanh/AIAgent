---
name: context-engine
description: >
  Context Engine v4.0 — "RAM" của framework. Agent không tự đọc project; nhận Context Package.
  Pipeline: Discover → Filter → Resolve → Rank → Deduplicate → Compress → Validate → Package → Deliver.
  Tích hợp Context Intelligence Layer (chấm điểm giá trị từng context), Budget, Cache, Diff, Index.
agent: general
---

# Context Engine v4.0

## 1. Vai trò

Nếu Workflow Runtime là CPU thì Context Engine là **RAM**.

> Agent không còn tự đọc Project. Agent chỉ nhận **một Context Package**.

```text
Project / Knowledge / Memory / Workflow / Artifacts
        │
        ▼
     Context Engine
        │
        ▼
    Context Package
        │
        ▼
      Agent
```

## 2. Kiến trúc

```text
                Context Engine
                       │
        ┌──────────────┼──────────────┐
        │              │              │
    Discover        Resolver      Validator
        │              │              │
        └──────────────┼──────────────┘
                       │
                 Context Builder
                       │
                 Context Package
                       │
                      Agent
```

## 3. Tư tưởng cốt lõi

> Context Engine **không đọc tất cả**.

Nó trả lời: **"Agent này cần gì?"** — không phải "Project có gì?".

## 4. Tư duy chi phí

- **Token**: chỉ giao context giá trị cao nhất.
- **Tốc độ**: cache → không đọc lại.
- **Chất lượng**: context đúng trọng tâm → response tốt hơn.

## 5. Trạng thái

Phase 4 — Context Engine. Chi tiết: `architecture.md`, `pipeline.md`, `profiles/`, `schemas/`, `cache/`, `compression/`, `metrics/`, `tests/`.

## 6. Tương tác

- `agents/metadata/*.yaml` (required_context/forbidden_context/contracts) → nguồn Resolver.
- Workflow Runtime state → Workflow Context.
- Phase 5 (Artifact Store) → Artifact Context Provider.
- Phase 8 (Doctor) → đọc metrics context.