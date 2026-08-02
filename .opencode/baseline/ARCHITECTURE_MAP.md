---
name: architecture-map
description: ARCHITECTURE_MAP — sơ đồ luồng (command/knowledge/failure) của Agent Framework v3.
agent: general
---

# ARCHITECTURE_MAP.md — Agent Framework v3

> Sơ đồ luồng dữ liệu và điều phối hiện tại.

## 1. Tổng quan (System Overview)

```
User
  ↓
Command (/team, /ask, /doctor, ...)
  ↓
Agent(s) — orchestrator triệu hồi sub-agent
  ↓
Workflow (phases)
  ↓
Artifact (file .md/.json trong WF-*)
  ↓
Knowledge / Memory / Registry
```

## 2. Command Flow

Luồng `/team <yêu cầu>` (Workflow Engine v4):

```
User
  ↓
/team (launcher)
  ↓
Workflow Engine (engine -> loader -> validator -> executor -> phase-runner)
  ↓
Phase 1 Analyze   → analyst
Phase 2 Design    → planner
Phase 3 Plan      → planner
Phase 4 Review    → reviewer
Phase 5 Guardrail → guardian (gitguard)
Phase 6 Backup    → backup-agent
Phase 7 Build     → builder
Phase 8-9 Testing → tester (+ test-planner)
Phase 10-13 Doc/Skill/Report → general/self-improver
```

## 3. Knowledge Flow

```
Knowledge (lessons, patterns, index JSON)
  ↓
/ask → knowledge-agent (Intent Analyzer + Router)
  ↓
Skill pipeline (code-understanding, document-understanding, search-engine...)
  ↓
Answer Builder (answer-builder)
  ↓
Người dùng (evidence file:line)
```

## 4. Failure Flow

```
Error / Failed phase
  ↓
failure-agent (chuẩn hóa lỗi, classify)
  ↓
root-cause-agent (hypotheses + confidence)
  ↓
learning-agent (Failure Learning Pipeline, approval gate)
  ↓
Memory (LSN-/PAT-) + Knowledge (lessons.md)
```

## 5. Memory & Learning Flow

```
Workflow hoàn tất
  ↓
self-improver (đọc lại quá trình, đề xuất cải tiến)
  ↓
approval gate (MEDIUM/HIGH)
  ↓
Knowledge base + memory ghi mới
```

## 6. Dependency Flow (top-down)

```
Command
  ↓
Agent
  ↓
Skill
  ↓
Knowledge / Memory
  ↓
Scripts (registry scripts, baseline, validator)
```

## 7. Registry Flow (Sprint 2)

```
Command/User → Capability Registry
  ↓
capabilities.yaml (14 category)
  ↓
matcher → manager → scorer
  ↓
agent-registry / skill-registry / command-registry
  ↓
/team-capabilities (discovery) · capability-validator.ps1 (PASS exit 0)