---
name: adr-unfreeze-s004-boundaries
description: >
  ADR-007 — Mở Frozen S004 để sửa boundaries.schema.json (bổ sung
  frozen/frozen_date), boundaries.yaml (quote target, bổ sung 8 boundary B001-B008
  vào canonical + mapping 9 + metrics đầy đủ) và đồng bộ boundaries.md + 7 artifact
  YAML. Do /review revfull REV-20260808-019 phát hiện 3 MAJOR (#01/#02/#03).
agent: general
---

# ADR-007 — Unfreeze S004 để sửa schema + canonical boundaries + md tables

- **ADR ID**: ADR-007
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**:
  - `docs/specs/SPEC-001/S004/boundaries.schema.json` (Frozen)
  - `docs/specs/SPEC-001/S004/boundaries.yaml` (Frozen)
  - `docs/specs/SPEC-001/S004/boundaries.md` (Frozen)
  - 7 artifact YAML S004 (Frozen): `ownership-boundary.yaml`, `delegation-boundary.yaml`,
    `dependency-boundary.yaml`, `interface-boundary.yaml`, `boundary-registry.yaml`,
    `boundary-matrix.yaml`, `boundary-ownership-matrix.yaml`
- **Trigger**: REV-20260808-019 (revfull S004, health semantics) — 3 MAJOR: #01 (schema chặn
  `frozen`/`frozen_date`), #02 (`target: 0` int vs schema type string), #03 (canonical chỉ định
  nghĩa 1/9 boundary — Doctor không máy-kiểm tra được 8/9, vi phạm Success Criteria).

## Bối cảnh

S004 — Runtime Boundaries — được đông băng (Frozen) 2026-08-04 (commit cdd1ca6, 2026-08-05).
Review revfull REV-20260808-019 (health semantics — giữ nguyên 2 trục) phát hiện:

1. **MAJOR #01**: `boundaries.schema.json:58` dùng `additionalProperties: false` nhưng
   `properties` không khai báo `frozen`/`frozen_date` — 2 field khai báo trong
   `boundaries.yaml:8-9` → jsonschema strict validation FAIL. Cùng lớp lỗi S002 (ADR-002),
   S003 (ADR-003), S006 (ADR-006).
2. **MAJOR #02**: `boundaries.yaml:51` — `B009-security.target: 0` (integer) nhưng schema
   khai báo `"target": { "type": "string" }` → jsonschema FAIL lỗi thứ 2.
3. **MAJOR #03**: File canonical khai báo 9 boundary (hierarchy/registry/comment) nhưng
   `boundaries:` map chỉ định nghĩa **B009-security (1/9)**. B001-B008 thiếu
   severity/violation/impact/detected_by/metric/target/principles/rules machine-readable
   (B002/B006/B007/B008 không có artifact YAML riêng). Success Criteria "Doctor có thể tự
   động kiểm tra mọi Boundary qua quy tắc machine-readable" (`boundaries.md:339`) không đạt 8/9.
4. Kèm 4 MINOR: #04 (md Boundary Mapping 7/9), #05 (md Ownership Matrix 6/9 + Violations 4/9),
   #06 (version `"1.0"` × 7 artifact vs `1.0.0` — RP014), #07 (`frozen_date` 08-04 trước ngày
   commit freeze 08-05).

## Quyết định

**Mở Frozen S004** để sửa các lỗi trên:

1. **#01**: Bổ sung 2 key (`frozen` boolean, `frozen_date` string date) vào
   `boundaries.schema.json` properties, **giữ nguyên `additionalProperties: false`**
   (nghiêm ngặt top-level). Cập nhật title `(S004)` → `(S004 v2.1)` (bump PATCH theo POLICY-002).
2. **#02**: Đổi `target: 0` → `target: "0"` (string, chuẩn hóa theo schema — không đổi ngữ nghĩa).
3. **#03**: Bổ sung đủ **8 boundary còn thiếu (B001-B008)** vào `boundaries:` map của
   `boundaries.yaml` với cấu trúc đầy đủ như B009 (name/severity/version/status/
   allowed/forbidden/owns/not_owns/delegates/dependencies/exposes/manages/processes/
   responsible + violation/impact/detected_by/metric/target/principles/rules), đồng bộ
   từ `boundaries.md` + 4 artifact riêng đã có. Cập nhật `mapping` đủ 9 entry (khớp
   `boundary-matrix.yaml`) và `metrics` đầy đủ 8 chỉ số (khớp mục Boundary Metrics trong md).
   Đổi key không có trong schema `not_manage` → `not_manages` (key có type trong schema).
