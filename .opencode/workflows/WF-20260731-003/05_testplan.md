---
phase: 05_testplan
agent: test-planner
workflow_id: WF-20260731-003
status: READY
schema_version: "3.2"
---

# 05 — Test Plan: Evolution Mode — Sandbox / Simulation Engine

## Test Strategy

Test tập trung vào: (1) syntax validity, (2) standalone engine hoạt động,
(3) orchestrator dispatch, (4) report tích hợp, (5) backward compat với stress test.

## Test Types

- **unit**: PowerShell Parser syntax cho 5 scripts (2 mới + 3 sửa)
- **integration**: Orchestrator dispatch 2 engines mới, report passing (fix bug splatting)
- **e2e**: Chạy full pipeline `-evolve`, verify `SYSTEM_EVOLUTION_REPORT.md` có sections mới

## Test Cases

| ID | Loại | Mô tả | Expected |
|----|------|-------|----------|
| T1 | unit | Parser syntax 5 scripts | 0 errors mỗi file |
| T2 | integration | `simulation-engine.ps1` standalone | Exit 0, JSON report, runtime_health 0-100 |
| T3 | integration | `capability-benchmark.ps1` standalone | Exit 0, JSON report, capability_score 0-100 |
| T4 | integration | `sync-system-docs.ps1 -evolutionMode sandbox` | 2 JSON reports sinh ra (simulation + benchmark) |
| T5 | integration | `sync-system-docs.ps1 -stressTest -stressCount 20` | Exit 0, stress JSON sinh ra, không crash |
| T6 | e2e | `sync-system-docs.ps1 -evolve` | Health Score có Runtime/Capability != 50 (fallback), SYSTEM_EVOLUTION_REPORT.md có "Runtime Simulation" + "Capability Benchmark" sections |
| T7 | unit | team-syncdocs.md frontmatter + code block balance | Parse OK, fences cân đối |
| T8 | regression | `-dryRun` mode không ghi file | Exit 0, không tạo report mới |

## Coverage Targets

- unit: 100% (5 scripts parse)
- integration: 100% (T2-T5, T8)
- e2e: 100% (T6)
