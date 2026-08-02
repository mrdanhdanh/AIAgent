---
name: context-intelligence
description: intelligence — Context Intelligence Layer: chấm điểm giá trị từng context, budget policy, loại context kém.
agent: general
---

# Context Intelligence Layer

> Nâng cấp Phase 4: không chỉ "gom context" mà **đánh giá giá trị** mỗi context.

## 1. Vì sao

Nếu chỉ gom → agent nhận "nhiều thứ" chứ chưa chắc "nhiều thứ có giá trị".
Intelligence đảm bảo agent nhận **context có giá trị cao nhất**.

## 2. Scoring

| type | score mặc định |
|------|--------------|
| task | 100 |
| artifact (plan/code) | 95 |
| project.rules | 88 |
| workflow | 85 |
| knowledge | 70 |
| runtime | 50 |
| memory | 30 |

## 3. Chính sách token budget

| Nhóm | Hành động |
|------|-----------|
| required | **luôn giữ** |
| high (>=80) | giữ, không nén |
| medium (50-79) | giữ nhưng **nén** tùy budget |
| low (<50) | loại trước nếu vượt budget |

## 4. Ví dụ

Budget = 2000 token. Các context: task 300, plan 900, rules 400, knowledge 600, memory 300.

1. Giữ task+rules = 1300 (required/high).
2. Còn 700. plan (400) + knowledge (300) = 700 → lọt vừa đủ.
3. memory (300) → **bị loại** (thiếu token).

## 5. Override

Agent có thể ghi đè score trong profile:

```yaml
rank:
  memory: 60
```

## 6. Sinh Indicators

- Không gửi score trong package (chỉ dùng nội bộ).
- Ghi lý do loại vào `runtime.warnings`/metrics cho Doctor.

## 7. Tương tác

- `compression/` dùng mức score để quyết định nén bao nhiêu.
- `metrics/` ghi budget used + số context loại.
- Method: `intelligence.scorer`.