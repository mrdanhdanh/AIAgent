---
name: evolution-architecture
description: Kiến trúc Evolution Engine — layers, pipeline, integration với Doctor/Simulation/Knowledge Graph.
agent: general
---

# Evolution Engine — Architecture

## 1. Layers

```text
┌────────────────────────────────────────┐
│          Input Sources                  │
│  Doctor · Runtime · Events · Registry · │
│  Context · Artifact · Knowledge Graph   │
├────────────────────────────────────────┤
│          Evolution Analyzer             │
│  Pattern Detection · Problem Finding    │
├────────────────────────────────────────┤
│  Optimizer · Predictor                  │
├────────────────────────────────────────┤
│          Proposal Generator             │
│  (object theo evolution.schema.yaml)    │
├────────────────────────────────────────┤
│  Migration Planner · Simulation ·       │
│  Backtest                              │
├────────────────────────────────────────┤
│  Approval Gate → Execute → Version      │
└────────────────────────────────────────┘
```

## 2. Data flow

```text
Collect metrics (Doctor output)
  → Detect patterns (retry > 20%, context > 5000, unused > 90d)
  → Find problem (agent/context/capability yếu)
  → Generate Proposal (object)
  → Policy check (proposal được phép?)
  → Simulation (risk/confidence)
  → Backtest (replay N workflow)
  → Approval (con người)
  → Migration (apply)
  → Version bump → Learning loop
```

## 3. Proposal lifecycle

```text
proposed → under-review → approved → applied
                         └→ rejected
applied → failed (nếu lỗi) → rollback
```

## 4. Impact Analysis (nhờ Knowledge Graph)

```text
Capability → Agent → Workflow → Artifacts → Dashboard
```

Engine biết toàn bộ thứ bị ảnh hưởng qua graph relations.

## 5. Compatibility check

```text
Planner v2 → Runtime v1 → REJECT (không tương thích)
```

Migration phải backward compatible hoặc update chain.

## 6. Tương tác

- Doctor (Phase 8) — metrics input.
- Simulation (Phase 7) — validate proposal.
- Knowledge Graph (Phase 9) — impact analysis.
- Dashboard (Phase 12) — hiển thị proposals.
- Plugin (Phase 11) — đăng ký proposal riêng.