---
name: doctor-v2
description: >
  Doctor v2 — Framework Diagnostics Platform. Static + Behavioral + Runtime Analysis,
  Health Engine, Improvement Engine, Rule Engine, Technical Debt, Readiness.
  Không còn là command check file đơn thuần.
agent: general
---

# Doctor v2 — Framework Diagnostics Platform

## 1. Nâng cấp từ Doctor v1

**Trước**: Doctor → kiểm tra file.

**Sau**: Framework → Doctor Engine → Health/Capability/Behavior/Architecture → Improvement Report.

## 2. Kiến trúc

```text
              Doctor Engine
                    │
   ┌────────────────┼────────────────┐
   │                │                │
 Static        Behavioral      Runtime
 Analysis       Analysis       Analysis
   │                │                │
   └────────────────┼────────────────┘
                    │
              Health Engine
                    │
           Improvement Engine
                    │
             Doctor Report
```

## 3. Doctor Pipeline

```text
Discover
  → Load Metadata
  → Validate
  → Analyze (static + behavioral + runtime)
  → Score (Health Engine)
  → Recommend (Improvement Engine)
  → Report
```

## 4. 3 Analysis Types

| Type | Kiểm tra | Chạy workflow? |
|------|----------|---------------|
| Static | workflow, registry, context, artifact, event, contracts, schemas | ❌ |
| Behavioral | agent success/retry rate, patterns | ❌ (đọc history) |
| Runtime | execution time, retry, rollback, timeout, lock, recovery | ✅ (metrics) |

## 5. Doctor Score (nhóm)

| Nhóm | Score |
|------|------:|
| Architecture | 98 |
| Runtime | 96 |
| Context | 95 |
| Workflow | 99 |
| Registry | 97 |
| **Overall** | **97/100** |

## 6. Modes

| Mode | Thời gian | Mô tả |
|------|-----------|-------|
| quick | ~5s | scan nhanh |
| standard | đầy đủ | static + health |
| deep | lâu | + behavioral + simulation + performance |
| ci | nhanh | chỉ PASS/FAIL |

## 7. File hệ thống

| File | Vai trò |
|------|---------|
| `doctor.schema.yaml` | Report schema |
| `architecture.md` | Kiến trúc platform |
| `engine.md` | Doctor Engine core |
| `health.md` | Health Engine |
| `behavior.md` | Behavioral analysis |
| `coverage.md` | Capability coverage |
| `analyzers/` | 4 analyzers |
| `scoring/` | Score, debt, readiness |
| `rules/` | Rule Engine + rules.yaml |
| `validators/` | Static validators |
| `reports/` | Report generator |
| `metrics.md` | Metrics |

## 8. Nâng cấp

- **Rule Engine**: rules.yaml thêm quy tắc không cần sửa code.
- **Technical Debt Analyzer**: đo "sự già đi" của framework.
- **Readiness Assessment**: production/plugin/evolution ready %.