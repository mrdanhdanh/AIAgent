---
name: doctor-engine
description: Doctor Engine — orchestrator chạy analyzers, health engine, rule engine, improvement, sinh report.
agent: general
---

# Doctor Engine

## 1. Vai trò

Orchestrator của Diagnostics Platform — điều phối analyzers + engines.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Scan(mode)` | chạy full pipeline |
| `AnalyzeStatic()` | static checks |
| `AnalyzeBehavior()` | behavioral |
| `AnalyzeRuntime()` | runtime |
| `AnalyzeCoverage()` | capability coverage |
| `Health()` | compute scores |
| `Recommend()` | improvement suggestions |
| `Report()` | sinh report |

## 3. Scan flow

```text
Scan(deep)
  → Discover sources
  → Load metadata
  → Validate (validators)
  → AnalyzeStatic (validators + structure)
  → AnalyzeBehavior (history)
  → AnalyzeRuntime (metrics)
  → AnalyzeCoverage
  → Health (rule engine + scores)
  → TechnicalDebt
  → Readiness
  → Recommend
  → Report
```

## 4. Mode behavior

| Mode | Analysis subset |
|------|-----------------|
| quick | static chỉ 1 số + overall |
| standard | static full + health |
| deep | standard + behavior + runtime + simulation accuracy |
| ci | static full → PASS/FAIL |

## 5. Modes & exit

- quick/standard/deep → sinh report chi tiết.
- ci → chỉ `PASS`/`FAIL` (exit code).

## 6. Tương tác

- `analyzers/` — 4 analyzer.
- `health.md` — health engine.
- `rules/` — rule engine.
- `reports/` — output.