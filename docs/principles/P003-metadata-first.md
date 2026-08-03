---
id: P003
name: Metadata First
status: Draft
category: Data
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - validator
implemented_in:
  - SPEC-004
  - SPEC-005
related:
  - P002
  - P009
  - P017
statement: >
  Mọi thực thể đều phải có metadata.
rationale: >
  Metadata là nguồn cho resolver/scheduler/doctor/dashboard.
  Không hard-code đặc tính trong code — đặc tính nằm ở metadata.
rules:
  - Mọi entity có id, version, owner, status, created, updated.
  - Không hard-code đặc tính thực thể trong code.
implications:
  - Agent, Workflow, Artifact, Capability, Plugin đều có metadata.
  - Metadata machine-readable (P017).
anti_patterns:
  - Đặc tính thực thể nằm trong code, không nằm ở metadata.
  - Entity thiếu id/version/status.
exceptions:
  - Không có.
examples:
  - workflow.yaml có metadata id/version/status.
references:
  - P009 Single Source of Truth
  - P017 AI Native
---

# P003 — Metadata First

## Statement

> Mọi thực thể đều phải có metadata.

## Rules

Agent, Workflow, Artifact, Capability, Plugin đều phải có:

```text
id

version

owner

status

created

updated
```

## Implications

- Metadata machine-readable.
- Resolver/scheduler/doctor đọc metadata, không đọc code.

## Anti Pattern

❌ Đặc tính thực thể hard-code trong code.
