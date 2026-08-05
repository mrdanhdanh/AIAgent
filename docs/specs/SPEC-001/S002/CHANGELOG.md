---
name: spec-001-s002-changelog
description: SPEC-001 S002 changelog — lịch sử thay đổi Runtime Requirements.
agent: general
---

# S002 — Changelog

## v1.0.0 (2026-08-04) — ✅ Frozen

- 20 Functional Requirements (FR-001..020)
- 15 Non-functional Requirements (NFR-001..015)
- 9 Constraints (C-001..009, 4 nhóm: Architectural/Operational/Governance/Security)
- 5 Assumptions (A-001..005)
- Dependencies tách 2 loại (logical + runtime_services)
- 6 External Interfaces (có direction)
- 8 Quality Attributes (định lượng)
- 6 Acceptance Requirements (AR-001..006, có traceability)
- Metadata chuẩn mỗi req: title/priority/status/owner/source/verification/category
- 9 deliverables machine-readable (requirements/traceability/priority/index/categories/lifecycle/metrics/schema)

## Future Considerations (v1.1.0 trở đi — qua RFC/ADR)

Theo đề xuất kiến trúc dài hạn (ghi nhận, chưa áp dụng vì S002 đã freeze):

1. **Tách mỗi Requirement thành entity riêng** (`functional/FR-001.yaml`...) — chuẩn AUTOSAR/Eclipse/OpenTelemetry.
2. **UUID** cho mỗi requirement — đổi tên không ảnh hưởng traceability.
3. **Stability** field (experimental/stable/deprecated) — phục vụ Evolution Engine.
4. **Risk** field (critical/high/medium) — khác với priority.
5. **Verification Type** chuẩn (Doctor/Simulation/Integration Test/Runtime Test/Manual Review).
6. **QA thay Availability** → Execution Success Rate 99.9% (Runtime không phải server).
7. **Scalability** → "Support concurrent executions without shared mutable state" (không ràng buộc con số).
8. **C-010**: Runtime không phụ thuộc Plugin cụ thể (P012).
9. **Assumptions** thêm: Clock available, Storage available, Configuration valid.
10. **External Interfaces** dạng bảng Read/Write/Publish.
11. **AR → FR → TEST → DOCTOR** liên kết để Dashboard tính coverage.
12. **requirements-registry.yaml** — registry tổng hợp để Doctor đọc một file.
