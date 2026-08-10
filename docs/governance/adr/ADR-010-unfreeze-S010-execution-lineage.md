---
name: adr-unfreeze-s010-execution-lineage
description: >
  ADR-010 — Mở Frozen S010 để sửa execution-lineage.yaml:10 (plain scalar chứa ': '
  gây YAML ScannerError) + version 1.0 → 1.0.0. Do regression REV-20260808-044 phát
  hiện CRITICAL #01.
agent: general
---

# ADR-010 — Unfreeze S010 để sửa execution-lineage.yaml

- **ADR ID**: ADR-010
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**:
  - `docs/specs/SPEC-001/S010/execution-lineage.yaml` (Review)
- **Trigger**: REV-20260808-044 (regression S010, TRG-002) — CRITICAL #01 (YAML ScannerError)

## Bối cảnh

S010 — Runtime Execution Flow — được machine-validate toàn bộ lần đầu trong
REV-20260808-044 (PyYAML 6.0.3 thực tế, 20/20 artifact). Phát hiện **CRITICAL #01**:

1. **CRITICAL #01**: `execution-lineage.yaml:10` — `Simulation: Execution mô phỏng
   (simulated: true).` — plain scalar chứa `': '` (trong `(simulated: true)`) → PyYAML
   **ScannerError** (`mapping values are not allowed here`) — file **không parse được**.
   Cùng lớp S009#01 / S008#01 / S003#01 / S005#01 / S006#01 đã fix bằng quoted string.
   Lỗi có từ lúc tạo file, chưa từng machine-validated.

Kèm 1 MINOR (#02 version "1.0" execution-lineage.yaml:4 vs "1.0.0" canonical) — xử lý
cùng đợt metadata (theo ADR-004/009 precedent).

## Quyết định

**Mở Frozen S010** (trạng thái Review — không phải Frozen, nhưng theo chuẩn ADR cho
mọi fix trên SPEC) để sửa:

1. **CRITICAL #01**: Quote `Simulation:` tại `execution-lineage.yaml:10`:
   `Simulation: Execution mô phỏng (simulated: true).` →
   `Simulation: "Execution mô phỏng (simulated: true)."`
   — không đổi dữ liệu, `lineage` giữ nguyên 6 mục.
2. **MINOR #02**: `version: "1.0"` → `"1.0.0"` (`execution-lineage.yaml:4`) — thống nhất
   version (POLICY-002, tiền lệ ADR-009 #03).

Sau khi sửa, S010 **giữ nguyên trạng thái** (Review/Completed/count 2) — regression
không đổi 2 trục.

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file SPEC.
- **POLICY-002** (Version): PATCH bump — không breaking.
- **POLICY-006** (Documentation): Machine Readable phải parse được.
- **POLICY-010** (Quality): Metadata phải nhất quán.

## Phạm vi thay đổi

### 1. execution-lineage.yaml

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `:10` | `  Simulation: Execution mô phỏng (simulated: true).` → `  Simulation: "Execution mô phỏng (simulated: true)."` | YAML ScannerError |
| 2 | `:4` | `version: "1.0"` → `version: "1.0.0"` | Thống nhất version (POLICY-002) |

## Tác động (Impact Analysis)

- **Low**: Quote string + version — không breaking dữ liệu (không đổi key lineage).
- **Downstream**: Validator/Doctor được lợi — chặn false-FAIL parse.
- **Cascade**: Không mục nào ref execution-lineage.yaml theo ID (grep toàn hệ thống
  xác nhận trong REV-20260808-044) → không cascade mới.

## Trở lại trạng thái

Sau khi hoàn tất, S010 giữ nguyên:
- lifecycle: Review (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker: gỡ `recheck_required` chỉ khi `/review SPEC-001/S010 regression` lần 2 xác nhận PASS.

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-044)
- **Người phê duyệt**: User (confirm "ok" — chuỗi fix schema/YAML các mục)
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-044: `docs/governance/reviews/REV-SPEC-001-S010-REGRESSION-20260808-111533.md`
- ADR-009 (precedent): `docs/governance/adr/ADR-009-unfreeze-S008-data-model.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
