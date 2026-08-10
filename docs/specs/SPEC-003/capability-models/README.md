---
name: spec-003-capability-models
description: >
  SPEC-003 Appendix — Capability Canonical Models. Single Source of Truth (P009)
  cho Capability System — mọi SPEC của SPEC-003 tham chiếu, không định nghĩa lại.
agent: general
---

# Appendix — Capability Canonical Models

> **SPEC-003**: Capability System · **Version**: 1.0 · **Trạng thái**: Draft

## Mô hình chuẩn (8)

| ID | Model | Kind | Immutable |
|----|-------|------|-----------|
| CM-001 | Capability | Root | — |
| CM-002 | CapabilityDefinition | Entity | ✅ Published |
| CM-003 | CapabilityVersion | Entity | ✅ |
| CM-004 | CapabilityMapping | Value | ✅ Published |
| CM-005 | CapabilityGroup | Value | — |
| CM-006 | CapabilityBinding | Value | ✅ Published |
| CM-007 | CapabilityResult | Entity | ✅ |
| CM-008 | CapabilityRegistryEntry | Reference | ✅ Published |

## Quy tắc

- **Aggregate Root**: Capability.
- Mọi SPEC của SPEC-003 tham chiếu model này — không định nghĩa lại (P009).
- CapabilityDefinition immutable khi Published.
- CapabilityMapping qua Registry (S014) — không hardcode (CB007).
- CapabilityBinding có policy_ref (S012).
- CapabilityResult immutable (P010).

## Tham chiếu

- `capability-models.yaml` — nguồn dữ liệu chuẩn
- `capability-model-registry.yaml` · `capability-model-relationships.yaml` · `capability-model-validation.yaml`
- `capability-models.schema.json`
- W008: `../../SPEC-002/workflow-models/workflow-models.yaml` (mẫu)
- Constitution: `docs/specs/SPEC-000/`