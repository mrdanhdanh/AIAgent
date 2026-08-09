---
name: spec-005-r008-data-model
description: SPEC-005 R008 — Registry Data Model. 15 entities, Aggregate Root = RegistryEntry.
agent: general
---

# R008 — Registry Data Model

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry quản lý dữ liệu nào?**

## RDM001 — Data Philosophy

- Registry Data Model là SSOT (P009).
- Registry không quản lý Business Data.

## RDM002 — Aggregate Root

**RegistryEntry** là Aggregate Root duy nhất.

- Entry owns: [Metadata, Version, Domain, Owner, Reference, Result].
- Entry references: [Capability (SPEC-003), Workflow (SPEC-002), Agent (SPEC-004), Execution (S008)].

## RDM003 — Classification

| Nhóm | Gồm |
|------|-----|
| Entry Data | Metadata, Version, Domain, Owner |
| Transient | EntryState |
| Persistent Metadata | ResolutionResult, Snapshot, Events, Metrics |
| Reference Data | Capability/Workflow/Agent/Execution Ref |
| **Không quản lý** | Business Data, Knowledge, User Data |

## RDM004 — Entities (15)

| ID | Entity | Kind | Immutable |
|----|--------|------|-----------|
| ENT-R001 | RegistryEntry | AggregateRoot | — |
| ENT-R002 | EntryMetadata | Entity | ✅ |
| ENT-R003 | EntryVersion | Entity | ✅ |
| ENT-R004 | EntryDomain | Value | ✅ |
| ENT-R005 | EntryOwner | Value | ✅ |
| ENT-R006 | EntryReference | Value | ✅ |
| ENT-R007 | EntryState | Transient | — |
| ENT-R008 | ResolutionResult | Entity | ✅ |
| ENT-R009 | RegistryEvent | Ref (S011) | ✅ |
| ENT-R010 | RegistryMetric | Ref (S011) | ✅ |
| ENT-R011 | RegistrySnapshot | Entity | ✅ |
| ENT-R012 | CapabilityRef | Ref (SPEC-003) | ✅ |
| ENT-R013 | WorkflowRef | Ref (SPEC-002) | ✅ |
| ENT-R014 | AgentRef | Ref (SPEC-004) | ✅ |
| ENT-R015 | RegistryExtension | Value | ✅ |

## RDM005 — Invariants (12)

- Entry có đúng một Metadata. · Entry versioned (SemVer). · Entry có đúng một Owner. · ResolutionResult immutable. · Event không thay đổi. · Entry ID toàn cục. · Entry luôn có Owner. · Entry luôn có Version. · Entry luôn có Lifecycle. · Entry không đổi Identity. · Metadata không đổi khi Published. · Reference không đổi khi Published.

## RDM006 — Consistency

- Levels: Metadata · Version · Reference Consistency.
- Metadata hợp lệ (validate trước khi lưu). · Version semver. · Reference trỏ đến Entry tồn tại. · Metrics/Event chỉ append.

## RDM007 — Lifecycle

- **Entry**: Draft → Published → Deprecated → Retired.
- **Resolution**: Idle → Running → Completed.

## RDM008 — Ownership

- Entry, Metadata, Version, Result → Registry Team.
- Capability (SPEC-003) → Capability Team.

## RDM009 — References

- Entry → Capability: CapabilityRef (SPEC-003). · Entry → Workflow: WorkflowRef (SPEC-002). · Entry → Agent: AgentRef (SPEC-004). · Entry → Execution: ExecutionRef (S008). · Entry → Event: RegistryEvent (S011).

## RDM010 — Relations

- Entry 1-1 Metadata · Entry 1-N Version · Entry 1-N Domain · Entry 1-1 Owner · Entry 1-N Reference · Entry 1-1 ResolutionResult.

## RDM011 — Validation

- Entry đúng một Metadata. · Entry versioned. · Entry đúng một Owner. · Reference trỏ đến Entry tồn tại. · ResolutionResult immutable. · Không Business Data.

## RDM012 — Queries

- Theo Entry ID. · Theo Version. · Theo Domain. · Theo Owner.

## RDM013 — Machine-readable

```text
registry-data-model.yaml
registry-entities.yaml
registry-identities.yaml
registry-invariants.yaml
registry-lifecycle.yaml
registry-ownership.yaml
registry-references.yaml
registry-relations.yaml
registry-validation.yaml
registry-data.schema.json
```

## RDM014 — Traceability

```text
Entry → Metadata → Version → Resolution Result
    ↓
Capability (SPEC-003) → Workflow (SPEC-002) → Registry (S014) → Event (S011)
```

## RDM015 — Success Criteria

- RegistryEntry là Aggregate Root duy nhất.
- 15 entities đủ fields.
- 12 invariants đúng.
- Không quản lý Business Data.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- Appendix: `../registry-models/registry-models.yaml`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
