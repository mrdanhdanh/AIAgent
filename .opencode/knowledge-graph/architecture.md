---
name: knowledge-graph-architecture
description: Kiến trúc System Knowledge Graph — indexer, extractor, relation builder, integration với AIOS components.
agent: general
---

# System Knowledge Graph — Architecture

## 1. Layers

```text
┌──────────────────────────────────────┐
│          Knowledge Sources            │
│  knowledge/ memory/ workflows/        │
│  contracts/ artifacts/ registry/      │
├──────────────────────────────────────┤
│          Knowledge Indexer            │
│  scan → extract → build relations     │
├──────────────────────────────────────┤
│          System Knowledge Graph       │
│  Entities + Relations (in-memory)     │
│  persisted: graph.json                │
├──────────────────────────────────────┤
│  Query Engine · Ranking · Validator   │
├──────────────────────────────────────┤
│  Context · Doctor · Dashboard ·       │
│  Simulation · Evolution · Plugin      │
└──────────────────────────────────────┘
```

## 2. Data flow

```text
Scan sources
  → extract entities (entity types)
  → build relations (relation types)
  → validate (broken link, cycle, duplicate)
  → persist graph.json
  → serve queries (O(1)/indexed)
```

## 3. Sources → Entity types

| Source | Entity types |
|--------|--------------|
| registry/capabilities.yaml | capability |
| agents/metadata/*.yaml | agent |
| skills/*/SKILL.md | skill |
| commands/*.md | command |
| contracts/*.yaml | contract |
| workflows/definitions/*.yaml | workflow, phase |
| artifacts/*.yaml | artifact |
| knowledge/**/*.md | lesson, pattern, framework, language |
| memory/failure-records | failure |
| docs/rules | rule |

## 4. Graph = Source of Truth

- Graph phản ánh trạng thái thực của framework.
- Mọi module query graph thay vì scan file.
- Graph rebuild khi source thay đổi (indexer).

## 5. Integration

| Module | Truy vấn |
|--------|----------|
| Context Engine | Related(agent), TopK(knowledge) |
| Doctor | orphan entities, coverage |
| Dashboard | full graph viz |
| Simulation | dependency graph |
| Evolution | impact analysis |
| Plugin | add entity + relation |

## 6. Tương tác

- `indexer.md` — rebuild pipeline.
- `query.md` — query API.
- `graph.md` — operations.
- Phase 2-8 registries/artifacts — nguồn dữ liệu.