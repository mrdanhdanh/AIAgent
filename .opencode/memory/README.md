---
name: memory-engine
description: >
  Memory Engine v19.0 — thống nhất knowledge/ + memory/ thành một engine 8 loại.
  Context Engine chỉ là một phần của Memory.
agent: general
---

# Memory Engine v19.0

## 1. Vai trò

Thống nhất bộ nhớ:

```text
Memory Engine
├── Working Memory
├── Session Memory
├── Workflow Memory
├── Knowledge Memory
├── Failure Memory
├── User Memory
├── Cache
└── Embedding Index
```

Context Engine chỉ là một phần của Memory (Working + Cache).

## 2. Memory types

| Type | Scope | TTL |
|------|-------|-----|
| Working | task hiện tại | task end |
| Session | phiên làm việc | session end |
| Workflow | workflow instance | workflow end |
| Knowledge | lessons/patterns | vĩnh viễn |
| Failure | failure records | vĩnh viễn |
| User | preferences | dài hạn |
| Cache | context/artifact | TTL |
| Embedding | vector index | vĩnh viễn |

## 3. Tương tác

- `memory.schema.yaml`.
- `working.md`, `knowledge.md`, `failure.md`, `cache.md`.
- `context/` (Phase 4) — working/cache.
- `knowledge-graph/` (Phase 9) — knowledge memory.
- `knowledge/` + `memory/` hiện có — merge vào engine.