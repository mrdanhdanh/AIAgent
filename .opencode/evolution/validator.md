---
name: evolution-validator
description: Validator — kiểm tra proposal hợp lệ trước khi vào approval/apply.
agent: general
---

# Evolution Validator

## 1. Checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | EVO-001 | Proposal schema đủ required |
| 2 | EVO-002 | Category hợp lệ |
| 3 | EVO-003 | Impact analysis có affected list |
| 4 | EVO-004 | Simulation đã chạy (risk/confidence) |
| 5 | EVO-005 | Migration plan tồn tại |
| 6 | EVO-006 | Policy cho phép proposal |
| 7 | EVO-007 | Backtest done (nếu required) |
| 8 | EVO-008 | Compatibility check pass |

## 2. Validation flow

```text
Schema (EVO-001/002)
  → Impact (EVO-003)
  → Simulation (EVO-004)
  → Migration (EVO-005)
  → Policy (EVO-006)
  → Backtest (EVO-007)
  → Compat (EVO-008)
  → Ready for approval
```

## 3. Error level

- Thiếu simulation/backtest → block.
- Policy không cho phép → block.
- Compatibility fail → block.

## 4. Tương tác

- `planner.md` — proposal được tạo đúng chuẩn.
- `migration.md` — apply sau pass.
- `evolution-validator.ps1` — gate Phase 10.