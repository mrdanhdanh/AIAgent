---
name: workflow-runtime-service-locator
description: service-locator — Phase 1.17: Runtime không new object trực tiếp. Service Locator trung gian (Repo/Persistence/Metrics/Logger).
agent: general
---

# service-locator.md — Runtime Service Locator

> Runtime **không new object trực tiếp**. Service Locator là trung gian.

## 1. Chain

```text
Runtime
   ↓
Service Locator
   ├── Workflow Repository
   ├── Persistence
   ├── Metrics
   └── Logger
```

## 2. Vì sao

```text
File
 ↓
SQLite
 ↓
Postgres
 ↓
Cloud
```

Đổi backend → không sửa Runtime. Runtime chỉ hỏi `ServiceLocator.get(IWorkflowRepository)`.

## 3. API

```text
get<T>(service_type)  → T
register(instance)
clear()
```

| Service | Interface |
|---------|-----------|
| Repository | IWorkflowRepository |
| Persistence | IPersistence |
| Metrics | IMetricsRecorder |
| Logger | ILogger |
| State Store | IStateStore |
| Event Queue | IEventQueue |

## 4. Quan hệ với DI

- Service Locator là **container** chứa instance; DI (1.22) quyết **cách dựng**.
- Trong Phase 1 dùng Service Locator đơn giản; nếu thêm DI framework → ServiceLocator dùng DI làm factory.

## 5. Quy tắc

- Runtime không `new` service trực tiếp — luôn qua locator.
- Plugin (Phase 11) đăng ký service qua locator (không sửa core).
- Không để service rò ra ngoài (SDK vẫn là tầng duy nhất public).

## 6. Tương tác

- `kernel.md` (services gọi qua locator)
- `dependency-injection.md` (cách dựng)
- `configuration.md` (cấu hình service chọn)