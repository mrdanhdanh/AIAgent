---
id: TERM-021
name: SDK
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: SDK
stability: Stable
tags: [platform, sdk, access, integration]
aliases: [Client Library, API Client]
deprecated_aliases: [Wrapper]
summary: Lớp truy cập chính thức vào AIOS; không vào Core trực tiếp.
definition: >
  SDK là lớp truy cập chính thức vào AIOS.
  SDK truy cập qua Contract — không vào Core trực tiếp.
purpose: Cho bên ngoài tích hợp AIOS an toàn và có kiểm soát.
entity_type: Service
normative:
  MUST:
    - Access qua Contract
    - Provide typed client
    - Be versioned (semver)
  MUST NOT:
    - Access Core trực tiếp
    - Chứa Business Data
responsibilities:
  - SDK Client (11 components)
  - API Binding + Typed Access
  - Auth + Versioning
does_not_responsible:
  - Access Core trực tiếp
  - Xử lý nghiệp vụ
owned_by: SDK
used_by:
  - User
  - Application
  - CLI
depends_on:
  - TERM-001 Runtime
  - TERM-014 Contract
inputs:
  - API Call
outputs:
  - SDK Response
lifecycle: Connected → Authenticated → Bound → Active
states: [Connected, Authenticated, Bound, Active]
invariants:
  - SDK không vào Core trực tiếp.
related:
  - TERM-001
  - TERM-014
references:
  - SPEC-015 SDK
  - aios-sdk (v13)
---

# SDK

Lớp truy cập chính thức vào AIOS.

## Normative

- **MUST** Access qua Contract.
- **MUST** Provide typed client.
- **MUST NOT** Access Core trực tiếp.

## Responsibilities

- SDK Client (11 components)
- API Binding + Typed Access
- Auth + Versioning

## Invariant

> SDK không vào Core trực tiếp.
