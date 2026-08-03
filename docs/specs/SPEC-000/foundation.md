---
name: spec-000-foundation
description: SPEC-000 Part I — Foundation: Vision, Scope, Goals, Non Goals, Terminology.
agent: general
---

# Part I — Foundation

## Chương 1 — Vision

### Mission
Xây dựng một nền tảng điều hành cho AI Agent — nơi Runtime điều phối, Agent chỉ là thành phần chạy trên đó.

### Vision
AIOS trở thành tầng hạ tầng chuẩn để vận hành AI agent ở quy mô enterprise: ổn định 5–10 năm, mở rộng qua extension, không phải sửa lõi.

### Target Users
- Đội phát triển cần điều phối nhiều agent cho một project.
- Tổ chức cần governance, audit, cost control cho AI.
- Plugin/extension developers.
- AI (agent/LLM) đọc SPEC để sinh code chính xác.

### Core Value
> Runtime là trung tâm. Agent chỉ là ứng dụng chạy trên AIOS.

### Success Criteria
- Mở rộng tính năng không cần sửa Core.
- Mọi module nhất quán theo hiến pháp.
- AI sinh code chính xác từ SPEC.

## Chương 2 — Scope

### Included
- Workflow Runtime
- Context Engine
- Registry (capability/agent/skill/command)
- Artifact Store
- Event Bus
- Knowledge Graph
- Memory
- Simulation
- Doctor / Evaluation
- Evolution
- Plugins / SDK
- Dashboard
- Governance / Cost / Trust

### Excluded
- LLM
- IDE
- Git / Source Control
- CI/CD
- Database Engine
- Chat Platform

## Chương 3 — Goals

```
✓ Deterministic
✓ Composable
✓ Observable
✓ Plugin First
✓ AI Friendly
✓ Scalable
✓ Stateless
```

Mỗi goal phải kiểm chứng được qua tests + Doctor.

## Chương 4 — Non Goals

AIOS **không phải**:

- GUI Builder
- Source Control
- Database Engine
- Chat Platform
- Prompt Marketplace

Non Goals ngăn framework phình to (over-engineering).

## Chương 5 — Terminology

Mỗi thuật ngữ **một nghĩa duy nhất** — không hiểu nhiều cách.

| Thuật ngữ | Định nghĩa (chính xác) |
|-----------|------------------------|
| Workflow | chuỗi phase có trạng thái, điều phối agent theo capability |
| Capability | khả năng hệ thống làm được; không phụ thuộc agent |
| Agent | thực thể thực thi capability; stateless |
| Command | lệnh cài sẵn của framework |
| Skill | kiến thức/kỹ năng dùng cho agent |
| Runtime | trung tâm điều phối; mọi thứ chạy qua Runtime |
| Artifact | object output có version/checksum/lineage |
| Context | package dữ liệu cấp cho agent trước khi chạy |
| Knowledge | lessons, patterns, graph |
| Plugin | gói mở rộng đóng gói agent/skill/capability/... |

Bảng đầy đủ tại `glossary.md`.