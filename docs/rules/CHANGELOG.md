---
name: aios-rules-changelog
description: Changelog của AIOS Architecture Rules.
agent: general
---

# AIOS Architecture Rules — Changelog

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
