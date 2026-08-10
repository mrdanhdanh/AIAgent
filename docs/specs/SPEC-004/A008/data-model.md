---
name: spec-004-a008-data-model
description: >
  SPEC-004 A008 — Agent Data Model. Trả lời: Agent System quản lý dữ liệu
  nào? 15 entities, Aggregate Root = Agent — không quản lý Business Data.
  Mirror C008 (SPEC-003).
agent: general
---

# A008 — Agent Data Model

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System quản lý dữ liệu nào?**

## ADM001 — Data Philosophy

- Agent Data Model là SSOT (P009) cho Agent System.
- Agent không quản lý Business Data.
- Agent không quản lý Execution Data (thuộc S008).

## ADM002 — Aggregate Root

**Agent** là Aggregate Root duy nhất.

- Agent owns: [Definition, Mapping, Binding, Result, Events, Metrics].
- Agent references: [Capability (SPEC-003), Workflow (SPEC-002), Execution (S008), Registry Entry (S014)].
- Ownership và Reference khác nhau — không nhầm lẫn.

## ADM003 — Classification

| Nhóm | Gồm |
|------|-----|
| Definition Data | AgentDefinition, AgentVersion, AgentGroup |
| Mapping Data | CapabilityMapping, AgentBinding |
| Transient | AgentState |
| Persistent Metadata | AgentResult, Events, Metrics, Trace |
| Reference Data | Capability Ref (SPEC-003), Workflow Ref (SPEC-002), Execution Ref (S008), Registry Entry (S014) |
| **Không quản lý** | Business Data, Knowledge, Plugin Data, User Data |

## ADM004 — Entities (15)

| ID | Entity | Kind | Owner | Immutable |
|----|--------|------|-------|-----------|
| ENT-A001 | Agent | AggregateRoot | Agent | — |
| ENT-A002 | AgentDefinition | Entity | Agent | ✅ |
| ENT-A003 | AgentVersion | Entity | Agent | ✅ |
| ENT-A004 | CapabilityMapping | Value | Agent | ✅ |
| ENT-A005 | AgentGroup | Value | Agent | — |
| ENT-A006 | AgentBinding | Value | Agent | ✅ |
| ENT-A007 | AgentState | Transient | Agent | — |
| ENT-A008 | AgentResult | Entity | Agent | ✅ |
| ENT-A009 | AgentEvent | Ref (S011) | Runtime | ✅ |
| ENT-A010 | AgentMetric | Ref (S011) | Runtime | ✅ |
| ENT-A011 | AgentRegistryEntry | Ref (S014) | Agent | ✅ |
| ENT-A012 | CapabilityRef | Ref (SPEC-003) | Capability | ✅ |
| ENT-A013 | WorkflowRef | Ref (SPEC-002) | Workflow | ✅ |
| ENT-A014 | ExecutionRef | Ref (S008) | Runtime | ✅ |
| ENT-A015 | AgentExtension | Value | Agent | ✅ |

> ENT-A009/010/011/012/013/014 là **Reference** tới Runtime/Capability/Workflow — không định nghĩa lại.

## ADM005 — Invariants (12)

- Agent có đúng một Definition.
- **Agent đăng ký trong Registry (S014).**
- **CapabilityMapping qua SPEC-003 — không hardcode (AB007).**
- AgentResult immutable.
- Event không thay đổi.
- Agent ID toàn cục.
- Agent luôn có Owner.
- Agent luôn có Version.
- Agent luôn có Lifecycle.
- Agent không đổi Identity.
- Definition không đổi khi Published.
- Binding không đổi khi Published.

## ADM006 — Consistency

- Levels: Definition Consistency · Mapping Consistency · Binding Consistency.
- Definition luôn hợp lệ (validate trước khi đăng ký).
- **Mapping luôn qua Capability System (SPEC-003).**
- Binding luôn có policy_ref hợp lệ (S012).
- Metrics chỉ append.
- Event chỉ append.

## ADM007 — Lifecycle

- **Definition**: Draft → Published → Deprecated → Retired.
- **Run**: Idle → Assigned → Running → Completed.

## ADM008 — Ownership

- Agent, Definition, Mapping, Binding, Result → Agent Team.
- Capability (SPEC-003) → Capability Team.

## ADM009 — References

- Agent → Capability: CapabilityRef (SPEC-003).
- Agent → Workflow: WorkflowRef (SPEC-002).
- Agent → Execution: ExecutionRef (S008).
- Agent → Registry: AgentRegistryEntry (S014).
- Agent → Event: AgentEvent (S011).

## ADM010 — Relations

- Agent 1-1 Definition · Definition 1-N Version · Agent 1-N CapabilityMapping · Agent 1-N Binding · Group 1-N Agent · Agent 1-1 Result.

## ADM011 — Validation

- Agent có đúng một Definition.
- CapabilityMapping qua SPEC-003 — không hardcode.
- Binding có policy_ref (S012).
- Group chỉ chứa Agent hợp lệ.
- Result immutable.
- Reference trỏ đến entity tồn tại.

## ADM012 — Queries

- Theo Agent ID.
- Theo Definition Version.
- Theo Registry Entry (S014).
- Theo CapabilityRef (SPEC-003).

## ADM013 — Machine-readable

```text
agent-data-model.yaml
agent-entities.yaml
agent-identities.yaml
agent-invariants.yaml
agent-lifecycle.yaml
agent-ownership.yaml
agent-references.yaml
agent-relations.yaml
agent-validation.yaml
agent-data.schema.json
```

## ADM014 — Traceability

```text
Agent → Definition → Mapping/Binding
    ↓
Capability (SPEC-003) → Workflow (SPEC-002) → Registry (S014) → Event (S011)
```

## ADM015 — Success Criteria

- Agent là Aggregate Root duy nhất.
- 15 entities đủ fields.
- 12 invariants đúng.
- Không quản lý Business Data.
- Reference tới Runtime/Capability/Workflow — không định nghĩa lại.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- Appendix: `../agent-models/agent-models.yaml`
- A002: `../A002/requirements.md`
- C008: `../../SPEC-003/C008/data-model.md` (mẫu)
- S008: `../../SPEC-001/S008/runtime-data-model.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
