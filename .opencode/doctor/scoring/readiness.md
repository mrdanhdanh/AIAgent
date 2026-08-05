---
name: doctor-readiness
description: Readiness Assessment — đánh giá production/plugin/evolution ready %.
agent: general
---

# Readiness Assessment

## 1. Vai trò

Cuối mỗi lần Doctor chạy → đánh giá mức sẵn sàng mở rộng.

## 2. Readiness types

| Type | Công thức | Ví dụ |
|------|-----------|------:|
| production | overall × 0.5 + runtime × 0.3 + reliability × 0.2 | 95% |
| plugin | registry × 0.4 + contract × 0.3 + extension × 0.3 | 88% |
| evolution | simulation accuracy × 0.4 + history × 0.3 + behavior × 0.3 | 91% |

## 3. Production Ready

Cần:
- Static checks PASS.
- Runtime health > 90.
- Reliability (retry < 5%, recovery > 95%).
- No CRITICAL warning.

## 4. Plugin Ready (Phase 11)

Cần:
- Registry ổn định (contract v4.0).
- Extension interface rõ ràng.
- SDK + provider registry sẵn sàng.

## 5. Evolution Ready (Phase 10)

Cần:
- Simulation accuracy > 85%.
- Event history đầy đủ.
- Behavioral data có.

## 6. Output

```yaml
readiness:
  production: 95
  plugin: 88
  evolution: 91
```

## 7. Tương tác

- `health.md` — scores nguồn.
- `doctor.schema.yaml` — readiness field.
- Công cụ quyết định trước Phase 9-11.