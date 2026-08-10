---
name: spec-005-r015-resources
description: SPEC-005 R015 — Registry Resources.
agent: general
---

# R015 — Registry Resources

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry dùng tài nguyên như thế nào?**

## RRS001 — Resource Philosophy

- Registry dùng Resource của Runtime (S015) — không quản lý riêng.
- Quota khai báo qua binding (R012 RPB-004).
- Không Resource nào bị Leak.

## RRS002 — Resource Principles

- Allocated · Released (Terminal State) · Bounded (quota binding R012) · Observable (S011) · Traceable (S015).

## RRS003 — Resource Categories

- 10 categories của S015 RS003.

## RRS004 — Canonical Resource Model

```yaml
resource:
  fields: [id, type, category, owner, status, capacity, allocated, quota, references, metadata]
```

## RRS005 — Resource Lifecycle

```text
Draft → Available → Allocated → In Use → Released → Depleted
```

## RRS006 — Resource Allocation

```text
Request (registry resolution) → Binding Check (RPB-004 → POL-RES-001) → Allocate (S015) → Bind to Entry → Track (S011)
```

## RRS007 — Resource Access

```text
Request → Binding Check (RPB-010 → POL-RESACC-001) → Grant / Deny
```

## RRS008 — Resource Ownership

- Registry Resolution → Registry · Quota → Registry Team · Resource → Runtime (S015).

## RRS009 — Resource Constraints

- Không Double Allocation · Không Leak · Tôn trọng quota binding · Release trên Terminal State (S009).

## RRS010 — Resource Registry

- Resource đăng ký trong Registry (S014).

## RRS011 — Resource Events

- REGISTRY_RESOURCE_ALLOCATED · RELEASED · EXHAUSTED · LEAKED · DENIED · QUEUED.

## RRS012 — Resource Metrics

- registry_resource_allocations · releases · active · leak_count · exhaustion_count · quota_utilization · denied_count.

## RRS013 — Resource Governance

- Allocation qua Governance (S013). · Violation → Deny + Invalid Audit.

## RRS014 — Resource Validation

- Double Allocation · Resource Leak · Quota Violation (binding R012) · Undefined Resource · Release sai Terminal State (S009).

## RRS015 — Machine-readable

```text
registry-resources.yaml
registry-resource-model.yaml
registry-resource-categories.yaml
registry-resource-lifecycle.yaml
registry-resource-allocation.yaml
registry-resource-access.yaml
registry-resource-events.yaml
registry-resource-metrics.yaml
registry-resource-validation.yaml
registry-resources.schema.json
```

## RRS016 — Traceability

```text
Registry Resolution → Allocation (S015) → Execution (S008) → Artifact
```

## RRS017 — Success Criteria

- Registry dùng Resource của Runtime (S015). · Quota qua binding (R012). · Không Leak/Double Allocation. · Doctor xác minh từ machine-readable.

## Tham chiếu

- R012: `../R012/policies.md`
- S015: `../../SPEC-001/S015/resources.md`
- Constitution: `docs/specs/SPEC-000/`
