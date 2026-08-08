---
name: adr-unfreeze-s008-data-model
description: >
  ADR-009 — Mở Frozen S008 để sửa runtime-data-model.yaml (note: trong block
  sequence gây YAML ParserError) và runtime-data.schema.json (lỗi thời vs YAML v2:
  thiếu status/frozen/frozen_date, aggregate_rules mapping, classification, consistency
  object). Do regression REV-20260808-034 phát hiện CRITICAL + MAJOR.
agent: general
---

# ADR-009 — Unfreeze S008 để sửa runtime-data-model.yaml + runtime-data.schema.json

- **ADR ID**: ADR-009
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**:
  - `docs/specs/SPEC-001/S008/runtime-data-model.yaml` (Frozen)
  - `docs/specs/SPEC-001/S008/runtime-data.schema.json` (Frozen)
- **Trigger**: REV-20260808-034 (regression S008, TRG-002) — CRITICAL #01 (YAML ParserError) + MAJOR #02 (schema lỗi thời, POLICY-002/006)

## Bối cảnh

S008 — Runtime Data Model — được đông băng (Frozen) 2026-08-05 (commit 08cc1fa). Regression lần
đầu machine-validate S008 phát hiện 2 defect có từ lúc freeze (git blame: 65d8b61), chưa từng
được validate bằng máy — **cùng lớp defect đã fix ở S002/S003/S005/S006/S007**:

