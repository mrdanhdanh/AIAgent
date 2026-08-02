---
name: workflow-runtime-compiler
description: compiler — Workflow Compiler (Phase 1.3): Parser → Schema Validator → Resolver → DAG → Cycle → Execution Plan → compiled.workflow.json.
agent: planner
---

# compiler.md — Workflow Compiler

> **Compile một lần, chạy nhiều lần.** Runtime chỉ đọc `compiled.workflow.json`, không đọc yaml nữa.

## 1. Pipeline (Phase 1.3)

```text
workflow.yaml
      ↓
Parser              (yaml → definition object)
      ↓
Schema Validator    (workflow.schema.yaml / phase.schema.yaml)
      ↓
Dependency Resolver (resolve depends_on)
      ↓
Graph Builder       (dựng Phase DAG — Phase 1.4)
      ↓
Cycle Detector      (chặn loop)
      ↓
Execution Plan      (thứ tự + parallelism — Phase 1.5)
      ↓
Compiled Workflow
```

## 2. Output: compiled.workflow.json

```text
workflow.yaml → compiled.workflow.json
```

Structure:

```json
{
  "id": "feature-development",
  "version": "1",
  "manifest": {
    "schema": "workflow.v1",
    "minimum_framework_version": "4.0.0",
    "required_components": ["workflow-runtime"]
  },
  "dag": {
    "analyze": [],
    "design": ["analyze"],
    "explore": ["analyze"],
    "review": ["design", "explore"]
  },
  "execution_plan": [
    {"step": 1, "phases": ["analyze"]},
    {"step": 2, "phases": ["design", "explore"]},
    {"step": 3, "phases": ["review"]}
  ],
  "cycle_free": true,
  "entry_phase": "analyze",
  "phase_defs": {}
}
```

**Workflow → Phase DAG → Execution Order → Metadata.**

## 3. Phase DAG (Phase 1.4)

Workflow là **Graph**, không phải List:

```text
         Analyze
            │
       ┌────┴────┐
       │         │
    Design    Explore
       │         │
       └────┬────┘
            │
         Review
            │
          Build
```

- Đỉnh = phase, cạnh = depends_on.
- Scheduler đọc `execution_plan` để biết phase nào chạy **song song** (`design`, `explore` cùng step).
- Đây là **tiền đề Parallel Execution (v5)**.

## 4. Execution Plan (Phase 1.5)

Compiler nhóm phase theo topo thành **steps**:

```text
Step 1: Analyze
Step 2: Design, Explore     ← song song
Step 3: Review
Step 4: Build
```

Runtime chỉ **Execute** theo plan — không tự sắp xếp lại.

## 5. Cycle Detector

Nếu phát hiện vòng:

```text
design depends_on design → cycle
```

Compile fail, WF-001, không tạo plan. DAG phải `cycle_free`.

## 6. Manifest threshold (kế thừa)

Trước compile kiểm tra:

- `schema == workflow.v1`
- `minimum_framework_version <= framework hiện tại`
- `required_components` có mặt
- Không hợp → từ chối WF-001.

## 7. Caching

Compile một lần → lưu `compiled.workflow.json`. Lần chạy sau chỉ load compiled (nhanh, không parse lại yaml). Bản compiled versioned (VERSIONING.md).

## 8. Tương tác

- Chạy sau `loader.md`, dùng `validator.md` cho schema check sâu.
- Output đưa cho `runtime.md` → `CreateInstance`.
- Schema: `compiled.schema.yaml`, `workflow.schema.yaml`.