---
name: aios-architecture
description: >
  AIOS Architecture — 7 tầng kiến trúc lâu dài. Map 13 phase hiện có (0–13) + 12 phase đề xuất (14–25).
  Phase = kế hoạch triển khai theo thời gian. Layer = kiến trúc bền vững.
agent: general
---

# AIOS — 7 Tầng Kiến trúc

> Phase là **kế hoạch triển khai** (theo thời gian). Layer là **kiến trúc lâu dài**.
> Khi cần sửa một tính năng: biết ngay nó thuộc tầng nào và ảnh hưởng tầng nào.

## 1. 7 Layers

```text
Layer 7 - Infrastructure
  Security · Policies · Distributed Runtime

─────────────────────────────
Layer 6 - Operations
  Dashboard · Observability · Release Manager

─────────────────────────────
Layer 5 - Extension
  Plugins · SDK · Marketplace

─────────────────────────────
Layer 4 - Intelligence
  Simulation · Doctor · Evaluation · Evolution

─────────────────────────────
Layer 3 - Communication
  Event Bus · Registry · Contracts · Metadata

─────────────────────────────
Layer 2 - Data
  Context · Memory · Artifact · Knowledge Graph

─────────────────────────────
Layer 1 - Kernel
  Runtime · Scheduler · State Machine · Resource Manager
```

## 2. Layer map — Phase hiện có (0–13)

| Layer | Phase | Thư mục | Vai trò |
|-------|-------|---------|---------|
| 1 Kernel | 0.2 ASP, 1 Runtime | `.opencode/workflow-runtime/`, `.opencode/architecture/` | Kernel, scheduler, state machine, recovery, transaction |
| 1 Kernel | 9 (graph engine) | `.opencode/knowledge-graph/` | graph ops (traversal) |
| 2 Data | 4 Context | `.opencode/context/` | context package, profiles, budget, cache |
| 2 Data | 5 Artifact | `.opencode/artifacts/` | artifact store, version, lineage |
| 2 Data | 9 Knowledge Graph | `.opencode/knowledge-graph/` | entity/relation graph |
| 3 Communication | 2 Registry | `.opencode/registry/` | capability/agent/skill/command registry |
| 3 Communication | 3 Agent Metadata | `.opencode/agents/` | metadata 4-layer, contracts, lifecycle |
| 3 Communication | 6 Event Bus | `.opencode/events/` | pub/sub, queue, replay, lineage |
| 4 Intelligence | 7 Simulation | `.opencode/simulation/` | execution mode, risk, confidence |
| 4 Intelligence | 8 Doctor | `.opencode/doctor/` | diagnostics, health, rule engine |
| 4 Intelligence | 10 Evolution | `.opencode/evolution/` | proposal, backtest, migration |
| 5 Extension | 11 Plugins | `.opencode/plugins/` | plugin manager, sandbox, cert |
| 5 Extension | 13 AIOS SDK | `.opencode/aios-sdk/` | 11 SDK components |
| 6 Operations | 12 Dashboard | `.opencode/dashboard/` | control tower, CQRS snapshot |
| 7 Infrastructure | (permission) | `plugins/security.md`, `dashboard/security.md`, `aios-sdk/security.md` | permission + audit |

## 3. Layer map — Phase đề xuất (14–25)

| Phase | Layer | Nội dung | Trạng thái |
|-------|-------|----------|-----------|
| 14 Runtime Kernel | 1 | tách kernel khỏi workflow engine | đề xuất |
| 16 Resource Manager | 1 | token/memory/time/cost/model budget | đề xuất |
| 17 Model Router | 1 | router quyết định model (không agent) | đề xuất |
| 19 Memory Engine | 2 | working/session/workflow/knowledge/failure/user memory | đề xuất |
| 18 Prompt Registry | 3 | tách prompt khỏi agent → prompt id/version | đề xuất |
| 15 Policy Engine | 7 | allow/deny policy cho agent/plugin/workflow | đề xuất |
| 20 Observability Platform | 6 | logging, tracing, metrics, profiling, telemetry | đề xuất |
| 22 Release Manager | 6 | canary, A/B, release, rollback | đề xuất |
| 21 AI Evaluation | 4 | benchmark, regression, hallucination, cost | đề xuất |
| 25 AI Marketplace | 5 | agent/workflow/prompt/policy/knowledge packages | đề xuất |
| 23 Multi Workspace | 1 | nhiều workspace chung runtime | đề xuất |
| 24 Distributed Runtime | 7 | event bus nối đa machine | đề xuất |

