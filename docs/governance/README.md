---
name: aios-governance
description: >
  AIOS Governance Framework (D005) — cách AIOS được quản lý, thay đổi, phát hành
  và phát triển. 14 policies + 6 lifecycles + Decision Framework + Templates.
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
├── review-workflow.md   # Review workflow v2.0 — 2 trục trạng thái + 6 types + decision matrix
├── review-tracker.yaml  # Review tracker — nguồn sự thật (document.lifecycle + review.status)
├── review-history.yaml  # Global review log (append-only, review_id REV-*)
├── review-status.yaml   # 2 trục trạng thái + mapping + inheritance
├── review-severity.yaml # Severity + Decision Matrix + deduction
├── review-matrix.yaml   # Ma trận check bắt buộc theo review type
├── review-score.yaml    # Score model 0-100 + weights
├── review-rules.yaml    # SLA, counting, freeze, report rules
├── review-trigger.yaml  # Trigger review lại + cascade rule
├── review-metrics.yaml  # Metrics + aggregation
├── review.schema.json   # Schema validate tracker/history/report
├── reviews/             # Review reports (REV-*.md, append-only)
├── metrics.yaml         # Governance metrics (Dashboard)
├── audit-policy.yaml    # Audit trail + governance events
├── policies/          # 14 policies (POLICY-001..014)
├── lifecycle/         # 6 lifecycles
├── decisions/         # ADR, RFC, DECISION_TREE
└── templates/         # ADR, RFC, CHANGELOG template
```

## Review Workflow v2.0 (2-pass, 2 trục)

Mọi tài liệu AIOS (SPEC, mục S0xx) bắt buộc review **tối thiểu 2 lần**, với **2 trục trạng thái tách bạch**:

```text
Document Lifecycle:  Draft → Review → Approved → Frozen → Deprecated → Archived
Review Lifecycle:    NotReviewed → (review 1) → Rev1 → (review 2) → Completed
```

- **6 types**: `rev1` · `revfull` (deep research) · `health` (không tăng count) · `compliance` · `migration` · `regression`
- **Verdict = Decision Matrix** (CRITICAL→FAIL, MAJOR→CONDITIONAL, 0/0→PASS) — loại bỏ chủ quan.
- Score 0–100 + coverage cho Dashboard trend; cascade_review cho Doctor lập task regression (TRG-002).
- Mục đã review/Freeze (SPEC-000, S001–S008) **giữ nguyên cả 2 trạng thái** (inherited).
- Điều hành: `/review <SPEC> <mục> [type]` · `/review status` · `/review scan`.
- Chi tiết: `review-workflow.md` + `.opencode/commands/review.md`.

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
| Specification | Draft → Review → Approved → Frozen → Deprecated → Archived (2 trục: review riêng NotReviewed → Rev1 → Completed) |
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
- **`review-workflow.md`** — quy trình review 2-pass + 6 types + decision matrix.
- **`review-tracker.yaml`** — nguồn sự thật: document.lifecycle + review.status từng mục.
- **`review-history.yaml`** — global log review (append-only).
- **`review-status.yaml` / `review-severity.yaml` / `review-matrix.yaml` / `review-score.yaml`** — status ladder, severity + verdict, matrix check, score model.
- **`review-rules.yaml` / `review-trigger.yaml` / `review-metrics.yaml`** — SLA, trigger + cascade, metrics.
- **`review.schema.json`** — schema validate tracker/history/report.
- **`reviews/`** — review reports (append-only).
- **`metrics.yaml`** — Dashboard đọc metrics.
- **`audit-policy.yaml`** — Doctor/Audit dùng.
- **`governance.schema.json`** — validate policy template.

## Tham chiếu

- Principles: `docs/principles/` (P001–P020)
- Rules: `docs/rules/` (RULE-001..015)
- Glossary: `docs/glossary/`
- Constitution: `docs/specs/SPEC-000/`
