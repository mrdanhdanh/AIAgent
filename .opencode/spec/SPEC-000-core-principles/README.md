---
name: spec-000-core-principles
description: >
  SPEC-000 — Core Principles. Tài liệu quan trọng nhất của AIOS.
  Định nghĩa 7 nguyên tắc bất biến mà MỌI SPEC khác phải tuân theo.
  Level 1 (Vision) + Level 2 (Design) + Level 3 (Contract) tổng quát.
agent: general
---

# SPEC-000 — Core Principles

> **Trạng thái**: Draft (đang soạn) · **Version**: 0.1.0 · **Sprint**: A · **Schema**: spec-v1

## Level 1 — Vision

### Tại sao AIOS tồn tại

AIOS là **AI Operating System** — nền tảng điều phối agent, workflow, context, artifact trên quy mô enterprise. Nó tồn tại để:

1. Tách **AI logic** khỏi **hạ tầng** — agent chỉ là một loại ứng dụng chạy trên AIOS.
2. Cung cấp **một bộ nguyên tắc bất biến** để mọi thành phần phát triển nhất quán.
3. Đảm bảo **mở rộng không phá lõi** — extension qua plugin, không sửa core.

### Mục tiêu

- Ổn định trong 5–10 năm.
- Mọi module mới tuân theo cùng triết lý, không mâu thuẫn.
- AI có thể sinh code chính xác chỉ từ SPEC.

## Level 2 — Design

### 7 Nguyên tắc bất biến

#### P1 — Stateless by Default

> **Agent không giữ trạng thái. Mọi trạng thái nằm trong Runtime.**

- Agent nhận input (context/artifact), trả output (artifact/event).
- Không có state bên trong agent giữa các lần gọi.
- Trạng thái (workflow state, agent state) thuộc Runtime.

**Lý do**: stateless agent dễ scale, dễ replay, dễ test, dễ failover.

#### P2 — Contract First

> **Mọi giao tiếp đều qua Contract và Schema.**

- Agent ↔ Agent, Agent ↔ Runtime, Module ↔ Module: qua contract.
- Contract versioned, backward compatible.
- Không giao tiếp tự do ngoài contract.

**Lý do**: contract làm giao tiếp kiểm tra được, thay đổi không vỡ.

#### P3 — Everything is Metadata

> **Workflow, Agent, Artifact, Capability... đều được mô hình hóa bằng metadata.**

- Không hard-code đặc tính trong code.
- Mọi thực thể có metadata (id, type, version, status).
- Metadata là nguồn cho resolver, scheduler, doctor, dashboard.

**Lý do**: metadata làm hệ thống inspectable + driver-driven.

#### P4 — Everything is Event

> **Thay đổi trạng thái đều phát sinh Event.**

- Mọi transition phát event.
- Event immutable, có lineage.
- Event là nguồn sự thật (source of truth) cho observability/replay/simulation.

**Lý do**: event cho phép trace, replay, simulate mà không cần chạy lại code.

#### P5 — Everything is Versioned

> **Không ghi đè. Mọi thực thể đều có version.**

- Agent, artifact, prompt, capability, workflow: version tăng.
- Không overwrite — tạo version mới.
- Version cho phép rollback, A/B, backtest.

**Lý do**: version là nền tảng cho migration, experiment, recovery.

#### P6 — Core is Closed, Extension is Open

> **Core ổn định. Mở rộng qua Plugin và SDK.**

- Core chỉ thay đổi khi kiến trúc lớn.
- Tính năng mới qua Registry, Event Bus, SDK, Plugin.
- Core không biết plugin — plugin cắm vào qua interface.

**Lý do**: core đóng băng giữ ổn định; mở rộng không phá lõi.

#### P7 — Simulation Before Execution

> **Thay đổi lớn phải được mô phỏng trước khi thực thi.**

- Workflow lớn → simulation trước (risk/confidence).
- Proposal evolution → backtest trước apply.
- Hành động nguy hiểm → approval + simulation.

**Lý do**: dự đoán trước khi chạy — giảm rủi ro, chi phí, lỗi.

## Level 3 — Contract (tổng quát)

### Mọi SPEC phải tuân theo

| Nguyên tắc | Áp dụng cho |
|-----------|-------------|
| P1 Stateless | agent, task |
| P2 Contract First | mọi interface |
| P3 Metadata | mọi thực thể |
| P4 Event | mọi state change |
| P5 Versioned | mọi thực thể |
| P6 Closed Core | core, extension |
| P7 Simulate First | workflow, evolution |

### Object Model nền (P3)

```text
Entity (base)
├── id: string
├── type: string
├── version: integer
├── status: string
├── metadata: map
└── created_at: timestamp
```

### Event nền (P4)

```text
Event (base)
├── id
├── type
├── timestamp
├── source
├── payload
└── parent_event (lineage)
```

### Versioning nền (P5)

```text
version: integer (1, 2, 3...)
- immutable content
- không overwrite
- rollback = trỏ về version cũ
```

## Tương tác

- `spec/README.md` — index + sprint.
- Mọi SPEC-00x phải tham chiếu nguyên tắc P1–P7 này.
- `terminology.md` — thuật ngữ chung.
- `object-model.md` — entity/event base.