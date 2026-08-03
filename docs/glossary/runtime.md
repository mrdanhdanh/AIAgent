---
id: runtime
name: Runtime
status: Draft
category: core
summary: Thành phần trung tâm của AIOS, chịu trách nhiệm điều phối việc thực thi.
definition: >
  Runtime là thành phần trung tâm của AIOS chịu trách nhiệm điều phối việc thực thi.
  Runtime không xử lý nghiệp vụ. Runtime không sinh code. Runtime không phân tích.
  Runtime chỉ điều phối.
purpose: Điều phối tập trung mọi hoạt động của AIOS.
responsibilities:
  - Load Workflow
  - Resolve Capability
  - Allocate Context
  - Invoke Agent
  - Publish Event
  - Collect Artifact
  - Persist State
does_not_responsible:
  - Business Logic
  - Prompt Engineering
  - UI
  - Git
  - LLM
owned_by: AIOS Kernel
used_by:
  - Workflow Engine
  - Scheduler
  - Doctor
  - Simulation
inputs:
  - Workflow
  - Context
  - Runtime State
outputs:
  - Artifacts
  - Events
  - Execution Result
lifecycle: Init → Running → Suspended → Terminated
related:
  - workflow
  - context
  - event
  - artifact
  - capability
examples:
  - Runtime nhận Workflow, resolve Capability, giao Task cho Agent.
references:
  - P001 Runtime First
  - P004 Event Driven
  - P005 Stateless Agents
  - P012 Single Source of Truth
---

# Runtime

## Definition

Runtime là thành phần trung tâm của AIOS chịu trách nhiệm điều phối việc thực thi.

Runtime không xử lý nghiệp vụ.

Runtime không sinh code.

Runtime không phân tích.

Runtime chỉ điều phối.

## Responsibilities

- Load Workflow
- Resolve Capability
- Allocate Context
- Invoke Agent
- Publish Event
- Collect Artifact
- Persist State

## Not Responsible

- Business Logic
- Prompt Engineering
- UI
- Git
- LLM

## Owner

AIOS Kernel

## Used By

- Workflow Engine
- Scheduler
- Doctor
- Simulation

## Input

- Workflow
- Context
- Runtime State

## Output

- Artifacts
- Events
- Execution Result
