---
name: spec-001-runtime-models
description: >
  SPEC-001 Appendix — Runtime Canonical Models. Chuẩn hóa các model dùng
  xuyên suốt: Execution, Context, Artifact, Event, Contract, Capability, Metadata.
  S008 (Data Model), S009 (State Machine), S010 (Execution Flow) chỉ tham chiếu.
agent: general
---

# SPEC-001 Appendix — Runtime Canonical Models

> **SPEC-001**: Runtime Kernel · **Trạng thái**: Draft
> Mục đích: giảm trùng lặp, giữ SPEC nhất quán dài hạn.

## Mục đích

S008, S009, S010 và các SPEC sau **chỉ tham chiếu** các model chuẩn này thay vì định nghĩa lặp lại.

## Canonical Models

| Model | Fields |
|-------|--------|
| Execution | id, workflow_ref, status, context_ref, state_ref, started_at, ended_at, result_ref, events |
| Context | id, execution_ref, data, allocated_to, created_at, closed_at, isolated |
| Artifact | id, type, version, checksum, owner, created_at, immutable, metadata |
| Event | id, type, execution_ref, state_from, state_to, timestamp, lineage, immutable |
| Contract | id, name, category, version, status, owner, direction, pattern, inputs, outputs |
| Capability | id, name, description, implementation_ref, status, version |
| Metadata | id, type, version, status, owner, created_at, updated_at, tags |

## Quy tắc

- Mỗi model là **canonical** — một định nghĩa duy nhất (P009 Single Source of Truth).
- Model **versioned** (P004).
- Model **immutable** sau Published (nếu áp dụng) (P010).
- Muốn đổi model → RFC + ADR → version mới.

## Tham chiếu

- `runtime-models.yaml` — nguồn dữ liệu chuẩn.
- Glossary: `docs/glossary/`
- S008 (Data Model), S009 (State Machine), S010 (Execution Flow) sẽ tham chiếu tại đây.
