---
name: spec-002-workflow-models
description: >
  SPEC-002 Appendix — Workflow Canonical Models. Single Source of Truth (P009)
  cho Workflow Engine — mọi SPEC của SPEC-002 tham chiếu, không định nghĩa lại.
agent: general
---

# Appendix — Workflow Canonical Models

> **SPEC-002**: Workflow Engine · **Version**: 1.0 · **Trạng thái**: Draft

## Mô hình chuẩn (8)

| ID | Model | Kind | Immutable |
|----|-------|------|-----------|
| WM-001 | Workflow | Root | — |
| WM-002 | WorkflowDefinition | Entity | ✅ Published |
| WM-003 | WorkflowStep | Value | ✅ |
| WM-004 | Branch | Value | ✅ |
| WM-005 | Gate | Value | ✅ |
| WM-006 | WorkflowContext | Transient | — |
| WM-007 | WorkflowResult | Entity | ✅ |
| WM-008 | WorkflowRegistryEntry | Reference | ✅ Published |

## Quy tắc

- **Aggregate Root**: Workflow.
- Mọi SPEC của SPEC-002 tham chiếu model này — không định nghĩa lại (P009).
- WorkflowDefinition immutable khi Published (WCT-002).
- WorkflowContext isolated (S010 EF008).
- WorkflowResult immutable (P010).

## Tham chiếu

- `workflow-models.yaml` — nguồn dữ liệu chuẩn
- `workflow-model-registry.yaml` · `workflow-model-relationships.yaml` · `workflow-model-validation.yaml`
- `workflow-models.schema.json`
- S008: `../../SPEC-001/S008/runtime-data-model.yaml` (mẫu)
- Constitution: `docs/specs/SPEC-000/`