---
name: spec-003-c008-data-model
description: >
  SPEC-003 C008 — Capability Data Model. Trả lời: Capability System quản lý dữ
  liệu nào? 15 entities, Aggregate Root = Capability — không quản lý Business
  Data. Mirror W008 (SPEC-002).
agent: general
---

# C008 — Capability Data Model

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System quản lý dữ liệu nào?**

## CDM001 — Data Philosophy

- Capability Data Model là SSOT (P009) cho Capability System.
- Capability không quản lý Business Data.
- Capability không quản lý Execution Data (thuộc S008).

## CDM002 — Aggregate Root

**Capability** là Aggregate Root duy nhất.

- Capability owns: [Definition, Mapping, Binding, Result, Events, Metrics].
- Capability references: [Agent (SPEC-004), Plugin (S017), Execution (S008), Registry Entry (S014)].
- Ownership và Reference khác nhau — không nhầm lẫn.

## CDM003 — Classification

| Nhóm | Gồm |
|------|-----|
| Definition Data | CapabilityDefinition, CapabilityVersion, CapabilityGroup |
| Mapping Data | CapabilityMapping, CapabilityBinding |
| Transient | CapabilityState |
| Persistent Metadata | CapabilityResult, Events, Metrics, Trace |
| Reference Data | Agent Ref (SPEC-004), Plugin Ref (S017), Execution Ref (S008), Registry Entry (S014) |
| **Không quản lý** | Business Data, Knowledge, Plugin Data, User Data |

## CDM004 — Entities (15)

| ID | Entity | Kind | Owner | Immutable |
|----|--------|------|-------|-----------|
| ENT-C001 | Capability | AggregateRoot | Capability | — |
| ENT-C002 | CapabilityDefinition | Entity | Capability | ✅ |
| ENT-C003 | CapabilityVersion | Entity | Capability | ✅ |
| ENT-C004 | CapabilityMapping | Value | Capability | ✅ |
| ENT-C005 | CapabilityGroup | Value | Capability | — |
| ENT-C006 | CapabilityBinding | Value | Capability | ✅ |
| ENT-C007 | CapabilityState | Transient | Capability | — |
| ENT-C008 | CapabilityResult | Entity | Capability | ✅ |
| ENT-C009 | CapabilityEvent | Ref (S011) | Runtime | ✅ |
| ENT-C010 | CapabilityMetric | Ref (S011) | Runtime | ✅ |
| ENT-C011 | CapabilityRegistryEntry | Ref (S014) | Capability | ✅ |
| ENT-C012 | AgentRef | Ref (SPEC-004) | Agent | ✅ |
| ENT-C013 | PluginRef | Ref (S017) | Plugin | ✅ |
| ENT-C014 | ExecutionRef | Ref (S008) | Runtime | ✅ |
| ENT-C015 | CapabilityExtension | Value | Capability | ✅ |

> ENT-C009/010/011/012/013/014 là **Reference** tới Runtime/Agent/Plugin — không định nghĩa lại.

## CDM005 — Invariants (12)

- Capability có đúng một Definition.
- **Capability đăng ký trong Registry (S014).**
- **Mapping qua Registry — không hardcode (CB007).**
- CapabilityResult immutable.
- Event không thay đổi.
- Capability ID toàn cục.
- Capability luôn có Owner.
- Capability luôn có Version.
- Capability luôn có Lifecycle.
- Capability không đổi Identity.
- Definition không đổi khi Published.
- Binding không đổi khi Published.

## CDM006 — Consistency

- Levels: Definition Consistency · Mapping Consistency · Binding Consistency.
- Definition luôn hợp lệ (validate trước khi đăng ký).
- Mapping luôn qua Registry.
- Binding luôn có policy_ref hợp lệ (S012).
- Metrics chỉ append.
- Event chỉ append.

## CDM007 — Lifecycle

- **Definition**: Draft → Published → Deprecated → Retired.
- **Run**: Idle → Assigned → Running → Completed.

## CDM008 — Ownership

- Capability, Definition, Mapping, Binding, Result → Capability Team.
- Agent (SPEC-004) → Agent.

## CDM009 — References

- Capability → Agent: AgentRef (SPEC-004).
- Capability → Plugin: PluginRef (S017).
- Capability → Execution: ExecutionRef (S008).
- Capability → Registry: CapabilityRegistryEntry (S014).
- Capability → Event: CapabilityEvent (S011).

## CDM010 — Relations

- Capability 1-1 Definition · Definition 1-N Version · Capability 1-N Mapping · Capability 1-N Binding · Group 1-N Capability · Capability 1-1 Result.

## CDM011 — Validation

- Capability có đúng một Definition.
- Mapping qua Registry (S014) — không hardcode.
- Binding có policy_ref (S012).
- Group chỉ chứa Capability hợp lệ.
- Result immutable.
- Reference trỏ đến entity tồn tại.

## CDM012 — Queries

- Theo Capability ID.
- Theo Definition Version.
- Theo Registry Entry (S014).
- Theo AgentRef (SPEC-004).

## CDM013 — Machine-readable

```text
capability-data-model.yaml
capability-entities.yaml
capability-identities.yaml
capability-invariants.yaml
capability-lifecycle.yaml
capability-ownership.yaml
capability-references.yaml
capability-relations.yaml
capability-validation.yaml
capability-data.schema.json
```

## CDM014 — Traceability

```text
Capability → Definition → Mapping/Binding
    ↓
Agent (SPEC-004) → Plugin (S017) → Registry (S014) → Event (S011)
```

## CDM015 — Success Criteria

- Capability là Aggregate Root duy nhất.
- 15 entities đủ fields.
- 12 invariants đúng.
- Không quản lý Business Data.
- Reference tới Runtime/Agent/Plugin — không định nghĩa lại.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- Appendix: `../capability-models/capability-models.yaml`
- C002: `../C002/requirements.md`
- W008: `../../SPEC-002/W008/data-model.md` (mẫu)
- S008: `../../SPEC-001/S008/runtime-data-model.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
