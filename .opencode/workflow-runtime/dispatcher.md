---
name: workflow-runtime-dispatcher
description: dispatcher — Thành phần 6: adapter giữa Runtime và Agent. Phase 2 sẽ thay bằng Capability Resolver.
agent: general
---

# dispatcher.md — Dispatcher

> Thành phần 6. **Adapter duy nhất** giữa Runtime và Agent.
> Phase 2 thay dispatcher bằng **Capability Resolver**.

## 1. Vai trò

```text
Current Phase
      ↓
Resolve (capability → agent)
      ↓
Agent
      ↓
Execute
```

Dispatcher không chứa logic nghiệp vụ — chỉ là cầu nối.

## 2. Cơ chế phase 1

Trong Phase 1, dispatcher trong cách **đơn giản nhất**:

| Trường | Giá trị |
|--------|---------|
| `phase.agent` | tên agent trực tiếp (tạm thời Phase 1) |
| OR `phase.capability` | capability id (chờ Phase 2) |

Nếu khai báo `phase.capability` → Phase 2 resolver đọc registry. Nếu chỉ `phase.agent` → dispatcher map thẳng.

## 3. Interface (contract)

```text
interface Dispatcher {
  resolve(phase) → agent
  execute(agent, phase, inputs) → outputs
}
```

## 4. Phase 2 thay thế

- `resolve(phase)` → gọi Capability Registry → `capability + priority + providers`.
- Dispatcher chỉ còn là adapter gọi đúng agent/capability đã chọn.
- Không đổi giao diện; chỉ đổi nguồn resolve.

## 5. Lỗi

| Lỗi | Mã |
|-----|-----|
| Agent không tồn tại / không đảm nhận | AG-001 |
| Capability không có provider | CAP-001 |
| Output sai contract | AG-003 |

## 6. Tương tác

- Được gọi bởi `executor.md`.
- Đọc registry: Phase 1 đơn, Phase 2 → registry.
- Tham chiếu: `architecture/COMPONENTS.md` (Agent Layer), `architecture/adr/ADR-002-Capability-Registry.md`.