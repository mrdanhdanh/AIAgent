---
id: TERM-018
name: Simulation
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: Simulation Engine
stability: Stable
tags: [platform, simulation, test]
aliases: [Simulation Run, Mock Execution]
deprecated_aliases: [Dry Run]
summary: Mô phỏng workflow trước khi chạy thật; không đổi hệ thống.
definition: >
  Simulation là mô phỏng workflow trước khi chạy thật.
  Simulation isolated, deterministic, replayable qua Event log.
purpose: Kiểm tra hành vi workflow mà không ảnh hưởng hệ thống thật.
entity_type: Service
normative:
  MUST:
    - Be isolated (không đổi hệ thống thật)
    - Be deterministic
    - Be replayable qua Event log
  MUST NOT:
    - Thay đổi hệ thống thật
    - Chứa Business Data
responsibilities:
  - Mô phỏng 6 scenario types (Bug Fix, New Feature, Migration, Review, Testing, Refactoring)
  - Observe + Compare + Report
does_not_responsible:
  - Thay đổi hệ thống thật
  - Tạo Artifact production
owned_by: Simulation Engine
used_by:
  - Runtime
  - Doctor
  - User
depends_on:
  - TERM-001 Runtime
  - TERM-012 Event
inputs:
  - Workflow (SPEC-002)
  - Scenario
outputs:
  - Simulation Report
  - Scenario Result
lifecycle: Defined → Configured → Running → Observed → Reported
states: [Defined, Configured, Running, Observed, Reported]
invariants:
  - Simulation không đổi hệ thống thật.
related:
  - TERM-001
  - TERM-012
references:
  - SPEC-012 Simulation Engine
---

# Simulation

Mô phỏng workflow trước khi chạy thật.

## Normative

- **MUST** Be isolated.
- **MUST** Be deterministic.
- **MUST NOT** Thay đổi hệ thống thật.

## Responsibilities

- Mô phỏng 6 scenario types
- Observe + Compare + Report

## Invariant

> Simulation không đổi hệ thống thật.
