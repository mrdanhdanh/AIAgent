---
name: workflow-runtime-readme
description: README — mục lục và tổng quan Workflow Runtime (Phase 1). Core framework chuyển workflow từ Prompt-driven sang Runtime-driven.
agent: general
---

# Workflow Runtime — Phase 1

> Core framework. Biến Workflow từ **Prompt-driven** thành **Runtime-driven**.

## 1. Vị trí

- **Phase**: 1 (Workflow Runtime)
- **Kiến trúc**: tuân theo `architecture/ARCHITECTURE.md`, `architecture/DATA_MODEL.md`
- **Thư mục**: `.opencode/workflow-runtime/`
- **Definitions**: `.opencode/workflow/definitions/`

## 2. Triết lý

Workflow Runtime **không biết Planner/Builder/Tester là gì**. Nó chỉ biết:

```text
Workflow → Phase → State → Contract → Artifact
```

Biến đổi thiết kế:

| Trước (Prompt-driven) | Sau (Runtime-driven) |
|-----------------------|----------------------|
| /team → Prompt → Planner → Builder → Reviewer | /team → Runtime → Definition → Instance → Executor → Agent → Artifact |

## 3. Kiến trúc

```text
                User
                 │
              Command
                 │
        ┌─ Workflow Runtime ───────┐
        │  Loader  Validator  Scheduler │
        └────────────┼──────────────┘
                 │
             Phase Executor
                 │
            Agent Dispatcher
                 │
            Output Artifact
                 │
          Workflow Instance
```

## 4. Mục lục (24 thành phần)

| File | Nội dung | Phase |
|------|----------|-------|
| `ARCHITECTURE.md` | Kiến trúc tổng thể Runtime Core | 1.1 |
| `runtime.md` | Thành phần trung tâm: API, event, metrics, test | 1.1+1.15 |
| `kernel.md` | Runtime Kernel — 8 services | 1.2 |
| `compiler.md` | Workflow Compiler (parse→DAG→plan→compiled.json) | 1.3+1.4+1.5 |
| `loader.md` | Loader — parse yaml → object | 1.3 |
| `validator.md` | Validator — schema/cycle/dependency/output | 1.3 |
| `scheduler.md` | Scheduler — phase nào chạy tiếp (DAG/parallel) | 1.1 |
| `dispatcher.md` | Dispatcher — adapter gọi agent (Phase 2 thay) | 1.1 |
| `executor.md` | Executor — vòng chạy instance | 1.1 |
| `repository.md` | Repository abstraction (File→DB→Cloud) | 1.6 |
| `transaction.md` | Transaction như DB (lock/commit/rollback) | 1.8 |
| `lock-manager.md` | Lock Workflow/Artifact/Context | 1.9 |
| `recovery.md` | Recovery — Retry/Rollback/Skip/Resume/Abort/Escalate | 1.10 |
| `state-machine.md` | State machine Workflow + Phase | 1.1 |
| `state-store.md` | State Store atomically + snapshot | 1.2 |
| `metrics.md` | Runtime Metrics đầy đủ | 1.11 |
| `health.md` | Runtime Health (Healthy/Warning/Critical) | 1.12 |
| `api.md` | Runtime API | 1.13 |
| `sdk.md` | Runtime SDK (tầng public duy nhất) | 1.14 |
| `persistence.md` | Persistence (instance/history/state/log) | 1.1 |
| `workflow.schema.yaml` | Schema workflow definition | 1 |
| `phase.schema.yaml` | Schema phase | 1 |
| `instance.schema.yaml` | Schema workflow instance | 1 |
| `compiled.schema.yaml` | Schema compiled.workflow.json | 1.6 |
| `extensions.md` | Extension Points — hook before/after/on-error | 1.16 |
| `service-locator.md` | Service Locator (không new object trực tiếp) | 1.17 |
| `configuration.md` | Runtime Configuration (không hard-code) | 1.18 |
| `feature-flags.md` | Feature Flags (bật/tắt module) | 1.19 |
| `manifest.md` | Runtime Manifest + Generator (runtime-manifest.json) | 1.20+1.23 |
| `compatibility.md` | Compatibility Layer (workflow v3 → v4) | 1.21 |
| `dependency-injection.md` | Dependency Injection (interface → impl) | 1.22 |
| `benchmark.md` | Runtime Benchmark (/team-runtime-benchmark) | 1.24 |
| `RUNTIME_ACCEPTANCE.md` | Runtime Acceptance Checklist | 1.25 |
| `RUNTIME_CERTIFICATE.md` | Runtime Certification | 1.26 |
| `runtime-manifest.yaml` | Runtime tự khai báo (mẫu) | 1.20 |

## 5. Nguyên tắc khóa phạm vi (1.27)

> **Workflow Runtime không được phụ thuộc vào bất kỳ khái niệm AI nào.**

Runtime chỉ xử lý các khái niệm tổng quát:

```text
Workflow · Phase · State · Transition · Contract · Artifact · Execution · Persistence
```

Các khái niệm **Agent · Capability · Prompt · LLM · Skill** chỉ xuất hiện từ **Phase 2** qua adapter/service ngoài.

Lợi ích:
- Runtime tái sử dụng cho workflow không AI.
- Core ổn định, đơn giản, dễ test.
- Extension Points (1.16) là nơi AI gắn vào sau.

## 5. Pipeline biên dịch

```text
workflow.yaml
    ▼
Workflow Compiler  (validate schema, giải dependency, DAG, detect cycle, sinh execution plan)
    ▼
Compiled Workflow
    ▼
Workflow Runtime
```

Runtime chỉ thực thi, không phân tích lại workflow mỗi lần.

## 6. Phụ thuộc phase sau

- **Phase 2** (Capability Registry) → thay `dispatcher.md` bằng Capability Resolver.
- **Phase 4** (Context), **Phase 5** (Artifact), **Phase 6** (Event), **Phase 8** (Diagnostics/Doctor) → đọc/ghi qua Runtime API.
- **Phase 12** (Dashboard) → đọc persistence.

## 7. Workflow Runtime Acceptance Checklist

> Chỉ khi **đạt toàn bộ** mới chuyển sang Phase 2 — Capability Registry.

### Functional

- [ ] Nạp được workflow từ definition.
- [ ] Compiler tạo được execution plan hợp lệ (DAG + order, cycle-free).
- [ ] Runtime thực thi theo state machine.
- [ ] Hỗ trợ retry, rollback, pause, resume.
- [ ] Lưu và khôi phục workflow instance (persistence).

### Non-functional

- [ ] Runtime không phụ thuộc tên Agent/Skill.
- [ ] Runtime không chứa prompt AI.
- [ ] Runtime không hard-code workflow cụ thể.
- [ ] Mọi thao tác đều đi qua Runtime API (SDK).
- [ ] Có test suite độc lập với AI.

### Phụ (Runtime Core)

- [ ] Compile 1 lần, chạy nhiều (compiled.workflow.json cache).
- [ ] Transaction + Lock khi chạy phase.
- [ ] Recovery nhiều strategy (retry/rollback/skip/resume/abort/escalate).
- [ ] Metrics + Health đo được.
- [ ] Repository abstraction (File→DB→Cloud sẵn).

Khi đạt → **Workflow Runtime thành nền tảng độc lập**; Agent Framework chỉ là một hệ thống chạy trên nền Runtime.