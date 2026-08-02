---
name: adr-005-artifact-store
description: ADR-005 — Quyết định kiến trúc Artifact Store: checksum + version + dependency, không trông cậy tên file.
agent: general
---

# ADR-005 — Artifact Store

## Status

Accepted (Phase 0.2, khóa kiến trúc). Implementation ở Phase 5.

## Problem

Phase sau cần kết quả phase trước (plan → design → test). Nếu chỉ trông cậy tên file (plan.md) → đè file, không biết version, không detect hư hỏng.

## Options

1. **Chỉ ghi file theo tên** — plan.md đè plan.md.
2. **Artifact Store có record** — mỗi artifact lưu record (type, checksum SHA-256, version vN, dependencies, status), file đi kèm.
3. **DB/backend riêng** — quá nặng cho framework hiện tại.

## Decision

Chọn **Option 2 — Artifact Store**: artifact là object theo DATA_MODEL.md (id, type, version, checksum, path, dependencies, status). Artifact Driven là nguyên tắc #5; Phase sau chỉ đọc artifact dependency, không đoán.

Lifecycle: Created → Validated (checksum khớp) → Versioned → Archived. Lỗi: ART-001 (missing dep), ART-002 (checksum mismatch), ART-003 (invalid format).

## Consequences

**Tích cực**
- Không đè file, có lịch sử version (plan.v1.md, plan.v2.md).
- Detect hư hỏng qua checksum (ART-002).
- Simulation/rollback an toàn vì artifact có dependency graph.

**Tiêu cực / rủi ro**
- Chi phí quản lý record + checksum mỗi lần ghi.
- Phải tuân thủ DIRECTORY_STANDARD (`artifact/` thư mục).

## Tham chiếu

- `COMPONENTS.md` (Artifact Store), `DATA_MODEL.md` (Artifact), `LIFECYCLE.md` (Artifact), `NAMING_CONVENTIONS.md` (artifacts), `ERROR_HANDLING.md` (ART-001..003).