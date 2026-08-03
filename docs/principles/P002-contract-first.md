---
id: P002
name: Contract First
status: Draft
category: Architecture
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - validator
implemented_in:
  - SPEC-001
  - SPEC-003
related:
  - P001
  - P003
  - P018
statement: >
  Không module nào giao tiếp trực tiếp. Mọi giao tiếp qua Contract.
rationale: >
  Contract versioned, backward compatible → thay đổi không vỡ.
  Giao tiếp kiểm tra được, không phụ thuộc implementation.
rules:
  - Không truyền object nội bộ.
  - Không phụ thuộc implementation.
  - Chỉ dùng Contract.
implications:
  - Đúng: Workflow → Contract → Runtime.
  - Sai: Workflow → Runtime API (gọi thẳng implementation).
  - Mọi interface khai báo input/output contract.
anti_patterns:
  - Gọi trực tiếp method của module khác.
  - Truyền object nội bộ qua biên giới module.
  - Phụ thuộc implementation chi tiết.
exceptions:
  - Internal helper không qua biên giới module.
examples:
  - Runtime expose Capability Resolve qua Contract.
references:
  - P001 Runtime First
  - P018 Evolvable
---

# P002 — Contract First

## Statement

> Không module nào giao tiếp trực tiếp.

## Rules

```text
Workflow
    ↓
Contract
    ↓
Runtime
```

Không:

```text
Workflow
    ↓
Runtime API
```

## Rules (chi tiết)

- Không truyền object nội bộ.
- Không phụ thuộc implementation.
- Chỉ dùng Contract.

## Anti Pattern

❌ Gọi trực tiếp implementation của module khác.
