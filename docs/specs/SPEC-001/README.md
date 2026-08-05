---
name: spec-001-runtime-kernel
description: >
  SPEC-001 — Runtime Kernel. Execution kernel thống nhất của AIOS.
  Quy trình 20 bước (S001-S020), mỗi bước review + freeze trước khi sang bước tiếp.
agent: general
---

# SPEC-001 — Runtime Kernel

> **Trạng thái**: Draft · **Version**: 1.0.0 · **Phụ thuộc**: SPEC-000 (Constitution)
> **`implements: Runtime`** — xem compliance-matrix trong Constitution.
> **S001 Vision: ✅ Frozen** · **S002 Requirements: ✅ Frozen** · **S003 Responsibilities: ✅ Frozen (2026-08-04)**

## Runtime tồn tại để làm gì?

**Mission**: Runtime là trung tâm điều phối của AIOS. Mọi hoạt động đều phải được Runtime khởi tạo, điều phối, giám sát và kết thúc. Không có thành phần nào được phép thực thi bên ngoài Runtime.

**Vision**: Runtime trở thành một Execution Kernel thống nhất cho toàn bộ AIOS.

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Trạng thái |
|---|------|------|-----------|
| S001 | Vision | `S001-vision.md` | ✅ Frozen |
| S002 | Requirements | `S002/requirements.md` | ✅ Frozen |
| S003 | Responsibilities | `S003/responsibilities.md` | ✅ Frozen |
| S004 | Boundaries | `S004/boundaries.md` | 🚧 In progress |
| S004 | Boundaries | `S004-boundaries.md` | ⬜ |
| S005 | Architecture | `S005-architecture.md` | ⬜ |
| S006 | Components | `S006-components.md` | ⬜ |
| S007 | Contracts | `S007-contracts.md` | ⬜ |
| S008 | Data Model | `S008-data-model.md` | ⬜ |
| S009 | State Machine | `S009-state-machine.md` | ⬜ |
| S010 | Execution Flow | `S010-execution-flow.md` | ⬜ |
| S011 | Events | `S011-events.md` | ⬜ |
| S012 | Errors | `S012-errors.md` | ⬜ |
| S013 | Configuration | `S013-configuration.md` | ⬜ |
| S014 | Extension Points | `S014-extension-points.md` | ⬜ |
| S015 | Security | `S015-security.md` | ⬜ |
| S016 | Performance | `S016-performance.md` | ⬜ |
| S017 | Observability | `S017-observability.md` | ⬜ |
| S018 | Testing | `S018-testing.md` | ⬜ |
| S019 | Compatibility | `S019-compatibility.md` | ⬜ |
| S020 | Acceptance Criteria | `S020-acceptance-criteria.md` | ⬜ |

## Quy tắc

- Mỗi bước phải được **review + freeze** trước khi sang bước tiếp.
- 100% SPEC hoàn thành trước khi viết code.
- SPEC chỉ tham chiếu Constitution (SPEC-000), không định nghĩa lại khái niệm/rule.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Compliance cho Runtime: `../SPEC-000/compliance-matrix.yaml`
- Roadmap: `../README.md`
