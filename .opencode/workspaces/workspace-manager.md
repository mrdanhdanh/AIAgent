---
name: workspace-manager
description: Workspace Manager — tạo/setup/switch workspace; cô lập dữ liệu.
agent: general
---

# Workspace Manager

## 1. API

| Method | Mô tả |
|--------|-------|
| `Create(ws)` | tạo workspace |
| `Activate(id)` | chuyển active |
| `Delete(id)` | xóa (archive trước) |
| `Get(id)` | thông tin |
| `List()` | danh sách |

## 2. Workspace setup

```yaml
workspace:
  id: ws-a
  project_path: ./projects/a
  registry: { plugins: [oracle] }
  context: { budget: 5000 }
  knowledge: { shared: true }
```

## 3. Isolation

- File artifacts theo workspace folder.
- Memory namespace `ws-{id}`.
- Context profile per workspace.

## 4. Tương tác

- `workspaces.schema.yaml`.
- `kernel/` — shared runtime, active workspace context.
- `context/` — per-workspace profile.