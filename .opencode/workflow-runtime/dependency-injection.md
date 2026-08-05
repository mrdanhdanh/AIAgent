---
name: workflow-runtime-dependency-injection
description: dependency-injection — Phase 1.22: Runtime không biết implementation. Logger → ILogger → FileLogger/ConsoleLogger/CloudLogger.
agent: general
---

# dependency-injection.md — Runtime Dependency Injection

> Runtime **không biết implementation**. Chỉ biết interface (contract).

## 1. Pattern

```text
Logger
  ↓
ILogger
  ↓
FileLogger    (Phase 1)
ConsoleLogger (đổi được)
CloudLogger   (đổi được)
```

Đổi implementation → **không sửa Runtime**.

## 2. Vì sao DI

| Không DI | Có DI |
|----------|-------|
| Runtime `new FileLogger()` | Runtime nhận `ILogger` |
| đổi logger → sửa core | đổi binding → không sửa core |
| khó test | mock dễ |

## 3. Contracts (interface) Runtime cần

| Interface | Implementation mặc định |
|-----------|-------------------------|
| ILogger | FileLogger |
| IWorkflowRepository | FileRepository |
| IPersistence | JsonPersistence |
| IMetricsRecorder | MetricsService |
| IStateStore | StateStore |
| IEventQueue | (feature flag events) |

## 4. Cách bind

- `service-locator.md` chứa instance.
- Binding theo `configuration.md` (vd `logger: file` | `console` | `cloud`).
- Phase 1 không cần framework DI — bind thủ công đơn giản; có thể nâng cấp sau.

## 5. Quy tắc

- Runtime chỉ phụ thuộc interface (không dùng concrete class).
- Không `new` trong core (trừ factory duy nhất).
- Test inject mock (test suite không cần AI, không cần file thật).

## 6. Tương tác

- `service-locator.md` (container)
- `configuration.md` (chọn implementation)
- `runtime-test` (mock qua DI)