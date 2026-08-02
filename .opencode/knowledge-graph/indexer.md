---
name: knowledge-indexer
description: Indexer — scan sources, extract entities, build relations, validate, persist graph.
agent: general
---

# Indexer

## 1. Vai trò

Pipeline scan → graph. Biến mọi source thành Entity + Relation.

## 2. Pipeline

```text
Scan sources
  (knowledge/, memory/, workflows/, contracts/, artifacts/, registry/)
    ↓
Extract entities (15 types)
    ↓
Build relations (12 types)
    ↓
Validate (broken link, cycle, duplicate, orphan)
    ↓
Persist graph.json
    ↓
Update stats
```

## 3. Input sources

| Source | Format |
|--------|--------|
| registry/*.yaml | YAML |
| agents/metadata/*.yaml | YAML |
| skills/*/SKILL.md | Markdown |
| workflows/definitions/*.yaml | YAML |
| artifacts/*.yaml | YAML |
| knowledge/**/*.md | Markdown |
| memory/*.json | JSON |
| contracts/*.yaml | YAML |

## 4. Incremental vs full

- **Full rebuild**: khi source đổi lớn.
- **Incremental**: theo file mtime/hash — chỉ cập nhật phần thay đổi.

## 5. Output

- `graph.json` (schema graph.schema.yaml).
- Stats: entity_count, relation_count, by_type, avg_degree.
- Report: danh sách entity/relation mới.

## 6. Tương tác

- `entities.md` — extraction rules.
- `relations.md` — build rules.
- `validator.md` — validate trước persist.
- CLI: `/knowledge-index` (reuse) + `knowledge-graph-indexer.ps1`.