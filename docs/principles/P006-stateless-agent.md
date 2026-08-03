---
id: P006
name: Stateless Agent
status: Draft
category: Runtime
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - runtime
implemented_in:
  - SPEC-001
  - SPEC-004
related:
  - P001
  - P009
statement: >
  Agent KHÔNG giữ state.
rationale: >
  Stateless → replaceable, scalable, replayable.
  Mọi state nằm ở Runtime → single source of truth (P009).
rules:
  - Agent không cache.
  - Agent không nhớ.
  - Agent không lưu session.
  - Mọi state nằm ở Runtime.
implications:
  - Agent có thể được thay thế bất kỳ lúc nào.
  - State phục hồi từ Event log.
anti_patterns:
  - Agent cache nội bộ.
  - Agent lưu session riêng.
  - Agent duy trì state giữa các lần gọi.
exceptions:
  - Không có.
examples:
  - Agent nhận Context, thực thi, trả Artifact — không giữ gì lại.
references:
  - P001 Runtime First
  - P009 Single Source of Truth
---

# P006 — Stateless Agent

## Statement

> Agent KHÔNG giữ state.

## Rules

- Không cache.
- Không nhớ.
- Không lưu session.
- Mọi state nằm ở Runtime.

## Implications

- Thay thế được bất kỳ lúc nào.
- State phục hồi từ Event log.

## Anti Pattern

❌ Agent cache / lưu session / giữ state giữa các lần gọi.
