---
name: agent-compatibility
description: compatibility — kiểm tra tương thích Agent version ↔ Runtime version ↔ Capability version ↔ Contract version.
agent: general
---

# Agent Compatibility

> Trước khi chọn agent, verify compatibility. Không khớp → Reject → candidate kế tiếp.

## 1. Check matrix

| # | Kiểm tra | Điều kiện pass |
|---|----------|----------------|
| 1 | Agent ↔ Runtime | `manifest.compatibility` có `runtime >= X` và runtime version đạt |
| 2 | Agent ↔ Capability | capability tồn tại + version phù hợp (capability.since <= agent version v2) |
| 3 | Agent ↔ Contract | contract id tồn tại trong input/output.schema.yaml |
| 4 | Framework | capability.requires_framework ⊆ agent frameworks |

## 2. Ví dụ manifest

```yaml
manifest:
  framework: "4.0"
  schema: 1
  compatibility:
    - capability >= 1.0
    - runtime >= 1.0
    - contract >= 1.0
```

## 3. Version policy

| Agent version | capability version | Kết quả |
|----------------|--------------------|---------|
| 2.0 | 1.0 | OK (>=1.0) |
| 2.0 | 2.0 (MAJOR bump) | ⚠️ check breaking |
| 1.0 | 2.0 | ❌ nếu capability>=2.0 |

## 4. Reject flow

```
Reject
  ↓
Matcher tìm candidate kế tiếp
  ↓
hết candidate → CAP-002 → recovery (orchestration.fallback)
```

## 5. Error codes (Phase 3)

| Mã | Mô tả |
|----|-------|
| AG-CMP-001 | Agent incompatible with runtime |
| AG-CMP-002 | Capability version conflict |
| AG-CMP-003 | Contract not found |

## 6. Tương tác

- `compatibility` bước cuối trong Resolver (registry.md).
- `scoring.md` (sau compat chọn agent).
- `validator.md` AG-006/AG-009 (static) + compat runtime (dynamic).