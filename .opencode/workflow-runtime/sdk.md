---
name: workflow-runtime-sdk
description: sdk — Phase 1.14: Runtime SDK — các tầng sau không truy cập Runtime trực tiếp, tất cả qua SDK.
agent: general
---

# sdk.md — Runtime SDK

> **Các Phase sau không được truy cập Runtime trực tiếp.** Tất cả phải dùng SDK.

## 1. Chain

```text
Workflow SDK
   ↓
Runtime API (api.md)
   ↓
Runtime Kernel (kernel.md)
```

## 2. Ai dùng SDK

- Command (Phase 3+)
- Plugin (Phase 11)
- Simulation (Phase 7)
- Doctor (Phase 8)
- Dashboard (Phase 12)
- AI/Agent framework (chạy trên Runtime)

Không module nào gọi thẳng `kernel.md`/`state-store.md`/`event-queue` — đều qua SDK → API.

## 3. SDK surface

```text
SDK:
  workflows.create(def, vars)
  workflows.execute(id)
  workflows.pause(id) / resume(id) / cancel(id)
  workflows.retry(id) / rollback(id)
  workflows.state(id) / metrics(id)
```

SDK là **public contract ổn định** (versioned, VERSIONING.md) — các phase sau code phụ thuộc SDK, không phụ thuộc nội bộ kernel.

## 4. Lợi ích

- Runtime nội bộ tự đổi (kernel/store), SDK giữ nguyên → không phá caller.
- Plugin/Simulation/Doctor/Dashboard code một chỗ, dùng chung SDK.
- Test: mock SDK dễ hơn mock kernel.

## 5. Tương tác

- `api.md` (hàm được wrap)
- `kernel.md` (hàm thực thi)
- `sdk.md` là tầng public duy nhất.