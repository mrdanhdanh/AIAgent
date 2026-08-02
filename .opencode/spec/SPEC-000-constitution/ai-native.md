---
name: spec-000-ai-native
description: SPEC-000 Part VII — AI Native: Machine/Human Readable, Executable Spec, AI Responsibilities, Evolution, Future.
agent: general
---

# Part VII — AI Native

Phần khác biệt so với mọi framework khác.

## Chương 25 — Machine Readable

> Mọi định nghĩa đều phải có **Schema**.

- Metadata, config, output: có schema (yaml/json).
- AI đọc được, không cần diễn giải prose.
- Schema là nguồn sinh code.

## Chương 26 — Human Readable

> Mọi Schema đều phải có **Documentation**.

- Schema máy đọc được; tài liệu người đọc được.
- Hai mặt bổ sung — không thay thế nhau.

## Chương 27 — Executable Specification

SPEC trở thành thực thi được:

```text
SPEC
  ↓
Schema
  ↓
Validator
  ↓
Runtime
  ↓
Tests
```

- SPEC → Schema → Validator → Runtime → Tests.
- SPEC không chỉ mô tả — nó sinh validator + tests.
- Thay đổi SPEC → tái sinh code nhất quán.

## Chương 28 — AI Responsibilities

Phân định quyền:

```text
AI:    Plan · Generate · Review · Validate · Suggest
Human: Approve · Merge · Release
```

| Việc | AI | Human |
|------|:--:|:-----:|
| Plan/Generate | ✅ | — |
| Review/Validate | ✅ | — |
| Suggest | ✅ | — |
| Approve | ❌ | ✅ |
| Merge/Release | ❌ | ✅ |

- AI không tự apply proposal lớn — cần approval (P011).
- Autonomous mode chỉ khi policy cho phép + audit.

## Chương 29 — Evolution Principles

```text
Observe
  ↓
Analyze
  ↓
Simulate
  ↓
Approve
  ↓
Execute
```

- Observe: thu metrics/events.
- Analyze: phát hiện pattern.
- Simulate: backtest trước apply.
- Approve: con người duyệt.
- Execute: apply + version.

## Chương 30 — Future Compatibility

AIOS thiết kế cho tương lai:

```text
Distributed Runtime
Cloud Native
Local AI
Hybrid AI
Multi Model
```

- Distributed: event bus nối node.
- Cloud Native: stateless → container.
- Local/Hybrid AI: model router (P015 compatible).
- Multi Model: abstraction qua Capability.