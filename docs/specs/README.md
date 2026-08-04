---
name: aios-spec
description: >
  AIOS Specification — index toàn bộ SPEC (Kernel-first architecture).
  Mỗi SPEC là một thư mục, 3 cấp độ (Vision/Design/Implementation Contract).
  Bắt đầu từ SPEC-000 Constitution (Frozen).
agent: general
---

# AIOS Specification

> **Architecture → Specification → Implementation → Validation**
> **Kernel-first**: xây từ lõi Runtime ra ngoài — Execution Engine, Workflow, Context, Artifact, Event
> đều là dịch vụ của Runtime.

## 1. Cấu trúc SPEC

Một SPEC là một **thư mục** (theo chuẩn SPEC-000):

```text
specs/
  SPEC-###-name/
    README.md
    SPEC.yaml
    INDEX.yaml
    schema.json
    reports/
```

## 2. 3 cấp độ SPEC

| Level | Hỏi | Nội dung |
|-------|-----|----------|
| Level 1 Vision | Tại sao tồn tại? | motivation, mục tiêu |
| Level 2 Design | Hoạt động thế nào? | object model, state machine, sequence |
| Level 3 Contract | Code ra sao? | schema, API, events, tests |

## 3. SPEC Roadmap (Kernel-first)

| SPEC | Chủ đề | Sprint | Trạng thái |
|------|--------|--------|-----------|
| SPEC-000 | Constitution (Assemble D001-D005) | Foundation | ✅ Frozen |
| SPEC-001 | Runtime Kernel | A — Core | ⬜ |
| SPEC-002 | Execution Engine | A — Core | ⬜ |
| SPEC-003 | State Machine | A — Core | ⬜ |
| SPEC-004 | Workflow Engine | A — Core | ⬜ |
| SPEC-005 | Capability Registry | B — Registry | ⬜ |
| SPEC-006 | Context Engine | B — Registry | ⬜ |
| SPEC-007 | Artifact Manager | B — Registry | ⬜ |
| SPEC-008 | Event Bus | C — Data | ⬜ |
| SPEC-009 | Scheduler | C — Data | ⬜ |
| SPEC-010 | Simulation Engine | D — Intelligence | ⬜ |
| SPEC-011 | Doctor Framework | D — Intelligence | ⬜ |
| SPEC-012 | Knowledge Graph | D — Intelligence | ⬜ |
| SPEC-013 | Evaluation Engine | E — Evolution | ⬜ |
| SPEC-014 | Evolution Engine | E — Evolution | ⬜ |
| SPEC-015 | Plugin SDK | F — Extension | ⬜ |
| SPEC-016 | Dashboard | F — Extension | ⬜ |

## 4. Sprint plan (Kernel-first)

| Sprint | SPEC | Phạm vi |
|--------|------|---------|
| A — Core | 001–004 | Runtime Kernel, Execution, State Machine, Workflow |
| B — Registry | 005–007 | Capability Registry, Context, Artifact |
| C — Data | 008–009 | Event Bus, Scheduler |
| D — Intelligence | 010–012 | Simulation, Doctor, Knowledge |
| E — Evolution | 013–014 | Evaluation, Evolution |
| F — Extension | 015–016 | Plugin SDK, Dashboard |

## 5. Pipeline mỗi SPEC

```text
Vision → Design → Schema → API → Events → State Machine → Tests
```

## 6. Nguyên tắc

- **SPEC-000 bắt buộc trước** — mọi SPEC khác tuân theo.
- **Kernel-first**: xây từ lõi ra, không để service phụ thuộc Runtime chưa định nghĩa.
- Mọi SPEC **tham chiếu** Constitution + cross-reference, không định nghĩa lại.
- SPEC khai báo `implements: <component>` — Doctor đọc compliance-matrix biết thiếu gì.
- 80% thời gian Specification, 20% code.
