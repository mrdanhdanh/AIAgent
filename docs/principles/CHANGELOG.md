---
name: aios-principles-changelog
description: Changelog của AIOS Core Principles.
agent: general
---

# AIOS Core Principles — Changelog

## v2.0.0 (2026-08-03)

### Added

- **20 principle files** (P001–P020), mỗi principle một file riêng:
  P001-runtime-first.md → P020-constitution-first.md.
- **INDEX.yaml** — principles (20) + dependencies (P→deps) + categories (6 nhóm).
- **principles.schema.json** — JSON Schema cho template D003.
- Metadata mỗi principle: `severity`, `enforced_by`, `implemented_in`, `breaking_change` (Doctor/Dashboard/Evolution đọc).

### Changed

- Đánh số lại theo chuẩn mới:
  - P004 Event Driven cũ → **P005**
  - P009 Versioned cũ → **P004**
  - P008 Observable cũ → **P014**
  - P012 Single Source cũ → **P009**
  - P013 Immutable Artifacts cũ → **P010**
  - P010 Plugin First cũ → **P012**
  - P011 Simulation cũ → **P013**
- Thêm principle mới: P008 Single Responsibility, P011 Explicit Dependency, P015 Fail Safe, P016 Human Approval, P017 AI Native, P018 Evolvable, P019 Open Extension Closed Core, P020 Constitution First.
- Bỏ: P007 Discoverable (gộp Registry), P014 Least Privilege (gộp P016), P015 Backward Compatible (gộp P018).
- Cập nhật reference từ manifest/glossary/rules.

### Removed

- Xóa 3 file cũ: `principles.md`, `architecture-principles.md`, `governance.md` (thay bằng 20 file + INDEX).

## v1.0.0 (2026-08-03)

### Added

- Core Principles P001–P015 (1 file principles.md).
- Architecture Principles A-001..A-006.
- Governance Principles G-001..G-007.
