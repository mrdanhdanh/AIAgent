---
name: context-cache
description: cache — Cache các nguồn không đổi; Diff cho artifact giữa các iteration.
agent: general
---

# Context Cache

## 1. Mục tiêu

Agent đọc rồi, builder nhận cũng giống → không load lại. Giảm token + thời gian.

## 2. Chiến lược theo type

| type | cache | vì sao |
|------|-------|--------|
| project | **full** | nội dung cố định, đọc 1 lần |
| task | short-lived | mỗi phase mới task khác |
| workflow | per-state | thay đổi theo phase |
| artifact | **hash** | rẻ nhất: hash → không đổi không đọc lại |
| knowledge | index | query-based retry, cache toàn subset |

## 3. Key design

```
cache:LRU : per-agent + type + content-hash
```

- `project` key để dài (session).
- `artifact` key = content sha256 → miss khi artifact đổi.

## 4. Diff (Artifact)

- Lần 1 builder đọc plan.md (full).
- Lần 2 (iteration2) → chỉ gửi **diff** (thay đổi từ bản trước).

→ Lợi ích chính của "only diff, not full".

## 5. Xem thêm

- `cache/diff.md` — chi tiết thuật nhiều diff.
- `index/` — context index để lookup rẻ.

## 6. Metrics

- cache.hit_rate / miss_rate → metrics/context-metrics.
- Target hit-rate project >= 90%, artifact > 80%.