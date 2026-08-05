---
name: doctor-analyzer-coverage
description: Coverage Analyzer — khả năng capability coverage; liệt kê capability thiếu agent/skill/command.
agent: general
---

# Coverage Analyzer

## 1. Vai trò

Đo **Capability Coverage** — bao nhiêu capability có implementation (agent/skill/command).

## 2. Formula

```text
coverage = covered_capabilities / total_capabilities × 100
```

Ví dụ: 132/150 = 88%.

## 3. Coverage states

| State | Mô tả |
|-------|-------|
| covered | có agent |
| partial | chỉ skill/command |
| missing | không có gì |

## 4. Output

```yaml
coverage:
  total: 150
  covered: 132
  partial: 12
  missing: 6
  rate: 88
  missing_list:
    - implementation.specialized
    - analysis.semantic
```

## 5. Doctor action

- Missing capability → đề xuất thêm agent/skill/command.
- Partial → khuyến nghị thêm agent.
- Coverage < 80% → warning (rule).

## 6. Tương tác

- `capability-validator.ps1` — coverage report hiện có.
- `rules/rules.yaml` — threshold.
- `reports/` — hiển thị.