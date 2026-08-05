---
name: workflow-runtime-certificate
description: RUNTIME_CERTIFICATE — Phase 1.26: chứng nhận Runtime sau khi Acceptance + Benchmark đạt. Điểm giảm → không release.
agent: general
---

# RUNTIME_CERTIFICATE.md — Runtime Certification

> Chứng nhận Runtime **sau khi hoàn thành Phase 1**. Doctor → Benchmark → Acceptance → Certificate.

## Certificate

```text
Workflow Runtime
Version: 4.0
Architecture Score:   98/100
Reliability:          95%
Performance:          96%
Maintainability:      99%
Compatibility:        100%
```

## Cách tính điểm

| Hạng mục | Nguồn |
|----------|-------|
| Architecture Score | RUNTIME_ACCEPTANCE.md (Architecture boxes) |
| Reliability | acceptance Reliability + recovery tests |
| Performance | `/team-runtime-benchmark` vs PERFORMANCE.md |
| Maintainability | module count, coupling, DI/locator |
| Compatibility | v3 + v4 workflows chạy được |

## Quy trình khi Runtime thay đổi

```text
Doctor
  ↓
Benchmark
  ↓
Acceptance
  ↓
Certificate
```

Nếu **điểm giảm** → **Không Release**.

## Quy tắc

- Certificate là snapshot theo version (4.0.x).
- Khi core runtime thay đổi → re-certify.
- Certificate mới nhất ghi tại file này (cập nhật thủ công/script).
- Doctor đọc certificate để báo cáo sức khỏe tổng.

## Gate Phase 2

- Certificate phải đạt ngưỡng tối thiểu (vd ≥ 90% mọi hạng mục) trước khi sang Capability Registry.