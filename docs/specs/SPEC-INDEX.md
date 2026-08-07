---
name: aios-spec-index
description: >
  Master Specification Index của toàn bộ AIOS. Điểm vào duy nhất cho con người
  và AI. Doctor/Dashboard/Evolution Engine xây chỉ mục từ đây.
agent: general
---

# AIOS — Master Specification Index

> **Điểm vào duy nhất** cho toàn bộ SPEC của AIOS.
> Cấu trúc: Kernel trước, subsystem sau — không chồng chéo.

## SPEC-000 — Constitution

> **Trạng thái**: ✅ Frozen · **Mô hình**: Assemble

```text
SPEC-000 Constitution
├── D001 Manifest
├── D002 Glossary
├── D003 Principles
├── D004 Rules
└── D005 Governance
```

## SPEC-001 — Runtime Kernel

> **Trạng thái**: In progress · **Phụ thuộc**: SPEC-000
> **Tier 1 Foundation + S008: ✅ Frozen · Tier 2 Behavior · Tier 3 Operations

```text
SPEC-001 Runtime Kernel
│
├── Tier 1 — Foundation ✅
│   ├── S001 Runtime Vision          ✅
│   ├── S002 Runtime Requirements    ✅
│   ├── S003 Runtime Responsibilities ✅
│   ├── S004 Runtime Boundaries      ✅
│   ├── S005 Runtime Architecture    ✅
│   ├── S006 Runtime Components      ✅
│   ├── S007 Runtime Contracts       ✅
│   └── Appendix: Canonical Models   ✅
│
├── Tier 2 — Runtime Behavior
│   ├── S008 Runtime Data Model      ✅
│   ├── S009 Runtime State Machine   🚧
│   └── S010 Runtime Execution Flow  🚧
│
└── Tier 3 — Runtime Operations
    ├── S011 Execution Observability ✅ Draft
    ├── S012 Runtime Policies       ✅ Draft
    ├── S013 Runtime Governance     ✅ Draft
    ├── S014 Runtime Registry       ✅ Draft
    ├── S015 Runtime Resources      ✅ Draft
    ├── S016 Runtime Compliance     ✅ Draft
    ├── S017 Runtime Plugins        ✅ Draft
    ├── S018 Runtime Evolution      🚧
    └── S019+ Doctor · Dashboard (mở rộng sau)
```

## SPEC-002 — Workflow Engine

> **Trạng thái**: ⬜ · **Dùng**: SPEC-001

## SPEC-003 — Capability System

> **Trạng thái**: ⬜

## SPEC-004 — Agent System

> **Trạng thái**: ⬜

## SPEC-005 — Registry

> **Trạng thái**: ⬜

## SPEC-006 — Context Engine

> **Trạng thái**: ⬜

## SPEC-007 — Artifact Manager

> **Trạng thái**: ⬜

## SPEC-008 — Event Bus

> **Trạng thái**: ⬜

## SPEC-009 — Contract System

> **Trạng thái**: ⬜

## SPEC-010 — Plugin Framework

> **Trạng thái**: ⬜

## SPEC-011 — Doctor

> **Trạng thái**: ⬜

## SPEC-012 — Simulation Engine

> **Trạng thái**: ⬜

## SPEC-013 — Evolution Engine

> **Trạng thái**: ⬜

## SPEC-014 — Dashboard

> **Trạng thái**: ⬜

## SPEC-015 — SDK

> **Trạng thái**: ⬜

## SPEC-016 — CLI & Commands

> **Trạng thái**: ⬜

## Thứ tự triển khai (Kernel-first)

```text
Constitution
    ↓
Runtime (SPEC-001, đầy đủ S001-S020)
    ↓
Workflow → Capability → Registry → Agent → Context → Artifact → Event → Plugin → ...
```

## Quy ước trạng thái (Review Workflow v2.0 — chuẩn 2-pass, 2 trục)

Mọi mục bắt buộc review **tối thiểu 2 lần** (chi tiết: `docs/governance/review-workflow.md`).

**2 trục tách bạch:**

```text
Document Lifecycle:  Draft → Review → Approved → Frozen → Deprecated → Archived
Review Lifecycle:    NotReviewed → (review 1) → Rev1 → (review 2) → Completed
```

- `NotReviewed` = chưa review · `Rev1` = đã review lần 1 · `Completed` = đã review lần 2 (hoàn thành).
- Mục đã review/Freeze từ trước (✅ Frozen, kế thừa) **giữ nguyên cả 2 trạng thái** — không đổi.
- Ký hiệu tại index này: ✅ = hoàn thành/Frozen · 🚧 = đang làm (Draft/Rev1) · ⬜ = chưa bắt đầu.
- 6 review types: `rev1` · `revfull` · `health` (không tăng count) · `compliance` · `migration` · `regression`.
- Trạng thái chi tiết theo từng mục: `docs/governance/review-tracker.yaml` (nguồn sự thật).
- Điều hành: `/review <SPEC> <mục> [type]` · `/review status` · `/review scan`.

## Quy tắc

- Mọi SPEC tham chiếu Constitution (SPEC-000), không định nghĩa lại.
- Hoàn thiện toàn bộ Runtime trước khi sang SPEC-002.
- Mỗi SPEC theo chuỗi: Vision → Requirements → Responsibilities → Boundaries → Architecture → Components → Contracts → Data Model → State Machine → Execution Flow → Events.
- **Behavior Before Data** — định nghĩa Behavior (State Machine/Flow) trước Data Model; Data là hệ quả của State và Flow.
- Doctor/Dashboard/Evolution đọc file này để xây chỉ mục và kiểm tra tính đầy đủ.

> **Ghi chú**: "Behavior Before Data" hiện là nguyên tắc thiết kế SPEC (đã áp dụng từ S008). Nếu muốn nâng thành Principle P021 trong Constitution → cần RFC + ADR (Constitution đã Frozen).
