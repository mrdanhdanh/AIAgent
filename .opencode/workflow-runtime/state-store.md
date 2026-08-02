---
name: workflow-runtime-state-store
description: state-store — kết State Store tách khỏi Runtime Domain: ghi/đọc trạng thái workflow atomic, support snapshot, theo state-machine.
agent: general
---

# state-store.md — State Store

> Nơi lưu trạng thái hiện tại của workflow instance (Runtime-side). Atomic, hỗ trợ snapshot.

## 1. Trách nhiệm

- Lưu `WorkflowInstance` runtime state (Ph 1.7 Runtime Context).
- Ghi atomic (transaction.md) — không ghi dở dang.
- Support snapshot để recovery/rollback.

## 2. Runtime Context (Phase 1.7)

> KHÔNG phải Context Engine.

```text
Workflow ID
Current Phase
Retry
State
Metrics
Current Artifact
```

Chỉ runtime dùng, không cho AI/agent.

## 3. Dữ liệu lưu (per instance)

| Field | Giá trị |
|-------|------|
| id | WF-... |
| status | state-machine |
| current_phase | phase đang chạy |
| retry_count | số lần retry phase |
| completed[] | phase đã xong |
| failed[] | phase fail |
| artifacts[] | artifact sinh |
| metrics | Phase Time, Artifact Count... |
| checkpoint | điểm rollback an toàn |

## 4. Operational

```text
get(id)             → instance
save(instance)      → atomic
snapshot(id)        → checkpoint
restore(checkpoint) → khôi phục
```

## 5. Snapshot & recovery

- Trước mỗi phase nguy hiểm (build), state-store `commit(snapshot)`.
- Khi fail, recovery đọc snapshot → `restore` → trở về trạng thái an toàn.

## 6. Ghi atomic

- Ghi file tạm → validate → rename (persistence.md).
- Không cho consumer đọc nửa file.

## 7. Module liên hệ

- `persistence.md` — backend ghi.
- `transaction.md` — gói commit.
- `state-machine.md` — trạng thái hợp lệ.
- `lock-manager.md` — chống ghi chạy race.