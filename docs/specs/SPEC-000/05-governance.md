---
name: spec-000-05-governance
description: >
  SPEC-000 Part 05 — Governance Framework. Assemble từ docs/governance/.
agent: general
---

# 05 — Governance Framework

> Phần này **tham chiếu**, không định nghĩa lại. Nguồn sự thật: `docs/governance/`.

## Nội dung

| Điều | Nguồn |
|------|-------|
| 14 policies (POLICY-001..014) | `docs/governance/policies/` |
| 6 lifecycles | `docs/governance/lifecycle/` |
| Decision framework | `docs/governance/decisions/` |
| Templates | `docs/governance/templates/` |
| Roles | `docs/governance/roles.yaml` |
| Compliance | `docs/governance/compliance.yaml` |
| Review cycle | `docs/governance/review-cycle.yaml` |
| Metrics | `docs/governance/metrics.yaml` |
| Audit | `docs/governance/audit-policy.yaml` |

## 14 Policies

| ID | Name | Category |
|----|------|----------|
| POLICY-001 | Approval | Approval |
| POLICY-002 | Version | Versioning |
| POLICY-003 | Compatibility | Compatibility |
| POLICY-004 | Deprecation | Lifecycle |
| POLICY-005 | Release | Release |
| POLICY-006 | Documentation | Documentation |
| POLICY-007 | Naming | Naming |
| POLICY-008 | Plugin | Plugin |
| POLICY-009 | Security | Security |
| POLICY-010 | Quality | Quality |
| POLICY-011 | Traceability | Decision |
| POLICY-012 | Ownership | Decision |
| POLICY-013 | Change Impact Analysis | Decision |
| POLICY-014 | Exception | Decision |

## Decision Framework

```text
Need Change → Breaking? → Yes → RFC
              No → Affects multiple? → Yes → ADR
              No → Minor/format? → Yes → Direct
              No → ADR
```

**Emergency Path**: Critical Bug → Emergency Fix → Temporary Approval → Hotfix Release → Post Review ADR.

## Ràng buộc

- Mọi Entity có lifecycle chuẩn.
- Mọi quyết định governance phát Event + ghi audit trail.
- Policy bất biến sau Approved — đổi → version mới.

## Tham chiếu

- `docs/governance/README.md`
- `docs/governance/governance-registry.yaml`
- `docs/governance/compliance.yaml`
