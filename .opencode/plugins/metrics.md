---
name: plugin-metrics
description: Plugin Metrics — plugin count, load time, memory, capability count, error count, update count.
agent: general
---

# Plugin Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| plugin.count | số plugin cài |
| enabled.count | số plugin active |
| load.time | thời gian load trung bình |
| memory.used | bộ nhớ plugin dùng |
| capability.count | tổng capability plugin export |
| error.count | lỗi plugin |
| update.count | số update |
| certified.count | số plugin certified |

## 2. Per-plugin

```text
oracle: { load: 12ms, memory: 8MB, errors: 0, certified: true }
```

## 3. Doctor

- Plugin error > threshold → warning.
- Plugin memory cao → cảnh báo tối ưu.

## 4. Lưu trữ

- `plugins/metrics.json`.
- Dashboard hiển thị.

## 5. Tương tác

- `manager.md` — ghi metrics.
- Doctor — plugin health.
- Dashboard (Phase 12) — UI.