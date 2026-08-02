---
name: memory-architecture
description: Kiến trúc Memory Engine — 8 memory types, store, retrieval, embedding index.
agent: general
---

# Memory Engine — Architecture

## 1. Layers

```text
Memory Engine API (write/read/search)
        │
        ▼
Memory Store (per type)
  Working · Session · Workflow · Knowledge
  Failure · User · Cache
        │
        ▼
Embedding Index (vector search)
        │
        ▼
Backends (file, local storage, vector db)
```

## 2. Write flow

```text
Agent produce memory item
  → validate (memory.schema.yaml)
  → store (per type)
  → index embedding
  → publish MEMORY_* event
```

## 3. Read flow

```text
Retrieve(query, type, scope)
  → exact match (store)
  → semantic (embedding index)
  → rank + return top K
```

## 4. Context Engine relation

- Context Engine dùng **Working + Cache** memory.
- Context = projection của memory cho 1 task.

## 5. Tương tác

- `memory.schema.yaml`.
- `embedding-index.md`.
- `knowledge/` + `memory/` — migrate vào.
- `knowledge-graph/` (Phase 9) — knowledge nodes.