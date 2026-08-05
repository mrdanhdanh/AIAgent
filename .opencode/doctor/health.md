---
name: doctor-health
description: Health Engine — tính score từng nhóm (agent, workflow, registry, context, artifact, event, simulation, runtime).
agent: general
---

# Health Engine

## 1. Vai trò

Tổng hợp điểm sức khỏe từng thành phần + overall.

## 2. Health groups

| Group | Score nguồn |
|-------|------------|
| Architecture | static checks |
| Runtime | runtime analyzer |
| Context | context metrics (avg tokens) |
| Workflow | workflow health |
| Registry | registry health |
| Agent | agent health (behavioral) |
| Artifact | artifact health |
| Event | event health |
| Simulation | prediction accuracy |

## 3. Agent health

| Agent | Health |
|-------|-------:|
| Planner | 99 |
| Builder | 96 |
| Reviewer | 97 |
| Tester | 82 ← thấp, phân tích |

Tester thấp → behavioral analyzer tìm lý do (retry cao, test flaky).

## 4. Workflow health

```text
Execution 98% · Retry 1% · Recovery 100% → 97
```

## 5. Registry health

```text
Duplicate 5 · Deprecated 2 · Unused 18 → thấp hơn
```

## 6. Context health

```text
Avg context 8500 tokens (target 5000) → WARNING
```

## 7. Artifact health

```text
Missing · Duplicate · Unused · Broken Dependency · Invalid Version
```

## 8. Event health

```text
Dropped · Replay Error · Subscriber Missing · Queue Delay
```

## 9. Overall formula

```
overall = weighted_average(all groups)
```

Weights cấu hình trong `scoring/scores.yaml`.

## 10. Tương tác

- `analyzers/` — nguồn dữ liệu.
- `scoring/scores.md` — weight + bands.
- `reports/` — hiển thị.