---
name: adr-unfreeze-s007-schema
description: >
  ADR-008 — Mở Frozen S007 để sửa contracts.schema.json (bổ sung frozen/frozen_date).
  Do regression REV-20260808-028 phát hiện MAJOR #01 schema validation FAIL
  (cùng lớp S002/S003/S005/S006 đã fix).
agent: general
---

# ADR-008 — Unfreeze S007 để sửa contracts.schema.json

- **ADR ID**: ADR-008
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**: `docs/specs/SPEC-001/S007/contracts.schema.json` (Frozen)
- **Trigger**: REV-20260808-028 (regression S007, TRG-002) — MAJOR #01: schema validation FAIL (POLICY-002/006)

## Bối cảnh

S007 — Runtime Contracts — được đông băng (Frozen) ngày 2026-08-05 (commit 5c6eee1). `contracts.yaml`
khai báo 2 field quản trị vòng đời:

```yaml
status: Approved
frozen: true
frozen_date: "2026-08-04"
```

Nhưng `contracts.schema.json:44` dùng `additionalProperties: false` và `properties` không khai báo
`frozen`/`frozen_date` → **artifact không validate được bằng schema chính thức** — jsonschema strict
validation FAIL 1 error (`Additional properties are not allowed ('frozen', 'frozen_date')`), vi phạm
POLICY-006 (Machine Readable phải khớp schema). Đây là lần đầu S007 được machine-validated — lỗi có
từ lúc freeze, chưa từng bị phát hiện. **Cùng lớp defect đã fix**: S002 (ADR-002), S003 (ADR-003),
S005 (ADR-007), S006 (ADR-006) — S007 là mục cuối cùng chưa được fix.

## Quyết định

**Mở Frozen S007**, bổ sung `frozen` (boolean) + `frozen_date` (string, ISO date) vào
`contracts.schema.json` properties, giữ nguyên `additionalProperties: false` (nghiêm ngặt top-level).
Cập nhật version schema: title `(S007)` → `(S007 v1.0.1)` (PATCH — POLICY-002: sửa lỗi, không breaking).

Sau khi sửa, S007 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump — không breaking, không thay đổi nội dung contract.
- **POLICY-006** (Documentation): Human Readable + Machine Readable + Schema phải khớp nhau.
- **POLICY-011** (Traceability): Schema là nguồn sự thật cho validator — không thể lệch artifact.

## Phạm vi thay đổi (contracts.schema.json)

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `properties` | Thêm `"frozen": { "type": "boolean" }` | Khớp `contracts.yaml:8` |
| 2 | `properties` | Thêm `"frozen_date": { "type": "string", "format": "date" }` | Khớp `contracts.yaml:9` |
| 3 | `title` | `(S007)` → `(S007 v1.0.1)` | Đánh dấu version schema mới (PATCH) |

## Tác động (Impact Analysis)

- **Low**: Chỉ bổ sung 2 optional field vào schema — mọi artifact hiện có vẫn hợp lệ, không breaking.
- **Downstream**: Validator (spec001-validator, Doctor, Dashboard) được lợi — chặn false-FAIL schema.
- **Cascade**: Các MINOR còn treo (#02 version 1.0.0 vs 1.0, #03 registry layer/domain TBD, #04 registry
  dependencies []) nằm ngoài phạm vi ADR này — ghi nhận, xử lý trong đợt metadata riêng nếu cần.
  Không mục nào đọc `contracts.schema.json` làm logic → không cần cascade thêm.

## Trở lại Frozen

Sau khi hoàn tất, S007 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker: gỡ `recheck_required` chỉ khi `/review SPEC-001/S007 regression` lần 2 xác nhận PASS.

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-028)
- **Người phê duyệt**: User (confirm "ok" — tiếp tục chuỗi fix schema theo ADR-007)
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-028: `docs/governance/reviews/REV-SPEC-001-S007-REGRESSION-20260808-103318.md`
- ADR-007 (precedent): `docs/governance/adr/ADR-007-unfreeze-S005-architecture.md`
- ADR-002/003/006 (cùng lớp): `docs/governance/adr/`
- Tracker: `docs/governance/review-tracker.yaml`
- Schema: `docs/specs/SPEC-001/S007/contracts.schema.json`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/011: `docs/governance/policies/`
