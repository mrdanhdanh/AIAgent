---
name: artifact-lifecycle
description: Artifact Lifecycle — Created → Validated → Published → Consumed → Archived → Deleted.
agent: general
---

# Artifact Lifecycle

```
Created → Validated → Published → Consumed → Archived → Deleted
```

| State | Ý nghĩa | Transition |
|-------|---------|------------|
| Created | chưa validate | auto by Manager.Create |
| Validated | pass schema + checksum | Manager.Validate |
| Published | sẵn sàng consume | manual / auto publish |
| Consumed | đã được agent khác dùng | tự động khi consumed_by thêm |
| Archived | không còn active | Manager.Archive |
| Deleted | soft delete | Manager.Delete |

## Rules

- Không chỉnh sửa trực tiếp — mọi thay đổi = tạo version mới.
- Chỉ artifact **Published** mới được consume.
- Archived/Deleted → không còn trong index active.
- Lifecycle event publish sang Event Bus (Phase 6).