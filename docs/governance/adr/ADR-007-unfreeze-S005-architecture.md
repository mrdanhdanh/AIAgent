---
name: adr-unfreeze-s005-architecture
description: >
  ADR-007 — Mở Frozen S005 để sửa architecture.yaml (2 key note: trong block sequence
  gây YAML ParserError) và architecture.schema.json (bổ sung frozen/frozen_date).
  Do review revfull REV-20260808-018 phát hiện CRITICAL #01 + MAJOR #02.
agent: general
---

# ADR-007 — Unfreeze S005 để sửa architecture.yaml + architecture.schema.json

- **ADR ID**: ADR-007
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**:
  - `docs/specs/SPEC-001/S005/architecture.yaml` (Frozen)
  - `docs/specs/SPEC-001/S005/architecture.schema.json` (Frozen)
- **Trigger**: REV-20260808-018 (revfull S005) — CRITICAL #01 (YAML ParserError) + MAJOR #02 (schema validation FAIL, POLICY-002/006)

## Bối cảnh

S005 — Runtime Architecture — được đông băng (Frozen) 2026-08-05 (commit 6a18636, v2). Review
revfull REV-20260808-018 phát hiện 2 lỗi có từ lúc freeze, chưa từng được machine-validated:

1. **CRITICAL #01**: `architecture.yaml:130` (`communication_rules`) và `:159` (`constraints`) —
   key `note:` cùng indent với block sequence → PyYAML **ParserError**
   (`expected <block end>, but found '?'`) — file canonical **không parse được** bằng parser YAML
   chuẩn (7/8 YAML của S005 parse OK, duy nhất file canonical FAIL). Cùng lớp S003 #01 / S006 #01
   đã fix bằng ADR-003 / ADR-006.
2. **MAJOR #02**: `architecture.schema.json:47` — `additionalProperties: false` nhưng `properties`
   không khai báo `frozen`/`frozen_date` (khai báo tại `architecture.yaml:8-9`) → strict schema
   validation FAIL. Cùng lớp S002 #01 (ADR-002) / S003 #02 (ADR-003) — S005 chưa fix.

## Quyết định

**Mở Frozen S005** để sửa đúng 2 lỗi trên:

1. **CRITICAL #01**: Chuyển 2 key `note:` khỏi block sequence thành comment
   (`# Ngoài ra đều bị cấm` thay cho `note: Ngoài ra deu bi cam.` tại L130; `# Tat ca deu CAM.`
   thay cho `note: Tat ca deu CAM.` tại L159). Không đổi nội dung dữ liệu — `communication_rules`
   giữ nguyên 4 mục, `constraints` giữ nguyên 6 mục; note chỉ là chú thích.
2. **MAJOR #02**: Bổ sung `frozen` (boolean) + `frozen_date` (string, format date) vào `properties`,
   giữ nguyên `additionalProperties: false` (nghiêm ngặt top-level). Bump title `(S005)` →
   `(S005 v1.1.1)` (PATCH theo POLICY-002, khớp version artifact 1.1.0).
3. **Metadata**: Cập nhật `frozen_date: "2026-08-04"` → `"2026-08-08"` (ngày hoàn tất fix + ngày
   freeze lại bản đã sửa) — theo ADR-004 precedent, POLICY-010 (metadata phải khớp thời điểm
   freeze bản hiện hành).

Sau khi sửa, S005 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump — không breaking, không thay đổi nội dung layer/domain.
- **POLICY-006** (Documentation): Human Readable + Machine Readable + Schema phải khớp nhau.
- **POLICY-010** (Quality): Metadata phải nhất quán với lịch sử thực tế của tài liệu.
- **POLICY-011** (Traceability): Schema là nguồn sự thật cho validator — không thể lệch artifact.

## Phạm vi thay đổi

### 1. architecture.yaml

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `:130` | `  note: Ngoai ra deu bi cam.` → `  # Ngoai ra deu bi cam.` | YAML ParserError |
| 2 | `:159` | `  note: Tat ca deu CAM.` → `  # Tat ca deu CAM.` | YAML ParserError |
| 3 | `:9` | `frozen_date: "2026-08-04"` → `"2026-08-08"` | Metadata khớp thời điểm re-freeze |

### 2. architecture.schema.json

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 4 | `properties` | Thêm `"frozen": { "type": "boolean" }` | Khớp `architecture.yaml:8` |
| 5 | `properties` | Thêm `"frozen_date": { "type": "string", "format": "date" }` | Khớp `architecture.yaml:9` |
| 6 | `title` | `(S005)` → `(S005 v1.1.1)` | Đánh dấu version schema mới (PATCH) |

## Tác động (Impact Analysis)

- **Low**: Comment hóa note + schema optional fields + metadata — không breaking dữ liệu, nội dung
  9 layers/6 domains/4 views không đổi.
- **Downstream**: Validator (spec001-validator, Doctor, Dashboard) được lợi — chặn false-FAIL parse
  + false-FAIL schema.
- **Cascade**: S006 (`components.md:265`) + S007 (`contracts.md:277`) đọc `../S005/architecture.yaml`
  — cần regression (đã có `recheck_required: true` trong tracker). SPEC-002/W005 mirror cấu trúc
  S005 — kiểm tra khi start. Fix không đổi contract dữ liệu → downstream ít ảnh hưởng.

## Trở lại Frozen

Sau khi hoàn tất, S005 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker: gỡ `recheck_required` chỉ khi `/review SPEC-001/S005 health` xác nhận PASS.

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-018)
- **Người phê duyệt**: User (confirm "ok" cho kế hoạch fix P1 #01/#02)
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-018: `docs/governance/reviews/REV-SPEC-001-S005-20260808-100344.md`
- ADR-002/003/006 (precedent): `docs/governance/adr/ADR-002-unfreeze-S002-schema.md`,
  `ADR-003-unfreeze-S003-schema.md`, `ADR-006-unfreeze-S006-components.md`
- ADR-004 (frozen_date precedent): `docs/governance/adr/ADR-004-s003-frozen-date.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Schema: `docs/specs/SPEC-001/S005/architecture.schema.json`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/010/011: `docs/governance/policies/`
