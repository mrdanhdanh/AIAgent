---
name: doctor-coverage
description: Capability Coverage — đo tỉ lệ capability có implementation; liệt kê thiếu.
agent: general
---

# Capability Coverage

## 1. Khái niệm

Tỉ lệ capability của framework có agent/skill/command triển khai.

## 2. Ví dụ

```text
150 capabilities
132 có agent
12 chỉ skill/command
6 không có gì
→ Coverage 88%
```

## 3. Coverage matrix

| Capability | Agent | Skill | Command | Status |
|------------|-------|-------|---------|--------|
| implementation.code | x | x | x | covered |
| implementation.ui | x | x | x | covered |
| analysis.semantic | - | - | - | missing |

## 4. Doctor action

- Missing → đề xuất thêm implementation.
- Partial → khuyến nghị agent.
- Coverage < 80% → warning (rule).

## 5. Tương tác

- `capability-validator.ps1` — sinh coverage report.
- `rules/rules.yaml` — threshold rule.
- `reports/` — hiển thị matrix.