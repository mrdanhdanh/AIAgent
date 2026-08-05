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
> **S001 Vision: ✅ Frozen** · **S002 Requirements: ✅ Frozen** · **S003 Responsibilities: ✅ Frozen** · **S004 Boundaries: ✅ Frozen** · **S005 Architecture: ✅ Frozen (2026-08-04)**

## Runtime tồn tại để làm gì?

**Mission**: Runtime là trung tâm điều phối của AIOS. Mọi hoạt động đều phải được Runtime khởi tạo, điều phối, giám sát và kết thúc. Không có thành phần nào được phép thực thi bên ngoài Runtime.

**Vision**: Runtime trở thành một Execution Kernel thống nhất cho toàn bộ AIOS.

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Trạng thái |
|---|------|------|-----------|
| S001 | Runtime Vision | `S001-vision.md` | ✅ Frozen |
| S002 | Runtime Requirements | `S002/requirements.md` | ✅ Frozen |
| S003 | Runtime Responsibilities | `S003/responsibilities.md` | ✅ Frozen |
| S004 | Runtime Boundaries | `S004/boundaries.md` | ✅ Frozen |
| S005 | Runtime Architecture | `S005/architecture.md` | ✅ Frozen |
| S006 | Runtime Components | `S006/components.md` | 🚧 In progress |
| S007 | Runtime Contracts | `S007-contracts.md` | ⬜ |
| S008 | Runtime Data Model | `S008-data-model.md` | ⬜ |
| S009 | Runtime State Machine | `S009-state-machine.md` | ⬜ |
| S010 | Runtime Execution Flow | `S010-execution-flow.md` | ⬜ |
| S011 | Runtime Events | `S011-events.md` | ⬜ |
| S012 | Runtime Context | `S012-context.md` | ⬜ |
| S013 | Runtime Artifact Model | `S013-artifact-model.md` | ⬜ |
| S014 | Runtime Metrics | `S014-metrics.md` | ⬜ |
| S015 | Runtime Error Model | `S015-error-model.md` | ⬜ |
| S016 | Runtime Configuration | `S016-configuration.md` | ⬜ |
| S017 | Runtime Lifecycle | `S017-lifecycle.md` | ⬜ |
| S018 | Runtime Extension Points | `S018-extension-points.md` | ⬜ |
| S019 | Runtime Security | `S019-security.md` | ⬜ |
| S020 | Runtime Compliance | `S020-compliance.md` | ⬜ |

## Quy tắc

- Mỗi bước phải được **review + freeze** trước khi sang bước tiếp.
- 100% SPEC hoàn thành trước khi viết code.
- SPEC chỉ tham chiếu Constitution (SPEC-000), không định nghĩa lại khái niệm/rule.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Compliance cho Runtime: `../SPEC-000/compliance-matrix.yaml`
- Roadmap: `../README.md`
