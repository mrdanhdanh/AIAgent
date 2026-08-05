---
name: self-evolution-engine
description: >
  Self Evolution Engine v10.0 — framework tự đề xuất nâng cấp.
  Doctor → Metrics → Evolution → Simulation → Approval → Migration → Framework vNext.
  Proposal là object chuẩn, không phải Markdown.
agent: general
---

# Self Evolution Engine v10.0

## 1. Chuyển đổi

**Trước**: Doctor → Report → con người sửa.

**Sau**: Doctor → Metrics → Evolution Engine → Simulation → Approval → Migration → Framework vNext.

Framework **tự đề xuất nâng cấp**.

## 2. Kiến trúc

```text
              Doctor
                │
        Health Metrics
                │
       Evolution Analyzer
                │
   ┌────────────┼────────────┐
   │            │            │
Pattern     Optimizer    Predictor
   │            │            │
   └────────────┼────────────┘
                │
       Migration Planner
                │
        Simulation Engine
                │
       Approval / Execute
```

## 3. Evolution Pipeline

```text
Collect Metrics
  → Detect Pattern
  → Find Problem
  → Generate Proposal
  → Risk Analysis
  → Simulation
  → Approval
  → Migration
  → Version
```

**Không sửa ngay** — luôn qua approval.

## 4. Evolution Input

Dữ liệu từ: Doctor, Workflow, Registry, Context, Artifact, Knowledge Graph, Runtime, Events.

Không đọc source code trực tiếp.

## 5. Proposal Object (thay Markdown)

```yaml
id: EVO-001
category: performance
priority: high
reason: "Context avg 12000 > target 5000"
impact: { affected: [context-engine], estimated_gain: "-35% tokens", risk: low }
simulation: { risk_score: 12, confidence: 95, result: pass }
backtest: { replayed: 100, improved: true, gain_pct: 35 }
approval: { required: true, decision: approved }
status: applied
```

Dashboard hiển thị, Doctor đánh giá, Simulation chạy, Approval phê duyệt, Migration thực thi — **Proposal là workflow chuẩn**.

## 6. Nâng cấp đề xuất

- **Evolution Policy**: giới hạn loại proposal được phép.
- **Evolution Objectives**: tối ưu theo mục tiêu dài hạn, không ngẫu nhiên.
- **Evolution Backtesting**: replay N workflow cũ trước khi apply.

## 7. File hệ thống

| File | Vai trò |
|------|---------|
| `evolution.schema.yaml` | Proposal schema |
| `architecture.md` | Kiến trúc engine |
| `analyzer.md` | Pattern detection |
| `optimizer.md` | Optimization rules |
| `predictor.md` | Prediction |
| `planner.md` | Proposal generator |
| `migration.md` | Migration engine |
| `simulator.md` | Simulation + backtest |
| `policy.md` | Evolution policy |
| `objectives.md` | Objectives |
| `backtesting.md` | Backtest |
| `validator.md` | Validation |
| `metrics.md` | Metrics |
| `history.md` | Evolution history |