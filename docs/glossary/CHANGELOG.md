---
name: aios-glossary-changelog
description: Changelog của AIOS Glossary.
agent: general
---

# AIOS Glossary — Changelog

## v3.1.0 (2026-08-03)

### Changed

- Promote 16 term files từ `status: Draft` → **`status: Approved`** (đạt DoD SPEC-000 #1: D001-D005 Stable) — qua RFC + ADR theo RULES.md Rule 4.

## v3.0.0 (2026-08-03) — Domain Model

### Added

- **Taxonomy** (`taxonomy.yaml`) — 7 category: Core/Execution/EntryPoint/Data/Knowledge/Platform/Extension + entity_types.
- **Relationships** (`relationships.yaml`) — ownership matrix + cardinality (UML) + main flow.
- **CATALOG.md** — danh mục thuật ngữ đầy đủ (16 term, taxonomy, invariants).
- **Domain Model template** — thêm vào mỗi term: `version`, `since`, `owner`, `stability`, `tags`, `aliases`, `deprecated_aliases`, `normative` (MUST/MUST NOT/SHOULD/MAY), `states`, `entity_type`, `invariants`, `depends_on`.
- Mỗi term có `id: TERM-###` (TERM-001..TERM-016).

### Changed

- Đổi `id` từ slug (runtime) → **TERM-###**.
- README.md giờ chỉ giới thiệu; danh mục chuyển sang **CATALOG.md**.
- 16 term files chuyển vào `terms/` subfolder.
- `related`/`depends_on` tham chiếu TERM-### thay vì slug.
- Schema cập nhật theo template Domain Model.

## v2.0.0 (2026-08-03)

### Added

- **16 term files** theo template D002 chuẩn:
  `runtime`, `workflow`, `phase`, `task`, `capability`, `agent`, `skill`,
  `command`, `artifact`, `context`, `memory`, `knowledge`, `event`,
  `registry`, `plugin`, `contract`.
- **RULES.md** — 4 luật bắt buộc (một nghĩa, không đồng nghĩa, tham chiếu Glossary, đổi qua ADR+RFC).
- **glossary.schema.json** — JSON Schema cho template term.

### Removed

- Xóa 7 term ngoài phạm vi: `entity`, `kernel`, `lifecycle`, `metadata`, `state`, `status`, `version` (tránh chồng chéo trách nhiệm).

### Changed

- Thay đổi template cũ (Term/Owns/Does not own) → template D002 (id/name/status/category/summary/definition/purpose/responsibilities/does_not_responsible/owned_by/used_by/inputs/outputs/lifecycle/related/examples/references).
- Cập nhật reference principle theo số mới P001-P020.

## v1.0.0 (2026-08-03)

### Added

- Glossary đầu tiên (23 term files, template Owns/Does not own).
