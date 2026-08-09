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
| SPEC-000 | Constitution (Assemble D001-D005) | Foundation | Frozen |
| SPEC-001 | Runtime Kernel | A - Core | Frozen |
| SPEC-002 | Workflow Engine | A - Core | Frozen |
| SPEC-003 | Capability System | A - Core | Frozen |
| SPEC-004 | Agent System | A - Core | Frozen |
| SPEC-005 | Registry | B - Registry | Frozen |
| SPEC-006 | Context Engine | B - Registry | Frozen |
| SPEC-007 | Artifact Manager | B - Registry | Frozen |
| SPEC-008 | Event Bus | C - Data | Frozen |
| SPEC-009 | Contract System | C - Data | Frozen |
| SPEC-010 | Plugin Framework | C - Data | Frozen |
| SPEC-011 | Doctor | D - Intelligence | Frozen |
| SPEC-012 | Simulation Engine | D - Intelligence | Frozen |
| SPEC-013 | Evolution Engine | D - Intelligence | Frozen |
| SPEC-014 | Dashboard | E - Experience | Frozen |
| SPEC-015 | SDK | E - Experience | Frozen |
| SPEC-016 | CLI & Commands | E - Experience | Frozen |

## 4. Sprint plan (Kernel-first)

| Sprint | SPEC | Phạm vi |
|--------|------|---------|
| A - Core | 001-005 | Runtime Kernel, Workflow, Capability, Agent, Registry |
| B - Registry | 006-007 | Context, Artifact |
| C - Data | 008-010 | Event Bus, Contract, Plugin |
| D - Intelligence | 011-013 | Doctor, Simulation, Evolution |
| E - Experience | 014-016 | Dashboard, SDK, CLI & Commands |
| F — Extension | 015–016 | Plugin SDK, Dashboard |

## 5. Pipeline mỗi SPEC

```text
Vision → Design → Schema → API → Events → State Machine → Tests
```

## 6. Nguyên tắc

- **SPEC-000 bắt buộc trước** — mọi SPEC khác tuân theo.
- **Kernel-first**: xây từ lõi ra, không để service phụ thuộc Runtime chưa định nghĩa.
- **Behavior Before Data** ⭐ — không định nghĩa Data Model trước khi biết Behavior (State Machine, Execution Flow). Data chỉ là hệ quả của State và Flow (DDD, Event Sourcing, CQRS cũng tuân theo):

```text
Vision → Responsibilities → Architecture → Behavior → Data → Implementation
```

- Mọi SPEC **tham chiếu** Constitution + cross-reference, không định nghĩa lại.
- SPEC khai báo `implements: <component>` — Doctor đọc compliance-matrix biết thiếu gì.
- 80% thời gian Specification, 20% code.
