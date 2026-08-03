---
name: glossary-task
description: Thuật ngữ Task — đơn vị công việc cụ thể trong phase.
agent: general
---

# Term: Task

**Definition**: A concrete unit of work within a phase, executed by an agent.

**Owns**:
- goal
- inputs / outputs

**Does not own**:
- State
- Agent
- Workflow

**Quan hệ**:
- Task nằm trong Phase.
- Agent thực thi task qua capability.
- Task có thể retry (recoverable).

**Tham chiếu**: P001, P006, P009.