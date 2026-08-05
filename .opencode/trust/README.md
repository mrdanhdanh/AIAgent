---
name: trust-safety
description: >
  Trust & Safety v27.0 — prompt safety, output validation, policy check,
  sensitive data detection, approval. Framework biết "điều gì nguy hiểm".
agent: general
---

# Trust & Safety v27.0

## 1. Vai trò

Không chỉ kiểm tra quyền — framework phát hiện **hành động nguy hiểm** trước khi xảy ra.

## 2. Safety pipeline

```text
Prompt Safety
  → Output Validation
  → Policy Check
  → Sensitive Data Detection
  → Approval
```

## 3. Ví dụ

Agent định **xóa 200 file** → Runtime tự yêu cầu Approval trước khi thực thi.

## 4. Checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | TST-001 | prompt safety (injection, harmful instruction) |
| 2 | TST-002 | output validation (format, contract) |
| 3 | TST-003 | policy check (allow/deny) |
| 4 | TST-004 | sensitive data detection (secret, PII) |
| 5 | TST-005 | risky action → approval required |

## 5. Tương tác

- `trust.schema.yaml`.
- `approval.md` — approval gate.
- `policy/` (Phase 15).
- `governance/` (Phase 26) — audit.