---
name: adr-unfreeze-s002-schema
description: >
  ADR-002 — Mở Frozen S002 để sửa requirements.schema.json (bổ sung frozen/frozen_date).
  PATCH 1.0.0 → 1.0.1. Do /review revfull phát hiện MAJOR #01 schema validation FAIL.
agent: general
---

# ADR-002 — Unfreeze S002 để sửa requirements.schema.json

- **ADR ID**: ADR-002
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**: `docs/specs/SPEC-001/S002/requirements.schema.json` (Frozen, version 1.0.0)
- **Trigger**: REV-20260808-005 (revfull S002) — MAJOR #01: schema validation FAIL (POLICY-002/006)

## Bối cảnh

S002 — Runtime Requirements — được đông băng (Frozen) ngày 2026-08-04. `requirements.yaml` khai báo
2 field quản trị vòng đời:

```yaml
status: Approved
frozen: true
frozen_date: "2026-08-04"
```

Nhưng `requirements.schema.json:68` dùng `additionalProperties: false` và `properties` không khai báo
`frozen`/`frozen_date` → **artifact không validate được bằng schema chính thức** — mọi validator
nghiêm ngặt (schema validation thực tế) đều FAIL, vi phạm POLICY-006 (Machine Readable phải khớp schema).

## Quyết định

**Mở Frozen S002**, bổ sung `frozen` (boolean) + `frozen_date` (string, ISO date) vào
`requirements.schema.json` properties, giữ nguyên `additionalProperties: false` (nghiêm ngặt top-level).
Cập nhật version schema 1.0.0 → **1.0.1** (PATCH — POLICY-002: sửa lỗi, không breaking).

Sau khi sửa, S002 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump — không breaking, không thay đổi nội dung requirement.
- **POLICY-006** (Documentation): Human Readable + Machine Readable + Schema phải khớp nhau.
- **POLICY-011** (Traceability): Schema là nguồn sự thật cho validator — không thể lệch artifact.

## Phạm vi thay đổi (requirements.schema.json)

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `properties` | Thêm `"frozen": { "type": "boolean" }` | Khớp `requirements.yaml:8` |
| 2 | `properties` | Thêm `"frozen_date": { "type": "string", "format": "date" }` | Khớp `requirements.yaml:9` |
| 3 | `title` | `(S002 v2)` → `(S002 v2.1)` | Đánh dấu version schema mới |

## Tác động (Impact Analysis)

- **Low**: Chỉ bổ sung 2 optional field vào schema — mọi artifact hiện có vẫn hợp lệ, không breaking.
- **Downstream**: Validator (spec001-validator, Doctor, Dashboard) chỉ được lợi — chặn false-FAIL.
- **Cascade**: S003/S010 chỉ đọc `requirements.yaml` (không đọc schema) — không cần recheck thêm.

## Trở lại Frozen

Sau khi hoàn tất, S002 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker không cần cập nhật gì thêm

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-005)
- **Người phê duyệt**: User (đã confirm "Làm ADR-002 + fix schema luôn")
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-005: `docs/governance/reviews/REV-SPEC-001-S002-20260808-002919.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Schema: `docs/specs/SPEC-001/S002/requirements.schema.json`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/011: `docs/governance/policies/`
