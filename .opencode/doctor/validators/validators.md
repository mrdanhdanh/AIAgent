---
name: doctor-validators
description: Validators — Doctor gọi các validator script có sẵn làm static checks.
agent: general
---

# Doctor Validators

## 1. Vai trò

Doctor tái sử dụng toàn bộ validator script từ Phase 2-7 làm static checks.

## 2. Validator mapping

| Validator | Phase | Module |
|-----------|-------|--------|
| `capability-validator.ps1` | 2 | registry |
| `agent-validator.ps1` | 3 | agents |
| `context-validator.ps1` | 4 | context |
| `artifact-validator.ps1` | 5 | artifacts |
| `event-validator.ps1` | 6 | events |
| `simulation-validator.ps1` | 7 | simulation |

## 3. Output gộp

```yaml
static:
  registry: { pass: true, exit: 0 }
  agent:    { pass: true, exit: 0 }
  context:  { pass: true, exit: 0 }
  artifact: { pass: true, exit: 0 }
  event:    { pass: true, exit: 0 }
  simulation: { pass: true, exit: 0 }
```

## 4. Architecture score

Architecture score = 100 − (số validator exit 1 × penalty).

- Tất cả pass → 100.
- 1 fail → −10.

## 5. Tương tác

- `analyzers/static.md` — gọi validators.
- `health.md` — architecture score.
- `rules/` — thêm penalty.