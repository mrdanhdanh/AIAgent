---
name: kernel-resource-manager
description: Resource Manager — token/memory/time budget check trước khi chạy task.
agent: general
---

# Kernel Resource Manager

## 1. Vai trò

Quản lý budget tài nguyên của mọi task (nối Phase 16).

## 2. Budget types

| Budget | Đơn vị | Ví dụ |
|--------|--------|-------|
| tokens | token | max 12000 |
| memory | MB | max 512 |
| time | ms | timeout 30000 |
| cost | $ | max 0.05 |
| model | — | quota per model |

## 3. Check flow

```text
Task yêu cầu chạy
  → ResourceManager.Reserve(task)
  → đủ budget? → dispatch
  → thiếu → defer / reject / reduce context
```

## 4. Enforcement

- Reserve trước khi dispatch.
- Track usage trong kernel state.
- Giải phóng sau task hoàn thành.

## 5. Tương tác

- `scheduler.md` — check trước dispatch.
- `context/` (Phase 4) — context budget.
- `resources/` (Phase 16) — chi tiết.