---
name: dashboard-reports
description: Reports — sinh daily/weekly/monthly report từ snapshot + metrics; không cần Doctor.
agent: general
---

# Dashboard Reports

## 1. Vai trò

Sinh báo cáo định kỳ (daily/weekly/monthly) từ snapshot + metrics.

## 2. Reports

| Type | Nội dung |
|------|----------|
| daily | workflow hôm nay, errors, tokens |
| weekly | tổng hợp 7 ngày, trend |
| monthly | tổng kết, evolution gain, health trend |

## 3. Report structure

```yaml
report:
  period: daily
  generated_at: ISO8601
  summary: "97/100 health, 12 workflows, 0 errors"
  metrics: { workflows: 12, tokens: 84000, errors: 0 }
  evolution: { proposals: 2, applied: 1 }
  plugins: { enabled: 5, errors: 0 }
```

## 4. Không cần Doctor

- Reports dùng snapshot + metrics đã có.
- Doctor chỉ cho health chi tiết (tùy chọn embed).

## 5. Delivery

- Markdown render.
- Dashboard hiển thị lịch sử reports.

## 6. Tương tác

- `metrics/` — data.
- `projection/` — snapshot.
- Dashboard UI — hiển thị.