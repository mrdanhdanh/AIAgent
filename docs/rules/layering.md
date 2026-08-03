---
name: rule-layering
description: R-LAYER — Luật phân tầng. 5 tầng, phụ thuộc một chiều từ trên xuống.
agent: general
---

# R-LAYER — Layering

## Rule

Hệ thống có đúng **5 tầng**, phụ thuộc một chiều từ trên xuống:

```text
Presentation
    ↓
Extensions
    ↓
Intelligence
    ↓
Runtime
    ↓
Infrastructure
```

| Layer | Chứa |
|-------|------|
| Presentation | Dashboard, CLI, IDE |
| Extensions | Plugins, SDK, Marketplace |
| Intelligence | Simulation, Doctor, Evaluation, Evolution |
| Runtime | Scheduler, State Machine, Capability Resolver |
| Infrastructure | Storage, Registry, Event Bus |

## Bắt buộc

- Tầng trên gọi tầng dưới. Không được ngược.
- Layer chỉ truy cập layer kề dưới trực tiếp; vượt tầng phải qua Runtime API.
- Không nhét logic layer này vào layer khác.

## Kiểm tra

- Doctor scan dependency giữa các module → phát hiện vi phạm hướng.

**Nguồn**: A-001 · A-002 · P001