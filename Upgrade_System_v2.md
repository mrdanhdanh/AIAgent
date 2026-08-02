Tôi nghĩ nên **đóng băng roadmap ngay bây giờ**. Sau này có thể thêm Phase mới, nhưng **không nên đổi thứ tự nữa**, vì mỗi Phase sẽ là nền tảng cho Phase tiếp theo.

Tôi đề xuất roadmap chính thức của **Agent Framework v4.0** như sau.

---

# Phase 0 — Baseline & Architecture Specification ⭐

> Mục tiêu: Đóng băng v3 và thiết kế v4 trước khi bắt đầu.

## 0.1 Baseline

### Deliverables

```text
SYSTEM_BASELINE.md
ARCHITECTURE_MAP.md
DEPENDENCY_GRAPH.md
SYSTEM_STATISTICS.md
```

### Công việc

* Tag v3.x
* Thống kê Agent/Skill/Command
* Sinh Dependency Graph
* Đánh giá kiến trúc hiện tại
* Xác định Technical Debt

---

## 0.2 Architecture Specification

Đây là phần mới tôi bổ sung.

### Deliverables

```text
ARCHITECTURE.md
COMPONENTS.md
DATA_MODEL.md
SEQUENCE.md
VERSIONING.md
```

### Phải định nghĩa trước

```
Workflow
Phase
Capability
Agent
Skill
Command
Context
Artifact
Event
```

Nếu không làm bước này thì các Phase sau rất dễ phải sửa.

---

# Phase 1 — Workflow Runtime ⭐⭐⭐⭐⭐

Đây là nền móng.

## Mục tiêu

Workflow không còn hardcode.

### Deliverables

```
workflow-engine/

Workflow Loader

Workflow Validator

Workflow Executor

Phase Runner

Recovery

State Machine
```

### Thêm

```
workflow.schema.yaml

feature.workflow.yaml

bugfix.workflow.yaml

ui.workflow.yaml

doc.workflow.yaml
```

Sau Phase này

```
Command

↓

Workflow Runtime

↓

Phase

↓

Agent
```

---

# Phase 2 — Capability Registry ⭐⭐⭐⭐⭐

Workflow Runtime không còn biết Agent.

Nó chỉ biết Capability.

### Deliverables

```
capabilities.yaml

agent-registry.yaml

skill-registry.yaml

command-registry.yaml

resolver

matcher

scorer
```

Thêm

```
Capability Coverage
```

---

# Phase 3 — Agent Definition System ⭐⭐⭐⭐☆

Đây là nơi mô tả Agent.

Không còn chỉ có prompt.

### Deliverables

```
agent.yaml

contracts

constraints

priority

token budget

supported languages

supported frameworks

lifecycle
```

Thêm

```
Agent State

Created

Loaded

Ready

Running

Waiting

Completed

Retry

Failed

Disabled
```

---

# Phase 4 — Context Engine ⭐⭐⭐⭐⭐

Sau khi Agent có metadata.

Context Engine mới làm việc.

### Deliverables

```
Project Context

Workflow Context

Task Context

Artifact Context

Knowledge Context

Memory Context

Runtime Context
```

Thêm

```
Context Cache

Context Diff

Context Compression

Context Profile
```

---

# Phase 5 — Artifact Store ⭐⭐⭐⭐☆

Hiện tại Artifact chỉ là file.

Sau Phase này

Artifact trở thành object.

### Deliverables

```
artifact.schema.yaml

artifact-index.json

checksum

dependency

version

history
```

Thêm

```
Artifact Graph
```

---

# Phase 6 — Event System ⭐⭐⭐⭐☆

Workflow bắt đầu Event-driven.

Ví dụ

```
PLAN_READY

BUILD_STARTED

BUILD_FINISHED

TEST_FAILED

REVIEW_APPROVED
```

Thêm

```
Event Bus

Event Dispatcher

Event Handler
```

---

# Phase 7 — Simulation Framework ⭐⭐⭐⭐⭐

Một trong những Phase quan trọng nhất.

Command

```
/team-simulate
```

Mock

```
Workflow

↓

Agent

↓

Artifact

↓

Contract

↓

Report
```

Không sửa source.

---

# Phase 8 — System Diagnostics ⭐⭐⭐⭐☆

Doctor nâng cấp.

Không chỉ

```
Schema
```

Mà còn

```
Behavior

Coverage

Performance

Token

Workflow

Capability

Context

Artifact
```

---

# Phase 9 — Knowledge Index & Graph ⭐⭐⭐⭐☆

Knowledge trở thành searchable.

### Deliverables

```
knowledge-index.json

tag

category

references

confidence

graph
```

---

# Phase 10 — Evolution Engine ⭐⭐⭐⭐☆

Workflow

↓

Metrics

↓

Suggestion

↓

Simulation

↓

Approval

↓

Migration

↓

Version

↓

Release

---

# Phase 11 — Extension System ⭐⭐⭐☆☆

Cho phép

```
Plugin

Agent

Skill

Command

Workflow
```

được cài từ bên ngoài.

---

# Phase 12 — Observability Dashboard ⭐⭐⭐☆☆

Dashboard

Hiển thị

```
Workflow

Capability

Agent

Context

Artifact

Knowledge

Doctor

Metrics

Performance

Token
```

---

# Sau Phase 12

Framework đã ổn định.

Lúc này mới nên phát triển

```
v5

Multi Agent

Parallel Execution

Distributed Agent

Cloud Runtime

Remote Plugin

Marketplace

LLM Adapter

MCP Adapter

A2A Protocol

Auto Benchmark
```

---

# Roadmap tổng thể

```text
Phase 0
Baseline & Architecture Specification
        │
        ▼
Phase 1
Workflow Runtime
        │
        ▼
Phase 2
Capability Registry
        │
        ▼
Phase 3
Agent Definition System
        │
        ▼
Phase 4
Context Engine
        │
        ▼
Phase 5
Artifact Store
        │
        ▼
Phase 6
Event System
        │
        ▼
Phase 7
Simulation Framework
        │
        ▼
Phase 8
System Diagnostics
        │
        ▼
Phase 9
Knowledge Index & Graph
        │
        ▼
Phase 10
Evolution Engine
        │
        ▼
Phase 11
Extension System
        │
        ▼
Phase 12
Observability Dashboard
```

## Khi nào bắt đầu?

**Bắt đầu ngay từ Phase 0.2 (Architecture Specification).**

Lý do là:

* Baseline (0.1) gần như bạn đã có.
* Nếu triển khai Workflow Runtime (Phase 1) ngay mà chưa có **ARCHITECTURE.md**, **DATA_MODEL.md** và **COMPONENTS.md**, rất dễ phải thay đổi thiết kế khi sang Phase 2–5.
* Chỉ cần dành khoảng 1–2 ngày để hoàn thiện đặc tả kiến trúc sẽ giúp toàn bộ các phase sau triển khai nhất quán và ít phải refactor.

Tôi khuyến nghị trình tự thực tế là:

1. Hoàn thiện **Phase 0.1** (nếu còn thiếu).
2. Thực hiện **Phase 0.2** và khóa tài liệu kiến trúc.
3. Bắt đầu phát triển **Phase 1 – Workflow Runtime** trên nền đặc tả đã thống nhất. Đây sẽ là nền móng cho toàn bộ Agent Framework v4.
