---
phase: 02_design
agent: planner
workflow_id: WF-20260731-003
status: READY
schema_version: "3.2"
---

# 02 — Design: Evolution Mode — Sandbox / Simulation Engine

## Architecture

```
/team-syncdocs --simulate | --benchmark | --stress-test | --evolutionMode sandbox
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│ sync-system-docs.ps1  (orchestrator — MODIFY)                    │
│  ├─ --stress-test  → Stress Test Engine (inline, existing)       │
│  ├─ --simulate / sandbox mode → simulation-engine.ps1  (NEW)     │
│  ├─ --benchmark                → capability-benchmark.ps1 (NEW)  │
│  └─ evolution pipeline (7 engines, existing) + tích hợp runtime  │
└───────────────┬──────────────────────────────────────────────────┘
                │
    ┌───────────┼──────────────────────────┐
    ▼           ▼                          ▼
┌─────────┐ ┌───────────────┐ ┌──────────────────────┐
│simulation│ │capability-    │ │health-score.ps1      │
│-engine   │ │benchmark.ps1  │ │(MODIFY — +2 categories)│
│.ps1 (NEW)│ │(NEW)          │ └──────────┬───────────┘
└────┬─────┘ └──────┬────────┘            │
     │              │                     ▼
     ▼              ▼          ┌──────────────────────┐
simulation-      capability-   │evolution-report.ps1  │
<ts>.json        <ts>.json     │(MODIFY — +2 sections)│
     │              │          └──────────┬───────────┘
     └──────────────┴─────────────────────▼
                          SYSTEM_EVOLUTION_REPORT.md
```

**Nguyên tắc thiết kế:**
1. **Read-only**: Simulation/Benchmark KHÔNG sửa file hệ thống — chỉ validate + báo cáo.
2. **Backward compatible**: Flags mới thêm vào, không phá hành vi cũ.
3. **Pattern nhất quán**: JSON report `evolution/reports/<tool>-<timestamp>.json`, giống 7 engines hiện có.
4. **Runtime Health = f(simulation)**: score 0-100 từ tỷ lệ PASS các validation checks.
5. **Tách biệt với Doctor**: Doctor = health check nhanh; Evolution Simulation = runtime validation sâu, tích hợp vào syncdocs pipeline + health score.

## Components

| # | Component | Action | Path |
|---|-----------|--------|------|
| 1 | Simulation Engine (runtime validation) | CREATE | `.opencode/scripts/evolution/simulation-engine.ps1` |
| 2 | Capability Benchmark Engine | CREATE | `.opencode/scripts/evolution/capability-benchmark.ps1` |
| 3 | Orchestrator — flags + dispatch | MODIFY | `.opencode/scripts/sync-system-docs.ps1` |
| 4 | Health Score — Runtime + Capability categories | MODIFY | `.opencode/scripts/evolution/health-score.ps1` |
| 5 | Evolution Report — Simulation sections | MODIFY | `.opencode/scripts/evolution/evolution-report.ps1` |
| 6 | Command docs | MODIFY | `.opencode/commands/team-syncdocs.md` |
| 7 | System Evolution Report | REGENERATE | `.opencode/SYSTEM_EVOLUTION_REPORT.md` |

## Data Flow

1. User chạy `/team-syncdocs --simulate` (hoặc `--evolutionMode sandbox` / `--benchmark` / `--evolve`).
2. `sync-system-docs.ps1` parse flags → quyết định engines chạy:
   - `$runSimulation = $simulate -or ($evolutionMode -eq 'sandbox') -or $evolve`
   - `$runBenchmark = $benchmark -or ($evolutionMode -eq 'sandbox') -or $evolve`
3. **Simulation Engine** chạy 6 nhóm validation (xem Simulation Engine section) → xuất `simulation-engine-<ts>.json`.
4. **Capability Benchmark** chấm điểm agent theo domain → xuất `capability-benchmark-<ts>.json`.
5. **Health Score** nhận thêm `-simulationReport` + `-benchmarkReport` → tính 10 categories (8 cũ + Runtime + Capability) → xuất `health-score-<ts>.json`.
6. **Evolution Report** nhận thêm 2 report → tạo `SYSTEM_EVOLUTION_REPORT.md` với sections Simulation + Capability.
7. Console hiển thị Runtime Health + Capability Score + overall Health.

## Simulation Engine (chi tiết)

`simulation-engine.ps1` — 6 validation groups:

