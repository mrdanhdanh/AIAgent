---
name: aios-rules-changelog
description: Changelog của AIOS Architecture Rules.
agent: general
---

# AIOS Architecture Rules — Changelog

## v2.1.0 (2026-08-03) — Policy Engine

### Added

- **Policy metadata** mỗi rule: `policy_type: mandatory`, `severity`, `compliance`, `enforcement` (runtime/doctor/validator/dashboard) — Rule thành **Policy**.
- **RULE-014** Observability Contract — Runtime bắt buộc phát telemetry (Metrics→Logs→Events→Artifacts).
- **RULE-015** Backward Compatibility — mỗi thay đổi khai báo backward/forward/migration.
- **architecture-registry.yaml** (đổi tên từ architecture.yaml) — Architecture Registry: layers (level/depends_on/provides/consumes/owns/emits/principles/rules) + allowed_dependencies + forbidden_dependencies + ownership + interactions.
- RULE-004: thêm **Execution State Machine** (Created→Validated→Ready→Running→Completed + Failed→Retry).
- RULE-007: thêm **Event Taxonomy** (Workflow/Task/Artifact/Doctor/Simulation/Runtime).
- RULE-008: thêm **Permission Model** (Runtime/Agent/Skill/Plugin permissions).
- RULE-013: thêm **Determinism Definition** (required_inputs/allowed_variance/forbidden_variance).

## v2.0.0 (2026-08-03) — 13 Rules

### Added

- **13 rule files** (RULE-001..RULE-013), mỗi rule một file:
  - RULE-001 Layering, RULE-002 Dependency, RULE-003 Communication, RULE-004 Execution,
  - RULE-005 State, RULE-006 Data Flow, RULE-007 Event, RULE-008 Security,
  - RULE-009 Versioning, RULE-010 Extension, RULE-011 Resource Ownership,
  - RULE-012 Failure Isolation, RULE-013 Deterministic Execution.
- **architecture.yaml** — 9 layers + `depends_on` + `term_layer` (Doctor sinh Dependency Graph/Layer Diagram).
- **INDEX.yaml** — 13 rules + category + dependencies.
- Template D004: id/name/status/version/category/statement/purpose/rules/constraints(allowed/forbidden)/examples/related_principles/related_rules/verification.
- Đổi tên file: `layering.md`→`RULE-001-layering.md`, v.v.

### Changed

- 6 rules cũ (layering/dependency/communication/versioning/state/security) → 13 rules đầy đủ.
- Thêm 3 rule mới: RULE-011 Resource Ownership, RULE-012 Failure Isolation, RULE-013 Deterministic Execution.

## v1.0.0 (2026-08-03)

### Added

- 6 rule files (R-LAYER..R-SEC) + INDEX.yaml + schema.
