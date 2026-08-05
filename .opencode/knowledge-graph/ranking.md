---
name: knowledge-ranking
description: Ranking — xếp hạng entity theo relevance; semantic link tự động.
agent: general
---

# Ranking

## 1. Vai trò

Khi query trả nhiều entity (50) → rank top 5. Semantic link tự gợi ý quan hệ không cần tag tay.

## 2. Ranking factors

| Factor | Weight | Mô tả |
|--------|-------:|-------|
| term_match | 0.40 | độ khớp term/tag/name |
| type_match | 0.20 | entity type phù hợp context |
| relation_strength | 0.20 | tổng weight edges |
| degree | 0.10 | số neighbors (nổi tiếng hơn) |
| recency | 0.10 | version/timestamp mới hơn |

```
score = Σ(weight × factor)
```

## 3. Ví dụ

```text
Search("blazor", top 5):
  1. ENT-blazor (match 1.0, degree 8)   → 0.92
  2. ENT-fluentui (match 0.7, uses blazor) → 0.81
  3. ENT-blazor-component (match 0.6)    → 0.74
  ...
```

## 4. Semantic Link

```text
FluentUI --uses--> Blazor  (tự suy từ co-occurrence/relation)
```

Không cần tag tay — graph edge tự tạo liên kết ngữ nghĩa.

## 5. Tương tác

- `query.md` — TopK.
- `graph.md` — degree.
- Context Engine — top K knowledge cho agent.