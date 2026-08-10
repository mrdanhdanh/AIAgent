---
name: aios-implementation
description: >
  AIOS Implementation Control — file kiểm soát toàn bộ theo lịch trình nâng cấp.
  Pipeline: Roadmap → Specification → Architecture Validation → Code → Tests → Doctor.
  4 giai đoạn + module index + priority + progress tracking.
agent: general
---

# AIOS — Implementation Control

> File trung tâm kiểm soát mọi phần theo lịch trình nâng cấp.
> **Kiến trúc đã đóng băng** (`AIOS_V5_FREEZE.md`) — không thiết kế phase mới.
> Mọi thay đổi kiến trúc chỉ cần cập nhật tài liệu module + schema, sau đó chạy validator.

## 1. Pipeline

```text
Roadmap
  → Specification (30 module docs + schema)
  → Architecture Validation (30 validators)
  → Code Generation
  → Tests
  → Doctor
```

| Bước | Trạng thái | Ghi chú |
|------|-----------|---------|
| Roadmap | ✅ | 30 phases (0–30), đóng băng (`AIOS_V5_FREEZE.md`) |
| Specification | ✅ | 30 modules đủ docs + schema.yaml (thay SPEC-001..020 cũ) |
| Architecture Validation | ✅ | 30 validator scripts PASS |
| Code Generation | ✅ | Workflow Runtime v4.0 CERTIFIED + 54 scripts + SDK |
| Tests | ✅ | Acceptance/Benchmark PASS — stress test đã chạy (100% STABLE) |
| Doctor | ✅ | 98/100 (2026-08-11) — re-run `/doctor -Mode full` sau sync SPEC |

## 2. 4 Giai đoạn Implementation

### Giai đoạn 1 — Đóng băng kiến trúc ✅ hoàn tất
Mọi phase có đặc tả: architecture.md, README.md, schema.yaml, lifecycle.md, api.md, examples.md.

### Giai đoạn 2 — Core Runtime ✅ CERTIFIED (v4.0)
```text
1. Runtime Kernel          2. Workflow Engine          3. State Machine
4. Capability Registry     5. Agent Metadata           6. Contract Resolver
7. Scheduler
```
**Chứng nhận:** Architecture 98/100 · Reliability 95% · Performance 96% · Maintainability 99% · Compatibility 100% (`workflow-runtime/RUNTIME_CERTIFICATE.md`).
**Đang chạy thực tế:** Workflow Engine v4 qua `/team`, `/team-*` commands.

### Giai đoạn 3 — Data Layer ✅ docs (runtime qua validator + module-tests)
```text
1. Artifact Store   2. Context Engine   3. Knowledge Graph   4. Memory
```

### Giai đoạn 4 — Intelligence Layer ✅ docs + scripts thật
```text
1. Simulation   2. Doctor   3. Evaluation   4. Evolution
```
**Scripts thật:** `scripts/evolution/` — simulation-engine, semantic-diff, migration-system, health-score, capability-benchmark, self-healing, compatibility-checker (chạy trong `/doctor -Mode full`).

### Ops & Extension ✅ docs
```text
Dashboard → Plugin → SDK → Marketplace → Governance → Trust → Cost → Autonomous → Distributed
```

## 3. SPEC Index (SPEC-001..020)

Mỗi SPEC 5–10 trang. **Đã thực thi hóa thành 30 module docs** (architecture.md, README.md, schema.yaml, lifecycle.md, api.md...) — xem Module Index bên dưới. AI/Agent/Plugin đọc module docs — không cần đọc toàn bộ source.

| SPEC | Chủ đề | Core spec? | Trạng thái |
|------|--------|:----------:|-----------|
| SPEC-001 | Runtime Kernel | ✅ | ✅ → `workflow-runtime/`, `kernel/` |
| SPEC-002 | Capability Registry | ✅ | ✅ → `registry/` |
| SPEC-003 | Workflow Engine | ✅ | ✅ → `workflow-engine/` |
| SPEC-004 | State Machine | ✅ (thiếu) | ✅ → `workflow-runtime/state-machine.md` |
| SPEC-005 | Execution Model | ✅ (thiếu) | ✅ → `workflow-runtime/executor.md` |
| SPEC-006 | Context Engine | | ✅ → `context/` |
| SPEC-007 | Artifact Store | | ✅ → `artifacts/` |
| SPEC-008 | Event Bus | | ✅ → `events/` |
| SPEC-009 | Agent Metadata | | ✅ → `agents/` |
| SPEC-010 | Contract Resolver | ✅ | ✅ → `registry/resolver.md` |
| SPEC-011 | Object Model | ✅ (thiếu) | ✅ → `workflow-runtime/`, `kernel/` |
| SPEC-012 | Naming Convention | ✅ (thiếu) | ✅ → `registry/naming` (docs module) |
| SPEC-013 | Versioning Strategy | ✅ (thiếu) | ✅ → `aios-sdk/versioning.md` |
| SPEC-014 | Error Handling | ✅ | ✅ → `workflow-runtime/recovery.md` |
| SPEC-015 | Compatibility Rules | ✅ | ✅ → `workflow-runtime/compatibility.md` |
| SPEC-016 | Simulation | ✅ | ✅ → `simulation/` |
| SPEC-017 | Doctor | | ✅ → `doctor/` |
| SPEC-018 | Evaluation | | ✅ → `evaluation/` |
| SPEC-019 | Evolution | | ✅ → `evolution/` |
| SPEC-020 | Scheduler | ✅ | ✅ → `kernel/scheduler.md` |

