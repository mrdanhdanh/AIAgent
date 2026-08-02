---
name: release-manager
description: >
  Release Manager v22.0 — quản lý version framework: proposal → migration → canary → A/B → release → rollback.
agent: general
---

# Release Manager v22.0

## 1. Vai trò

Evolution sinh proposal → Release Manager đưa ra production an toàn.

```text
Proposal → Migration → Canary → A/B Test → Release → Rollback
```

## 2. Stages

| Stage | Mô tả |
|-------|-------|
| migration | áp dụng thay đổi |
| canary | triển khai 1 phần |
| A/B test | so sánh cũ/mới |
| release | rollout toàn bộ |
| rollback | quay lại nếu lỗi |

## 3. Tương tác

- `release.schema.yaml`.
- `canary.md`, `ab-test.md`, `rollback.md`.
- `evolution/` (Phase 10) — proposal.
- `evaluation/` (Phase 21) — A/B quality.
- `versioning/` (Phase 13 SDK) — version.