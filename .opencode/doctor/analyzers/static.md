---
name: doctor-analyzer-static
description: Static Analyzer — kiểm tra workflow, registry, context, artifact, event, contracts, schemas. Không chạy workflow.
agent: general
---

# Static Analyzer

## 1. Vai trò

Kiểm tra tính hợp lệ của toàn bộ metadata **không chạy workflow**.

## 2. Checks

| Module | Kiểm tra |
|--------|----------|
| Registry | capability/agent/skill/command hợp lệ (capability-validator) |
| Agent | metadata 4-layer hợp lệ (agent-validator) |
| Context | profiles/schemas/budget hợp lệ (context-validator) |
| Artifact | schemas/types/modules (artifact-validator) |
| Event | schema/categories/contracts (event-validator) |
| Simulation | schema/modes (simulation-validator) |
| Contracts | input/output contract tồn tại |
| Schemas | mọi schema version khớp |

## 2. Reuse validators

Doctor gọi trực tiếp các validator script đã có:

```text
capability-validator.ps1
agent-validator.ps1
context-validator.ps1
artifact-validator.ps1
event-validator.ps1
simulation-validator.ps1
```

Kết quả gộp thành static score.

## 3. Output

```yaml
static:
  score: 98
  errors: 0
  warnings: 2
  checks:
    - { module: registry, pass: true }
    - { module: agent, pass: true }
    - { module: context, pass: true }
```

## 4. Tương tác

- `engine.md` — gọi trong AnalyzeStatic.
- `validators/` — chi tiết từng module.
- `scoring/` — đóng góp vào architecture score.