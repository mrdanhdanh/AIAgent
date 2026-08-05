---
name: glossary-catalog
description: >
  AIOS Glossary Catalog — danh mục thuật ngữ (D002 Domain Model).
  Liệt kê đầy đủ 16 thuật ngữ với id/category/entity_type/invariants.
  Nguồn chi tiết: terms/*.md.
agent: general
---

# AIOS Glossary — Catalog

> **D002** — Danh mục toàn bộ thuật ngữ AIOS. Mỗi thuật ngữ một file trong `terms/`.
> Đây là **Domain Model**, không phải từ điển.

## 1. Taxonomy

| Category | Mô tả | Terms |
|----------|-------|-------|
| Core | Thành phần trung tâm | Runtime |
| Execution | Cấu trúc & thực thi công việc | Workflow, Phase, Task, Agent, Capability |
| EntryPoint | Điểm vào hệ thống | Command |
| Data | Dữ liệu thực thi & lưu trữ | Artifact, Context, Memory |
| Knowledge | Tri thức tái sử dụng | Knowledge, Skill |
| Platform | Hạ tầng nền tảng | Event, Registry, Contract |
| Extension | Mở rộng ngoài Core | Plugin |

## 2. Terms Index

| # | ID | Term | Category | Entity Type | File | Invariant |
|---|----|------|----------|-------------|------|-----------|
| 1 | TERM-001 | Runtime | Core | Service | `terms/runtime.md` | Luôn đúng một Runtime/Execution Context |
| 2 | TERM-002 | Workflow | Execution | Definition | `terms/workflow.md` | Không tự thay đổi |
| 3 | TERM-003 | Phase | Execution | Definition | `terms/phase.md` | Không phải Agent |
| 4 | TERM-004 | Task | Execution | Definition | `terms/task.md` | Không tự điều phối Agent |
| 5 | TERM-005 | Agent | Execution | Execution | `terms/agent.md` | Không giữ state |
| 6 | TERM-006 | Capability | Execution | Definition | `terms/capability.md` | Không chứa implementation |
| 7 | TERM-007 | Command | EntryPoint | Definition | `terms/command.md` | Chỉ khởi động Runtime |
| 8 | TERM-008 | Artifact | Data | Data | `terms/artifact.md` | Không overwrite |
| 9 | TERM-009 | Context | Data | Data | `terms/context.md` | Chỉ sống trong Runtime |
| 10 | TERM-010 | Memory | Data | Data | `terms/memory.md` | Tồn tại sau Runtime |
| 11 | TERM-011 | Knowledge | Knowledge | Data | `terms/knowledge.md` | Tri thức chuẩn hóa |
| 12 | TERM-012 | Event | Platform | Message | `terms/event.md` | Immutable |
| 13 | TERM-013 | Registry | Platform | Service | `terms/registry.md` | Không phải Database |
| 14 | TERM-014 | Contract | Platform | Definition | `terms/contract.md` | Không gọi trực tiếp |
| 15 | TERM-015 | Plugin | Extension | Extension | `terms/plugin.md` | Không sửa Core |
| 16 | TERM-016 | Skill | Knowledge | Definition | `terms/skill.md` | Không có state |

## 3. Main Flow

```text
User
    │
Command
    │
Workflow
    │
Phase
    │
Task
    │
Runtime
    │
Capability
    │
Registry
    │
Agent
    │
Skill
    │
Artifact
    │
Event
```

Context và Memory đứng ngang Runtime (data layer).

## 4. Ownership Matrix (tóm tắt)

| Entity | Owns | Owns nothing |
|--------|------|:---:|
| Runtime | Workflow State, Context, Execution, Event Bus | |
| Agent | — | ✅ |
| Workflow | Phase Definition | |
| Phase | Task Definition | |
| Registry | Capability/Agent Registration | |
| Plugin | Exported Capability/Skill | |
| Event | — | ✅ |

## 5. Cardinality (tóm tắt)

- Workflow **1..\*** Phase · Phase **1..\*** Task
- Task **1..1** Agent
- Capability **1** → **0..N** Agent
- Registry **1** → **N** Capability
- Plugin **1** → **0..N** Capability
- Context **1..1** Runtime

## Tham chiếu

- Chi tiết quan hệ: `relationships.yaml`
- Phân loại: `taxonomy.yaml`
- Quy tắc sử dụng: `RULES.md`
- Schema validate: `glossary.schema.json`
