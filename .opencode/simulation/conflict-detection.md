---
name: simulation-conflict-detection
description: Conflict Detection — phát hiện artifact conflict giữa 2 agent, version conflict, capability conflict.
agent: general
---

# Conflict Detection

## 1. Vai trò

Phát hiện xung đột trước khi execute — tránh workflow chạy sai.

## 2. Conflict types

| Type | Ví dụ |
|------|-------|
| Artifact write conflict | Builder & Builder2 cùng ghi Artifact A |
| Version conflict | Review dùng Plan v1, Builder sinh Plan v2 |
| Capability conflict | 2 agent support cùng capability cùng priority |
| Resource conflict | 2 agent vượt budget |
| Dependency cycle | Artifact A phụ thuộc B, B phụ thuộc A |

## 3. Detection

```text
Builder → writes Artifact A
Builder2 → writes Artifact A
        → CONFLICT (same target)
```

```text
Review → reads PLAN-001 v1
Builder → produces PLAN-001 v2
        → VERSION CONFLICT
```

## 4. Resolution

- Artifact write conflict → serialize (chỉ 1 agent write cùng lúc) hoặc warning.
- Version conflict → cảnh báo, reviewer đọc latest.
- Capability conflict → scorer chọn (priority/version).
- Dependency cycle → reject (validator SIM-005).

## 5. Output

```yaml
conflicts:
  - { type: artifact-write, agents: [builder, builder2], artifact: A, severity: high }
  - { type: version, artifact: PLAN-001, v1 vs v2, severity: medium }
```

## 6. Tương tác

- `simulator.md` — detect + resolve.
- `scenario.md` — scenario abort/rollback từ conflict.
- `dependency-checker.md` — cycle check.