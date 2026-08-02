---
name: architecture-core
description: ARCHITECTURE — kiến trúc tổng thể Agent Framework v4: mục tiêu, layer architecture, định hướng.
agent: general
---

# ARCHITECTURE.md — Agent Framework v4

> Tài liệu trung tâm của ASP v4. Định nghĩa mục tiêu framework và layer architecture.

## 1. Mục tiêu Framework

```
Agent Framework v4
       ↓
Workflow Runtime        → không hardcode, dữ liệu định nghĩa workflow
       ↓
Capability Driven       → engine không biết Agent, chỉ biết Capability
       ↓
Context Aware           → context chuẩn, isolation, compression
       ↓
Artifact Based          → artifact là object (checksum, version, dependency)
       ↓
Event Driven            → phản ứng sự kiện thay vì gọi tuần tự cứng
```

## 2. Layer Architecture

```
┌────────────────────────────────────────────┐
│ User                                       │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Command Layer   (54 commands, /team, /ask) │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Workflow Runtime (engine, loader, ...)     │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Capability Resolver (registry → matcher)   │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Agent Layer     (18 agents)                │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Skill Layer     (29 skills)                │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Artifact Layer  (plan.md, design.md, ...)  │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Knowledge Layer (knowledge, memory)        │
└─────────────────┬──────────────────────────┘
                  ↓
┌────────────────────────────────────────────┐
│ Infrastructure (model, scripts, storage)   │
└────────────────────────────────────────────┘
```

## 3. Trách nhiệm từng Layer

| Layer | Trách nhiệm | Không làm |
|-------|-------------|-----------|
| Command Layer | Nhận yêu cầu, route | Không gọi Agent trực tiếp |
| Workflow Runtime | Điều phối phases theo definition | Không hardcode agent theo tên |
| Capability Resolver | Map intent → capability → agent/skill | Không biết chi tiết implementation |
| Agent Layer | Thực thi capability, sinh artifact | Không tự quyết workflow |
| Skill Layer | Kỹ năng tái sử dụng | Không điều phối agent khác |
| Artifact Layer | Quản lý artifact (checksum, version) | Không chứa logic nghiệp vụ |
| Knowledge Layer | Knowledge/memory truy vấn | Không xử lý runtime |

## 4. Định hướng thiết kế

- **Configuration over Prompt**: cấu hình (yaml/json) quan trọng hơn prompt dài.
- **Data-driven Workflow**: workflow là dữ liệu (definitions), không phải code.
- **Capability trung gian**: yêu cầu → capability → thực thi, không gọi agent theo tên cứng.
- **Lock sau Phase 0.2**: layer, data model, lifecycle, state machine không đổi nếu không có ADR mới.

## 5. Không nằm trong phạm vi v4

- Multi-agent parallel (v5)
- Distributed agent / cloud runtime (v5)
- MCP / A2A protocol (v5)
- Marketplace plugin (v5)