---
name: knowledge-graph
description: Graph — operations trên System Knowledge Graph: add/remove entity+relation, traversal, stats.
agent: general
---

# Graph

## 1. Vai trò

Lớp thao tác trên graph — thêm/xóa node + edge, traverse, thống kê.

## 2. API

| Method | Mô tả |
|--------|-------|
| `AddEntity(entity)` | thêm node |
| `AddRelation(relation)` | thêm edge |
| `RemoveEntity(id)` | xóa node + edges liên quan |
| `RemoveRelation(id)` | xóa edge |
| `GetEntity(id)` | lấy node |
| `GetRelation(id)` | lấy edge |
| `Neighbors(id)` | các node liền kề |
| `Traverse(start, depth)` | BFS từ node |

## 3. Graph structure

```text
Node (entity): { id, type, name, tags, properties }
Edge (relation): { id, type, source, target, weight }
```

## 4. Thống kê

```text
entity_count, relation_count
avg_degree = (2 × relation_count) / entity_count
by_type: { framework: 12, capability: 38, agent: 18, ... }
```

## 5. Persistence

- In-memory: hash map entity id → node; edge list.
- Persist: `graph.json` (schema graph.schema.yaml).
- Rebuild khi source thay đổi (indexer).

## 6. Tương tác

- `indexer.md` — populate graph.
- `query.md` — query layer.
- `validator.md` — check integrity.