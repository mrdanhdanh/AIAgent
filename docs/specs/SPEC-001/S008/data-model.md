---
name: spec-001-s008-data-model
description: >
  SPEC-001 S008 — Runtime Data Model. Trả lời: Runtime quản lý những dữ liệu nào
  và quan hệ giữa chúng ra sao? Canonical Data Model. 15 sections D001-D015.
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

Chuẩn hóa toàn bộ dữ liệu Runtime để State Machine, Execution Flow, Contract, Event, Doctor, Dashboard, Plugin đều dùng chung một mô hình.

## D001 — Runtime Entities (12)

| ID | Entity | Canonical Model | Owner |
|----|--------|-----------------|-------|
| ENT-001 | Execution | RM-001 | Runtime |
| ENT-002 | Execution Context | RM-005 | Runtime |
| ENT-003 | Execution State | RM-006 | Runtime |
| ENT-004 | Workflow Reference | RM-002 | Workflow |
| ENT-005 | Capability Reference | RM-010 | Registry |
| ENT-006 | Agent Assignment | (execution-specific) | Runtime |
| ENT-007 | Event | RM-007 | Runtime |
| ENT-008 | Artifact | RM-008 | Runtime |
| ENT-009 | Metrics | (execution-specific) | Runtime |
| ENT-010 | Trace | (execution-specific) | Runtime |
| ENT-011 | Resource Allocation | (execution-specific) | Runtime |
| ENT-012 | Execution Result | RM-012 | Runtime |

> Mỗi entity tham chiếu Canonical Model — không định nghĩa lại (SPEC-001A rule).

## D002 — Entity Relationships

```text
Workflow
      │
      ▼
Execution
      │
      ├──────── Context
      ├──────── State
      ├──────── Event *
      ├──────── Artifact *
      ├──────── Metrics *
      ├──────── Trace *
      ├──────── Agent Assignment *
      └──────── Result
```

> **Execution là Aggregate Root.**

## D003 — Aggregate Rules

Execution sở hữu:

- Context
- State
- Event
- Metrics
- Trace
- Artifact Reference
- Result

> Không entity nào ngoài Runtime được phép sửa.

## D004 — Entity Ownership

| Entity | Owner |
|--------|-------|
| Execution, Context, State, Event, Artifact, Metrics, Trace, Result | Runtime |
| Workflow Reference | Workflow (tham chiếu) |
| Capability Reference | Registry (tham chiếu) |
| Agent Assignment | Runtime |

> Workflow chỉ tham chiếu. Registry chỉ tham chiếu. Agent không sở hữu.

## D005 — Entity Lifecycle

- **Execution**: Created → Prepared → Running → Completed → Archived
- **Artifact**: Created → Published → Consumed → Archived
- **Context**: Allocated → Active → Released
- **Event**: Created → Published → Immutable
- **State**: Created → Running → Terminal
- **Result**: Created → Published → Consumed → Archived

> Tham chiếu S009 State Machine.

## D006 — Data Classification

Runtime **chỉ quản lý**:

- Execution Data
- Context
- Metadata
- Events
- Metrics
- Artifact Metadata

Runtime **không quản lý**:

- Business Data
- Knowledge
- Plugin Data
- User Data
- Database Records

## D007 — Data Invariants

- Execution có đúng một Context.
- Execution có đúng một State.
- Event không thay đổi.
- Artifact immutable.
- Context isolated.
- Execution có duy nhất một Terminal State.
- Execution ID toàn cục.

## D008 — Identity Rules

Mọi Entity đều có:

- ID
- Version
- Owner
- Created Time
- Metadata
- Status

> Không entity nào không định danh. Identity theo SPEC-001A (ExecutionID, ContextID...).

## D009 — Reference Rules

Runtime dùng **Reference** thay vì Object Ownership:

```text
Execution → Workflow Ref → Capability Ref → Artifact Ref
```

- Không copy object.
- Không duplicate data (P009).

## D010 — Consistency Rules

- State luôn hợp lệ.
- Context không bị chia sẻ.
- Artifact luôn immutable.
- Metrics chỉ append.
- Event chỉ append.

## D011 — Data Dependencies

```text
Execution → Context → State → Events → Artifacts → Metrics
```

> Không dependency ngược.

## D012 — Data Validation

Doctor kiểm tra:

- Execution không có Context.
- Execution có nhiều State.
- Artifact bị sửa.
- Event bị sửa.
- Context chia sẻ.
- Reference hỏng.
- Version sai.

## D013 — Canonical Mapping

```text
Execution → State → Event → Artifact → Metrics → Dashboard
```

## D014 — Machine-readable

```text
runtime-data-model.yaml
runtime-entities.yaml
runtime-relationships.yaml
runtime-lifecycle.yaml
runtime-ownership.yaml
runtime-validation.yaml
runtime-references.yaml
runtime-data.schema.json
```

## D015 — Success Criteria

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
- `runtime-relationships.yaml` — D002.
- `runtime-lifecycle.yaml` — D005.
- `runtime-ownership.yaml` — D004.
- `runtime-references.yaml` — D009.
- `runtime-validation.yaml` — D012.
- `runtime-data.schema.json` — validate cấu trúc.
- Canonical Models: `../runtime-models/`
- S009: `../S009/state-machine.yaml`
- Constitution: `docs/specs/SPEC-000/`
