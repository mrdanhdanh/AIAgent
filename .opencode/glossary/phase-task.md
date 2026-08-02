---
name: glossary-phase-task
description: Thuật ngữ Phase + Task — bước workflow và đơn vị công việc.
agent: general
---

# Term: Phase

**Definition**: A step within a workflow, mapped to a capability.

**Owns**:
- capability ref
- depends_on (phase trước)
- inputs/outputs (artifact types)

**Does not own**:
- State (thuộc workflow)
- Agent (chọn bởi resolver)

# Term: Task

**Definition**: A concrete unit of work within a phase.

**Owns**:
- goal
- inputs / outputs

**Does not own**:
- State
- Agent

**Quan hệ**:
- Workflow → Phase → Task (Object Model).
- Mỗi phase liên kết 1 capability.

**Tham chiếu**: P006.