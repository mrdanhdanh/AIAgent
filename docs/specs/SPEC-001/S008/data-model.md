---
name: spec-001-s008-data-model
description: >
  SPEC-001 S008 — Runtime Data Model. Trả lời: Runtime quản lý những dữ liệu nào
  và quan hệ giữa chúng ra sao? Canonical Data Model. 18 sections D001-D018.
  Không nói database/DTO/class/JSON/implementation.
agent: general
---

# S008 — Runtime Data Model

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Dynamic Model của Runtime — tham chiếu Canonical Models (SPEC-001A) + State Machine (S009).

## Câu hỏi duy nhất

> **Runtime quản lý những dữ liệu nào và quan hệ giữa chúng ra sao?**

Không nói database.

Không nói DTO.

Không nói class.

Không nói JSON.

Không nói implementation.

Chỉ mô tả **Canonical Data Model**.

## Mục tiêu

Chuẩn hóa toàn bộ dữ liệu Runtime để State Machine, Execution Flow, Contract, Event, Doctor, Dashboard, Plugin, Replay, Simulation, Evolution đều dùng chung một mô hình.

## D001 — Runtime Entities (15)

| ID | Entity | Canonical Model | Classification | Owner |
|----|--------|-----------------|----------------|-------|
| ENT-001 | Execution | RM-001 | Execution Data | Runtime |
| ENT-002 | Execution Context | RM-005 | Transient | Runtime |
| ENT-003 | Execution State | RM-006 | Transient | Runtime |
| ENT-004 | Workflow Reference | RM-002 | Reference Data | Workflow |
| ENT-005 | Capability Reference | RM-010 | Reference Data | Registry |
| ENT-006 | Agent Assignment | (execution-specific) | Execution Data | Runtime |
| ENT-007 | Event | RM-007 | Persistent Metadata | Runtime |
| ENT-008 | Artifact | RM-008 | Persistent Metadata | Runtime |
| ENT-009 | Metrics | (execution-specific) | Persistent Metadata | Runtime |
| ENT-010 | Trace | (execution-specific) | Persistent Metadata | Runtime |
| ENT-011 | Resource Allocation | (execution-specific) | Execution Data | Runtime |
| ENT-012 | Execution Result | RM-012 | Persistent Metadata | Runtime |
| ENT-013 | **Execution Snapshot** | (execution-specific) | Persistent Metadata | Runtime |
| ENT-014 | **Execution Lineage** | (execution-specific) | Persistent Metadata | Runtime |
| ENT-015 | **Execution Metadata** | RM-011 | Metadata | Runtime |

> ENT-013/014/015 phục vụ Replay, Simulation, Resume, Doctor, Evolution.

## D002 — Entity Relationships (Graph)

```text
Workflow → Execution
Execution
    ├── Context (1)
    ├── State (1)
    ├── Event (N)
    ├── Artifact (N)
    ├── Metrics (N)
    ├── Trace (N)
    ├── Resource Allocation (N)
    ├── Agent Assignment (N)
    └── Result (1)
Capability Reference ← Registry
```

> **Execution là Aggregate Root.**

## D003 — Aggregate Rules

- Execution là **Aggregate Root duy nhất**.
- **Execution owns**: Context, State, Resources, Metrics, Events, Trace, Result.
- **Execution references**: Workflow, Capability, Agent, Artifact.
- **Ownership và Reference khác nhau** — không nhầm lẫn.

## D004 — Ownership

| Entity | Owner |
|--------|-------|
| Execution, Context, State, Event, Artifact, Metrics, Trace, Result, Snapshot, Lineage, Metadata, Agent Assignment, Resource Allocation | Runtime |
| Workflow Reference | Workflow (tham chiếu) |
| Capability Reference | Registry (tham chiếu) |

**Ownership Rules:**

- Một Entity chỉ có một Owner.
- Owner duy nhất được phép thay đổi Entity.
- Các thành phần khác chỉ được tham chiếu.

## D005 — Lifecycle

- **Execution**: Created → Prepared → Running → Completed → Archived
- **Artifact**: Created → Published → Consumed → Archived
- **Context**: Allocated → Active → Released
- **Event**: Created → Published → Immutable
- **State**: Created → Running → Terminal
- **Result**: Created → Published → Consumed → Archived
- **Snapshot**: Captured → Stored → Restored
- **Lineage**: Created → Completed

**Lifecycle Rule:** Không Entity nào được quay ngược lifecycle (Completed → Running là bất hợp lệ).

> Tham chiếu S009 State Machine.

## D006 — Data Classification

| Loại | Chứa |
|------|------|
| Runtime Data | Execution Data, Metadata |
| Execution Data | Execution, Agent Assignment, Resource Allocation |
| Transient | Context, Execution State |
| Persistent Metadata | Artifacts, Events, Metrics, Trace, Result, Snapshot, Lineage |
| Reference Data | Workflow Ref, Capability Ref |