4. **#04/#05**: Cập nhật `boundaries.md` — Boundary Mapping đủ 9 dòng (thêm B005, B008),
   Ownership Matrix đủ 9 hàng (thêm B002, B006, B008), Violations đủ 9 hàng (thêm
   B001/B003/B005/B006/B008) — khớp 2 YAML matrix.
5. **#06**: Chuẩn hóa `version: "1.0"` → `"1.0.0"` (RP014 semver) ở 7 artifact YAML.
6. **#07**: `frozen_date: "2026-08-04"` → `"2026-08-08"` (ngày re-freeze sau fix) trong
   `boundaries.yaml` + dòng trạng thái `boundaries.md:11`.

Sau khi sửa, S004 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump — không breaking, không thay đổi nội dung boundary.
- **POLICY-006** (Documentation): Human Readable + Machine Readable + Schema phải khớp nhau.
- **POLICY-011** (Traceability): Schema là nguồn sự thật cho validator — không thể lệch artifact.

## Phạm vi thay đổi

### 1. boundaries.schema.json

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `properties` | Thêm `"frozen": { "type": "boolean" }` | Khớp `boundaries.yaml:8` (#01) |
| 2 | `properties` | Thêm `"frozen_date": { "type": "string", "format": "date" }` | Khớp `boundaries.yaml:9` (#01) |
| 3 | `title` | `(S004)` → `(S004 v2.1)` | Đánh dấu version schema mới |

### 2. boundaries.yaml

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 4 | `B009-security.target` | `0` → `"0"` | Schema type string (#02) |
| 5 | `boundaries` map | Bổ sung B001-B008 (cấu trúc đầy đủ như B009) | Canonical 9/9 (#03) |
| 6 | `B009-security.not_manage` | → `not_manages` | Khớp key typed trong schema |
| 7 | `mapping` | 1 entry → 9 entry (khớp `boundary-matrix.yaml`) | Machine-readable (#03) |
| 8 | `metrics` | → 8 chỉ số đầy đủ (khớp md Boundary Metrics) | Machine-readable (#03) |
| 9 | `frozen_date` | `"2026-08-04"` → `"2026-08-08"` | Re-freeze sau fix (#07) |

### 3. boundaries.md

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 10 | `:11` | `✅ Frozen (2026-08-04)` → `✅ Frozen (2026-08-08)` | Đồng bộ frozen_date (#07) |
| 11 | Boundary Mapping | Thêm B005 (P002/RULE-003) + B008 (P015/RULE-012) | Đủ 9/9 (#04) |
| 12 | Boundary Violations | 4 → 9 hàng | Đủ 9/9 (#05) |
| 13 | Ownership Matrix | Thêm B002, B006, B008 | Đủ 9/9 (#05) |

### 4. 7 artifact YAML

| # | File | Thay đổi | Lý do |
|---|------|----------|-------|
| 14 | ownership/delegation/dependency/interface-boundary.yaml, boundary-registry/matrix/ownership-matrix.yaml | `version: "1.0"` → `"1.0.0"` | RP014 semver (#06) |

## Tác động (Impact Analysis)

- **Low**: Bổ sung key machine-readable vào canonical + bổ sung field optional vào schema —
  mọi artifact hiện có vẫn hợp lệ, không breaking. Không đổi key B00x nào (B001-B009 giữ
  nguyên định danh) → **không vỡ reference downstream** (S005/S006/S011/S013/S016/SPEC-002-W004).
- **Downstream**: Validator (spec001-validator, Doctor, Dashboard) được lợi — jsonschema hết
  false-FAIL + Doctor có thể máy-kiểm tra 9/9 boundary (Success Criteria đạt).
- **Cascade**: Regression TRG-001 cho chính S004 (theo review next-step). S004 không có
  `recheck_required` — chạy `/review SPEC-001 S004 regression` sau fix, rồi `/doctor`.

## Trở lại Frozen

Sau khi hoàn tất, S004 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker không cần cập nhật gì thêm (precedent ADR-003)

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-019)
- **Người phê duyệt**: User (đã confirm "làm đi")
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-019: `docs/governance/reviews/REV-SPEC-001-S004-20260808-100302.md`
- ADR-003 (precedent): `docs/governance/adr/ADR-003-unfreeze-S003-schema.md`
- ADR-006 (precedent): `docs/governance/adr/ADR-006-unfreeze-S006-components.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Schema: `docs/specs/SPEC-001/S004/boundaries.schema.json`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/011: `docs/governance/policies/`
