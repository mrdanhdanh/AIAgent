---
name: aios-spec
description: >
  AIOS Specification — index toàn bộ SPEC. Mỗi SPEC là một thư mục, 3 cấp độ
  (Vision/Design/Implementation Contract). Bắt đầu từ SPEC-000 Core Principles.
agent: general
---

# AIOS Specification

> **Architecture → Specification → Implementation → Validation**
> Roadmap là Architecture. Từ đây viết **Specification** — AI/Agent/Plugin đọc SPEC, không đọc source.

## 1. Cấu trúc SPEC

Một SPEC là một **thư mục**:

```text
spec/
  SPEC-001-runtime/
    README.md
    terminology.md
    object-model.md
    lifecycle.md
    state-machine.md
    api.md
    contracts.md
    schemas.md
    events.md
    compatibility.md
    examples.md
    tests.md
    changelog.md
```

## 2. 3 cấp độ SPEC

| Level | Hỏi | Nội dung |
|-------|-----|----------|
| Level 1 Vision | Tại sao tồn tại? | motivation, mục tiêu |
| Level 2 Design | Hoạt động thế nào? | object model, state machine, sequence |
| Level 3 Contract | Code ra sao? | schema, API, events, tests |

## 3. SPEC index

| SPEC | Chủ đề | Sprint | Trạng thái |
|------|--------|--------|-----------|
| SPEC-000 | Core Principles | Foundation | 🔶 đang viết |
| SPEC-001 | Runtime | A | ⬜ |
| SPEC-002 | Workflow | A | ⬜ |
| SPEC-003 | Registry | A | ⬜ |
| SPEC-004 | Agent Metadata | A | ⬜ |
| SPEC-005 | Capability | A | ⬜ |
| SPEC-006 | Context | B | ⬜ |
| SPEC-007 | Artifact | B | ⬜ |
| SPEC-008 | Knowledge | B | ⬜ |
| SPEC-009 | Memory | B | ⬜ |
| SPEC-010 | Event | C | ⬜ |
| SPEC-011 | Scheduler | C | ⬜ |
| SPEC-012 | State Machine | C | ⬜ |
| SPEC-013 | Execution | C | ⬜ |
| SPEC-014 | Simulation | D | ⬜ |
| SPEC-015 | Doctor | D | ⬜ |
| SPEC-016 | Evaluation | D | ⬜ |
| SPEC-017 | Evolution | D | ⬜ |
| SPEC-018 | Plugin | E | ⬜ |
| SPEC-019 | SDK | E | ⬜ |
| SPEC-020 | Dashboard | E | ⬜ |

## 4. Sprint plan

| Sprint | SPEC | Phạm vi |
|--------|------|---------|
| A Foundation | 000–005 | core principles, runtime, workflow, registry, agent, capability |
| B Data | 006–009 | context, artifact, knowledge, memory |
| C Runtime | 010–013 | event, scheduler, state machine, execution |
| D Intelligence | 014–017 | simulation, doctor, evaluation, evolution |
| E Extension | 018–020 | plugin, SDK, dashboard |

## 5. Pipeline mỗi SPEC

```text
Vision → Design → Schema → API → Events → State Machine → Tests
```

## 6. Nguyên tắc

- **SPEC-000 bắt buộc trước** — mọi SPEC khác tuân theo triết lý chung.
- 80% thời gian cho Specification, 20% code.
- Mọi thay đổi kiến trúc → cập nhật SPEC → tái sinh code nhất quán.
- Chưa có code trong giai đoạn spec (trừ reference model + schema mẫu).