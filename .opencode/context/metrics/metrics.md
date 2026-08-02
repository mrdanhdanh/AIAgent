---
name: context-metrics
description: metrics — theo dõi token, compression, cache hit/miss, delivery time của Context Engine.
agent: general
---

# Context Metrics

## 1. Chỉ số đo

| Metric | Đơn vị | Mô tả |
|--------|--------|-------|
| token.used | token | budget đã dùng |
| token.limit | token | budget giới hạn |
| compression.ratio | x | original / result |
| compression.saved | token | token tiết kiệm do nén |
| cache.hit_rate | % | nguồn cache hit |
| cache.miss_rate | % | nguồn miss |
| delivery.time | ms | thời gian Package → Agent |
| resolved.count | item | số context resolver trả |
| dropped.count | item | số context bị loại (filter/budget) |

## 2. Nơi lưu

- Một file metrics JSON trong `.opencode/context/metrics/` per render/session.
- Doctor đọc tổng hợp.

## 3. Target

- `cache.hit_rate` project >= 90%, artifact >= 80%.
- `compression.saved` >= 40% cho workflow dài.
- `delivery.time` < 100ms.

## 4. Ghi chú

- Metrics modulestateless, chỉ tổng hợp số.
- Số liệu góp phần chứng minh lợi ích "giảm 40–70% token".

## 5. Tương tác

- `budget.schema.yaml` (limit).
- `cache/cache.md` (hit/miss).
- Doctor (Phase 8).