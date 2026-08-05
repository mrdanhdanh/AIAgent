---
name: knowledge-metrics
description: Metrics — entities, relations, avg degree, query time, coverage, duplicate.
agent: general
---

# Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| entity.count | tổng entity |
| relation.count | tổng relation |
| avg.degree | độ liên kết trung bình |
| query.time | thời gian query trung bình |
| coverage | % entity có relation |
| duplicate | số entity duplicate |
| orphan | số entity orphan |
| by.type | phân bố entity theo type |

## 2. Target

- avg.degree >= 2 (graph liên thông).
- coverage >= 80%.
- query.time < 10ms.
- orphan == 0.

## 3. Lưu trữ

- `knowledge-graph/metrics.json`.
- Doctor đọc + so sánh trend.

## 4. Tương tác

- `graph.md` — stats.
- Doctor — health của graph.
- Dashboard — visualization.