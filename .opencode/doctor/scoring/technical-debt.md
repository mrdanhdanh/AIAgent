---
name: doctor-technical-debt
description: Technical Debt Analyzer — đo nợ kỹ thuật: deprecated agents, unused capabilities, orphan artifacts, duplicate profiles.
agent: general
---

# Technical Debt Analyzer

## 1. Vai trò

Đo **nợ kỹ thuật** của framework — biết "đang già đi ở đâu".

## 2. Debt items

| Hạng mục | Điểm |
|----------|-----:|
| Deprecated Agents | 4 |
| Unused Capabilities | 18 |
| Orphan Artifacts | 7 |
| Duplicate Context Profiles | 3 |
| Broken Dependencies | 2 |
| Missing Contracts | 3 |
| Outdated Schemas | 1 |

## 3. Formula

```text
debt_score = Σ(item_count × item_weight)
```

Ví dụ:
```
4×1 + 18×0.5 + 7×1 + 3×0.5 + 2×2 + 3×1 + 1×0.5 = 22.5
```

Debt Score = min(100, Σ) = **22.5/100** (thấp = ít nợ).

## 4. Bands

| Debt | Level |
|------|-------|
| 0-20 | low |
| 21-50 | medium |
| 51-80 | high |
| 81-100 | critical |

## 5. Improvement mapping

| Item | Đề xuất |
|------|---------|
| deprecated agent | tìm replacement |
| unused capability | deprecated |
| orphan artifact | archive/delete |
| duplicate profile | merge |
| broken dependency | fix chain |

## 6. Tương tác

- `analyzers/static.md` — phát hiện.
- `improvement.md` — suggestion.
- `doctor.schema.yaml` — technical_debt field.