---
name: governance-audit
description: Audit — immutable log mọi hành động; compliance report.
agent: general
---

# Governance Audit

## 1. Vai trò

Ghi log mọi hành động trong AIOS — traceability + compliance.

## 2. Audit entry

```yaml
audit:
  - id: A-001
    timestamp: ISO8601
    actor: planner
    action: workflow.execute
    target: WF-101
    result: allowed
    policy_ref: workflow-execute-policy
```

## 3. Immutable

- Audit log append-only, không sửa/xóa.
- Hash-chain để phát hiện giả mạo.

## 4. Retention

- Audit giữ 1 năm mặc định.
- Archive nén sau 1 năm.

## 5. Compliance report

- Governance audit → compliance check.
- Doctor tổng hợp thành governance score.

## 6. Tương tác

- `governance.schema.yaml`.
- `events/` (Phase 6) — audit events.
- `dashboard/` — hiển thị audit.