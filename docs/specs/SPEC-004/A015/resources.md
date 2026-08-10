---
name: spec-004-a015-resources
description: >
  SPEC-004 A015 — Agent Resources. Trả lời: Agent dùng tài nguyên như thế nào?
  Agent dùng Resource của Runtime (S015) — quota khai báo qua binding (A012).
  Mirror C015 (SPEC-003).
agent: general
---

# A015 — Agent Resources

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent dùng tài nguyên như thế nào?**

## ARC001 — Resource Philosophy

- Agent dùng Resource của Runtime (S015) — không quản lý riêng.
- Quota khai báo qua binding (A012 APB-004).
- Không Resource nào bị Leak.
- Agent không hardcode tài nguyên.

## ARC002 — Resource Principles

- **Allocated** — cấp phát tường minh (S015).
- **Released** — giải phóng trên Terminal State (S015).
- **Bounded** — quota qua binding (A012).
- **Observable** — quan sát qua S011 (S015).
- **Traceable** — mọi allocation truy vết (S015).

## ARC003 — Resource Categories

Dùng 10 categories của S015 RS003: Capability · Execution · Context · Memory · Storage · Compute · Network · Quota · Token · Time.

## ARC004 — Canonical Agent Resource Model

```yaml
resource:
  fields: [id, type, category, owner, status, capacity, allocated, quota, references, metadata]
```

(S015 RS004) — `allocated` không vượt `capacity` và `quota`.

## ARC005 — Resource Lifecycle

```text
Draft → Available → Allocated → In Use → Released → Depleted
```

(S015 RS005) — Release trên Terminal State (S009).

## ARC006 — Resource Allocation

```text
Request (agent execution)
    ↓
Binding Check (A012 APB-004 → POL-RES-001)
    ↓
Allocate (S015 qua Runtime)
    ↓
Bind to Agent
    ↓
Track (S011)
```

**Rules:** Không Double Allocation (S015); Queue khi không có sẵn (POL-RES-001).

## ARC007 — Resource Access

```text
Request → Binding Check (A012 APB-010 → POL-RESACC-001) → Grant / Deny
```

Deny mặc định (S013).

## ARC008 — Resource Ownership

| Resource | Owner |
|----------|-------|
| Agent Execution | Agent (qua Runtime S015) |
| Quota | Agent Team (khai báo) |
| Resource | Runtime (S015) |

## ARC009 — Resource Constraints

- Không Double Allocation (S015).
- Không Resource Leak (S015).
- Tôn trọng quota binding (A012).
- Release trên Terminal State (S009).

## ARC010 — Agent Resource Registry

- Resource đăng ký trong Registry (S014).
- Binding tham chiếu policy (S012).
- Resolution qua Registry trước khi Allocation.

## ARC011 — Resource Events

- AGENT_RESOURCE_ALLOCATED · RELEASED · EXHAUSTED · LEAKED · DENIED · QUEUED.

> S011 reuse trực tiếp.

## ARC012 — Resource Metrics

- agent_resource_allocations · releases · active_agent_resources · leak_count · exhaustion_count · quota_utilization · denied_count.

## ARC013 — Resource Governance

- Allocation qua Governance (S013): Binding Check + Governance Check.
- Violation → Deny + Invalid Audit (S013).
- Isolation theo S012 POL-ISOL-001 (binding APB-008).

## ARC014 — Resource Validation

Doctor kiểm tra:

- Double Allocation (S015)
- Resource Leak (S015)
- Quota Violation (binding A012)
- Undefined Resource
- Release sai Terminal State (S009)

## ARC015 — Machine-readable

```text
agent-resources.yaml
agent-resource-model.yaml
agent-resource-categories.yaml
agent-resource-lifecycle.yaml
agent-resource-allocation.yaml
agent-resource-access.yaml
agent-resource-events.yaml
agent-resource-metrics.yaml
agent-resource-validation.yaml
agent-resources.schema.json
```

## ARC016 — Traceability

```text
Agent Execution → Allocation (S015) → Execution (S008) → Artifact
```

## ARC017 — Success Criteria

- Agent dùng Resource của Runtime (S015) — không quản lý riêng.
- Quota qua binding (A012) — không hardcode.
- Không Resource Leak.
- Không Double Allocation.
- Mọi allocation truy vết được.
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A012: `../A012/policies.md`
- C015: `../../SPEC-003/C015/resources.md` (mẫu)
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- S015: `../../SPEC-001/S015/resources.md` (resource chính)
- Constitution: `docs/specs/SPEC-000/`