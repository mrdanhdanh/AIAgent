---
name: doctor-metrics
description: Doctor Metrics — scan time, files, artifacts, capabilities, workflows, agents, coverage.
agent: general
---

# Doctor Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| scan.time | thời gian scan (ms) |
| files | số file metadata |
| artifacts | số artifact |
| capabilities | số capability |
| workflows | số workflow definition |
| agents | số agent |
| skills | số skill |
| coverage | capability coverage % |
| mode | quick/standard/deep/ci |

## 2. Lưu trữ

- `doctor/metrics.json` — dump mỗi lần scan.
- Doctor track trend theo thời gian.

## 3. So sánh trend

```text
Scan 2026-08-01: overall 95
Scan 2026-08-02: overall 97  ↑ +2
```

## 4. Tương tác

- `engine.md` — ghi metrics.
- `doctor.schema.yaml` — metrics field.
- Dashboard — hiển thị trend.