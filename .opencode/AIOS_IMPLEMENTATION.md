---
name: aios-implementation
description: >
  AIOS Implementation Control — file kiểm soát toàn bộ theo lịch trình nâng cấp v4.
  Pipeline: Roadmap → SPEC → Architecture Validation → Code → Tests → Doctor.
  4 giai đoạn + SPEC index + priority + progress tracking.
agent: general
---

# AIOS v4 — Implementation Control

> File trung tâm kiểm soát mọi phần theo lịch trình nâng cấp.
> Dừng thiết kế phase mới. Chuyển sang **AIOS v4 Implementation**.
> Mọi thay đổi kiến trúc chỉ cần cập nhật SPEC, sau đó tái sinh/kiểm tra nhất quán.

## 1. Pipeline

```text
Roadmap
  → Specification (SPEC-001..020)
  → Architecture Validation (30 validators)
  → Code Generation
  → Tests
  → Doctor
```

| Bước | Trạng thái | Ghi chú |
|------|-----------|---------|
| Roadmap | ✅ | 30 phases (0–30), đóng băng (`AIOS_V5_FREEZE.md`) |
| Specification | 🔶 | SPEC index dưới đây — đang soạn |
| Architecture Validation | ✅ | 30 validator scripts PASS |
| Code Generation | ⬜ | Giai đoạn 2–4 |
| Tests | ⬜ | theo code |
| Doctor | ⬜ | run sau implementation |

## 2. 4 Giai đoạn Implementation

### Giai đoạn 1 — Đóng băng kiến trúc (1–2 tuần) ✅ docs
Mọi phase có đặc tả: architecture.md, README.md, schema.yaml, lifecycle.md, api.md, examples.md.

| # | Phase | Docs | SPEC |
|---|-------|------|------|
| 1 | Runtime | ✅ | SPEC-001 |
| 2 | Registry | ✅ | SPEC-002 |
| 3 | Metadata | ✅ | SPEC-009 |
| 4 | Context | ✅ | SPEC-006 |
| 5 | Artifacts | ✅ | SPEC-007 |
| 6 | Events | ✅ | SPEC-008 |
| 7 | Simulation | ✅ | SPEC-016 |
| 8 | Doctor | ✅ | SPEC-017 |
| 9 | Knowledge | ✅ | SPEC-003 (graph) |
| 10 | Evolution | ✅ | SPEC-019 |
| 11 | Plugins | ✅ | SPEC-011 (extension) |
| 12 | Dashboard | ✅ | SPEC-012 (ops) |

### Giai đoạn 2 — Core Runtime (4–6 tuần) ⬜ CODE — ƯU TIÊN CAO NHẤT
```text
1. Runtime Kernel
2. Workflow Engine
3. State Machine
4. Capability Registry
5. Agent Metadata
6. Contract Resolver
7. Scheduler
```
**Definition of Done:** chạy được `Workflow → Planner → Builder → Reviewer → Tester` (chưa cần Context/Event).

### Giai đoạn 3 — Data Layer (3–4 tuần) ⬜ CODE
```text
1. Artifact Store
2. Context Engine
3. Knowledge Graph
4. Memory
```

### Giai đoạn 4 — Intelligence Layer (4–6 tuần) ⬜ CODE
```text
1. Simulation
2. Doctor
3. Evaluation
4. Evolution
```

### Sau Giai đoạn 4 — Ops & Extension ⬜ CODE
```text
Dashboard → Plugin → SDK → Marketplace
```

## 3. SPEC Index (SPEC-001..020)

Mỗi SPEC 5–10 trang. AI/Agent/Plugin đọc SPEC — không cần đọc toàn bộ source.

| SPEC | Chủ đề | Core spec? | Trạng thái |
|------|--------|:----------:|-----------|
| SPEC-001 | Runtime Kernel | ✅ | ⬜ |
| SPEC-002 | Capability Registry | ✅ | ⬜ |
| SPEC-003 | Workflow Engine | ✅ | ⬜ |
| SPEC-004 | State Machine | ✅ (thiếu) | ⬜ |
| SPEC-005 | Execution Model | ✅ (thiếu) | ⬜ |
| SPEC-006 | Context Engine | | ⬜ |
| SPEC-007 | Artifact Store | | ⬜ |
| SPEC-008 | Event Bus | | ⬜ |
| SPEC-009 | Agent Metadata | | ⬜ |
| SPEC-010 | Contract Resolver | ✅ | ⬜ |
| SPEC-011 | Object Model | ✅ (thiếu) | ⬜ |
| SPEC-012 | Naming Convention | ✅ (thiếu) | ⬜ |
| SPEC-013 | Versioning Strategy | ✅ (thiếu) | ⬜ |
| SPEC-014 | Error Handling | ✅ (thiếu) | ⬜ |
| SPEC-015 | Compatibility Rules | ✅ (thiếu) | ⬜ |
| SPEC-016 | Simulation | | ⬜ |
| SPEC-017 | Doctor | | ⬜ |
| SPEC-018 | Evaluation | | ⬜ |
| SPEC-019 | Evolution | | ⬜ |
| SPEC-020 | Scheduler | ✅ | ⬜ |

**7 core spec (đang thiếu, cần viết đầu tiên):**
`SPEC-004 State Machine`, `SPEC-005 Execution Model`, `SPEC-011 Object Model`,
`SPEC-012 Naming Convention`, `SPEC-013 Versioning Strategy`, `SPEC-014 Error Handling`, `SPEC-015 Compatibility Rules`.

## 4. Priority (tỷ lệ ảnh hưởng)

| Ưu tiên | Công việc | Ảnh hưởng |
|---------|-----------|----------:|
| ⭐⭐⭐⭐⭐ | AIOS Specification (SPEC-001..020) | 40% |
| ⭐⭐⭐⭐⭐ | Runtime Kernel | 30% |
| ⭐⭐⭐⭐ | Capability Registry | 10% |
| ⭐⭐⭐⭐ | Workflow Engine | 10% |
| ⭐⭐⭐ | Context + Artifact | 5% |
| ⭐⭐⭐ | Event Bus | 5% |

## 5. Progress Tracking

| Metric | Giá trị |
|--------|---------|
| Phases thiết kế | 30/30 (đóng băng) |
| SPEC đã viết | 0/20 |
| Validator PASS | 30/30 |
| Giai đoạn 1 (docs) | ✅ hoàn tất |
| Giai đoạn 2 (core runtime) | ⬜ 0% |
| Giai đoạn 3 (data) | ⬜ 0% |
| Giai đoạn 4 (intelligence) | ⬜ 0% |
| Code coverage | ⬜ 0% |

## 6. Nguyên tắc Implementation

- **Đừng thiết kế thêm** — roadmap đã đủ, tránh over-engineering.
- AI **không sinh code trực tiếp từ roadmap** — phải qua SPEC.
- Viết code theo thứ tự 4 giai đoạn.
- Sau mỗi giai đoạn: chạy validators + Doctor health.
- Core spec viết trước, module spec sau.
- Mọi thay đổi kiến trúc → cập nhật SPEC → tái sinh code nhất quán.