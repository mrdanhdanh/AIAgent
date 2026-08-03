---
name: glossary
description: >
  Glossary — nền tảng từ vựng AIOS (D002). Mỗi thuật ngữ MỘT nghĩa duy nhất.
  Mọi SPEC/ADR/RFC phải dùng đúng thuật ngữ này. Quy tắc sử dụng xem RULES.md.
agent: general
---

# AIOS Glossary

> **D002** — tài liệu quan trọng nhất sau Manifest. Nếu thuật ngữ không thống nhất, toàn bộ SPEC sau sẽ mâu thuẫn.
> Mỗi thuật ngữ chỉ có **một nghĩa duy nhất**.

## Template

Mọi thuật ngữ dùng chung template (YAML frontmatter), không thêm field:

```yaml
id:
name:
status: Draft
category:
summary:
definition:
purpose:
responsibilities:
does_not_responsible:
owned_by:
used_by:
inputs:
outputs:
lifecycle:
related:
examples:
references:
```

## Index

| # | Thuật ngữ | File | Category | Định nghĩa ngắn |
|---|-----------|------|----------|-----------------|
| 1 | Runtime | `runtime.md` | core | Trung tâm điều phối thực thi |
| 2 | Workflow | `workflow.md` | execution | Kế hoạch thực thi (không phải Agent) |
| 3 | Phase | `phase.md` | execution | Nhóm Task trong Workflow |
| 4 | Task | `task.md` | execution | Đơn vị thực thi nhỏ nhất |
| 5 | Capability | `capability.md` | execution | Khả năng; Runtime resolve |
| 6 | Agent | `agent.md` | execution | Execution Unit; implement Capability |
| 7 | Skill | `skill.md` | knowledge | Thư viện tri thức tái sử dụng |
| 8 | Command | `command.md` | entrypoint | Entry point; khởi động Runtime |
| 9 | Artifact | `artifact.md` | data | Output immutable, versioned |
| 10 | Context | `context.md` | data | Execution Data; chỉ sống trong Runtime |
| 11 | Memory | `memory.md` | data | Bộ nhớ sau Runtime (working/session/failure) |
| 12 | Knowledge | `knowledge.md` | knowledge | Tri thức chuẩn hóa |
| 13 | Event | `event.md` | eventing | Thông báo bất biến |
| 14 | Registry | `registry.md` | platform | Nơi đăng ký; không phải Database |
| 15 | Plugin | `plugin.md` | platform | Extension; không sửa Core |
| 16 | Contract | `contract.md` | contract | Giao diện giữa hai thành phần |

## Quan hệ chính

```text
Command → Workflow → Phase → Task → Runtime → Agent → Artifact
                      ↓                            ↑
                  Capability ──────────────────────┘
                     ↓
                 Registry
```

```text
Context (trong Runtime) ≠ Memory (sau Runtime) → Knowledge
Event ── ghi mọi state change
Contract ── mọi giao tiếp
Plugin ── mở rộng qua Capability/Agent
```

## Quy tắc

- Xem **`RULES.md`** — 4 luật bắt buộc (một nghĩa, không đồng nghĩa, tham chiếu Glossary, đổi qua ADR+RFC).
- Thêm thuật ngữ mới → thêm Glossary trước, rồi mới dùng trong SPEC.
- Sửa Glossary → rà soát mọi SPEC tham chiếu (Consistency check).
