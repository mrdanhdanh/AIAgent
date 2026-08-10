---
name: spec-002-w015-resources
description: >
  SPEC-002 W015 — Workflow Resources. Trả lời: Workflow dùng tài nguyên như
  thế nào? Workflow dùng Resource của Runtime (S015) — quota khai báo qua
  binding (W012). Mirror S015 (SPEC-001).
agent: general
---

# W015 — Workflow Resources

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow dùng tài nguyên như thế nào?**

## WRC001 — Resource Philosophy

- Workflow dùng Resource của Runtime (S015) — không quản lý riêng.
- Quota khai báo qua binding (W012 WPB-004).
- Không Resource nào bị Leak.
- Workflow không hardcode tài nguyên.

## WRC002 — Resource Principles

- **Allocated** — cấp phát tường minh (S015).
- **Released** — giải phóng trên Terminal State (S015).
- **Bounded** — quota qua binding (W012).
- **Observable** — quan sát qua S011 (S015).
- **Traceable** — mọi allocation truy vết (S015).

## WRC003 — Resource Categories

Dùng 10 categories của S015 RS003: Capability · Execution · Context · Memory · Storage · Compute · Network · Quota · Token · Time.

## WRC004 — Canonical Workflow Resource Model

```yaml
resource:
  fields: [id, type, category, owner, status, capacity, allocated, quota, references, metadata]
```

(S015 RS004) — `allocated` không vượt `capacity` và `quota`.

## WRC005 — Resource Lifecycle

```text
Draft → Available → Allocated → In Use → Released → Depleted
```

(S015 RS005) — Release trên Terminal State (S009).

## WRC006 — Resource Allocation

```text
Request (workflow step)
    ↓
Binding Check (W012 WPB-004 → POL-RES-001)
    ↓
Allocate (S015 qua Runtime)
    ↓
Bind to Step
    ↓
Track (S011)
```

**Rules:** Không Double Allocation (S015); Queue khi không có sẵn (POL-RES-001).

## WRC007 — Resource Access

```text
Request → Binding Check (W012 WPB-010 → POL-RESACC-001) → Grant / Deny
```

Deny mặc định (S013).

## WRC008 — Resource Ownership

| Resource | Owner |
|----------|-------|
| Workflow Execution | Workflow (qua Runtime S015) |
| Quota | Workflow Team (khai báo) |
| Resource | Runtime (S015) |

## WRC009 — Resource Constraints

- Không Double Allocation (S015).
- Không Resource Leak (S015).
- Tôn trọng quota binding (W012).
- Release trên Terminal State (S009).

## WRC010 — Workflow Resource Registry

- Resource đăng ký trong Registry (S014).
- Binding tham chiếu policy (S012).
- Resolution qua Registry trước khi Allocation.

## WRC011 — Resource Events

- WORKFLOW_RESOURCE_ALLOCATED · RELEASED · EXHAUSTED · LEAKED · DENIED · QUEUED.

> W015 định nghĩa 6 event types WORKFLOW_RESOURCE_* — S011 cung cấp event model (fields, correlation_id).

## WRC012 — Resource Metrics

- workflow_resource_allocations · releases · active_workflow_resources · leak_count · exhaustion_count · quota_utilization · denied_count.

## WRC013 — Resource Governance

- Allocation qua Governance (S013): Binding Check + Governance Check.
- Violation → Deny + Invalid Audit (S013).
- Isolation theo S012 POL-ISOL-001 (binding WPB-008).

## WRC014 — Resource Validation

Doctor kiểm tra:

- Double Allocation (S015)
- Resource Leak (S015)
- Quota Violation (binding W012)
- Undefined Resource
- Release sai Terminal State (S009)

## WRC015 — Machine-readable

```text
workflow-resources.yaml
workflow-resource-model.yaml
workflow-resource-categories.yaml
workflow-resource-lifecycle.yaml
workflow-resource-allocation.yaml
workflow-resource-access.yaml
workflow-resource-events.yaml
workflow-resource-metrics.yaml
workflow-resource-validation.yaml
workflow-resources.schema.json
```

## WRC016 — Traceability

```text
Workflow Step → Allocation (S015) → Execution (S008) → Artifact
```

## WRC017 — Success Criteria

- Workflow dùng Resource của Runtime (S015) — không quản lý riêng.
- Quota qua binding (W012) — không hardcode.
- Không Resource Leak.
- Không Double Allocation.
- Mọi allocation truy vết được.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- W012: `../W012/policies.md`
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- S015: `../../SPEC-001/S015/resources.md` (mẫu + resource chính)
- Constitution: `docs/specs/SPEC-000/`
