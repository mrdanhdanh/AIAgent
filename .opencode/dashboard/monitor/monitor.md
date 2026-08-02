---
name: dashboard-monitor
description: Monitor — 13 module monitors: overview, runtime, workflow, agents, capabilities, context, artifacts, events, knowledge, simulation, doctor, evolution, plugins.
agent: general
---

# Dashboard Monitors

## 1. Overview

```text
Framework Version  ·  Health 97/100  ·  Running Workflows  ·  Plugins  ·  Agents  ·  Capabilities  ·  Knowledge Nodes
```

## 2. Runtime Monitor

```text
Workflow Running / Waiting / Completed / Failed · Average Time
```

## 3. Workflow Monitor

```text
WF-101: Planning ✓ · Build ● Running · Review ○ Waiting
```

Live timeline per workflow.

## 4. Agent Monitor

| Agent | Status |
|-------|--------|
| Planner | Idle |
| Builder | Running |
| Reviewer | Waiting |
| Tester | Completed |

## 5. Capability Monitor

```text
Registered 152 · Used Today 86 · Unused 31
```

## 6. Context Monitor

```text
Avg Context 5200 tokens · Cache Hit 82% · Compression 65%
```

## 7. Artifact Monitor

```text
Artifacts 212 · Orphan 3 · Invalid 1 · Latest v4
```

## 8. Event Monitor

Live event stream (Log Viewer):

```text
PLAN_READY → BUILD_STARTED → BUILD_FINISHED → TEST_STARTED
```

## 9. Knowledge Graph

Hiển thị graph interactive — click node → details.

```text
Planner → Plan → Builder → Artifact → Tester
```

## 10. Simulation Center

```text
Workflow → Simulate → Risk → Recommendation
```

## 11. Doctor Center

```text
Health 97 · Architecture 99 · Runtime 98 · Context 92 (+ history)
```

## 12. Evolution Center

```text
Proposal → Approved → Simulation → Apply (không đọc Markdown)
```

## 13. Plugin Center

```text
Oracle Plugin: Enabled v2 · Blazor Plugin: Disabled (Update available)
```

## Tương tác

- Data từ `projection/` (snapshot).
- Control từ `control/`.
- Widget: `widgets/`.