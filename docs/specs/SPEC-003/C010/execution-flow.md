---
name: spec-003-c010-execution-flow
description: >
  SPEC-003 C010 — Capability Execution Flow. Trả lời: Capability chạy như thế
  nào? Capability chạy qua Runtime (SPEC-001) — Capability System chỉ khai
  báo + đăng ký + resolve. Mirror W010 (SPEC-002).
agent: general
---

# C010 — Capability Execution Flow

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability chạy như thế nào?**

## CF001 — Flow Philosophy

- Capability chạy như Execution của Runtime (SPEC-001).
- Capability System khai báo + đăng ký, Runtime thực thi (CB004).
- Mọi resolution đều qua Runtime (EF007).
- Không bước nào thiếu Event (S011).

## CF002 — Flow Principles

- **Declarative** — năng lực khai báo trước, không hardcode.
- **Validate trước khi đăng ký** (CFR-006).
- **Register trước khi resolve** (CNFR-003).
- **Delegate thực thi cho Runtime** (CB004).
- Mọi resolution có trace + event (S011).

## CF003 — Execution Stages (7)

Capability dùng 7 stages của **S010 EF004** (qua Runtime) — không định nghĩa lại:

```text
Initialize → Validate → Prepare → Execute → Coordinate → Finalize → Complete
```

## CF004 — Canonical Capability Flow

```text
Command
    ↓
Declare (metadata)
    ↓
Validate
    ↓
Register (S014 + mapping)
    ↓
Resolve (delegate Runtime EF007)
    ↓
Execute (Runtime S010)
    ↓
Finalize
    ↓
Complete
```

## CF005 — Definition Resolution

```text
Khai báo (metadata) → Validate → Register (S014) → Capability Definition
```

## CF006 — Registration Flow

```text
Khai báo → Validate (CB003) → Đăng ký Registry Entry (S014)
    → Mapping Agent/Plugin (CB007) → Published (CST-003)
```

**Rules:** Không hardcode mapping (CB007); mỗi bước sinh Event + Audit (S011).

## CF007 — Resolution Flow

```text
Request (capability id + version)
    ↓
Lookup (S014)
    ↓
Candidate Selection
    ↓
Compatibility Check (S013 GV010)
    ↓
Policy Binding Check (S012)
    ↓
Governance Check (S013)
    ↓
Resolved (delegate Runtime EF007)
```

**Rules:** Delegate Runtime (EF007) — không tự resolve (CB004); Failure → lỗi chuẩn (S014 RG005A).

## CF008 — Sequential Usage

- Capability được dùng tuần tự trong Workflow (SPEC-002 W010).
- Step sau chỉ chạy khi step trước Terminal (S009).

## CF009 — Parallel Usage

- Capability dùng song song qua Scatter/Gather (S010 EF021).
- Delegate Runtime thực thi.

## CF010 — Barrier & Join

- Barrier chờ mọi capability con đạt Terminal State (S009).
- Join Policy: ALL · ANY · QUORUM · CUSTOM (S010 EF021).

## CF011 — Gate Flow

```text
Capability → Gate (chưa duyệt) → Waiting (ST-005)
    → Approved → tiếp tục
    → Denied → Failure (ST-009)
```

Gate cần approval (S012 POL-APPROVAL-001); quyết định ghi Audit (S011).

## CF012 — Retry Flow

```text
Capability Failed (ST-009) → Retry (guard: retry_count < max_retry)
    → Retrying (ST-013) → Success
    → Hết retry → Failure
```

Delegate Runtime (S010 EF012, POL-RETRY-001).

## CF013 — Timeout Flow

```text
Capability Running (ST-004) → Timeout exceeded → TimedOut (ST-011)
```

Delegate Runtime (S010 EF014, POL-TIMEOUT-001).

## CF014 — Fallback Flow

```text
Resolution Failed (S014 RG005A)
    ↓
Kiểm tra fallback list (khai báo)
    ↓
Resolve fallback (qua Runtime EF007)
    ↓
Success → dùng fallback
    ↓
Hết fallback → Failure (ST-009)
```

**Rules:** Fallback khai báo trước — không hardcode; mỗi fallback sinh Event (S011).

## CF015 — Failure Flow

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

## CF016 — Capability Lineage

- Root Capability · Capability trong Workflow (SPEC-002) · Replay (ST-012) · Simulation (GV011A).
- Lineage immutable (append-only, S011).

## CF017 — Capability Outcome

| Outcome | State |
|---------|-------|
| Success | Completed (ST-008) |
| **Fallback Success** | Completed (ST-008) — dùng fallback |
| Failure | Failed (ST-009) |
| Cancelled | Cancelled (ST-010) |
| Timeout | TimedOut (ST-011) |
| Aborted | Aborted (ST-014) |

## CF018 — Machine-readable

```text
capability-execution-flow.yaml
capability-stages.yaml
capability-registration.yaml
capability-resolution.yaml
capability-fallback.yaml
capability-failure.yaml
capability-lineage.yaml
capability-outcome.yaml
capability-policies.yaml
capability-validation.yaml
capability-execution-flow.schema.json
```

## CF019 — Success Criteria

- Canonical flow 8 bước đầy đủ.
- Mọi resolution delegate Runtime EF007 (không tự resolve).
- Mọi capability đăng ký trước khi resolve (CNFR-003).
- Mọi bước sinh Event (S011).
- Fallback khai báo trước — không hardcode.
- Capability kết thúc bằng Terminal State (S009).
- Capability khai báo tham số policy, không định nghĩa policy (CB008).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C009: `../C009/state-machine.md`
- W010: `../../SPEC-002/W010/execution-flow.md` (mẫu)
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S010: `../../SPEC-001/S010/execution-flow.md` (delegate)
- S011: `../../SPEC-001/S011/observability.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
