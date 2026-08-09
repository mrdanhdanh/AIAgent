---
name: spec-015-x001-vision
version: "1.0.0"
description: >
  SPEC-015 X001 — SDK Vision. Trả lời: SDK tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — SDK Vision

> **SPEC-015**: SDK · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **SDK tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
SDK là lớp truy cập chính thức vào AIOS.

Mọi bên ngoài truy cập AIOS đều qua SDK: client cho từng component
(agent, plugin, workflow, context, artifact, event, registry, doctor,
simulation, evolution, dashboard), API binding theo Contract, typed access,
auth, và versioning — theo aios-sdk.schema.yaml.

Không ai truy cập Core trực tiếp.
```

## Vision

```text
SDK trở thành cổng truy cập thống nhất cho toàn bộ AIOS.

Mọi ứng dụng, script, plugin tích hợp AIOS qua SDK thay vì truy cập Core.
```

## Position

SDK là **access layer** của AIOS.

SDK **không phải** Runtime.

SDK **không phải** Core.

SDK là **lớp truy cập chính thức** — client, API binding, typed access, auth, versioning.

## Design Philosophy

SDK được thiết kế theo các nguyên tắc:

- **Access only.** SDK chỉ truy cập qua Contract — không vào Core trực tiếp (P006).
- **Typed access.** Mọi component có typed client.
- **Versioned.** SDK version theo semver (aios-sdk v13).
- **Auth required.** Mọi truy cập qua auth.
- **Observable, never hidden.** Mọi SDK call quan sát được qua S011.
- **Safe.** SDK không chứa Business Data (S011 OB003A).

## Invariants

1. SDK truy cập AIOS qua Contract — không vào Core trực tiếp (P006).
2. SDK cung cấp typed client cho 11 components.
3. SDK version theo semver (aios-sdk v13).
4. Mọi truy cập qua auth.
5. SDK không chứa Business Data (S011 OB003A).
6. Mọi SDK call sinh Event (S011).

## Scope

SDK bao gồm:

- SDK Client (per component).
- API Binding (theo Contract).
- Typed Access.
- Auth.
- Versioning (semver).
- SDK Registry (SPEC-005).
- Observability (S011).

SDK không bao gồm:

- Runtime (SPEC-001).
- Core Implementation.
- Business Data.
- Quyết định chính sách (S013).

## Relation to SPEC-000..014

SDK **truy cập AIOS qua Contract**:

```text
SDK (SPEC-015)
    │
    ├── SPEC-001..014 — Components để binding
    ├── SPEC-005 — Registry (SDK registration)
    ├── SPEC-009 — Contract (API binding)
    ├── aios-sdk — schema v13 (11 components)
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Truy cập AIOS
```

SDK không định nghĩa lại bất kỳ hệ thống nào.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Registry: `../SPEC-005/`
- aios-sdk: `.opencode/aios-sdk/`
