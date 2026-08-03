---
id: RULE-006
name: Data Flow
status: Stable
version: 1.0.0
category: Data
policy_type: mandatory
severity: high
compliance: required
enforcement:
  runtime: False
  doctor: True
  validator: False
  dashboard: False
statement: >
  Data flow: Context→Agent→Artifact. Không Agent→Agent, không Agent→Memory.
purpose: >
  Data di chuyển theo hướng duy nhất, Memory do Runtime quản lý.
rules:
  - Context→Agent→Artifact.
  - Không Agent→Agent.
  - Không Agent→Memory.
  - Memory do Runtime.
constraints:
  allowed:
    - Context→Agent→Artifact
  forbidden:
    - Agent→Agent.
    - Agent→Memory.
examples:
  - Context → Agent → Artifact
related_principles:
  - P009
  - P006
related_rules:
  - RULE-005
  - RULE-011
verification:
  - doctor: data-flow-check
  - tests: data-flow-tests
---

# RULE-006 — Data Flow

## Statement

> Data flow: Context→Agent→Artifact. Không Agent→Agent, không Agent→Memory.

## Purpose

Data di chuyển theo hướng duy nhất, Memory do Runtime quản lý.

## Rules

- Context→Agent→Artifact.
- Không Agent→Agent.
- Không Agent→Memory.
- Memory do Runtime.

## Allowed

- Context→Agent→Artifact

## Forbidden

- Agent→Agent.
- Agent→Memory.

## Example

```text
Context → Agent → Artifact
```

## Related Principles

- P009, P006

## Related Rules

- RULE-005, RULE-011

## Verification

- doctor: data-flow-check
- tests: data-flow-tests
