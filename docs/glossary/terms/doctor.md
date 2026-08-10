---
id: TERM-017
name: Doctor
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: Doctor
stability: Stable
tags: [platform, health, doctor, observability]
aliases: [Health Checker, System Doctor]
deprecated_aliases: [Fixer]
summary: Kiểm tra sức khỏe hệ thống; không tự sửa core.
definition: >
  Doctor là kiểm tra sức khỏe toàn bộ hệ sinh thái AIOS.
  Doctor scan, diagnose, score (0-100), repair an toàn (doc-only).
purpose: Phát hiện lỗi và chấm điểm sức khỏe trước khi chạy.
entity_type: Service
normative:
  MUST:
    - Scan toàn bộ hệ sinh thái
    - Chấm Health Score 0-100
    - Self-repair doc-only
  MUST NOT:
    - Sửa Core
    - Tự quyết định chính sách
responsibilities:
  - Scan (Environment/Agents/Commands/Skills/Knowledge/Workflow/Contracts)
  - Diagnose + Score
  - Report (markdown/JSON)
does_not_responsible:
  - Sửa Core
  - Quyết định chính sách
owned_by: Doctor
used_by:
  - Runtime
  - User
  - Dashboard
depends_on:
  - TERM-001 Runtime
inputs:
  - Hệ sinh thái AIOS
outputs:
  - Health Report
  - Health Score
lifecycle: Requested → Scanning → Diagnosed → Scored → Reported
states: [Requested, Scanning, Diagnosed, Scored, Reported]
invariants:
  - Doctor không sửa Core.
related:
  - TERM-001
  - TERM-012
references:
  - SPEC-011 Doctor
---

# Doctor

Kiểm tra sức khỏe hệ thống.

## Normative

- **MUST** Scan toàn bộ hệ sinh thái.
- **MUST NOT** Sửa Core.

## Responsibilities

- Scan (Environment/Agents/Commands/Skills/Knowledge/Workflow/Contracts)
- Diagnose + Score
- Report (markdown/JSON)

## Invariant

> Doctor không sửa Core.