> ⚠️ **Naming collision (đã đồng bộ):** `docs/specs/SPEC-014/015/016` hiện chứa spec thế hệ mới **Dashboard / SDK / CLI & Commands** (ngày 2026-08-10) — không phải Error Handling/Compatibility/Simulation ở bảng trên. Hai hệ đánh số trùng id:
> - Legacy core SPEC-001..020 (bảng trên) → đã thực thi hóa thành **30 module docs** trong `.opencode/` (`workflow-runtime/`, `simulation/`, `doctor/`, `evaluation/`, `evolution/`, `kernel/`...) — đọc module docs, không đọc `docs/specs/`.
> - Spec hiện hành trong `docs/specs/` (SPEC-000..016 + SPEC-INDEX.md) → quản lý bởi `/review`, validate bởi `spec0XX-validator.ps1` (spec014/015/016-validator.ps1 validate đúng nội dung Dashboard/SDK/CLI).

## 3b. Module Index (30 modules)

Mỗi module 1 thư mục với đặc tả đầy đủ (architecture.md, README.md, schema.yaml...).

| Domain | Modules | Trạng thái |
|--------|---------|-----------|
| core | workflow-runtime, architecture, kernel, model-router, resources | ✅ |
| memory | context, artifacts, knowledge-graph, memory, prompts | ✅ |
| intelligence | simulation, doctor, evolution, evaluation, experiments, autonomous | ✅ |
| extensions | plugins, aios-sdk, marketplace | ✅ |
| operations | dashboard, observability, governance, release, cost, trust | ✅ |
| resources | agents, commands, skills, workflows | ✅ |
| shared | registry, policy, events, distributed, workspaces | ✅ |

## 4. Priority (tỷ lệ ảnh hưởng — giai đoạn bảo trì)

| Ưu tiên | Công việc | Ảnh hưởng | Trạng thái |
|---------|-----------|----------:|------------|
| ⭐⭐⭐⭐⭐ | AIOS Specification (SPEC-001..020) | 40% | ✅ hoàn tất |
| ⭐⭐⭐⭐⭐ | Runtime Kernel | 30% | ✅ CERTIFIED v4.0 |
| ⭐⭐⭐⭐ | Capability Registry | 10% | ✅ |
| ⭐⭐⭐⭐ | Workflow Engine | 10% | ✅ |
| ⭐⭐⭐ | Context + Artifact | 5% | ✅ |
| ⭐⭐⭐ | Event Bus | 5% | ✅ |

### Action items còn lại (bảo trì)

| Ưu tiên | Công việc | Trạng thái |
|---------|-----------|------------|
| 🔴 HIGH | Stress test Runtime (Doctor: 50/100 UNSTABLE) | ✅ 100% (20/20, 2026-08-11) |
| 🔴 HIGH | SemanticDiff 55/100 — cải thiện điểm | ✅ 100/100 (2026-08-11) |
| 🟡 MEDIUM | Re-run `/doctor --full --markdown` sau khi fix | ✅ 98/100 (2026-08-11) |
| 🟡 MEDIUM | Hoàn tất tests còn thiếu theo module tests.md | ✅ module-tests.ps1 (72/72, 2026-08-11) |
| 🟢 LOW | Bảo trì định kỳ: `/team-syncdocs` + `/team-doctor` | 🔁 |

## 5. Progress Tracking

| Metric | Giá trị |
|--------|---------|
| Phases thiết kế | 30/30 (đóng băng v5) |
| Module docs | 30/30 |
| Validator PASS | 30/30 |
| Runtime Certificate | ✅ v4.0 (≥90% mọi hạng mục) |
| Scripts | 54 |
| Agents / Commands / Skills | 18 / 56 / 28 |
| Doctor Health | 98/100 |
| Evolution Health | 98/100 |
| Giai đoạn 2 (core runtime) | ✅ CERTIFIED |
| Giai đoạn 3 (data) | ✅ docs + validator/module-tests |
| Giai đoạn 4 (intelligence) | ✅ docs + scripts thật (evolution/) |
| Stress test | ✅ 100% (20/20 STABLE, 2026-08-11) |

## 6. Nguyên tắc Implementation

- **Không thiết kế thêm** — roadmap đã đủ, kiến trúc đóng băng (`AIOS_V5_FREEZE.md`).
- Mọi tính năng mới cắm qua **Registry, Event Bus, SDK, Plugin** — không sửa lõi.
- Core chỉ thay đổi khi breaking architecture / security / backward-compatible patch.
- Sau mỗi thay đổi: chạy validators + `/team-syncdocs` + `/team-doctor`.
- Mọi thay đổi kiến trúc → cập nhật module docs + schema → tái sinh code nhất quán.
- Runtime thay đổi → re-certify theo quy trình Doctor → Benchmark → Acceptance → Certificate.
