---
name: aios-v5-freeze
description: >
  AIOS v5 Architecture Freeze — đóng băng kiến trúc. Không thêm module mới trừ khi thật sự cần.
  Domain map (giữ nguyên thư mục hiện có). Mọi mở rộng qua Registry, Event Bus, SDK, Plugin.
agent: general
---

# AIOS v5 — Architecture Freeze

## 1. Nguyên tắc freeze

Kiến trúc AIOS v5 đạt độ trưởng thành:

- **Không thêm module mới** trừ khi thật sự cần.
- Chỉ tối ưu, mở rộng, thay thế implementation.
- Mọi tính năng mới phải cắm qua **Registry, Event Bus, SDK, Plugin**.
- **Core chỉ thay đổi** khi có thay đổi kiến trúc lớn.
- Kiến trúc ổn định; mở rộng đến từ **extension**, không sửa lõi.

## 2. Toàn bộ roadmap (0–30)

| Giai đoạn | Phases | Trạng thái |
|-----------|--------|-----------|
| Foundation | 0–1 (Baseline, ASP, Runtime) | ✅ |
| Capability | 2–3 (Registry, Agent Definition) | ✅ |
| Data | 4–5 (Context, Artifact Store) | ✅ |
| Communication | 6 (Event Bus) | ✅ |
| Intelligence | 7–8 (Simulation, Doctor) | ✅ |
| Graph & Evolution | 9–10 (Knowledge Graph, Evolution) | ✅ |
| Extension | 11–13 (Plugins, Dashboard, SDK) | ✅ |
| Enterprise | 14–25 (Kernel, Policy, Resources, Model Router, Prompts, Memory, Observability, Evaluation, Release, Workspaces, Distributed, Marketplace) | ✅ |
| Governance | 26–30 (Governance, Trust, Cost, Experiment, Autonomous) | ✅ |

## 3. Domain map (giữ nguyên thư mục hiện có)

Không di chuyển file — domain là tổ chức tài liệu phía trên. Mọi thư mục phase hiện tại giữ nguyên vị trí.

| Domain | Thư mục phase |
|--------|---------------|
| core | `workflow-runtime/`, `architecture/`, `kernel/`, `model-router/`, `resources/` |
| memory | `context/`, `artifacts/`, `knowledge-graph/`, `memory/`, `prompts/` |
| intelligence | `simulation/`, `doctor/`, `evolution/`, `evaluation/`, `experiments/`, `autonomous/` |
| extensions | `plugins/`, `aios-sdk/`, `marketplace/` |
| operations | `dashboard/`, `observability/`, `governance/`, `release/`, `cost/`, `trust/` |
| resources | `agents/`, `commands/`, `skills/`, `prompts/`, `workflows/` |
| shared | `registry/`, `policy/`, `events/`, `distributed/`, `workspaces/` |

## 4. Đổi tên kiến trúc

- AI Agent Framework → **AIOS (AI Operating System)**.
- Agent = một loại ứng dụng chạy trên AIOS, không phải trung tâm.
- Layer (7 tầng) = kiến trúc lâu dài (`AIOS_ARCHITECTURE.md`).

## 5. 30 validator gates

Mỗi phase có validator script (`.opencode/scripts/*-validator.ps1`), tất cả PASS.

```text
capability · agent · context · artifact · event · simulation · doctor ·
knowledge-graph · evolution · plugins · dashboard · sdk · architecture ·
kernel · policy · resources · model-router · prompts · memory · observability ·
evaluation · release · workspaces · distributed · marketplace ·
governance · trust · cost · experiments · autonomous
```

## 6. Extension-first

| Tính năng mới | Cắm qua |
|---------------|---------|
| Agent mới | Plugin + Registry |
| Capability mới | Plugin exports |
| Prompt mới | Prompt Registry (P18) |
| Doctor rule mới | Plugin + Doctor rules |
| Widget mới | Plugin widgets |
| Workflow mới | Plugin workflows |

## 7. Core change policy

Core chỉ đổi khi:

- Breaking architecture (như Phase 1→7→14 kernel).
- Security/compliance bắt buộc.
- Backward compatible patch.

Khác → dùng extension.