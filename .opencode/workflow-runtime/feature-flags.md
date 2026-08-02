---
name: workflow-runtime-feature-flags
description: feature-flags — Phase 1.19: bật/tắt module runtime bằng config. Khi Phase 6 xong chỉ cần events: true.
agent: general
---

# feature-flags.md — Runtime Feature Flags

> Bật/tắt module **không sửa Runtime** — chỉ đổi config.

## 1. Flags

```yaml
features:
  workflow_compiler: true
  recovery: true
  metrics: true
  events: false
  simulation: false
```

| Flag | Default | Phase |
|------|---------|-------|
| workflow_compiler | true | 1.3 |
| recovery | true | 1.10 |
| metrics | true | 1.11 |
| events | false | 6 |
| simulation | false | 7 |

## 2. Ví dụ tiến triển

Khi Phase 6 (Event System) hoàn thành:

```yaml
events: true
```

Không sửa Runtime.

## 3. Quy tắc

- Flag mặc định không làm hỏng core (nếu tắt recovery → không retry).
- Feature được compile-time check: `if features.events` → dùng event queue.
- Doctor đọc flags để đánh giá capability hiện có.

## 4. Tương tác

- `configuration.md` (features nằm trong config)
- `runtime-manifest.json` (phản ánh flags bật)