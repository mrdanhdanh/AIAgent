---
id: registry
name: Registry
status: Draft
category: platform
summary: Nơi đăng ký (Capability→Agent→Priority); không phải Database.
definition: >
  Registry là nơi đăng ký. Registry không phải Database.
  Registry chứa Capability → Agent → Priority.
purpose: Là nguồn discover để Runtime resolve capability.
responsibilities:
  - Đăng ký Capability
  - Đăng ký Agent
  - Đăng ký Priority
does_not_responsible:
  - Lưu dữ liệu nghiệp vụ (thuộc Database)
  - Chạy logic
owned_by: Registry Service
used_by:
  - Runtime (Capability Resolver)
  - Doctor
  - Dashboard
inputs:
  - Registration
outputs:
  - Lookup result
lifecycle: Registered → Updated → Removed
related:
  - capability
  - agent
  - plugin
examples:
  - Capability → Agent → Priority
references:
  - P007 Discoverable
  - P012 Single Source of Truth
---

# Registry

Registry là nơi đăng ký.

Không phải Database.

Ví dụ:

```text
Capability
    ↓
Agent
    ↓
Priority
```

## Responsibilities

- Đăng ký Capability
- Đăng ký Agent
- Đăng ký Priority

## Not Responsible

- Lưu dữ liệu nghiệp vụ (thuộc Database)
- Chạy logic

## Owner

Registry Service

## Used By

- Runtime (Capability Resolver)
- Doctor
- Dashboard

## Input

- Registration

## Output

- Lookup result