Runtime **không quản lý**: Business Data, Knowledge, Plugin Data, User Data, Database Records.

> Hữu ích cho Persistence sau này.

## D007 — Data Invariants (15)

- Execution có đúng một Context.
- Execution có đúng một State.
- Event không thay đổi.
- Artifact immutable.
- Context isolated.
- Execution có duy nhất một Terminal State.
- Execution ID toàn cục.
- Execution luôn có Owner.
- Execution luôn có Metadata.
- Execution luôn có Version.
- Execution luôn có Lifecycle.
- Execution không đổi Identity.
- Context không đổi Owner.
- Artifact không đổi Checksum.
- Event không đổi Timestamp.

## D008 — Identity Rules

Toàn AIOS thống nhất:

- ExecutionID, ContextID, EventID, ArtifactID, CapabilityID, WorkflowID, StateID, TaskID, PhaseID, ResultID...

**Rules:**

- Mọi Entity có ID duy nhất toàn cục.
- Identity không đổi trong vòng đời (P009).
- Không dùng GUID lẫn lộn giữa các loại entity.

## D009 — Reference Rules

**Reference Types:**

- **Strong Reference**: Workflow Ref, Capability Ref.
- **Weak Reference**: Artifact Ref, Agent Ref.
- **External Reference**: Plugin Ref.

**Rules:**

- Runtime dùng Reference thay vì Object Ownership.
- Không copy object.
- Không duplicate data (P009).

## D010 — Consistency Rules

**Consistency Levels:**

- Execution Consistency.
- Context Consistency.
- State Consistency.
- Artifact Consistency.

**Rules:**

- State luôn hợp lệ.
- Context không bị chia sẻ.
- Artifact luôn immutable.
- Metrics chỉ append.
- Event chỉ append.

## D011 — Dependency Graph

```text
Workflow → Execution → Context → State → Assignment → Events → Artifacts → Result
```

> Không dependency ngược.

## D012 — Validation Rules (20)

Doctor kiểm tra:

1. Duplicate IDs
2. Invalid References
3. Broken Ownership
4. Invalid Lifecycle
5. Invalid State
6. Missing Metadata
7. Invalid Version
8. Invalid Checksum
9. Invalid Aggregate
10. Context Leak
11. Multiple Context
12. Missing Result
13. Event Ordering
14. Circular Reference
15. Missing Owner
16. Missing Created Time
17. Invalid Lineage
18. Invalid Artifact
19. Broken Trace
20. Invalid Capability Reference

## D013 — Canonical Mapping

```text
Execution → Context → State → Assignments → Events → Artifacts → Metrics
    → Dashboard → Doctor → Replay
```

## D014 — Machine-readable

```text
runtime-data-model.yaml
runtime-entities.yaml
runtime-relations.yaml
runtime-ownership.yaml
runtime-lifecycle.yaml
runtime-validation.yaml
runtime-identities.yaml
runtime-references.yaml
runtime-invariants.yaml
runtime-data.schema.json
```

## D015 — Data Principles (mới)

- **Single Source of Truth** (P009)
- **Immutable by Default** (P010)
- **Reference over Copy**
- **Append Only**
- **Metadata First** (P003)
- **Version First** (P004)
- **Owner First**
- **Traceable**
- **Deterministic**
- **Machine Readable** (P017)

## D016 — Data Metrics (mới)

Dashboard đọc:

```yaml
entity_count: 15
reference_count: 0
broken_references: 0
aggregate_size: 8
event_count: 0
artifact_count: 0
execution_count: 0
consistency_score: 100
ownership_violations: 0
identity_violations: 0
```

## D017 — Traceability (mới)

```text
Entity → Requirement → Responsibility → Boundary → Contract → State → Implementation → Doctor
```

> Dashboard dựng toàn bộ graph từ traceability này.

## D018 — Success Criteria

Hoàn thành khi:

- Runtime chỉ có một Canonical Data Model.
- Không còn định nghĩa Entity trùng lặp trong các SPEC khác.
- S009 (State Machine) chỉ sử dụng Entity của S008.
- S010 (Execution Flow) chỉ thao tác trên Entity của S008.
- Doctor kiểm tra toàn bộ Data Model từ file machine-readable.
- Dashboard dựng sơ đồ Entity + Relationship không cần đọc implementation.

## Tham chiếu

- `runtime-data-model.yaml` — nguồn dữ liệu chuẩn.
- `runtime-entities.yaml` — D001.
- `runtime-relations.yaml` — D002.
- `runtime-ownership.yaml` — D004.
- `runtime-lifecycle.yaml` — D005.
- `runtime-validation.yaml` — D012 (20 rules).
- `runtime-identities.yaml` — D008.
- `runtime-references.yaml` — D009.
- `runtime-invariants.yaml` — D007.
- `runtime-data.schema.json` — validate cấu trúc.
- Canonical Models: `../runtime-models/`
- S009: `../S009/state-machine.yaml`
- Constitution: `docs/specs/SPEC-000/`
