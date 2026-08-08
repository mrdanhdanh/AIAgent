---
name: adr-unfreeze-s003-schema
description: >
  ADR-003 — Mở Frozen S003 để sửa responsibilities.yaml + responsibility-matrix.yaml
  (output: - chưa quote, YAML parse FAIL) và responsibilities.schema.json (bổ sung
  frozen/frozen_date/principle/invariants/delegation). Do /review revfull phát hiện
  CRITICAL #01 + MAJOR #02.
agent: general
---

# ADR-003 — Unfreeze S003 để sửa YAML artifacts + responsibilities.schema.json

- **ADR ID**: ADR-003
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**:
  - `docs/specs/SPEC-001/S003/responsibilities.yaml` (Frozen)
  - `docs/specs/SPEC-001/S003/responsibility-matrix.yaml` (Frozen)
  - `docs/specs/SPEC-001/S003/responsibilities.schema.json` (Frozen)
- **Trigger**: REV-20260808-008 (revfull S003) — CRITICAL #01 (YAML parse FAIL) + MAJOR #02 (schema validation FAIL, POLICY-002/006)

## Bối cảnh

S003 — Runtime Responsibilities — được đông băng (Frozen) ngày 2026-08-05 (commit 2226123, Freeze S003 v3).
Review revfull REV-20260808-008 phát hiện 2 lỗi nghiêm trọng ngay từ lúc freeze, chưa từng được
validate bằng máy:

1. **CRITICAL #01**: `RR-031` khai báo `output: -` (chưa quote) tại `responsibilities.yaml:421` và
   `responsibility-matrix.yaml:159` → giá trị `-` là block sequence indicator trong YAML → cả 2
   artifact canonical **không parse được** (ScannerError). Mọi validator máy đều FAIL.
2. **MAJOR #02**: `responsibilities.schema.json:38` dùng `additionalProperties: false` nhưng
   `properties` không khai báo `frozen`/`frozen_date`/`principle`/`invariants`/`delegation` — là 5
   field khai báo trong `responsibilities.yaml:8-21` → schema strict validation FAIL. Cùng lớp lỗi
   S002 đã fix bằng ADR-002.

## Quyết định

**Mở Frozen S003** để sửa đúng 2 lỗi trên:

1. **CRITICAL #01**: Đổi `output: -` → `output: "-"` (string rỗng-nội dung "không có output") ở
   cả `responsibilities.yaml` và `responsibility-matrix.yaml`. Không đổi ngữ nghĩa: RR-031 là
   responsibility cấm hành động (no output), thể hiện bằng chuỗi `-`.
2. **MAJOR #02**: Bổ sung 5 key (`frozen` boolean, `frozen_date` string date, `principle` string,
   `invariants` array string, `delegation` object) vào `responsibilities.schema.json` properties,
   giữ nguyên `additionalProperties: false` (nghiêm ngặt top-level). Cập nhật title `(S003 v2)` →
   `(S003 v3.1)` (bump PATCH theo POLICY-002).

Sau khi sửa, S003 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump — không breaking, không thay đổi nội dung responsibility.
- **POLICY-006** (Documentation): Human Readable + Machine Readable + Schema phải khớp nhau.
- **POLICY-011** (Traceability): Schema là nguồn sự thật cho validator — không thể lệch artifact.

## Phạm vi thay đổi

### 1. responsibilities.yaml + responsibility-matrix.yaml

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `RR-031` (`responsibilities.yaml:421`) | `output: -` → `output: "-"` | YAML parse FAIL |
| 2 | `RR-031` (`responsibility-matrix.yaml:159`) | `output: -` → `output: "-"` | YAML parse FAIL |

### 2. responsibilities.schema.json

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 3 | `properties` | Thêm `"frozen": { "type": "boolean" }` | Khớp `responsibilities.yaml:8` |
| 4 | `properties` | Thêm `"frozen_date": { "type": "string", "format": "date" }` | Khớp `responsibilities.yaml:9` |
| 5 | `properties` | Thêm `"principle": { "type": "string" }` | Khớp `responsibilities.yaml:11` |
| 6 | `properties` | Thêm `"invariants": { "type": "array", "items": { "type": "string" } }` | Khớp `responsibilities.yaml:12-16` |
| 7 | `properties` | Thêm `"delegation": { "type": "object", "additionalProperties": { "type": "string" } }` | Khớp `responsibilities.yaml:17-21` |
| 8 | `title` | `(S003 v2)` → `(S003 v3.1)` | Đánh dấu version schema mới |

## Tác động (Impact Analysis)

- **Low**: Chỉ quote lại giá trị hiện có + bổ sung optional field vào schema — mọi artifact hiện có
  vẫn hợp lệ, không breaking.
- **Downstream**: Validator (spec001-validator, Doctor, Dashboard) được lợi — chặn false-FAIL parse
  + false-FAIL schema.
- **Cascade**: `recheck_required` S006/S007/S012 (có sẵn trong tracker từ REV-20260808-008) — dùng
  `/doctor` lập task regression TRG-002, không tự đổi review.status.

## Trở lại Frozen

Sau khi hoàn tất, S003 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker không cần cập nhật gì thêm

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-008)
- **Người phê duyệt**: User (đã confirm "Soạn ADR + fix #01/#02")
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-008: `docs/governance/reviews/REV-SPEC-001-S003-20260808-085811.md`
- ADR-002 (precedent): `docs/governance/adr/ADR-002-unfreeze-S002-schema.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Schema: `docs/specs/SPEC-001/S003/responsibilities.schema.json`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/011: `docs/governance/policies/`
