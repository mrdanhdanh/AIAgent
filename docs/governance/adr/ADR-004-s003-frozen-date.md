---
name: adr-s003-frozen-date
description: >
  ADR-004 — Mở Frozen S003 để cập nhật frozen_date metadata (2026-08-04 → 2026-08-08).
  Do health check REV-SPEC-001-S003-HEALTH-20260808-090502 phát hiện MINOR #04:
  frozen_date trước commit cuối (v3, 2026-08-05).
agent: general
---

# ADR-004 — Unfreeze S003 để cập nhật frozen_date

- **ADR ID**: ADR-004
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**: `docs/specs/SPEC-001/S003/responsibilities.yaml` (Frozen)
- **Trigger**: REV-SPEC-001-S003-HEALTH-20260808-090502 — MINOR #04: `frozen_date: "2026-08-04"`
  trước commit cuối sửa nội dung v3 (2026-08-05) → metadata freeze không nhất quán (Frozen =
  không sửa sau freeze).

## Bối cảnh

S003 — Runtime Responsibilities — được freeze thực tế vào 2026-08-05 (commit 2226123 "Freeze S003 v3"),
nhưng `responsibilities.yaml:9` khai báo `frozen_date: "2026-08-04"` (ngày freeze của v2). Metadata
không phản ánh đúng thời điểm đông băng bản hiện hành — vi phạm nhất quán metadata (POLICY-010).

## Quyết định

**Mở Frozen S003** chỉ để sửa metadata `frozen_date: "2026-08-04"` → `"2026-08-08"` (ngày ADR-003
hoàn tất fix + ngày freeze lại bản đã sửa). Không đổi bất kỳ nội dung nào khác.

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): Không bump version nội dung — metadata-only, không breaking.
- **POLICY-010** (Quality): Metadata phải nhất quán với lịch sử thực tế của tài liệu.

## Phạm vi thay đổi

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `responsibilities.yaml:9` | `frozen_date: "2026-08-04"` → `"2026-08-08"` | Khớp thời điểm freeze bản hiện hành |

## Tác động (Impact Analysis)

- **Low**: Metadata-only — không ảnh hưởng contract dữ liệu, không lan downstream.
- **Downstream**: Không mục nào đọc `frozen_date` để lấy logic — không cần cascade thêm.

## Trở lại Frozen

Sau khi hoàn tất, S003 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker không cần cập nhật gì thêm

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-SPEC-001-S003-HEALTH-20260808-090502)
- **Người phê duyệt**: User (confirm "còn gì làm hết")
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- Health report: `docs/governance/reviews/REV-SPEC-001-S003-HEALTH-20260808-090502.md`
- ADR-003 (fix trước): `docs/governance/adr/ADR-003-unfreeze-S003-schema.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/010: `docs/governance/policies/`
