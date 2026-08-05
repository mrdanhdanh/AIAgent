---
name: simulation-dependency-checker
description: Dependency Checker — verify workflow → capability → agent → artifact → context → contract đủ.
agent: general
---

# Dependency Checker

## 1. Vai trò

Kiểm tra chuỗi dependency của workflow. Thiếu → Reject.

## 2. Chain

```text
Workflow → Capability → Agent → Artifact → Context → Contract
```

| Level | Check |
|-------|-------|
| Workflow | definition hợp lệ, phases đủ |
| Capability | mỗi phase có capability tồn tại |
| Agent | capability có agent hỗ trợ |
| Artifact | input/output artifact tồn tại |
| Context | context đủ theo profile |
| Contract | input/output contract tồn tại |

## 3. Result

```yaml
dependency:
  status: ok | missing
  missing:
    - { level: capability, name: implementation.code }
    - { level: artifact,   name: PLAN-001 }
```

## 4. Reject rules

- Thiếu capability → Reject.
- Thiếu agent → Reject (hoặc fallback general).
- Thiếu artifact bắt buộc → Reject.
- Thiếu context required → Reject.

## 5. Tương tác

- `simulator.md` — gọi trước risk.
- `planner.md` — order dependency.
- `registry/` + `context/` — nguồn kiểm tra.