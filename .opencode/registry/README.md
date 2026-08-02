---
name: capability-registry
description: >
  Capability Registry v4.0 — biến agent thành tập capability (thay vì tên). Chứa
  taxonomy, registry (capability/agent/skill/command), resolver, matcher, scorer, validator,
  graph coverage. Non-invasive layer phía trên Workflow Engine (Sprint 1).
agent: general
---

# Capability Registry v4.0

## 1. Mục đích

Thay vì framework chỉ biết tên agent (`planner`, `builder`, `reviewer`, `tester`),
registry biết hệ thống làm được **việc gì (Capability)**. Capability KHÔNG phụ thuộc agent.

```
User request
   │
   ▼
Intent Resolver → Capability → Registry
   │
   ▼
Candidate Agents / Skills / Commands
   │
   ▼
Scorer / Ranking → Selected → Execute
```

## 2. Cấu trúc

| File | Mô tả |
|------|-------|
| `registry.schema.yaml` | Contract v4.0 cho 4 registry |
| `capability.schema.yaml` | Schema chi tiết từng capability object + Capability Manifest |
| `capabilities.yaml` | Taxonomy + 38 capabilities + profile + Capability Manifest (version/owner/stability/since/deprecated) |
| `agent-registry.yaml` | Metadata 18 agents (capabilities, priority, lang, framework) |
| `skill-registry.yaml` | Metadata 29 skills (supports) |
| `command-registry.yaml` | Metadata 55 commands (supports) |
| `registry.md` | Object, resolver pipeline, cache, metrics, API, test |
| `compatibility.md` | Version/contract compatibility check (reject khi không khớp) |
| `category.yaml` | Taxonomy 14 category |
| `tags.yaml` | Tag map cho resolver lọc theo công nghệ |
| `dependency.yaml` | Capability dependency graph (acyclic, runtime thứ tự thực thi) |
| `resolver.md` | Chỉ dẫn: intent/request → capability |
| `matcher.md` | Chỉ dẫn: capability → agents/skills/commands |
| `scorer.md` | Chỉ dẫn: ranking candidate theo score |
| `validator.md` | Checklist validation + bảng mã CR-001..009 |

## 3. Phạm vi & nguyên tắc

- **Non-invasive**: registry layer phía trên, KHÔNG sửa Workflow Engine v4 / definitions / agents.
  Engine v4 vẫn dùng `agent:`/`command:` fixed như hiện tại. Registry là nguồn metadata + discovery.
- Capability có thể route qua Agent, Skill, hoặc Command.
- Mapping skill/command ghi bằng tay (explicit) trong skill-registry.yaml / command-registry.yaml.
- Quy ước: UTF-8 no-BOM, 2-space, không tab, không `#` trước CR-xx/WF-ID.
- Capability có **manifest** (version, owner, stability, since, deprecated) → nguồn cho Phase 10 Evolution + Phase 11 Plugin.
- Capability **không biết Agent**; Agent/Skill/Command chỉ là **implementation** của capability.

## 4. Capability Graph (ví dụ)

```
implementation.code
├── builder   (agent)
├── .opencode/skills/impeccable (skill)
└── /team-build (command)

review.security
├── guardian (agent)
└── team-gitguard (command)
```

Graph chi tiết xem `CAPABILITY_COVERAGE.md` (`.opencode/reports/`).

## 5. Integrity checks

- Xem `validator.md` + chạy `.opencode/scripts/capability-validator.ps1`.
- Doctor (`.opencode/commands/doctor.md`) tích hợp + /team-capabilities để discovery.

## 6. Dùng với Workflow Engine (Sprint 1 + context Sprint 3)

Workflow Engine dispatch theo definition. Registry cung cấp metadata để:
- `/team-capabilities`: xuất taxonomy + graph cho người dùng.
- `capability-validator.ps1`: đảm bảo registry phản ánh hiện trạng.
- Doctor: tính capability coverage (có agent/skill/command cho từng capability).
- Sprint 3 (Context Engine): đọc `required_context`/`produces_artifacts` trong profile để cấp context tối ưu.