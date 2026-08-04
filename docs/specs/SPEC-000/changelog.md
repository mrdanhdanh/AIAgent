---
name: spec-000-constitution-changelog
description: SPEC-000 changelog — lịch sử thay đổi Hiến pháp AIOS.
agent: general
---

# SPEC-000 — Changelog

## 3.0.0 — 2026-08-03

- **Chuyển sang mô hình Assemble hoàn toàn** — SPEC-000 không viết mới, chỉ lắp ráp D001-D005.
- Xóa 7 part files cũ + appendices (foundation/architecture/governance/lifecycle/quality/ai-native/glossary/principles + SUMMARY + building-blocks).
- Cấu trúc mới:
  - `SPEC.yaml` — metadata (includes D001-D005, authoritative, breaking_change_requires ADR+RFC).
  - `INDEX.yaml` — Constitution Registry (documents/principles/rules/policies/glossary_terms).
  - `01-manifest.md` → `05-governance.md` — 5 phần assemble tham chiếu.
  - `cross-reference.yaml` — P### → rules/policies/terms.
  - `dependency-map.yaml` — Manifest→Glossary→Principles→Rules→Governance.
  - `compliance-matrix.yaml` — component → principles/rules/policies.
  - `constitution.schema.json` — validate SPEC.yaml.
- 5 Foundational Registries: System/Domain/Policy/Architecture/Governance.

## 2.0.0 — 2026-08-02

- **Nâng cấp Enterprise Constitution**.
- Cấu trúc 7 Part, 30 chương:
  - Part I Foundation (1–5): Vision, Scope, Goals, Non Goals, Terminology.
  - Part II Constitutional Principles (P001–P015).
  - Part III Architecture (6–11): Layers, Object Model, Dependency, Communication, Execution, Data.
  - Part IV Governance (12–16): Versioning, Compatibility, Naming, Documentation, Decision Hierarchy.
  - Part V Lifecycle (17–20): Entity, Workflow, Plugin, Artifact.
  - Part VI Quality (21–24): Quality, Constraints, Error Philosophy, Security.
  - Part VII AI Native (25–30): Machine Readable, Human Readable, Executable Spec, AI Responsibilities, Evolution, Future.
- Thêm Appendix A–H (glossary, object/metadata/state/error/event/capability catalog, references).
- Đổi tên thư mục: SPEC-000-core-principles → **SPEC-000-constitution**.
- Đánh số lại principles: P001–P015 (bỏ P-xxx có dấu gạch).

## 1.0.0 — 2026-08-02

- Hiến pháp 6 Part, 23 chương.
- 15 core principles.

## 0.1.0 — 2026-08-02

- Khởi tạo Core Principles, 7 nguyên tắc ban đầu.