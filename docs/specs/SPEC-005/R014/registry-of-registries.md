---
name: spec-005-r014-registry-of-registries
description: SPEC-005 R014 — Registry-of-Registries.
agent: general
---

# R014 — Registry-of-Registries

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry tự đăng ký và được khám phá như thế nào?**

## RRG001 — Philosophy

- Registry đăng ký chính nó trong S014.
- Registry-of-Registries là điểm vào duy nhất cho mọi Registry.
- Dashboard chỉ cần đọc một file.

## RRG002 — Principles

- Single File · Metadata First · Versioned · Discoverable.

## RRG003 — Categories

- Capability · Workflow · Contract · Policy · Plugin · Agent Registry.

## RRG004 — Canonical Entry

```yaml
entry:
  fields: [id, type, category, version, status, owner, references, compatibility, lifecycle, metadata]
```

## RRG005 — Resolution

```text
Request → Lookup (S014) → Candidate Selection → Governance Check (S013) → Resolved
```

## RRG006 — Resolution Rules

- Resolve theo ID (S014). · Không Resolve Deprecated nếu có bản Active.

## RRG007 — Version Resolution

- Exact → Compatible → Latest Compatible → Failure.

## RRG008 — Relationships

- Registry → Sub Registries (capability/workflow/contract/policy/plugin/agent).

## RRG009 — Ownership

- Registry-of-Registries → Registry Team. · Sub Registry → Owner riêng.

## RRG010 — Lifecycle

```text
Draft → Published → Deprecated → Retired
```

## RRG011 — Constraints

- Không Duplicate Registry ID · Không Broken Reference (S014) · Không Circular Reference (S014) · Không Orphan Registry.

## RRG012 — Events

- REGISTRY_REGISTERED · UPDATED · DEPRECATED · RETIRED.

## RRG013 — Metrics

- registry_count · active_registries · resolution_success_rate.

## RRG014 — Machine-readable

```text
registry-of-registries.yaml
registry-of-registries-registry.yaml
registry-of-registries.schema.json
```

## RRG015 — Success Criteria

- Registry đăng ký chính nó trong S014. · Dashboard đọc 1 file. · Không orphan registry.

## Tham chiếu

- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
