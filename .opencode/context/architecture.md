---
name: context-architecture
description: architecture — kiến trúc Context Engine: modules, layers, data flow, context package contract.
agent: general
---

# Context Engine — Architecture

## 1. Layer

```text
┌─────────────────────────────────────────────┐
│                    UI / Workflow             │
│                    (caller)                 │
├─────────────────────────────────────────────┤
│         Context Engine (orchestrator)       │
│  Discover → Filter → Resolve → Rank → De-   │
│  duplicate → Compress → Validate → Package   │
├───────────────┬──────────────┬──────────────┤
│  Providers    │  Resolver    │  Validator    │
│  (5)          │              │              │
├───────────────┴──────────────┴──────────────┤
│  Cache / Index / Metrics                    │
├─────────────────────────────────────────────┤
│  Project · Knowledge · Memory · Workflow ·  │
│  Artifacts  (nguồn dữ liệu)                │
└─────────────────────────────────────────────┘
```

## 2. Module

| Module | Thư mục | Vai trò |
|--------|---------|---------|
| Discover | `providers/` | liệt kê nguồn khả dụng, không load |
| Filter | `resolver/` | loại nguồn không cần (forbidden/irrelevant) |
| Resolve | `resolver/` | khớp agent metadata → provider |
| Rank | `intelligence/` | chấm điểm giá trị context |
| Deduplicate | `compression/` | gộp nội dung trùng |
| Compress | `compression/` | tóm tắt/token budget |
| Validate | `validator/` | check thiếu required → error |
| Package | `builder/` | sinh Context Package object |

## 3. Context Package (output contract)

```yaml
context:
  version: "4.0"
  agent: planner
  created_at: ISO8601
  budget: { limit: 12000, used: 11000 }
  package:
    project:   { ... }
    workflow:  { phase, state }
    task:      { goal, requirements, acceptance, constraints }
    artifacts: { plan: {...}, ... }
    knowledge: [ ... ]
    memory:    [ ... ]
    runtime:   { retry, execution_time, ... }
```

## 4. Nguyên tắc

- Engine **không gọi LLM** để sinh context (trừ Compress tùy chọn).
- Mỗi bước module độc lập, có thể test riêng.
- Plugin (Phase 11) thêm nguồn bằng cách cấp thêm **Provider**.

## 5. Data flow

1. Caller gọi `Engine.Resolve(agent, workflowState)`.
2. Discover: truy vấn provider → danh sách candidate.
3. Resolve + Filter: khớp metadata, loại forbidden.
4. Intelligence: chấm score từng context.
5. Deduplicate + Compress: trong budget.
6. Validate: đủ required.
7. Package: Build Context Package → Deliver.

## 6. Tương tác

- `pipeline.md` (chi tiết từng bước)
- `profiles/` (định nghĩa required/optional/forbidden per agent)
- `schemas/` (context package contract)
- `metrics/` (token, cache hit, delivery time)