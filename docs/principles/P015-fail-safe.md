---
id: P015
name: Fail Safe
status: Draft
category: Quality
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - runtime
implemented_in:
  - SPEC-011
related:
  - P004
  - P010
  - P013
statement: >
  Nếu lỗi → Rollback → Artifact → Audit. Không im lặng bỏ qua lỗi.
rationale: >
  Lỗi phải hiển thị, có vết, có thể rollback. Im lặng bỏ qua lỗi → mất kiểm soát.
rules:
  - Lỗi luôn được báo cáo.
  - Có rollback point.
  - Có artifact ghi lỗi.
  - Có audit trail.
implications:
  - Lỗi → Rollback → Artifact → Audit.
  - Không im lặng bỏ qua lỗi.
anti_patterns:
  - Nuốt lỗi (catch empty).
  - Chạy tiếp khi state không rõ.
exceptions:
  - Lỗi không ảnh hưởng (best-effort) phải ghi log.
examples:
  - TEST_FAILED → Rollback → Artifact test-report → Audit.
references:
  - P004 Everything is Versioned
  - P010 Immutable Artifact
  - P013 Simulation Before Execution
---

# P015 — Fail Safe

## Statement

> Nếu lỗi → Rollback → Artifact → Audit. Không im lặng bỏ qua lỗi.

## Rules

```text
Lỗi
    ↓
Rollback
    ↓
Artifact
    ↓
Audit
```

## Implications

- Lỗi luôn hiển thị.
- Có rollback point.
- Có vết để audit.

## Anti Pattern

❌ Nuốt lỗi / im lặng bỏ qua.
