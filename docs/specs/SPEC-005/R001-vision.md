---
name: spec-005-r001-vision
version: "1.0.0"
description: >
  SPEC-005 R001 — Registry Vision. Trả lời: Registry tồn tại để làm gì?
  Và Registry là gì trong AIOS. Không nói implementation, không nói class,
  không nói code.
agent: general
---

# R001 — Registry Vision

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Registry là nguồn sự thật duy nhất (SSOT) cho Runtime Metadata AIOS.

Mọi Capability, Workflow, Contract, Policy, Plugin và Agent đều đăng ký
trong Registry theo S014 (Registry Model), versioned, immutable khi Published,
và được phân giải qua Resolution Service.

Không có metadata nào nằm ngoài Registry.
```

## Vision

```text
Registry trở thành hệ thống metadata thống nhất cho toàn bộ AIOS.

Mọi thành phần — Runtime, Workflow, Capability, Agent, Plugin — tham chiếu
Registry thay vì lưu metadata riêng.
```

## Position

Registry là **metadata system** của AIOS.

Registry **không phải** Database.

Registry **không phải** Runtime.

Registry **không phải** Capability System.

Registry là **hệ thống lưu trữ và phân giải metadata** — storage-agnostic, multi-domain.

## Design Philosophy

Registry được thiết kế theo các nguyên tắc:

- **Metadata only, never data.** Registry lưu metadata, không lưu Business Data.
- **Storage-agnostic.** Không ràng buộc database/implementation.
- **Versioned & Immutable.** Entry Published không bao giờ thay đổi.
- **Resolve through rules.** Phân giải qua Compatibility + Governance (S013).
- **Multi-domain.** capability/workflow/contract/policy/plugin/agent trong một hệ thống.
- **Observable, never hidden.** Mọi resolution quan sát được qua S011.

## Invariants

1. Registry là SSOT duy nhất cho Runtime Metadata.
2. Mọi Entry versioned, immutable khi Published (S014 RG010).
3. Mọi Resolution đi qua Compatibility + Governance.
4. Registry không chứa Business Data.
5. Registry không định nghĩa lại S014 Registry Model — chỉ thực thi.

## Scope

Registry bao gồm:

- Lưu trữ Entry (S014 entry model).
- Resolution Service (S014 resolution pipeline).
- Multi-domain management.
- Version + lifecycle (S014 RG010).
- Observability (S011).
- Governance (S013).

Registry không bao gồm:

- Runtime (SPEC-001).
- Business Data.
- Database implementation.

## Relation to SPEC-001

Registry **thực thi S014** (Runtime Registry Model):

```text
Registry (SPEC-005)
    │
    ├── S014 Registry Model — entry, resolution, lifecycle, constraints
    ├── Runtime (SPEC-001) — Observability (S011), Policies (S012), Governance (S013)
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Lưu trữ + phân giải metadata
```

Registry không định nghĩa lại bất kỳ khái niệm nào của S014.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S014 Registry Model)
