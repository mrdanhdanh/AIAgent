---
name: adr-unfreeze-s001
description: >
  ADR-001 — Mở Frozen S001 để sửa Forward References S011–S020 (PATCH 1.0.0 → 1.0.1).
  Quyết định theo POLICY-001/002/006. Do /review revfull phát hiện MAJOR #01 traceability.
agent: general
---

# ADR-001 — Unfreeze S001 để sửa Forward References

- **ADR ID**: ADR-001
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**: `docs/specs/SPEC-001/S001-vision.md` (Frozen, version 1.0.0)
- **Trigger**: REV-20260808-004 (revfull S001) — MAJOR #01: Forward References S011–S020 dùng tên cũ, vỡ traceability 10/19 mục (POLICY-011)

## Bối cảnh

S001 — Runtime Vision — được đông băng (Frozen) ngày 2026-08-04. Các mục S011–S017 **đổi tên sau đó** (commits f97df72, d63f075, fe65ab4, 81a0618, befb4ec, 0712932, e1e3682):

| Ref cũ (S001 Frozen) | Tên hiện hành (từ SPEC-INDEX.md:51-58) |
|-----------------------|----------------------------------------|
| S011 — Events | S011 — Execution Observability |
| S012 — Errors | S012 — Runtime Policies |
| S013 — Configuration | S013 — Runtime Governance |
| S014 — Extension Points | S014 — Runtime Registry |
| S015 — Security | S015 — Runtime Resources |
| S016 — Performance | S016 — Runtime Compliance |
| S017 — Observability | S017 — Runtime Plugins |
| S018 — Testing | S018 — Runtime Evolution |
| S019 — Compatibility | S019 — Doctor |
| S020 — Acceptance Criteria | S020 — Dashboard |

S001 vẫn tham chiếu tên cũ → cross-reference sai 10/19 mục, vi phạm POLICY-011 (Traceability), gây confusion cho AI agent đọc spec.

## Quyết định

**Mở Frozen S001**, sửa Forward References theo tên hiện hành, cập nhật version 1.0.0 → **1.0.1** (PATCH — POLICY-002: sửa lỗi traceability, không breaking).

Sau khi sửa, S001 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): Quyết định này là approval record (ADR) cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump cho sửa lỗi — không breaking, không thay đổi nội dung Vision.
- **POLICY-006** (Documentation): Human Readable (S001-vision.md) phải đồng bộ với Machine Readable (SPEC-INDEX.md, README.md, tracker). Tên sai → vỡ đồng bộ.
- **POLICY-011** (Traceability): Cross-reference 2 chiều file:line phải chính xác.
- `specification-lifecycle.md`: Frozen → Approved không có transition chính thức → dùng ADR làm cơ chế exception, không tạo tiền lệ cho thay đổi nội dung.

## Phạm vi thay đổi (S001-vision.md)

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `:11` header | `Trạng thái: Draft` → `✅ Frozen (2026-08-04)` | Đồng bộ tracker (MAJOR #02) |
| 2 | `:179` text | `S020 — Acceptance Criteria` → `S020 — Dashboard` | Tên hiện hành |
| 3 | `:231-240` Forward Refs | Cập nhật 10 tên theo bảng trên | Fix MAJOR #01 |
| 4 | `:244-250` Principles | Thêm `P010 Immutable Artifact` | Traceability 2 chiều (MAJOR #03) |
| 5 | `:1-7` frontmatter | Thêm `version: "1.0.1"` | POLICY-002 |

## Tác động (Impact Analysis)

- **Low**: Chỉ thay đổi metadata + tên tham chiếu — không đụng đến nội dung Vision, không thay đổi Mission/Philosophy/Goals/Constraints/Invariants/KPI.
- **Downstream**: Không mục nào bị phá vỡ — tên mới đã được downstream dùng từ lúc rename.
- **Cascade**: KHÔNG gắn `recheck_required` mới — S001 chỉ đổi metadata.

## Trở lại Frozen

Sau khi hoàn tất thay đổi, S001 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker không cần cập nhật gì thêm

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-004)
- **Người phê duyệt**: User (người dùng hiện tại — đã confirm "Bạn muốn làm RFC/ADR mở Frozen rồi sửa forward refs")
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-004: `docs/governance/reviews/REV-SPEC-001-S001-20260808-001938.md`
- Tracker: `docs/governance/review-tracker.yaml`
- SPEC-INDEX: `docs/specs/SPEC-INDEX.md:51-58`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/011: `docs/governance/policies/`