## 4. Dependency direction

```text
Layer 7 (Infrastructure) ── dùng ──┐
Layer 6 (Operations)     ─────────┤
Layer 5 (Extension)      ─────────┤  → hướng lên (higher depends lower)
Layer 4 (Intelligence)   ─────────┤
Layer 3 (Communication)  ─────────┤
Layer 2 (Data)           ─────────┤
Layer 1 (Kernel)         ←────────┘  (nền tảng, không phụ thuộc tầng trên)
```

- Layer cao **phụ thuộc** layer thấp hơn.
- Layer 1 (Kernel) không phụ thuộc tầng nào — là nền.
- Thay đổi layer thấp → ảnh hưởng dây chuyền lên trên (impact analysis).

## 5. Chi tiết từng layer

### Layer 1 — Kernel
- Runtime, Scheduler, State Machine, Resource Manager (đề xuất P16), Model Router (P17), Workflow Runtime.
- Không module nào gọi nhau trực tiếp — mọi thứ qua kernel.
- Thư mục: `workflow-runtime/` (25 file), `architecture/` (ASP v4).

### Layer 2 — Data
- Context Engine (P4), Artifact Store (P5), Knowledge Graph (P9), Memory Engine (P19).
- Context chỉ là một phần của Memory (P19).
- Thư mục: `context/`, `artifacts/`, `knowledge-graph/`.

### Layer 3 — Communication
- Event Bus (P6), Registry (P2), Agent Metadata + Contracts (P3), Prompt Registry (P18).
- Mọi giao tiếp qua event/registry, không gọi trực tiếp.
- Thư mục: `events/`, `registry/`, `agents/`.

### Layer 4 — Intelligence
- Simulation (P7), Doctor (P8), Evaluation (P21), Evolution (P10).
- Phân tích, dự đoán, tự cải tiến.
- Thư mục: `simulation/`, `doctor/`, `evolution/`.

### Layer 5 — Extension
- Plugins (P11), SDK (P13), Marketplace (P25).
- Mở rộng AIOS không sửa Core.
- Thư mục: `plugins/`, `aios-sdk/`.

### Layer 6 — Operations
- Dashboard (P12), Observability (P20), Release Manager (P22).
- Quan sát, điều hành, phân tích vận hành.
- Thư mục: `dashboard/`.

### Layer 7 — Infrastructure
- Security, Policies (P15), Distributed Runtime (P24).
- Nền tảng chéo cho mọi layer.
- Thư mục: `plugins/security.md`, `dashboard/security.md`, `aios-sdk/security.md`.

## 6. 5 Phase xương sống

| Phase | Layer | Mức độ |
|-------|-------|--------|
| Runtime Kernel | 1 | ⭐⭐⭐⭐⭐ |
| Capability Registry | 3 | ⭐⭐⭐⭐⭐ |
| Context & Memory Engine | 2 | ⭐⭐⭐⭐⭐ |
| Artifact Store + Event Bus | 2+3 | ⭐⭐⭐⭐⭐ |
| Knowledge Graph | 2 | ⭐⭐⭐⭐⭐ |

Đây là "xương sống" — các layer khác (Dashboard, Plugin, Doctor, Evolution...) xây dựng tốt nếu 5 nền tảng này thiết kế đúng.

## 7. Impact analysis khi sửa

Ví dụ sửa `workflow-runtime/kernel` (Layer 1):

| Tầng | Ảnh hưởng |
|------|-----------|
| Layer 1 | runtime trực tiếp |
| Layer 2 | context/artifact resolve |
| Layer 3 | event/registry flow |
| Layer 4 | simulation/doctor đọc state |
| Layer 5-7 | gián tiếp (qua SDK) |

→ Dùng `knowledge-graph/` (Phase 9) để impact analysis tự động.

## 8. Nguyên tắc

- Layer giữ ranh giới rõ — không nhảy tầng (layer 5 không gọi thẳng layer 2).
- Giao tiếp chéo qua Layer 3 (Event Bus / Registry).
- Thư mục hiện có **giữ nguyên** — layer là tổ chức tài liệu phía trên, không di chuyển file.
- Phase mới (14–25) triển khai trong đúng layer của nó.