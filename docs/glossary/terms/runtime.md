---
id: TERM-001
name: Runtime
version: "1.0"
since: "1.0"
status: Approved
category: Core
owner: Core Runtime
stability: Stable
tags: [core, runtime, orchestration]
aliases: [Execution Engine]
deprecated_aliases: [Runner]
summary: Thành phần trung tâm của AIOS, chịu trách nhiệm điều phối việc thực thi.
definition: >
  Runtime là thành phần trung tâm của AIOS chịu trách nhiệm điều phối việc thực thi.
  Runtime không xử lý nghiệp vụ. Runtime không sinh code. Runtime không phân tích.
  Runtime chỉ điều phối.
purpose: Điều phối tập trung mọi hoạt động của AIOS.
entity_type: Service
normative:
  MUST:
    - Orchestrate execution
    - Resolve capability qua Registry
    - Persist state
  MUST NOT:
    - Execute business logic
    - Generate code
    - Analyze data
  SHOULD:
    - Emit event cho mọi state change
  MAY:
    - Cache read-only metadata
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
depends_on:
  - TERM-013 Registry
  - TERM-009 Context
  - TERM-012 Event
inputs:
  - TERM-002 Workflow
  - TERM-009 Context
outputs:
  - TERM-008 Artifact
  - TERM-012 Event
lifecycle: Draft → Stable → Deprecated
states: [Draft, Stable, Deprecated]
invariants:
  - Luôn tồn tại đúng một Runtime trong một Execution Context.
  - Runtime không chứa business logic.
related:
  - TERM-002
  - TERM-009
  - TERM-012
  - TERM-008
  - TERM-006
examples:
  - Runtime nhận Workflow, resolve Capability, giao Task cho Agent.
references:
  - P001 Runtime First
  - P005 Event Driven
  - P006 Stateless Agent
  - P009 Single Source of Truth
---

# Runtime

## Definition

Runtime là thành phần trung tâm của AIOS chịu trách nhiệm điều phối việc thực thi.

Runtime không xử lý nghiệp vụ.

Runtime không sinh code.

Runtime không phân tích.

Runtime chỉ điều phối.

## Normative

- **MUST** Orchestrate execution.
- **MUST NOT** Execute business logic.

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

## Invariant

> Luôn tồn tại đúng một Runtime trong một Execution Context.
