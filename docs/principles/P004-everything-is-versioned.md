---
id: P004
name: Everything is Versioned
status: Draft
category: Data
severity: high
breaking_change: true
enforced_by:
  - doctor
  - validator
implemented_in:
  - SPEC-004
  - SPEC-007
related:
  - P003
  - P010
  - P018
statement: >
  Không có object nào không version.
rationale: >
  Version cho phép rollback, trace, compatibility.
  Không ghi đè — mỗi thay đổi tạo version mới.
rules:
  - Mọi entity/workflow/agent/artifact có version.
  - Không overwrite — tạo version mới.
  - Version bất biến sau publish.
implications:
  - workflow.yaml version: 2.1.
  - Agent version: 1.3.
  - Artifact version: 5.
anti_patterns:
  - Object không có version.
  - Ghi đè content cũ cùng version.
exceptions:
  - Không có.
examples:
  - Artifact v3 là bản mới, v2 vẫn còn.
references:
  - P010 Immutable Artifact
  - P018 Evolvable
---

# P004 — Everything is Versioned

## Statement

> Không có object nào không version.

## Rules

```text
workflow.yaml
version: 2.1
```

```text
Agent
version: 1.3
```

```text
Artifact
version: 5
```

## Implications

- Không ghi đè.
- Version bất biến sau publish.
- Rollback được (P015).

## Anti Pattern

❌ Object không version / ghi đè content cũ.
