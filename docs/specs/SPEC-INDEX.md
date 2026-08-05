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
> **Tier 1 Foundation: ✅ Frozen** · Tier 2 Behavior · Tier 3 Quality

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
│   ├── S008 Runtime Data Model
│   ├── S009 Runtime State Machine
│   ├── S010 Runtime Execution Flow
│   ├── S011 Runtime Event Model
│   └── S012 Runtime Error Model
│
└── Tier 3 — Runtime Quality
    ├── S013 Runtime Observability
    ├── S014 Runtime Security
    └── S015 Runtime Compliance & Verification
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

## Quy tắc

- Mọi SPEC tham chiếu Constitution (SPEC-000), không định nghĩa lại.
- Hoàn thiện toàn bộ Runtime trước khi sang SPEC-002.
- Mỗi SPEC theo chuỗi: Vision → Requirements → Responsibilities → Boundaries → Architecture → Components → Contracts → Data Model → State Machine → Execution Flow → Events.
- **Behavior Before Data** — định nghĩa Behavior (State Machine/Flow) trước Data Model; Data là hệ quả của State và Flow.
- Doctor/Dashboard/Evolution đọc file này để xây chỉ mục và kiểm tra tính đầy đủ.

> **Ghi chú**: "Behavior Before Data" hiện là nguyên tắc thiết kế SPEC (đã áp dụng từ S008). Nếu muốn nâng thành Principle P021 trong Constitution → cần RFC + ADR (Constitution đã Frozen).
