---
name: evolution-migration
description: Migration Engine — áp dụng proposal sau khi approved; auto-migrate schema, version, rollback.
agent: general
---

# Migration Engine

## 1. Vai trò

Thực thi proposal đã approved — biến đề xuất thành thay đổi thật.

## 2. Migration types

| Type | Ví dụ |
|------|-------|
| schema | agent.yaml schema v1 → v2 |
| config | profile bật compression |
| metadata | deprecate capability |
| file | thay prompt, hợp nhất profile |
| registry | thêm/gỡ agent/capability |

## 3. Migration plan

```yaml
migration:
  steps:
    - { action: update, target: profile/context.yaml, change: enable_compression }
    - { action: deprecate, target: capability.x }
  backward_compatible: true
  rollback:
    - { action: restore, target: profile/context.yaml }
```

## 4. Version Manager

Framework version nội bộ (không chỉ git):

```text
4.0.0 → 4.1.0 → 4.2.0
```

Mỗi proposal applied → minor version bump.

## 5. Compatibility check

- Planner v2 → Runtime v1 → Reject (không tương thích).
- Migration phải kiểm tra compat trước apply.
- Backward incompatible → requires full chain migration.

## 6. Rollback

- Migration lỗi → rollback về bản trước.
- Backup trước khi migrate (reuse backup-agent).

## 7. Tương tác

- `planner.md` — proposal có migration plan.
- `validator.md` — kiểm tra trước apply.
- `history.md` — ghi version.
- Phase 11 (Plugin) — plugin migration riêng.