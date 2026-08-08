---
name: spec-004-agent-models
description: >
  SPEC-004 Appendix — Agent Canonical Models. Single Source of Truth (P009)
  cho Agent System — mọi SPEC của SPEC-004 tham chiếu, không định nghĩa lại.
agent: general
---

# Appendix — Agent Canonical Models

> **SPEC-004**: Agent System · **Version**: 1.0 · **Trạng thái**: Draft

## Mô hình chuẩn (8)

| ID | Model | Kind | Immutable |
|----|-------|------|-----------|
| AM-001 | Agent | Root | — |
| AM-002 | AgentDefinition | Entity | ✅ Published |
| AM-003 | AgentVersion | Entity | ✅ |
| AM-004 | CapabilityMapping | Value | ✅ Published |
| AM-005 | AgentGroup | Value | — |
| AM-006 | AgentBinding | Value | ✅ Published |
| AM-007 | AgentResult | Entity | ✅ |
| AM-008 | AgentRegistryEntry | Reference | ✅ Published |

## Quy tắc

- **Aggregate Root**: Agent.
- Mọi SPEC của SPEC-004 tham chiếu model này — không định nghĩa lại (P009).
- AgentDefinition immutable khi Published.
- CapabilityMapping qua Capability System (SPEC-003) — không hardcode (AB007).
- AgentBinding có policy_ref (S012).
- AgentResult immutable (P010).

## Tham chiếu

- `agent-models.yaml` — nguồn dữ liệu chuẩn
- `agent-model-registry.yaml` · `agent-model-relationships.yaml` · `agent-model-validation.yaml`
- `agent-models.schema.json`
- C008: `../../SPEC-003/capability-models/capability-models.yaml` (mẫu)
- Constitution: `docs/specs/SPEC-000/`