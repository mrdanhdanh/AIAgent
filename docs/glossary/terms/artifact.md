---
id: TERM-008
name: Artifact
version: "1.0"
since: "1.0"
status: Approved
category: Data
owner: Artifact Store
stability: Stable
tags: [data, artifact, output]
aliases: [Output, Deliverable]
deprecated_aliases: [Result]
summary: Output versioned, immutable, không overwrite.
definition: >
  Artifact là output của một Task/Agent. Artifact luôn immutable.
  Không overwrite.
purpose: Lưu kết quả thực thi dưới dạng toàn vẹn, tái sử dụng được.
entity_type: Data
normative:
  MUST:
    - Be immutable
    - Carry version
    - Carry checksum
  MUST NOT:
    - Be overwritten
    - Be modified sau publish
responsibilities:
  - Lưu output (plan, report, diagram...)
  - Giữ version + checksum
does_not_responsible:
  - Giữ state thay đổi
  - Chạy logic
owned_by: Artifact Store
used_by:
  - Agent
  - Doctor
  - Dashboard
depends_on:
  - TERM-001 Runtime
inputs:
  - Output của Agent
outputs:
  - Artifact versioned
lifecycle: Created → Published → Immutable
states: [Created, Published, Immutable]
invariants:
  - Artifact không được overwrite.
related:
  - TERM-005
  - TERM-012
  - TERM-009
examples:
  - plan.md
  - review.md
  - test-report.md
  - diagram.png
references:
  - P010 Immutable Artifact
---

# Artifact

Đây là output.

Ví dụ:

- plan.md
- review.md
- test-report.md
- diagram.png

Artifact luôn immutable.

Không overwrite.

## Normative

- **MUST** Be immutable.
- **MUST NOT** Be overwritten.

## Responsibilities

- Lưu output (plan, report, diagram...)
- Giữ version + checksum

## Invariant

> Artifact không được overwrite.
