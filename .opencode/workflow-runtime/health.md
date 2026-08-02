---
name: workflow-runtime-health
description: health — Phase 1.12: Runtime tự đánh giá sức khỏe: Healthy / Warning / Critical. Dùng cho rollback liên tục, retry nhiều.
agent: general
---

# health.md — Runtime Health

> Runtime **tự đánh giá** sức khỏe workflow từ metrics. Doctor (Phase 8) đọc.

## 1. Trạng thái

```text
Healthy      → chạy tốt
Warning      → retry nhiều / tắc
Critical     → rollback liên tục / không thể tự phục hồi
```

## 2. Quy tắc đánh giá

| Tín hiệu | Status |
|----------|--------|
| retry_count thấp, error thấp, dưới ngưỡng | Healthy |
| retry nhiều (vd > threshold), waiting cao | Warning |
| rollback liên tục, nhiều phase fail, không recover | Critical |

## 3. Health API

```text
Status(instance) → Healthy | Warning | Critical
Report(workflow) → danh sách phase + metrics + gợi ý
```

## 4. Threshold (mặc định, override trong definition)

| Metric | Warning khi | Critical khi |
|--------|------------|--------------|
| retry_count | > 3 | > 5 |
| error_count | > 5 | > 10 |
| recovery_count | > 2 | > 4 |
| completed / total | < 0.5 | < 0.2 |

## 5. Hành động

| Status | Hành động |
|--------|-----------|
| Healthy | tiếp tục |
| Warning | log + metrics ghi, có thể escalate |
| Critical | dừng, escalate/abort (recovery), ghi failure memory |

## 6. Tương tác

- `metrics.md` — input.
- `recovery.md` — quyết escalate/abort khi Critical.
- Doctor: tự đánh giá runtime toàn cục bằng tổng hợp instance health.