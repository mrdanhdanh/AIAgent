---
name: doctor-reports
description: Reports — sinh Doctor Report (summary, scores, warnings, recommendations, migration, metrics).
agent: general
---

# Doctor Reports

## 1. Report structure

```yaml
report:
  id: DOC-0421
  timestamp: ISO8601
  mode: deep

  summary: "Framework healthy, 97/100"

  scores:
    architecture: 98
    runtime: 96
    context: 95
    workflow: 99
    registry: 97
    overall: 97

  technical_debt: 14

  readiness:
    production: 95
    plugin: 88
    evolution: 91

  warnings:
    - "Context avg 8500 > target 5000"
    - "Unused capabilities: 18"

  recommendations:
    - "Enable context compression"
    - "Deprecate unused capabilities"

  migration:
    - "Phase 9 ready"
    - "Phase 10 requires simulation accuracy > 85%"

  metrics:
    scan_time: 1200
    files: 145
    coverage: 88
```

## 2. Format

- Markdown report cho người đọc.
- JSON report cho dashboard/tooling.

## 3. Modes

- quick/standard/deep → full report.
- ci → chỉ PASS/FAIL.

## 4. Tương tác

- `engine.md` — generate report.
- `doctor.schema.yaml` — report contract.
- Dashboard — hiển thị.