---
name: adr-s002-traceability-rr
description: >
  ADR-005 — Mở Frozen S002 để bổ sung traceability 2 chiều: thêm responsibilities: [RR-0xx]
  vào từng FR trong requirement-traceability.yaml. Do health REV-SPEC-001-S003-HEALTH-20260808-090502
  phát hiện MINOR #05 (POLICY-011 trace 1 chiều).
agent: general
---

# ADR-005 — Unfreeze S002 để bổ sung traceability 2 chiều S002 ↔ S003

- **ADR ID**: ADR-005
- **Ngày**: 2026-08-08
- **Trạng thái**: Đã quyết định (triển khai ngay sau)
- **Target**: `docs/specs/SPEC-001/S002/requirement-traceability.yaml` (Frozen)
- **Trigger**: REV-SPEC-001-S003-HEALTH-20260808-090502 — MINOR #05: traceability 1 chiều
  (S003→S002 35/35 khớp nhưng S002 không trace ngược về RR — grep `S003|RR-0` trong S002 = 0 matches).

## Bối cảnh

S002 — Runtime Requirements — trace các FR/NFR/C/AR theo chiều xuôi (FR → P → RULE → SPEC → TEST → DOCTOR),
nhưng không có chiều ngược từ FR về S003/RR. Trong khi đó S003 (`responsibilities.yaml`) map mỗi RR
tới 1..n FR (`requirements: [FR-0xx]`) — 35/35 RR đều khớp FR hợp lệ. POLICY-011 yêu cầu
cross-reference 2 chiều: bổ sung `responsibilities: [RR-0xx]` vào mỗi FR để trace đầy đủ.

## Quyết định

**Mở Frozen S002**, bổ sung field `responsibilities` (array, pattern `^RR-\d{3}$`) vào 20 mục FR
(FR-001..FR-020) trong `requirement-traceability.yaml`, theo mapping nghịch đảo đã verify từ
`S003/responsibilities.yaml` (máy sinh, khớp 35/35). Không sửa NFR/C/AR (không do S003 cover),
không đổi field khác.

## Căn cứ

- **POLICY-001** (Approval): ADR này là approval record cho thay đổi trên file Frozen.
- **POLICY-002** (Version): Không bump version nội dung — thêm field trace, không breaking.
- **POLICY-011** (Traceability): Cross-reference 2 chiều bắt buộc — S003→S002 đã có, bổ sung chiều ngược.

## Phạm vi thay đổi (requirement-traceability.yaml)

Thêm vào mỗi FR-001..FR-020 khối `responsibilities: [...]` (sau `rules:`, trước `spec:`), theo bảng:

| FR | responsibilities |
|----|------------------|
| FR-001 | [RR-001] |
| FR-002 | [RR-005] |
| FR-003 | [RR-006, RR-020] |
| FR-004 | [RR-004, RR-007, RR-019] |
| FR-005 | [RR-011, RR-012, RR-013] |
| FR-006 | [RR-015, RR-016, RR-017, RR-018] |
| FR-007 | [RR-025, RR-028] |
| FR-008 | [RR-029, RR-030, RR-031] |
| FR-009 | [RR-009, RR-026, RR-027] |
| FR-010 | [RR-004, RR-008, RR-021] |
| FR-011 | [RR-009, RR-027] |
| FR-012 | [RR-010, RR-023] |
| FR-013 | [RR-035] |
| FR-014 | [RR-033, RR-035] |
| FR-015 | [RR-001, RR-003, RR-018] |
| FR-016 | [RR-013, RR-014] |
| FR-017 | [RR-010] |
| FR-018 | [RR-022] |
| FR-019 | [RR-024, RR-032, RR-034] |
| FR-020 | [RR-002, RR-030] |

## Tác động (Impact Analysis)

- **Low**: Chỉ thêm field trace — mọi artifact hiện có vẫn hợp lệ, không breaking.
- **Downstream**: Doctor/Dashboard trace 2 chiều được lợi; S003 không đổi gì.
- **Cascade**: Không mục nào phụ thuộc nội dung traceability.yaml ngoài S003 (đã ổn) — không cần recheck thêm.

## Trở lại Frozen

Sau khi hoàn tất, S002 **trở lại Frozen**:
- lifecycle: Frozen (giữ nguyên)
- review.status: Completed (giữ nguyên, count 2)
- Tracker không cần cập nhật gì thêm

## Phê duyệt

- **Người đề xuất**: AIOS Review Agent (REV-SPEC-001-S003-HEALTH-20260808-090502)
- **Người phê duyệt**: User (confirm "còn gì làm hết")
- **Ngày phê duyệt**: 2026-08-08

## Tham chiếu

- Health report: `docs/governance/reviews/REV-SPEC-001-S003-HEALTH-20260808-090502.md`
- ADR-002 (precedent S002): `docs/governance/adr/ADR-002-unfreeze-S002-schema.md`
- Mapping nguồn: `docs/specs/SPEC-001/S003/responsibilities.yaml`
- Tracker: `docs/governance/review-tracker.yaml`
- POL-001/002/011: `docs/governance/policies/`
