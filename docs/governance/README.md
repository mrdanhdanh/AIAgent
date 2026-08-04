---
name: aios-governance
description: >
  AIOS Governance Framework (D005) — cách AIOS được quản lý, thay đổi, phát hành
  và phát triển. 13 policies + 5 lifecycles + Decision Framework + Templates.
  D005 không quản lý Runtime — quản lý toàn bộ AIOS.
agent: general
---

# AIOS Governance Framework

> **D005** — Nơi phân biệt AIOS với đa số framework Agent.
> Nhiều framework có Runtime/Workflow/Plugin, rất ít có **Governance Layer**.
> D005 quản lý **toàn bộ AIOS**, không phải Runtime.

## Cấu trúc

```text
docs/governance/
├── README.md
├── INDEX.yaml
├── governance-registry.yaml
├── governance.schema.json
├── roles.yaml           # Ai chịu trách nhiệm + approval matrix
├── compliance.yaml      # Mức bắt buộc + principles mapping
├── review-cycle.yaml    # Chu kỳ review (Evolution Engine)
├── metrics.yaml         # Governance metrics (Dashboard)
├── audit-policy.yaml    # Audit trail + governance events
├── policies/          # 14 policies (POLICY-001..014)
├── lifecycle/         # 6 lifecycles
├── decisions/         # ADR, RFC, DECISION_TREE
└── templates/         # ADR, RFC, CHANGELOG template
```

## Policies (14)

| ID | Policy | Category | Tóm tắt |
|----|--------|----------|---------|
| POLICY-001 | Approval | Approval | Không thay đổi nào đi thẳng vào Core |
| POLICY-002 | Version | Versioning | Semantic Versioning |
| POLICY-003 | Compatibility | Compatibility | backward required, forward preferred |
| POLICY-004 | Deprecation | Lifecycle | Không xóa trực tiếp |
| POLICY-005 | Release | Release | Release qua Simulation→Doctor→Validation→Approval |
| POLICY-006 | Documentation | Documentation | Human + Machine readable |
| POLICY-007 | Naming | Naming | Quy ước tên chuẩn |
| POLICY-008 | Plugin | Plugin | Install→Validate→Enable→Disable→Remove |
| POLICY-009 | Security | Security | Least Privilege, Sandbox, Audit, Approval |
| POLICY-010 | Quality | Quality | Validation/Doctor/Schema/Cross-ref pass |
| POLICY-011 | Traceability | Decision | Requirement→SPEC→Impl→Test→Artifact |
| POLICY-012 | Ownership | Decision | Mỗi Entity có Owner, không owner → không approved |
| POLICY-013 | Change Impact Analysis | Decision | Change→Impact→Simulation→Approval→Impl |
| POLICY-014 | Exception | Decision | Ngoại lệ có kiểm soát + expiration |

## Lifecycles (6)

| Lifecycle | States |
|-----------|--------|
| Entity | Draft → Review → Approved → Deprecated → Removed |
| Workflow | Created → Validated → Running → Completed |
| Plugin | Installed → Validated → Enabled → Disabled → Removed |
| Artifact | Created → Indexed → Consumed → Archived |
| Specification | Draft → Review → Approved → Implemented → Verified → Stable |
| Policy | Draft → Review → Approved → Active → Deprecated → Retired |

## Decision Framework

```text
Need Change
      │
Breaking? ──── Yes ────► RFC
      │
      No
      │
Affects multiple? ──── Yes ────► ADR
      │
      No
      │
Minor/format? ──── Yes ────► Direct
      │
      No
      ▼
     ADR
```

**Emergency Path** (Critical Bug → Emergency Fix → Temporary Approval → Hotfix Release → Post Review ADR bắt buộc) — xem `decisions/DECISION_TREE.md`.

## Governance Roles

```text
Governance Board
        │
 ┌──────┼────────┐
 │      │        │
Core   Runtime  Plugin
Owner  Owner    Owner
```

Xem `roles.yaml` — responsibilities + approval matrix.

## Governance Events

- Policy Approved · Policy Updated · ADR Created · RFC Accepted · Release Approved · Deprecation Started · Emergency Fix Applied · Exception Granted

Liên kết trực tiếp Event Bus (P005). Xem `audit-policy.yaml`.

## Machine-readable

- **`governance-registry.yaml`** — Registry trung tâm: policies + lifecycles + decision (+ emergency path) + events.
- **`INDEX.yaml`** — 14 policies + 6 lifecycles + decisions + templates + registries.
- **`roles.yaml`** — ai chịu trách nhiệm.
- **`compliance.yaml`** — mức bắt buộc + principles mapping.
- **`review-cycle.yaml`** — Evolution Engine tự nhắc review.
- **`metrics.yaml`** — Dashboard đọc metrics.
- **`audit-policy.yaml`** — Doctor/Audit dùng.
- **`governance.schema.json`** — validate policy template.

## Tham chiếu

- Principles: `docs/principles/` (P001–P020)
- Rules: `docs/rules/` (RULE-001..015)
- Glossary: `docs/glossary/`
- Constitution: `docs/specs/SPEC-000/`
