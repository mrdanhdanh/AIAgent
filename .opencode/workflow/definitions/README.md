---
name: workflow-definitions
description: Chứa workflow definition chuẩn (feature/bugfix/ui/documentation) cho Workflow Runtime v1.
agent: general
---

# Workflow Definitions

> Các workflow definition cho Runtime. Mỗi definition kèm `manifest` (Workflow Manifest).

## Danh sách

| File | Workflow | Mô tả |
|------|----------|-------|
| `feature.workflow.yaml` | feature-development | feature tiêu chuẩn: analyze→design→review→build→test |
| `bugfix.workflow.yaml` | bugfix-development | sửa lỗi nhanh |
| `ui.workflow.yaml` | ui-development | cải tiến UI/UX |
| `documentation.workflow.yaml` | documentation-write | viết/ cải thiện tài liệu |

## Workflow Manifest

Mỗi workflow khai báo `manifest` (theo user đề xuất):

```yaml
manifest:
  schema: workflow.v1
  entry_phase: analyze
  supported_capabilities: [implementation.code, ...]
  required_components: [workflow-runtime]
  minimum_framework_version: 4.0.0
```

Compiler (compiler.md) kiểm tra manifest trước khi chạy.

## Schema

Tham chiếu: `workflow-runtime/workflow.schema.yaml`, `phase.schema.yaml`, `instance.schema.yaml`.