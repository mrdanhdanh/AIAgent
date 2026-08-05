---
name: knowledge-query
description: Query — API truy vấn graph; không scan file.
agent: general
---

# Query Engine

## 1. Vai trò

Agent/module hỏi graph — **không tìm file**.

```text
Agent hỏi "Blazor lifecycle"
  → Query graph → Top K entities
```

## 2. Query API

| API | Mô tả |
|-----|-------|
| `Find(id)` | tìm entity by id |
| `Search(term)` | tìm entity theo tên/tag |
| `Related(id)` | các entity liên quan (neighbors) |
| `DependsOn(id)` | các entity phụ thuộc |
| `Consumers(id)` | ai tiêu thụ entity này |
| `Producers(id)` | ai tạo entity này |
| `Neighbors(id)` | node liền kề |
| `TopK(term, k)` | top K theo ranking |

## 3. Search

```text
Search("blazor") → [ENT-blazor, ENT-blazor-component, ...]
```

Match: name, tags, type, description.

## 4. Graph query example

```text
Consumers(ENT-builder)
  → [ENT-plan] (builder consumes plan)

DependsOn(ENT-testing.e2e)
  → [ENT-implementation.code] (e2e requires code)
```

## 5. Performance

- Entity lookup: O(1) hash map.
- Neighbors: adjacency list.
- TopK: ranking index.

## 6. Tương tác

- `graph.md` — data structure.
- `ranking.md` — TopK.
- Context Engine — query thay scan.