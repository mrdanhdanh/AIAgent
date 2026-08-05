---
name: release-canary
description: Canary + A/B + Rollback — triển khai an toàn, so sánh, khôi phục.
agent: general
---

# Canary · A/B · Rollback

## 1. Canary

- Triển khai thay đổi cho 5-10% workflow đầu.
- Theo dõi error/latency.
- OK → rollout tiếp. Lỗi → stop + rollback.

## 2. A/B Test

```text
Nhóm A (old) vs Nhóm B (new)
  → chạy cùng benchmark
  → so quality/latency/cost (evaluation)
  → B tốt hơn? → release : giữ A
```

## 3. Rollback

- Auto-rollback khi error rate > threshold.
- Khôi phục version trước (backup-agent).
- Notification + audit.

## 4. Tương tác

- `release.schema.yaml`.
- `evolution/backtesting.md` — dữ liệu so sánh.
- `evaluation/` — A/B score.
- `kernel/recovery.md` — rollback.