1. **CRITICAL #01**: `runtime-data-model.yaml:53` — key `note: Không dependency ngược.` cùng
   indent với block sequence `dependencies:` (dòng 45-52) → PyYAML **ParserError** (`expected
   <block end>, but found '?'`) — file canonical (runtime-data-model.yaml = "nguồn dữ liệu
   chuẩn" theo data-model.md:293) **không parse được**. Cùng lớp S003 #01 / S005 #01 / S006 #01.
2. **MAJOR #02**: `runtime-data.schema.json` lỗi thời so với YAML v2 — jsonschema strict **FAIL
   5 errors**: (a) `additionalProperties: false` chặn `status`/`frozen`/`frozen_date`
   (runtime-data-model.yaml:5-7); (b) `aggregate_rules` items type string nhưng YAML chứa mapping
   `{Execution owns: [...]}`, `{Execution references: [...]}` → 2 errors; (c) `classification`
   schema yêu cầu `required: [manages, not_manages]` nhưng YAML dùng keys phân loại
   (Runtime Data/Execution Data/Transient/Persistent Metadata/Reference Data) + `not_manages`
   (không có `manages`) → 1 error; (d) `consistency` schema khai báo `type: array` nhưng YAML
   là object `{levels, rules}` → 1 error.

Kèm 2 MINOR (#03 version "1.0" vs "1.0.0", #04 frozen_date 08-04 vs commit freeze 08-05) —
xử lý cùng đợt metadata (theo ADR-004 precedent).

## Quyết định

**Mở Frozen S008** để sửa:

1. **CRITICAL #01**: Chuyển `note:` thành comment (`# Khong dependency nguoc.`) tại
   `runtime-data-model.yaml:53` — không đổi dữ liệu, `dependencies` giữ nguyên 8 mục.
2. **MAJOR #02**: Cập nhật `runtime-data.schema.json` theo YAML v2 (giữ `additionalProperties:
   false`):
   - Thêm `status` (string), `frozen` (boolean), `frozen_date` (string, format date) vào properties.
   - `aggregate_rules` items → `oneOf` [string, object với `additionalProperties` array string]
     (cho phép mapping `{Execution owns: [...]}`).
   - `classification` → bỏ `required: [manages]`, thêm `patternProperties` hoặc
     `additionalProperties` array string cho keys phân loại + giữ `not_manages`.
   - `consistency` → đổi `type: array` thành `type: object` `{levels: array string, rules:
     array string}`.
   - Title `(S008)` → `(S008 v2.1)` (PATCH theo POLICY-002).
3. **MINOR #03/#04**: `version: "1.0"` → `"1.0.0"` (runtime-data-model.yaml:4) + `frozen_date`
   → `"2026-08-08"` (runtime-data-model.yaml:7, ngày re-freeze — theo ADR-004 precedent).

Sau khi sửa, S008 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump — không breaking, không thay đổi nội dung data model.
- **POLICY-006** (Documentation): Human Readable + Machine Readable + Schema phải khớp nhau.
- **POLICY-010** (Quality): Metadata phải nhất quán với lịch sử thực tế của tài liệu.

## Phạm vi thay đổi

### 1. runtime-data-model.yaml

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `:53` | `  note: Không dependency ngược.` → `  # Khong dependency nguoc.` | YAML ParserError |
| 2 | `:4` | `version: "1.0"` → `version: "1.0.0"` | Thống nhất version (POLICY-002) |
| 3 | `:7` | `frozen_date: "2026-08-04"` → `"2026-08-08"` | Metadata khớp thời điểm re-freeze |

### 2. runtime-data.schema.json

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 4 | `properties` | Thêm `"status": { "type": "string" }` | Khớp `runtime-data-model.yaml:5` |
| 5 | `properties` | Thêm `"frozen": { "type": "boolean" }` | Khớp `runtime-data-model.yaml:6` |
| 6 | `properties` | Thêm `"frozen_date": { "type": "string", "format": "date" }` | Khớp `runtime-data-model.yaml:7` |
| 7 | `aggregate_rules.items` | `{ "type": "string" }` → `{ "oneOf": [ { "type": "string" }, { "type": "object", "additionalProperties": { "type": "array", "items": { "type": "string" } } } ] }` | Cho phép mapping `{Execution owns: [...]}` |
| 8 | `classification` | Bỏ `required: [manages]`; `properties.not_manages` giữ; thêm `additionalProperties` array string cho keys phân loại | Khớp YAML v2 (không có `manages`) |
| 9 | `consistency` | `{ "type": "array", ... }` → `{ "type": "object", "required": ["levels", "rules"], "properties": { "levels": { "type": "array", "items": { "type": "string" }, "minItems": 1 }, "rules": { "type": "array", "items": { "type": "string" }, "minItems": 1 } } }` | Khớp YAML v2 (`{levels, rules}`) |
| 10 | `title` | `(S008)` → `(S008 v2.1)` | Đánh dấu version schema mới (PATCH) |

## Tác động (Impact Analysis)

- **Low**: Comment hóa note + schema cập nhật theo đúng YAML v2 + metadata — không breaking dữ
  liệu (không đổi key ENT-0xx/RM-0xx, không đổi aggregate_root/invariants).
- **Downstream**: Validator (spec001-validator, Doctor, Dashboard) được lợi — chặn false-FAIL
  parse + false-FAIL schema.
- **Cascade**: S009 (state-history.yaml:9 ref ENT-014), S010 (artifact-flow), S011 (events/
  metrics), S014 (registry), S015 (resources), SPEC-002/W008 ref theo tên/ID — fix không đổi
  key nào → không breaking. REV-20260808-034 đã xác nhận upstream cascade OK.

## Trở lại Frozen

Sau khi hoàn tất, S008 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker: gỡ `recheck_required` chỉ khi `/review SPEC-001/S008 regression` lần 2 xác nhận PASS.

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-034)
- **Người phê duyệt**: User (confirm "xử lý tiếp" — chuỗi fix schema/YAML các mục Frozen)
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-034: `docs/governance/reviews/REV-SPEC-001-S008-REGRESSION-20260808-105010.md`
- ADR-002/003/006/007/008 (precedent): `docs/governance/adr/`
- ADR-004 (frozen_date precedent): `docs/governance/adr/ADR-004-s003-frozen-date.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Schema: `docs/specs/SPEC-001/S008/runtime-data.schema.json`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/010: `docs/governance/policies/`
