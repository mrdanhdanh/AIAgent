---
name: doctor-behavior
description: Behavioral Analysis — agent success/retry rate, workflow patterns, bottleneck detection.
agent: general
---

# Behavioral Analysis

## 1. Vai trò

Phân tích **hành vi** qua history — điểm mới của Doctor v2.

## 2. Agent health từ behavior

| Agent | Success | Retry | Health |
|-------|--------:|------:|-------:|
| Planner | 99% | 1% | 99 |
| Builder | 92% | 8% | 96 |
| Reviewer | 97% | 2% | 97 |
| Tester | 82% | 18% | 82 |

Tester thấp → phân tích: retry cao → test flaky → xem failure records.

## 3. Workflow behavior

| Metric | Giá trị |
|--------|---------|
| completion_rate | 98% |
| avg_retry | 1.2 |
| bottleneck_phase | implementation |

Workflow hay dừng sau BUILD_COMPLETED → context/dependency thiếu.

## 4. Pattern rules

- Retry > 20% → rule AGT-001.
- Success < 70% → rule AGT-002.
- Phase retry > 30% → rule WFL-001.

## 5. Nguồn

- `events/history.json`
- `artifacts/history.json`
- `memory/failure-records/`

## 6. Tương tác

- `analyzers/behavioral.md` — engine.
- `rules/rules.yaml` — pattern rules.
- `health.md` — agent/workflow health.