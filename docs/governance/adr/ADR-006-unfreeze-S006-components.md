---
name: adr-unfreeze-s006-components
description: >
  ADR-006 — Mở Frozen S006 để sửa components.yaml (YAML ParserError at not_in_runtime),
  components.schema.json (bổ sung frozen/frozen_date/note) và rename "Orchestrator Contract"
  → "Coordination Contract" (khớp S007 CTR-003). Do regression REV-20260808-016 phát hiện
  CRITICAL #01 + MAJOR #02/#03.
agent: general
---

# ADR-006 — Unfreeze S006 để sửa components.yaml + schema + contract name

- **ADR ID**: ADR-006
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**:
  - `docs/specs/SPEC-001/S006/components.yaml` (Frozen)
  - `docs/specs/SPEC-001/S006/components.schema.json` (Frozen)
  - `docs/specs/SPEC-001/S006/components.md` (Frozen)
  - `docs/specs/SPEC-001/S006/component-contracts.yaml` (Frozen)
  - `docs/specs/SPEC-001/S006/component-registry.yaml` (Frozen)
- **Trigger**: REV-20260808-016 (regression S006, TRG-002) — CRITICAL #01 (YAML ParserError) + MAJOR #02 (schema validation FAIL) + MAJOR #03 (contract name không khớp S007)

## Bối cảnh

S006 — Runtime Components — được đông băng (Frozen) 2026-08-04. Regression cascade sau S003 fix
phát hiện 3 lỗi chưa từng được machine-validated từ lúc freeze:

1. **CRITICAL #01**: `components.yaml:274-285` — `not_in_runtime` là block sequence nhưng `note:`
   cùng indent với các mục `- Agent`... → PyYAML **ParserError** — file canonical không parse được
   (cùng lớp S003 #01).
2. **MAJOR #02**: `components.schema.json:51` — `additionalProperties: false` chặn `frozen`,
   `frozen_date`, `note` → strict schema validation FAIL (cùng lớp S002 #01 / S003 #02 đã fix).
3. **MAJOR #03**: S006 dùng tên contract **"Orchestrator Contract"** ×4 (components.yaml:63,
   components.md:161, component-contracts.yaml:7, component-registry.yaml:18) nhưng S007 định nghĩa
   **"Coordination Contract"** (CTR-003) — 0 occurrence tên cũ trong S007 → cross-reference vỡ.

## Quyết định

**Mở Frozen S006** để sửa đúng 3 lỗi trên:

1. **CRITICAL #01**: Đưa `note:` ra ngoài sequence `not_in_runtime` (thành key top-level) —
   `not_in_runtime` giữ nguyên là list các component không thuộc runtime.
2. **MAJOR #02**: Bổ sung `frozen` (boolean), `frozen_date` (string date), `note` (string) vào
   `properties`, giữ nguyên `additionalProperties: false`. Bump title `(S006 v4)` → `(S006 v4.1)`
   (PATCH — POLICY-002).
3. **MAJOR #03**: Rename **"Orchestrator Contract" → "Coordination Contract"** ở cả 4 file, khớp
   S007 CTR-003 (contract-mapping.yaml:24, contract-registry.yaml:38-39).

Sau khi sửa, S006 **trở lại Frozen** ngay (cùng ngày 2026-08-08).

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): PATCH bump — không breaking, không thay đổi nội dung component.
- **POLICY-006** (Documentation): Human Readable + Machine Readable + Schema phải khớp nhau.
- **POLICY-011** (Traceability): Cross-reference phải trỏ đúng tên contract chuẩn S007.

## Phạm vi thay đổi

### 1. components.yaml

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 1 | `:274-285` | `note:` ra khỏi sequence `not_in_runtime` (top-level) | YAML ParserError |
| 2 | `:63` | `[Orchestrator Contract]` → `[Coordination Contract]` | Khớp S007 CTR-003 |

### 2. components.schema.json

| # | Vị trí | Thay đổi | Lý do |
|---|--------|----------|-------|
| 3 | `properties` | Thêm `"frozen": { "type": "boolean" }` | Khớp `components.yaml:8` |
| 4 | `properties` | Thêm `"frozen_date": { "type": "string", "format": "date" }` | Khớp `components.yaml:9` |
| 5 | `properties` | Thêm `"note": { "type": "string" }` | Khớp top-level `note` |
| 6 | `title` | `(S006 v4)` → `(S006 v4.1)` | Đánh dấu version schema mới |

### 3. Rename contract (4 file)

| # | File | Vị trí | Thay đổi |
|---|------|--------|----------|
| 7 | `components.md` | `:161` | `Orchestrator Contract (S007)` → `Coordination Contract (S007)` |
| 8 | `component-contracts.yaml` | `:7` | `Orchestrator Contract (S007)` → `Coordination Contract (S007)` |
| 9 | `component-registry.yaml` | `:18` | `[Orchestrator Contract]` → `[Coordination Contract]` |

## Tác động (Impact Analysis)

- **Low**: YAML restructure + schema optional fields + rename contract — không breaking dữ liệu.
- **Downstream**: Validator (spec001-validator, Doctor, Dashboard) được lợi — chặn false-FAIL parse.
- **Cascade**: S007 là nguồn tên contract (CTR-003) — không đổi; mục nào ref `Orchestrator Contract`
  khác ngoài S006 cần kiểm tra (grep toàn hệ thống trong lúc fix — dự kiến không có).

## Trở lại Frozen

Sau khi hoàn tất, S006 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker: chỉ cập nhật khi review lại (regression lần 2 để gỡ recheck_required).

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-20260808-016)
- **Người phê duyệt**: User (confirm "còn gì làm hết")
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- REV-20260808-016: `docs/governance/reviews/REV-SPEC-001-S006-REGRESSION-20260808-093016.md`
- ADR-003 (precedent): `docs/governance/adr/ADR-003-unfreeze-S003-schema.md`
- Tracker: `docs/governance/review-tracker.yaml`
- Schema: `docs/specs/SPEC-001/S006/components.schema.json`
- S007 CTR-003: `docs/specs/SPEC-001/S007/contracts.yaml:50-51`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md`
- POL-001/002/006/011: `docs/governance/policies/`
