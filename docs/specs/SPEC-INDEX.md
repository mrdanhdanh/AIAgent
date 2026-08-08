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

> **Trạng thái**: ✅ Frozen (S001-S020, 2026-08-08) · **Phụ thuộc**: SPEC-000
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
│   ├── S009 Runtime State Machine   ✅
│   └── S010 Runtime Execution Flow  ✅
│
└── Tier 3 — Runtime Operations
    ├── S011 Execution Observability ✅
    ├── S012 Runtime Policies       ✅
    ├── S013 Runtime Governance     ✅
    ├── S014 Runtime Registry       ✅
    ├── S015 Runtime Resources      ✅
    ├── S016 Runtime Compliance     ✅
    ├── S017 Runtime Plugins        ✅
    ├── S018 Runtime Evolution      ✅
    ├── S019 Runtime Doctor         ✅
    └── S020 Runtime Dashboard      ✅
```

## SPEC-002 — Workflow Engine

> **Trạng thái**: In progress (20/20 — W001-W008 Rev1, W009-W010 Completed, W011 Rev1, W012 Completed, W013 Completed, W014 Rev1, W015 Rev1, W016 Rev1, W017 Rev1, W018-W020 NotReviewed) · **Phụ thuộc**: SPEC-000, SPEC-001

```text
SPEC-002 Workflow Engine
│
├── Tier 1 — Foundation ✅
│   ├── W001 Workflow Vision          🚧 Draft
│   ├── W002 Workflow Requirements    🚧 Draft
│   ├── W003 Workflow Responsibilities 🚧 Draft
│   ├── W004 Workflow Boundaries      🚧 Draft
│   ├── W005 Workflow Architecture    🚧 Draft
│   ├── W006 Workflow Components      🚧 Draft
│   ├── W007 Workflow Contracts       🚧 Draft
│   └── Appendix: Canonical Models    ✅ Draft
│
├── Tier 2 — Behavior ✅
│   ├── W008 Workflow Data Model      🚧 Draft
│   ├── W009 Workflow State Machine   ✅ Draft
│   └── W010 Workflow Execution Flow  ✅ Draft
│
└── Tier 3/4 — Operations + Experience ✅
    ├── W011-W016 Operations          🚧 Draft
    └── W017-W020 Experience          🚧 Draft
```

## SPEC-003 — Capability System

> **Trạng thái**: ✅ COMPLETE (20/20 Draft) · **Phụ thuộc**: SPEC-000, SPEC-001, SPEC-002

```text
SPEC-003 Capability System
│
├── Tier 1 — Foundation ✅
│   ├── C001 Capability Vision          ✅ Draft
│   ├── C002 Capability Requirements    ✅ Draft
│   ├── C003 Capability Responsibilities ✅ Draft
│   ├── C004 Capability Boundaries      ✅ Draft
│   ├── C005 Capability Architecture    ✅ Draft
│   ├── C006 Capability Components      ✅ Draft
│   ├── C007 Capability Contracts       ✅ Draft
│   └── Appendix: Canonical Models      ✅ Draft
│
├── Tier 2 — Behavior ✅
│   ├── C008 Capability Data Model      ✅ Draft
│   ├── C009 Capability State Machine   ✅ Draft
│   └── C010 Capability Execution Flow  ✅ Draft
│
└── Tier 3/4 — Operations + Experience ✅
    ├── C011-C016 Operations            ✅ Draft
    └── C017-C020 Experience            ✅ Draft
```

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
