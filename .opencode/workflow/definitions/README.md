---
name: workflow-definitions
description: Chứa workflow definition chuẩn (default/bugfix/feature/ui/docs/documentation) cho Workflow Engine v4 + Workflow Runtime v1.
agent: general
---

# Workflow Definitions

> Các workflow definition chung. Engine v4 (`workflow-engine/`) chạy schema v4.0
> (id/name/version/description/phases với `title` + `agent|command`). Workflow
> Runtime v1 đọc cùng file (giữ `manifest` + `capability` + `outputs`).

## Danh sách

| File | Workflow | Mô tả |
|------|----------|-------|
| `default.workflow.yaml` | default | 15 phases: analyze → design → plan → review → guardrail → backup → build → static_analysis → ui_audit → testplan → test → skill_validation → failure_analysis → learning → complete |
| `bugfix.workflow.yaml` | bugfix-development | sửa lỗi nhanh: reproduce → diagnose → fix → verify → failure_analysis → learning → complete |
| `feature.workflow.yaml` | feature-development | feature tiêu chuẩn: analyze → design → review → backup → build → test → complete |
| `ui.workflow.yaml` | ui-development | cải tiến UI/UX: audit → design → implement → verify → complete |
| `docs.workflow.yaml` | docs | tài liệu: analyze → write → review → validate → complete |
| `documentation.workflow.yaml` | documentation-development | tài liệu (legacy alias): analyze → write → review → complete |

## Workflow Manifest (Runtime v1)

Mỗi workflow khai báo `manifest` (cho Workflow Runtime v1):

```yaml
manifest:
  schema: workflow.v1
  entry_phase: analyze
  supported_capabilities: [implementation.code, ...]
  required_components: [workflow-runtime]
  minimum_framework_version: 4.0.0
```

Compiler (compiler.md) kiểm tra manifest trước khi chạy.

## Learning phases (v4.0)

`default` và `bugfix` có 2 phase tự học (cả 2 `optional: true`, không block):

- `failure_analysis` — failure-agent + `/team-analyze-failure`: normalize+hash qua
  `failure-analyzer.ps1`, classify, search failure memory.
- `learning` — learning-agent + `/team-learn`: quét `.opencode/memory/failures/`,
  sinh lessons/patterns, cập nhật failure records.

## Schema

- Engine v4: `workflow/schemas/workflow.schema.yaml` (v4.0) — gate validator: `workflow-validator.ps1`
- Runtime v1: `workflow-runtime/workflow.schema.yaml`, `phase.schema.yaml`, `instance.schema.yaml`
