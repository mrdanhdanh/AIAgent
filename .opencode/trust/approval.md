---
name: trust-approval
description: Approval Gate — hành động nguy hiểm cần approval; auto/human decision.
agent: general
---

# Approval Gate

## 1. Vai trò

Chặn hành động nguy hiểm (xóa nhiều file, publish, deploy) trước khi thực thi.

## 2. Risk levels → approval

| Risk | Ví dụ | Approval |
|------|-------|----------|
| low | tạo artifact | auto |
| medium | sửa nhiều file | auto (policy) |
| high | xóa >100 file | human |
| critical | deploy/release | human + audit |

## 3. Flow

```text
Action detected (risky)
  → evaluate risk
  → auto approval? → execute
  → human required → queue + notify
  → denied → block + log
```

## 4. Tương tác

- `trust.schema.yaml`.
- `dashboard/` — approval queue UI.
- `events/` — approval events.
- `governance/audit.md` — log.