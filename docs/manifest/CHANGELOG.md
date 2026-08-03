---
name: aios-manifest-changelog
description: Changelog của AIOS Manifest.
agent: general
---

# AIOS Manifest — Changelog

## v1.0.0 (2026-08-03)

### Added — nâng lên Enterprise

- **Identity**: domain, type, architecture, deployment.
- **Metadata**: kind (Manifest), apiVersion (aios/v1), manifestVersion, specVersion, constitution (SPEC-000).
- **Architecture Style**: Layered, Event Driven, Metadata Driven, Capability Driven, Plugin Oriented, Contract First.
- **Scope**: tách `included` / `excluded`.
- **Goals**: bỏ tham chiếu P0xx (Manifest không phụ thuộc Principle).
- **Design Values**: Simplicity, Explicitness, Consistency, Predictability, Composability, Reusability.
- **Maturity**: current (Architecture) / target (Enterprise).
- **Deliverables**: SPEC, Runtime, Doctor, Dashboard, Plugin SDK.
- **Source of Truth**: constitution, specifications, adr, rfc, glossary, principles, rules, governance.
- **Repository Layout**: docs/, .opencode/, plugins/, sdk/, runtime/.
- **Lifecycle**: Draft, Review, Approved, Deprecated.
- **Compatibility**: backward required, forward preferred, breaking_change requires_adr.
- **Cấu trúc thư mục**: thêm README.md, CHANGELOG.md, manifest.schema.json.
