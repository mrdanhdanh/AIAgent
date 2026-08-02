---
name: simulation-confidence
description: Confidence Engine — tính Confidence Score; risk thấp + confidence cao → execute.
agent: general
---

# Confidence Engine

## 1. Vai trò

Không chỉ Risk. Thêm **Confidence Score** (0..100) — mức độ tin tưởng workflow sẽ thành công.

## 2. Factors

| Tiêu chí | Điểm mặc định |
|----------|--------------:|
| Workflow hợp lệ | 100 |
| Capability đầy đủ | 100 |
| Context đầy đủ | 92 |
| Agent ổn định | 96 |
| Artifact hợp lệ | 100 |
| Dependency đủ | 95 |

## 3. Formula

```
confidence = average(criteria scores) × history_factor
history_factor = agent historical success rate (default 1.0)
```

## 4. Decision matrix

| Risk | Confidence | Decision |
|------|------------|----------|
| 10 | 97% | ✅ execute |
| 30 | 97% | ✅ execute |
| 40 | 60% | ⚠️ proceed-with-warning |
| 70 | 50% | ❌ reject |

**Risk thấp + Confidence cao → Execute.** Risk cao nhưng Confidence cao vẫn có thể Execute tùy policy.

## 5. Policy

```yaml
decision:
  execute:        risk <= 40 AND confidence >= 70
  proceed-warning: risk <= 60 OR confidence >= 50
  reject:         risk > 60 AND confidence < 50
```

## 6. Tương tác

- `simulator.md` — dùng cả risk + confidence.
- `report.md` — hiển thị cả 2.
- `scenario.md` — confidence per scenario.