---
id: RULE-013
name: Deterministic Execution
status: Stable
version: 1.0.0
category: Reliability
statement: >
  Cùng Workflow + Context + Capability Version + Agent Version → cùng kết quả (hoặc sai khác trong giới hạn).
purpose: >
  Nền tảng cho Simulation, Replay, Regression Test, Doctor Behavioral Test.
rules:
  - Cùng input → cùng output.
  - Version cố định.
  - Giới hạn sai khác nếu có.
constraints:
  allowed:
    - Simulation
    - Replay Workflow
    - Regression Test
    - Doctor Behavioral Test
  forbidden:
    - Kết quả ngẫu nhiên không kiểm soát.
examples:
  - Replay cùng Workflow/Context/Version → cùng kết quả
related_principles:
  - P009
  - P011
  - P013
related_rules:
  - RULE-004
  - RULE-009
verification:
  - doctor: deterministic-check
  - tests: deterministic-tests
---

# RULE-013 — Deterministic Execution

## Statement

> Cùng Workflow + Context + Capability Version + Agent Version → cùng kết quả (hoặc sai khác trong giới hạn).

## Purpose

Nền tảng cho Simulation, Replay, Regression Test, Doctor Behavioral Test.

## Rules

- Cùng input → cùng output.
- Version cố định.
- Giới hạn sai khác nếu có.

## Allowed

- Simulation
- Replay Workflow
- Regression Test
- Doctor Behavioral Test

## Forbidden

- Kết quả ngẫu nhiên không kiểm soát.

## Example

```text
Replay cùng Workflow/Context/Version → cùng kết quả
```

## Related Principles

- P009, P011, P013

## Related Rules

- RULE-004, RULE-009

## Verification

- doctor: deterministic-check
- tests: deterministic-tests
