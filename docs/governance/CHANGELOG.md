---
name: aios-governance-changelog
description: Changelog của AIOS Governance Framework.
agent: general
---

# AIOS Governance Framework — Changelog

## v1.1.0 (2026-08-03) — Governance System

### Added

- **roles.yaml** — Governance Roles (Architecture Board / Core Owner / Runtime Owner / Plugin Owner / Spec Owner) + approval_matrix.
- **compliance.yaml** — mandatory/recommended/optional + principles_mapping (14 policies).
- **review-cycle.yaml** — principles yearly, rules quarterly, specifications monthly, plugins monthly, policies quarterly.
- **metrics.yaml** — approval_time, policy_compliance, breaking_changes, deprecated_entities, plugin_quality.
- **audit-policy.yaml** — audit_trail flow (Change→Reviewer→Decision→Artifact→History) + 8 governance events.
- **POLICY-014** Exception — ngoại lệ có kiểm soát (approval + expiration + rationale, review 30d).
- **policy-lifecycle.md** — Draft→Review→Approved→Active→Deprecated→Retired.
- **scope** field cho mọi policy (applies_to / excludes).
- **Emergency Path** trong DECISION_TREE (Critical Bug→Emergency Fix→Temporary Approval→Hotfix Release→Post Review ADR).
- governance-registry.yaml: thêm metadata (owner/last_review/next_review) + emergency_path + events + policy lifecycle.

## v1.0.0 (2026-08-03)

### Added

- **13 policies** (POLICY-001..013): Approval, Version, Compatibility, Deprecation, Release, Documentation, Naming, Plugin, Security, Quality, Traceability, Ownership, Change Impact Analysis.
- **5 lifecycles**: entity, workflow, plugin, artifact, specification.
- **Decision Framework**: ADR.md, RFC.md, DECISION_TREE.md.
- **Templates**: ADR-template, RFC-template, CHANGELOG-template.
- **governance-registry.yaml** — registry trung tâm (policies + lifecycles + decision).
- **INDEX.yaml** — index 13 policies + 5 lifecycles + decisions + templates.
- **governance.schema.json** — validate policy template.

### Removed

- Xóa 6 file flat cũ: adr.md, approval.md, naming.md, release.md, review.md, rfc.md (thay bằng framework cấu trúc).

### Changed

- Governance từ tài liệu → **Governance Framework** (registry + policies + lifecycles + decision).
