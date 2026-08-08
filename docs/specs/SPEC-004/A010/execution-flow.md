---
name: spec-004-a010-execution-flow
description: >
  SPEC-004 A010 — Agent Execution Flow. Trả lời: Agent chạy như thế nào?
  Agent chạy qua Runtime (SPEC-001) + Workflow (SPEC-002) — Agent System chỉ
  khai báo + đăng ký + điều phối. Mirror C010 (SPEC-003).
agent: general
---

# A010 — Agent Execution Flow

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent chạy như thế nào?**

## AF001 — Flow Philosophy

- Agent chạy như Execution của Runtime (SPEC-001).
- Agent System khai báo + đăng ký, Runtime thực thi (AB004).
- Điều phối qua Workflow (SPEC-002).
- Không bước nào thiếu Event (S011).

## AF002 — Flow Principles

- **Declarative** — Agent khai báo trước, không hardcode.
- **Validate trước khi đăng ký** (AFR-006).
- **Register trước khi chạy** (ANFR-003).
- **Delegate thực thi cho Runtime** (AB004).
- Mọi execution có trace + event (S011).

## AF003 — Execution Stages (7)

Agent dùng 7 stages của **S010 EF004** (qua Runtime) — không định nghĩa lại:

```text
Initialize → Validate → Prepare → Execute → Coordinate → Finalize → Complete
```

## AF004 — Canonical Agent Flow

```text
Command
    ↓
Declare (metadata)
    ↓
Validate
    ↓
Register (S014 + Capability Mapping SPEC-003)
    ↓
Orchestrate (Workflow SPEC-002 + Runtime SPEC-001)
    ↓
Execute (Runtime S010)
    ↓
Finalize
    ↓
Complete
```

## AF005 — Definition Resolution

```text
Khai báo (metadata) → Validate → Register (S014) → Agent Definition
```

## AF006 — Registration Flow

```text
Khai báo → Validate (AB003) → Đăng ký Registry Entry (S014)
    → Capability Mapping (SPEC-003) → Published (AST-003)
```

**Rules:** Không hardcode capability mapping (AB007); mỗi bước sinh Event + Audit (S011).

## AF007 — Orchestration Flow

```text
Request (agent + capability)
    ↓
Resolve capability (SPEC-003 qua Registry S014)
    ↓
Điều phối qua Workflow (SPEC-002)
    ↓
Delegate Runtime (SPEC-001)
    ↓
Resolved (agent execution)
```

**Rules:** Delegate Workflow (SPEC-002) + Runtime (SPEC-001) — không tự chạy (AB004); Failure → lỗi chuẩn (S014 RG005A).

## AF008 — Sequential Usage

- Agent được dùng tuần tự trong Workflow (SPEC-002).
- Step sau chỉ chạy khi step trước Terminal (S009).

## AF009 — Parallel Usage

- Agent dùng song song qua Scatter/Gather (S010 EF021).
- Delegate Runtime thực thi.

## AF010 — Barrier & Join

- Barrier chờ mọi agent con đạt Terminal State (S009).
- Join Policy: ALL · ANY · QUORUM · CUSTOM (S010 EF021).

## AF011 — Gate Flow

```text
Agent → Gate (chưa duyệt) → Waiting (ST-005)
    → Approved → tiếp tục
    → Denied → Failure (ST-009)
```

Gate cần approval (S012 POL-APPROVAL-001); quyết định ghi Audit (S011).

## AF012 — Retry Flow

```text
Agent Failed (ST-009) → Retry (guard: retry_count < max_retry)
    → Retrying (ST-013) → Success
    → Hết retry → Failure
```

Delegate Runtime (S010 EF012, POL-RETRY-001).

## AF013 — Timeout Flow

```text
Agent Running (ST-004) → Timeout exceeded → TimedOut (ST-011)
```

Delegate Runtime (S010 EF014, POL-TIMEOUT-001).

## AF014 — Fallback Flow

```text
Resolution Failed (S014 RG005A)
    ↓
Kiểm tra fallback list (khai báo)
    ↓
Resolve fallback (qua Runtime)
    ↓
Success → dùng fallback
    ↓
Hết fallback → Failure (ST-009)
```

**Rules:** Fallback khai báo trước — không hardcode; mỗi fallback sinh Event (S011).

## AF015 — Failure Flow

6 loại failure:

- Validation Failure (khai báo không hợp lệ)
- Registration Failure (không đăng ký được S014)
- Resolution Failure (S014 RG005A)
- Policy Failure (Gate deny)
- Execution Failure (Runtime)
- System Failure

```text
Failure → Isolation → Failure Event → Failure Artifact → Terminal State
```

## AF016 — Agent Lineage

- Root Agent · Agent trong Workflow (SPEC-002) · Replay (ST-012) · Simulation (GV011A).
- Lineage immutable (append-only, S011).

## AF017 — Agent Outcome

| Outcome | State |
|---------|-------|
| Success | Completed (ST-008) |
| **Fallback Success** | Completed (ST-008) — dùng fallback |
| Failure | Failed (ST-009) |
| Cancelled | Cancelled (ST-010) |
| Timeout | TimedOut (ST-011) |
| Aborted | Aborted (ST-014) |

## AF018 — Machine-readable

```text
agent-execution-flow.yaml
agent-stages.yaml
agent-registration.yaml
agent-orchestration.yaml
agent-fallback.yaml
agent-failure.yaml
agent-lineage.yaml
agent-outcome.yaml
agent-policies.yaml
agent-validation.yaml
agent-execution-flow.schema.json
```

## AF019 — Success Criteria

- Canonical flow 8 bước đầy đủ.
- Mọi execution delegate Runtime (không tự chạy).
- Mọi agent đăng ký trước khi chạy (ANFR-003).
- Mọi bước sinh Event (S011).
- Fallback khai báo trước — không hardcode.
- Agent kết thúc bằng Terminal State (S009).
- Agent khai báo tham số policy, không định nghĩa policy (AB008).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A009: `../A009/state-machine.md`
- C010: `../../SPEC-003/C010/execution-flow.md` (mẫu)
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S010: `../../SPEC-001/S010/execution-flow.md` (delegate)
- S011: `../../SPEC-001/S011/observability.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
