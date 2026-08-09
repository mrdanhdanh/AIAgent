---
name: spec-005-r013-governance
description: SPEC-005 R013 — Registry Governance.
agent: general
---

# R013 — Registry Governance

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry được thực thi luật như thế nào?**

## RGV001 — Governance Philosophy

- Governance là cơ chế thực thi luật.
- Registry không quyết định luật.
- Registry chỉ thực thi luật đã được định nghĩa (S012/S013).

## RGV002 — Governance Principles

- Constitution First · Policy Binding First (R012) · Contract First (R007) · Boundary First (R004) · Least Privilege · Deterministic · Auditable · Versioned.

## RGV003 — Governance Scope

**Thực thi:** Constitution · Policy Binding (R012) · Contract (R007) · Boundary (R004) · Permission (S013) · Version Compatibility.

**Không thực thi:** Business Rule · Domain Rule.

## RGV003A — Governance Stack

```text
Constitution → Boundary (R004) → Contract (R007) → Policy Binding (R012) → Permission → Execution Decision
```

## RGV004 — Constitution Enforcement

- Tham chiếu S013 GV004 — vi phạm → Aborted (ST-014).

## RGV005 — Policy Binding Enforcement

- Resolve → Validate (R012) → Apply (S013) → Audit (S011).
- Binding Invalid → Entry không lưu (Validation Failure).

## RGV005A — Conflict Resolution

- S013 GV005A: Highest Priority → Most Specific → Newest Version → **Deny Wins**.

## RGV006 — Contract Enforcement

- Tham chiếu R007 + S013 GV006.

## RGV007 — Boundary Enforcement

- Tham chiếu R004 + S013 GV007.

## RGV008 — Permission Enforcement

- Tham chiếu S013 GV008 — Deny mặc định.

## RGV009 — Version Governance

- SemVer · Compatibility · Deprecated · Breaking Change.

## RGV010 — Compatibility Governance

- Contract · Capability · Plugin · Agent.

## RGV011 — Validation Pipeline

```text
Constitution → Boundary (R004) → Contract (R007) → Policy Binding (R012) → Execution (Runtime SPEC-001)
```

## RGV011A — Governance Modes

- Strict · Compatible · Simulation · Audit Only (S013 GV011A).

## RGV012 — Governance Decision

- Model: `id/entry/rule/result/reason/timestamp/severity`.
- Priority: Constitution 100 · Boundary 90 · Contract 80 · Binding 70 · Permission 60.
- Matrix: Binding Invalid → Ignore.

## RGV012A — Governance Lifecycle

```text
Resolved → Validated → Applied → Audited → Archived
```

## RGV013 — Governance Events

- REGISTRY_GOVERNANCE_VALIDATED · BOUNDARY_DENIED · BINDING_APPLIED · CONTRACT_VALIDATED · PERMISSION_DENIED · VERSION_CONFLICT · COMPATIBILITY_FAILED.

## RGV014 — Governance Traceability

```text
Entry → Binding (R012) → Contract (R007) → Boundary (R004) → Constitution
```

## RGV014A — Governance Mapping

```text
Registry Governance → Binding (R012) → Contract (R007) → Boundary (R004) → Requirement (R002) → Constitution
```

## RGV015 — Governance Metrics

- violations · denied · warnings · binding_usage · contract_failures · boundary_failures · version_conflicts.

## RGV016 — Machine-readable

```text
registry-governance.yaml
registry-governance-stack.yaml
registry-binding-enforcement.yaml
registry-governance-matrix.yaml
registry-governance-events.yaml
registry-governance-decisions.yaml
registry-governance-lifecycle.yaml
registry-governance-metrics.yaml
registry-governance-registry.yaml
registry-governance.schema.json
```

## RGV017 — Governance Validation

- Missing Enforcement · Invalid Binding (R012) · Invalid Contract (R007) · Boundary Violation (R004) · Constitution Violation · Version Conflict.

## RGV018 — Success Criteria

- Registry luôn chịu Governance (S013). · Mọi binding enforce (R012). · Mọi contract validate (R007). · Không Entry vượt Boundary (R004). · Doctor xác minh từ machine-readable.

## Tham chiếu

- R004: `../R004/boundaries.md` · R007: `../R007/contracts.md` · R012: `../R012/policies.md`
- S013: `../../SPEC-001/S013/governance.md`
- Constitution: `docs/specs/SPEC-000/`
