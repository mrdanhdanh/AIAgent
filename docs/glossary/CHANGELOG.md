---
name: aios-glossary-changelog
description: Changelog của AIOS Glossary.
agent: general
---

# AIOS Glossary — Changelog

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