| Group | Checks | Phát hiện lỗi |
|-------|--------|--------------|
| 1. Agent Validation | Frontmatter parse, mode/model hợp lệ, permissions, depends_on refs, skill requirements, output schema | `AGENT_INVALID`, `MISSING_DEPENDENCY`, `SCHEMA_MISMATCH` |
| 2. Skill Validation | SKILL.md frontmatter, referenced files tồn tại, agent permission, deprecated, conflict | `SKILL_MISSING_FILE`, `SKILL_DEPRECATED`, `SKILL_CONFLICT` |
| 3. Command Validation | Frontmatter parse, agent tồn tại, params/flags hợp lệ | `COMMAND_NO_AGENT`, `COMMAND_BAD_FRONTMATTER` |
| 4. Contract Validation | Contract tồn tại cho core agents, schema version compat (output v1 vs input v2) | `MISSING_CONTRACT`, `VERSION_MISMATCH` |
| 5. Integration Test | Chain planner→reviewer→tester: output của agent trước là input agent sau | `INTEGRATION_BREAK` |
| 6. Output Validation | Fake task injection: expected output (result.md) vs actual output (result.txt → FAIL) | `OUTPUT_MISMATCH` |

**Runtime Health Score:**
```
runtime_health = round( (passed_checks / total_checks) * 100 )
verdict: STABLE (>=90) | WARNING (70-89) | UNSTABLE (<70)
```

**Report JSON:**
```yaml
simulation:
  agents_tested: X
  skills_tested: X
  commands_tested: X
  contracts_tested: X
  runtime_errors: [{type, severity, detail}]
  integration_issues: [{chain, detail}]
  capability_issues: []
  checks: [{group, check, status, detail}]
  runtime_health: X/100
  verdict: STABLE|WARNING|UNSTABLE
  suggested_actions: [...]
```

## Capability Benchmark (chi tiết)

`capability-benchmark.ps1` — chấm điểm từng agent theo domain:

- Domain pool: Blazor/.NET, Planning/Design, Testing, Git/DevOps, Security, UI/UX, Docs/Knowledge, Orchestration, Scripting, Database.
- Scoring: base 40 + 15/hit keyword (giống doctor, nhưng đọc thêm contract + knowledge để chính xác hơn).
- **Task-type simulation**: với mỗi domain, mô phỏng 1 task (vd "Fix Blazor bug") → PASS nếu agent có capability >= 60.
- Aggregate: per-domain score 0-100 + per-agent top domains.
- `capability_score = avg(domain_scores)`.

**Report JSON:**
```yaml
benchmark:
  agents_benchmarked: X
  domains: [{domain, score, agents}]
  agent_capabilities: [{agent, top_domains, overall}]
  capability_score: X/100
  task_simulations: [{domain, task, status, score}]
  verdict: STRONG (>=80) | MODERATE (60-79) | WEAK (<60)
```

## Security Concerns

| Concern | Severity | Mitigation |
|---------|----------|------------|
| Script đọc file hệ thống — không ghi | LOW | Chỉ `Get-Content`/`Test-Path`; không `Set-Content`/`Remove-Item` |
| Path injection qua param | LOW | Dùng `Test-Path -LiteralPath`, không nối path dạng string thô |
| Thực thi PowerShell từ user input | NONE | Không có `Invoke-Expression`; chỉ đọc + parse |
| Backup trước sửa | N/A | Không sửa file hệ thống trong sandbox |

## Edge Cases

| Case | Handling |
|------|----------|
| Thư mục agents/skills/commands rỗng | Count=0 → log WARNING, không crash |
| YAML frontmatter không parse được | Đếm là `BAD_FRONTMATTER` issue, tiếp tục |
| File được tham chiếu (location/require) không tồn tại | `SKILL_MISSING_FILE` MAJOR |
| Skill không có `schema_version` | WARNING (không block) |
| Contract thiếu cho agent non-core (cleaner, pusher...) | Bỏ qua agent đã biết không cần contract |
| Duplicate skill names | `SKILL_CONFLICT` MAJOR |
| `--simulate` + `--stress-test` cùng lúc | Stress test chạy trước (exit sớm), simulation chỉ chạy nếu không có stress |
| Unicode path (OneDrive Desktop) | `-LiteralPath` mọi nơi |
| PowerShell 5.1 — splatting & method syntax | Tránh `?.`, `??`, ternary; dùng `if/else`; tránh `[version]` parse lỗi |

## Issues

**Blocking issues:**
- Không có.

**Non-blocking issues:**
- `health-score.ps1` thay đổi weights → score tổng có thể đổi so với trước (chấp nhận, vì thêm khả năng mới).
- Stress test vẫn inline trong sync-system-docs.ps1 (refactor để sau).

**Open questions:**
- User có muốn `sandbox` mặc định chạy kèm `--evolve` không? → Mặc định: CÓ (evolve = full pipeline 7+2 engines).

## Effort

**LARGE** — 7 components, 2 engines mới (mỗi engine ~250-350 dòng PS), 3 file sửa + 1 docs + 1 regenerate. Chia 4 chunks:
- Chunk 1 (config): workflow dir, thư mục reports
- Chunk 2 (logic): 2 engines mới
- Chunk 3 (integration): orchestrator + health-score + evolution-report
- Chunk 4 (test + docs): docs + run validation + fix lỗi
