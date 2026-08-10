---
name: spec-005-r010-execution-flow
description: SPEC-005 R010 — Registry Execution Flow.
agent: general
---

# R010 — Registry Execution Flow

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Entry chạy như thế nào?**

## RF001 — Flow Philosophy

- Entry chạy như Execution của Runtime (SPEC-001).
- Registry lưu + resolve, Runtime thực thi (RB004).
- Không bước nào thiếu Event (S011).

## RF002 — Flow Principles

- **Declarative** — Entry khai báo trước, không hardcode.
- **Validate trước khi lưu** (RFR-004).
- **Delegate thực thi cho Runtime** (RB004).
- Mọi resolution có trace + event (S011).

## RF003 — Execution Stages (7)

```text
Initialize → Validate → Prepare → Execute → Coordinate → Finalize → Complete
```

(S010 EF004 — không định nghĩa lại)

## RF004 — Canonical Registry Flow

```text
Command → Declare (metadata) → Validate → Store (S014 model)
       → Resolve (S014 pipeline) → Execute (Runtime S010) → Finalize → Complete
```

## RF005 — Definition Resolution

```text
Khai báo (metadata) → Validate → Store (S014) → Entry Definition
```

## RF006 — Storage Flow

```text
Khai báo → Validate (RB003) → Lưu Entry theo S014 → Published (RST-003)
```

Rules: Không lưu Business Data (RB002); mỗi bước sinh Event + Audit (S011).

## RF007 — Resolution Flow

```text
Request (entry id + version) → Lookup → Candidate Selection
→ Compatibility (S013 GV010) → Policy Binding (S012) → Governance (S013) → Resolved
```

Delegate Runtime — không tự resolve (RB004); Failure → lỗi chuẩn (S014 RG005A).

## RF008 — Query Flow

```text
Query Request → Validate Query → Lookup (theo domain) → Trả kết quả
```

Query chỉ đọc metadata; không trả Business Data.

## RF009 — Sequential Usage

- Entry dùng tuần tự trong Workflow (SPEC-002).

## RF010 — Parallel Usage

- Entry dùng song song qua Scatter/Gather (S010 EF021).

## RF011 — Barrier & Join

- Barrier chờ mọi entry con đạt Terminal State (S009).
- Join Policy: ALL · ANY · QUORUM · CUSTOM.

## RF012 — Gate Flow

- Gate cần approval (S012 POL-APPROVAL-001); quyết định ghi Audit (S011).

## RF013 — Retry Flow

- Delegate Runtime (S010 EF012, POL-RETRY-001).

## RF014 — Timeout Flow

- Delegate Runtime (S010 EF014, POL-TIMEOUT-001).

## RF015 — Failure Flow

5 loại: Validation · Storage · Resolution (S014 RG005A) · Policy · System.

```text
Failure → Isolation → Failure Event → Terminal State
```

## RF016 — Registry Lineage

- Root Entry · Entry trong Workflow (SPEC-002) · Replay (ST-012) · Simulation (GV011A).
- Lineage immutable (append-only, S011).

## RF017 — Registry Outcome

| Outcome | State |
|---------|-------|
| Success | Completed (ST-008) |
| Failure | Failed (ST-009) |
| Cancelled | Cancelled (ST-010) |
| Timeout | TimedOut (ST-011) |
| Aborted | Aborted (ST-014) |

## RF018 — Machine-readable

```text
registry-execution-flow.yaml
registry-stages.yaml
registry-storage.yaml
registry-resolution.yaml
registry-query.yaml
registry-failure.yaml
registry-lineage.yaml
registry-outcome.yaml
registry-policies.yaml
registry-validation.yaml
registry-execution-flow.schema.json
```

## RF019 — Success Criteria

- Canonical flow 8 bước. · Mọi resolution delegate Runtime. · Mọi bước sinh Event (S011). · Không lưu Business Data. · Entry kết thúc bằng Terminal State (S009). · Doctor xác minh từ machine-readable.

## Tham chiếu

- R009: `../R009/state-machine.md`
- S010: `../../SPEC-001/S010/execution-flow.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
