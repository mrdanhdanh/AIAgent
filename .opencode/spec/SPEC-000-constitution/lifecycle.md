---
name: spec-000-lifecycle
description: SPEC-000 Part V — Lifecycle: Entity, Workflow, Plugin, Artifact.
agent: general
---

# Part V — Lifecycle

## Chương 17 — Entity Lifecycle

Mọi entity (mức khai báo — status):

```text
Draft
  ↓
Experimental
  ↓
Stable
  ↓
Deprecated
  ↓
Removed
```

| Status | Ý nghĩa |
|--------|---------|
| Draft | chưa hoàn thiện |
| Experimental | dùng thử, có thể đổi |
| Stable | ổn định, backward compatible |
| Deprecated | đánh dấu cũ, sẽ gỡ |
| Removed | gỡ khỏi hệ thống |

## Chương 18 — Workflow Lifecycle

```text
Created
  ↓
Validated
  ↓
Running
  ↓
Completed
```

Kèm nhánh lỗi:

```text
Running → Failed → Retry → Running
Running → Failed → Rollback → Completed
```

## Chương 19 — Plugin Lifecycle

```text
Installed
  ↓
Validated
  ↓
Enabled
  ↓
Disabled
  ↓
Removed
```

- Enabled trước phải **certified** (simulation + doctor + security).
- Disabled → exports gỡ khỏi Registry.

## Chương 20 — Artifact Lifecycle

```text
Created
  ↓
Indexed
  ↓
Consumed
  ↓
Archived
```

- Immutable (P013) — không sửa, chỉ tạo version.
- Indexed: có metadata + checksum trong index.
- Consumed: đã được agent/module dùng.
- Archived: không còn active.