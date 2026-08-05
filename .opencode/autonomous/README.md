---
name: autonomous-mode
description: >
  Autonomous Mode v30.0 — đích cuối. Workflow chạy tự động: simulation → doctor →
  approval policy → execute → review → evolution → release. Không cần con người nếu policy cho phép.
agent: general
---

# Autonomous Mode v30.0

## 1. Vai trò

Workflow tự hành hoàn toàn khi policy cho phép.

```text
Workflow
  → Simulation
  → Doctor
  → Approval Policy
  → Execute
  → Review
  → Evolution
  → Release
  → Done
```

## 2. Autonomy levels

| Level | Con người | Mô tả |
|-------|-----------|-------|
| L0 manual | luôn | mọi bước cần người |
| L1 assisted | review | gợi ý tự động, người duyệt |
| L2 supervised | exception | tự động, người chỉ khi rủi ro cao |
| L3 autonomous | không | tự hoàn toàn (policy-bound) |

## 3. Gate per level

| Level | Simulation | Doctor | Approval |
|-------|-----------|--------|----------|
| L1 | bắt buộc | report | human review |
| L2 | bắt buộc | health > 90 | auto (risk < high) |
| L3 | bắt buộc | health > 95 | auto + audit |

## 4. Safety

- Autonomous KHÔNG vượt policy (Phase 15).
- Hành động nguy hiểm → Trust & Safety (Phase 27) block.
- Mọi hành động audit (Phase 26).

## 5. Tương tác

- `autonomous.schema.yaml`.
- `simulation/` — gate.
- `doctor/` — health gate.
- `trust/` — safety.
- `evolution/` — tự đề xuất.
- `release/` — tự release.
- `policy/` — giới hạn.