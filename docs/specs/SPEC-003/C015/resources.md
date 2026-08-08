---
name: spec-003-c015-resources
description: >
  SPEC-003 C015 — Capability Resources. Trả lời: Capability dùng tài nguyên
  như thế nào? Capability dùng Resource của Runtime (S015) — quota khai báo
  qua binding (C012). Mirror W015 (SPEC-002).
agent: general
---

# C015 — Capability Resources

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability dùng tài nguyên như thế nào?**

## CRC001 — Resource Philosophy

- Capability dùng Resource của Runtime (S015) — không quản lý riêng.
- Quota khai báo qua binding (C012 CPB-004).
- Không Resource nào bị Leak.
- Capability không hardcode tài nguyên.

## CRC002 — Resource Principles

- **Allocated** — cấp phát tường minh (S015).
- **Released** — giải phóng trên Terminal State (S015).
- **Bounded** — quota qua binding (C012).
- **Observable** — quan sát qua S011 (S015).
- **Traceable** — mọi allocation truy vết (S015).

## CRC003 — Resource Categories

Dùng 10 categories của S015 RS003: Capability · Execution · Context · Memory · Storage · Compute · Network · Quota · Token · Time.

## CRC004 — Canonical Capability Resource Model

```yaml
resource:
  fields: [id, type, category, owner, status, capacity, allocated, quota, references, metadata]
```

(S015 RS004) — `allocated` không vượt `capacity` và `quota`.

## CRC005 — Resource Lifecycle

```text
Draft → Available → Allocated → In Use → Released → Depleted
```

(S015 RS005) — Release trên Terminal State (S009).

## CRC006 — Resource Allocation

```text
Request (capability resolution)
    ↓
Binding Check (C012 CPB-004 → POL-RES-001)
    ↓
Allocate (S015 qua Runtime)
    ↓
Bind to Capability
    ↓
Track (S011)
```

**Rules:** Không Double Allocation (S015); Queue khi không có sẵn (POL-RES-001).

## CRC007 — Resource Access

```text
Request → Binding Check (C012 CPB-010 → POL-RESACC-001) → Grant / Deny
```

Deny mặc định (S013).

## CRC008 — Resource Ownership

| Resource | Owner |
|----------|-------|
| Capability Execution | Capability (qua Runtime S015) |
| Quota | Capability Team (khai báo) |
| Resource | Runtime (S015) |

## CRC009 — Resource Constraints

- Không Double Allocation (S015).
- Không Resource Leak (S015).
- Tôn trọng quota binding (C012).
- Release trên Terminal State (S009).

## CRC010 — Capability Resource Registry

- Resource đăng ký trong Registry (S014).
- Binding tham chiếu policy (S012).
- Resolution qua Registry trước khi Allocation.

## CRC011 — Resource Events

- CAPABILITY_RESOURCE_ALLOCATED · RELEASED · EXHAUSTED · LEAKED · DENIED · QUEUED.

> S011 reuse trực tiếp.

## CRC012 — Resource Metrics

- capability_resource_allocations · releases · active_capability_resources · leak_count · exhaustion_count · quota_utilization · denied_count.

## CRC013 — Resource Governance

- Allocation qua Governance (S013): Binding Check + Governance Check.
- Violation → Deny + Invalid Audit (S013).
- Isolation theo S012 POL-ISOL-001 (binding CPB-008).

## CRC014 — Resource Validation

Doctor kiểm tra:

- Double Allocation (S015)
- Resource Leak (S015)
- Quota Violation (binding C012)
- Undefined Resource
- Release sai Terminal State (S009)

## CRC015 — Machine-readable

```text
capability-resources.yaml
capability-resource-model.yaml
capability-resource-categories.yaml
capability-resource-lifecycle.yaml
capability-resource-allocation.yaml
capability-resource-access.yaml
capability-resource-events.yaml
capability-resource-metrics.yaml
capability-resource-validation.yaml
capability-resources.schema.json
```

## CRC016 — Traceability

```text
Capability Resolution → Allocation (S015) → Execution (S008) → Artifact
```

## CRC017 — Success Criteria

- Capability dùng Resource của Runtime (S015) — không quản lý riêng.
- Quota qua binding (C012) — không hardcode.
- Không Resource Leak.
- Không Double Allocation.
- Mọi allocation truy vết được.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C012: `../C012/policies.md`
- W015: `../../SPEC-002/W015/resources.md` (mẫu)
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- S015: `../../SPEC-001/S015/resources.md` (resource chính)
- Constitution: `docs/specs/SPEC-000/`
