---
name: spec-006-x011-observability
description: SPEC-006 X011 - Context Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Context Observability

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Context quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Context la observability boundary (S011 OB003A).
- Moi thay doi Context phai phat Event (S011).
- Khong the debug Context ma khong co event/trace.
- Observability la bat buoc (P005, XNF-004).

## XO002 - Principles

- **Event-first** - moi stage/transition co event.
- **Immutable events** - chi append (P010).
- **Correlated** - correlation_id xuyen suot.
- **Metrics co label** - phan tich duoc.
- **Audit day du** - ai lam gi, khi nao (XFR-016).

## XO003 - Events (15)

| Event | Y nghia |
|-------|---------|
| CONTEXT_ALLOCATED | Context tao |
| CONTEXT_POPULATED | Du lieu dien vao |
| CONTEXT_ACTIVE | San sang dung |
| CONTEXT_DISTRIBUTED | Grant cap |
| CONTEXT_MUTATED | Item thay doi |
| CONTEXT_MERGING / MERGED | Gop Context con |
| CONTEXT_COLLECTING / COLLECTED | Thu ket qua |
| CONTEXT_RELEASED | Thu hoi |
| CONTEXT_REJECTED | Tu choi |
| CONTEXT_MERGE_FAILED | Merge loi |
| CONTEXT_RELEASED_FAILED | Release loi |
| CONTEXT_GRANTED / GRANT_REVOKED | Grant song doi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

context_allocated_total, context_released_total, context_rejected_total,
context_active_current, context_mutate_total, context_merge_total,
context_release_latency_seconds, context_grant_active_current, context_memory_bytes.

Labels: context_id, state, execution_id, agent_id.

## XO005 - Traces (7 spans)

context.allocate / populate / distribute / mutate / merge / collect / release.
Span attrs: context_id, execution_id, grant_id, agent_id.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi thay doi Context.

## XO007 - Correlation

correlation_id (Context) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Context Activity, Lifecycle, Failures, Grant Status, Resource Usage.
Tool: X020 Context Dashboard.

## XO009 - Health Checks (5)

allocate_ok, release_ok (khong leak), state_ok (khong stuck),
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- X009 State Machine - SPEC-006
- X019 Doctor - SPEC-006
