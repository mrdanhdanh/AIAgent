---
name: aios-governance-changelog
description: Changelog của AIOS Governance Framework.
agent: general
---

# AIOS Governance Framework — Changelog

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
