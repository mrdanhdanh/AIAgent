---
id: artifact
name: Artifact
status: Draft
category: data
summary: Output versioned, immutable, không overwrite.
definition: >
  Artifact là output của một Task/Agent. Artifact luôn immutable.
  Không overwrite.
purpose: Lưu kết quả thực thi dưới dạng toàn vẹn, tái sử dụng được.
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
inputs:
  - Output của Agent
outputs:
  - Artifact versioned
lifecycle: Created → Published → Immutable
related:
  - agent
  - event
  - context
examples:
  - plan.md
  - review.md
  - test-report.md
  - diagram.png
references:
  - P013 Immutable Artifacts
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

## Responsibilities

- Lưu output (plan, report, diagram...)
- Giữ version + checksum

## Not Responsible

- Giữ state thay đổi
- Chạy logic

## Owner

Artifact Store

## Used By

- Agent
- Doctor
- Dashboard

## Input

- Output của Agent

## Output

- Artifact versioned
