---
description: 'System Evolution Engine — đồng bộ system docs + semantic diff + compatibility check + migration + self-healing + health score + simulation (runtime validation) + capability benchmark + stress test + evolution report. Chạy định kỳ để duy trì sức khỏe hệ thống.'
agent: general
---

## HELP — Hướng dẫn sử dụng `/team-syncdocs`

**Mục đích:** **System Evolution Engine** — Không chỉ đồng bộ tài liệu, mà còn:
- **Semantic Diff** giữa các phiên bản Agent/Workflow/Schema
- **Compatibility Check** giữa toàn bộ hệ thống
- **Migration Plan** khi có breaking changes
- **Self-Healing** các lỗi tương thích đơn giản
- **Contract Registry** quản lý agents và workflows
- **Knowledge Migration** phát hiện knowledge lỗi thời
- **Simulation Engine (Sandbox)** — runtime validation: "nếu chạy thật thì có hoạt động không?"
- **Capability Benchmark** — đánh giá năng lực từng Agent theo domain
- **Stress Test** — 20 fake tasks qua 13-step workflow, đo độ ổn định
- **Health Score** chấm điểm sức khỏe hệ thống (System + Runtime + Capability)
- **Evolution Report** báo cáo tiến hóa hệ thống

**Khi nào chạy:**
- Sau khi thêm agent/command/skill mới
- Sau khi update schema/contract
- Trước khi giới thiệu người mới vào dự án
- Định kỳ (khuyến nghị mỗi tuần) để duy trì sức khỏe hệ thống
- Khi nghi ngờ có compatibility issue giữa các agents
- **Khi nghi ngờ agent/skill/command không chạy được ở runtime** → `--simulate`

**Cách dùng:** `/team-syncdocs [--flags] [--evolution-mode <mode>]`

**Flags:**
| Flag | Mô tả |
|------|-------|
| `--dry-run` | Chỉ xem trước, không ghi file |
| `--force` | Ghi đè không cần xác nhận + cho phép auto-fix |
| `--evolve` | Chạy đầy đủ System Evolution Engine (9 engines) |
| `--semantic-diff` | Chỉ chạy Semantic Diff Engine |
| `--compatibility` | Chỉ chạy Compatibility Checker |
| `--migration` | Chỉ chạy Migration System |
| `--self-heal` | Chỉ chạy Self Healing Engine |
| `--knowledge-migrate` | Chỉ chạy Knowledge Migration |
| `--simulate` | Chạy **Simulation Engine** (Sandbox mode) — runtime validation |
| `--benchmark` | Chạy **Capability Benchmark Engine** |
| `--stress-test` | Chạy **Stress Test** (20 fake tasks qua 13-step workflow) |
| `--health-score` | Chỉ chạy Health Score |
| `--report` | Chỉ chạy Evolution Report |

**Modes:**
| Mode | Mô tả | Engines chạy |
|------|-------|-------------|
| `full` (default) | Toàn bộ pipeline | 1→2→3→4→5→6→7→8→9 |
| `scan` | Chỉ scan, không heal | 1, 2, 3, 5 |
| `heal` | Scan + self-heal + migration | 1, 2, 3, 4, 5 |
| `sandbox` | Runtime validation + benchmark | 6, 7 (simulation + benchmark) |
| `quick` | Scan nhanh + health | 1, 2, 8 |
| `report` | Chỉ tạo report từ cache | 9 |

**Đầu ra:**
- `SYSTEM_MAP.md` — Sơ đồ tổng thể hệ thống
- `SYSTEM_EVOLUTION_REPORT.md` — Báo cáo tiến hóa chi tiết (gồm Runtime Health + Capability)
- Cập nhật cross-reference trong `team.md` và `SKILL.md`
- Báo cáo phát hiện vấn đề, health score
- `reports/simulation-engine-<ts>.json` — Runtime validation report
- `reports/capability-benchmark-<ts>.json` — Capability report
- `reports/stress-test-<ts>.json` — Stress test report

---

## KIẾN TRÚC HỆ THỐNG

```
.opencode/
├── system/
│   └── contracts/           # Contract Registry (YAML) — 13 contracts
│       ├── analyst.yaml
│       ├── planner.yaml
│       ├── reviewer.yaml
│       ├── builder.yaml
│       ├── tester.yaml
│       ├── test-planner.yaml
│       ├── ui-beautifier.yaml
│       ├── guardian.yaml
│       ├── failure-agent.yaml
│       ├── root-cause-agent.yaml
│       ├── learning-agent.yaml
│       ├── self-improver.yaml
│       └── workflow.yaml
├── scripts/
│   ├── sync-system-docs.ps1  # Orchestrator (nâng cấp)
│   ├── evolution/            # System Evolution Engines
│   │   ├── semantic-diff.ps1         # Nâng cấp #1
│   │   ├── compatibility-checker.ps1 # Nâng cấp #2
│   │   ├── migration-system.ps1      # Nâng cấp #3
│   │   ├── self-healing.ps1          # Nâng cấp #4
│   │   ├── knowledge-migration.ps1   # Nâng cấp #6
│   │   ├── simulation-engine.ps1     # Nâng cấp #9 (Runtime Validation)
│   │   ├── capability-benchmark.ps1  # Nâng cấp #10 (Capability Benchmark)
│   │   ├── health-score.ps1          # Nâng cấp #8 (System + Runtime + Capability)
│   │   └── evolution-report.ps1      # Nâng cấp #7
│   └── reports/              # Evolution reports output
├── SYSTEM_MAP.md             # System map (sync output)
├── SYSTEM_EVOLUTION_REPORT.md # Evolution report (evolution output)
└── commands/
    └── team-syncdocs.md      # Command definition (file này)
```

---

## QUY TRÌNH CHI TIẾT

### Bước 1: Scan (legacy sync)
Giữ nguyên quy trình sync cũ: scan agents, commands, skills, scripts, knowledge → cross-reference → generate SYSTEM_MAP.md.

### Bước 2: Semantic Diff Engine
Chạy `semantic-diff.ps1` cho từng agent contract:
- So sánh schema version hiện tại với contract registry
- Phát hiện schema_change, contract_change, workflow_change
- Phát hiện breaking_change (downgrade, removed fields)
- Output: báo cáo JSON chi tiết từng thay đổi

### Bước 3: Compatibility Checker
Chạy `compatibility-checker.ps1`:
- Kiểm tra dependency cycles giữa contracts
- Agent → Contract mapping (agent nào thiếu contract)
- Schema version compatibility (output v1 vs input v2)
- Workflow step consistency
- Output: compatibility score + issues list

### Bước 4: Migration System
Chạy `migration-system.ps1`:
- Parse migration_rules từ từng contract
- Sinh migration tasks cho downstream agents
- Xác định affected agents
- Output: migration plan + tasks

### Bước 5: Self Healing
Chạy `self-healing.ps1`:
- Scan field name typos (dùng Levenshtein distance)
- Scan broken agent references
- Auto-fix nếu confidence >= 95% và --force được set
- Backup trước khi fix
- Output: auto-fixed + pending items

### Bước 6: Knowledge Migration
Chạy `knowledge-migration.ps1`:
- Scan deprecated frameworks (MudBlazor → FluentUI)
- Scan deprecated .NET versions
- Phát hiện missing knowledge topics
- Output: deprecated + missing knowledge

### Bước 7: Health Score
Chạy `health-score.ps1`:
- Workflow integrity (dựa trên workflow contract)
- Skills freshness (schema version, deprecated content)
- Knowledge completeness (từ knowledge migration)
- Compatibility score (từ compatibility checker)
- Agents health (contract coverage, structure)
- Scripts quality (documentation, parameters)
- Tests coverage (số lượng test files)
- Learning maturity (lessons, skills-learned)
- **Runtime Health** (từ Simulation Engine — runtime validation)
- **Capability Score** (từ Capability Benchmark)
- Output: weighted score 0-100 (10 categories)

### Bước 8: Evolution Report
Chạy `evolution-report.ps1`:
- Tổng hợp tất cả kết quả từ bước 2-7
- Tạo `SYSTEM_EVOLUTION_REPORT.md`
- Hiển thị detected changes, auto-fixed, pending, learning, suggestions, health
- **Hiển thị Runtime Simulation (runtime health + suggested actions)**
- **Hiển thị Capability Benchmark (domain scores + task simulations)**
- Output: Evolution Report Markdown

---

## SIMULATION ENGINE (Sandbox Mode)

### Nâng cấp #9: Simulation Engine (`simulation-engine.ps1`)
Runtime validation — trả lời câu hỏi **"nếu chạy thật thì có hoạt động không?"**:
Static analysis chỉ kiểm tra file/contract đúng, nhưng các lỗi sau chỉ xuất hiện khi runtime:
- Agent không load được skill
- Skill tham chiếu file không tồn tại
- Workflow bị loop / output format sai
- Prompt bị conflict / command không truyền được parameter

**6 nhóm validation:**
| Group | Kiểm tra | Lỗi phát hiện |
|-------|----------|---------------|
| Agent Validation | Frontmatter, mode/model, permissions, depends_on, contract, skill requirements | `AGENT_BAD_FRONTMATTER`, `MISSING_DEPENDENCY`, `AGENT_PERMISSION_INVALID` |
| Skill Validation | SKILL.md frontmatter, file tham chiếu tồn tại, deprecated, conflict | `SKILL_REF_NOT_FOUND`, `SKILL_DEPRECATED`, `SKILL_CONFLICT` |
| Command Validation | Frontmatter, agent/trigger/opencode.json routing | `COMMAND_NO_AGENT`, `COMMAND_AGENT_NOT_FOUND`, `COMMAND_TRIGGER_ROUTING` |
| Contract Validation | Contract tồn tại, schema version compat | `MISSING_CONTRACT`, `VERSION_MISMATCH` |
| Integration Test | Chain planner→reviewer→builder→tester | `INTEGRATION_BREAK` |
| Output Validation | Fake task injection, expected artifact vs contract output | `OUTPUT_MISMATCH` |

**Runtime Health:** `passed_checks / total_checks * 100` → verdict STABLE (>=90) | WARNING (70-89) | UNSTABLE (<70)

**Learning:** Từ các failures → `suggested_actions` (create skill, update contract, fix reference, ...)

## CAPABILITY BENCHMARK

### Nâng cấp #10: Capability Benchmark (`capability-benchmark.ps1`)
Đánh giá năng lực từng Agent theo 10 domain:
- Blazor/.NET, Planning, Testing, Git, Security, UI/UX, Docs, Orchestration, Scripting, Database
- Scoring: base 40 + 15/keyword hit, cộng bonus từ contract presence + knowledge coverage
- **Task simulation:** mỗi domain mô phỏng 1 task (vd "Fix Blazor bug") → PASS nếu có agent >= 60
- Output: `capability_score` 0-100 + verdict STRONG (>=80) | MODERATE (60-79) | WEAK (<60)

## STRESS TEST

### Nâng cấp #11: Stress Test (inline trong sync-system-docs.ps1)
- Sinh 20 fake tasks (deterministic theo seed) qua 13-step state machine
- Mỗi bước có xác suất thành công mô phỏng thực tế
- Stats: success rate, health score, verdict (STABLE/WARNING/UNSTABLE), weakest steps, common errors
- Usage: `--stress-test -stressCount 20 -stressSeed <seed>`

---

## OUTPUT CONTRACT

```yaml
status: SUCCESS | PARTIAL | FAILED
summary: "System Evolution: X changes, Y compatibility issues, Z auto-fixed, runtime health R/100, capability C/100, score: W/100"
sync:
  files_updated:
    - ".opencode/SYSTEM_MAP.md"
    - ".opencode/commands/team.md"
    - ".opencode/skills/dev-team/SKILL.md"
  stats:
    agents: X
    commands: X
    skills: X
    scripts: X
    knowledge: X
evolution:
  semantic_diff:
    changes: X
    breaking: X
  compatibility:
    score: X/100
    issues: X
  migration:
    tasks: X
    affected_agents: [agent1, agent2]
  self_healing:
    auto_fixed: X
    pending: X
  knowledge:
    deprecated: X
    missing: X
  simulation:
    runtime_health: X/100
    verdict: STABLE | WARNING | UNSTABLE
    runtime_errors: X
    integration_issues: X
    suggested_actions: [action1, action2]
  benchmark:
    capability_score: X/100
    verdict: STRONG | MODERATE | WEAK
    task_success_rate: X%
  stress_test:
    total_tasks: X
    success_rate: X%
    verdict: STABLE | WARNING | UNSTABLE
  health_score:
    overall: X/100
    categories:
      Workflow: X
      Skills: X
      Knowledge: X
      Compatibility: X
      Agents: X
      Scripts: X
      Tests: X
      Learning: X
      Runtime: X
      Capability: X
  report: ".opencode/SYSTEM_EVOLUTION_REPORT.md"
issues:
  - type: ORPHAN_AGENT | MISSING_AGENT | COMPATIBILITY_ISSUE | MIGRATION_REQUIRED | RUNTIME_ERROR
    severity: WARNING | ERROR | CRITICAL
    detail: "Mô tả vấn đề"
```

---

## SCRIPT

```powershell
# Quick sync (legacy mode — chỉ sync docs)
& ".opencode\scripts\sync-system-docs.ps1"

# Full System Evolution (sync + all 9 engines)
& ".opencode\scripts\sync-system-docs.ps1" -evolve

# Scan only (no heal)
& ".opencode\scripts\sync-system-docs.ps1" -evolutionMode scan

# Scan + heal
& ".opencode\scripts\sync-system-docs.ps1" -evolutionMode heal -force

# Sandbox mode — runtime validation + capability benchmark
& ".opencode\scripts\sync-system-docs.ps1" -evolutionMode sandbox

# Simulation Engine only (runtime validation)
& ".opencode\scripts\sync-system-docs.ps1" -simulate

# Capability Benchmark only
& ".opencode\scripts\sync-system-docs.ps1" -benchmark

# Stress Test (20 fake tasks, deterministic)
& ".opencode\scripts\sync-system-docs.ps1" -stressTest -stressCount 20

# Health score only
& ".opencode\scripts\sync-system-docs.ps1" -healthScore

# Dry run
& ".opencode\scripts\sync-system-docs.ps1" -dryRun -evolve
```

---

## HỆ THỐNG 11 NÂNG CẤP

### Nâng cấp #1: Semantic Diff Engine (`semantic-diff.ps1`)
So sánh semantic giữa các phiên bản contract — phát hiện:
- `schema_change`: Field thêm/xóa/thay đổi
- `contract_change`: Contract version thay đổi
- `workflow_change`: Workflow step thay đổi
- `dependency_change`: Dependency thay đổi
- `breaking_change`: Breaking changes (downgrade, removed fields)

### Nâng cấp #2: Compatibility Checker (`compatibility-checker.ps1`)
Kiểm tra:
- Dependency cycles (CRITICAL)
- Agent → Contract mapping (agent nào thiếu contract)
- Schema version compatibility (output v1 vs input v2)
- Workflow step consistency

### Nâng cấp #3: Migration System (`migration-system.ps1`)
Sinh migration plan khi có breaking changes:
- Phân tích migration_rules trong từng contract
- Xác định downstream agents bị ảnh hưởng
- Sinh tasks: ADD_FIELD_SUPPORT, REMOVE_FIELD_SUPPORT, DOWNSTREAM_MIGRATION

### Nâng cấp #4: Self Healing (`self-healing.ps1`)
Phát hiện và tự vá:
- Field name typos (dùng Levenshtein distance, threshold 95%)
- Broken agent references (command→agent không tồn tại)
- Tự động backup trước khi fix
- Pending items nếu confidence < 95%

### Nâng cấp #5: Contract Registry (`system/contracts/`)
13 contract files — mỗi agent core có 1 contract, cộng workflow:
- `analyst.yaml` — Analyze phase
- `planner.yaml` — Design + Plan phases
- `reviewer.yaml` — Evaluation phase
- `builder.yaml` — Execution phase
- `tester.yaml` — Verification phase
- `test-planner.yaml` — Test planning phase
- `ui-beautifier.yaml` — UI audit phase
- `guardian.yaml` — Pre-push guardrail
- `failure-agent.yaml` — Failure analysis
- `root-cause-agent.yaml` — Root cause analysis
- `learning-agent.yaml` — Learning pipeline
- `self-improver.yaml` — Skill validation
- `workflow.yaml` — Workflow state machine

Mỗi contract gồm:
- `input/output`: Schema định nghĩa fields
- `supported_versions`: Các version hỗ trợ
- `dependencies`: Agent dependencies
- `migration_rules`: Rules cho migration giữa versions

### Nâng cấp #6: Knowledge Migration (`knowledge-migration.ps1`)
Phát hiện:
- Deprecated frameworks (MudBlazor → FluentUI)
- Deprecated .NET versions (5-9 → 10)
- Missing knowledge topics (dựa trên agents scan)
- Score: 0-100 dựa trên deprecated + missing

### Nâng cấp #7: Evolution Report (`evolution-report.ps1`)
Tạo báo cáo Markdown gồm:
- **Detected:** Workflow/schema changes, compatibility issues, migration tasks
- **Auto-fixed:** Những gì đã tự sửa
- **Pending:** Những gì cần user can thiệp
- **Learning:** Patterns phát hiện, rules mới
- **Suggestions:** Gợi ý cải thiện
- **Health Score:** Điểm sức khỏe tổng thể

### Nâng cấp #8: System Health Score (`health-score.ps1`)
Chấm điểm 10 categories (System Health + Runtime Health + Capability Score):
| Category | Weight | Mô tả |
|----------|--------|-------|
| Workflow | 13% | Workflow contract integrity |
| Skills | 13% | Skills freshness, schema version |
| Knowledge | 9% | Knowledge completeness |
| Compatibility | 13% | Cross-agent compatibility |
| Agents | 13% | Agent health, contract coverage |
| Scripts | 9% | Script quality, documentation |
| Tests | 9% | Test coverage |
| Learning | 9% | Lessons, patterns documentation |
| **Runtime** | **6%** | Runtime health từ Simulation Engine |
| **Capability** | **6%** | Capability score từ Benchmark Engine |

**Overall** = weighted average (0-100). Runtime/Capability fallback 50 nếu chưa chạy simulation/benchmark.

---

## QUY TẮC

- Backward compatible: `--simulate`/`--benchmark` flags mới, không phá vỡ sync cũ
- `--dry-run`: chỉ scan, không ghi file, không fix
- `--force`: cho phép auto-fix (self-healing)
- Self-healing luôn backup trước khi fix vào `.opencode/backup/self-heal/`
- Health score < 50 → warning trong report
- Migration tasks CRITICAL → cần user can thiệp
- Contract Registry là single source of truth cho tất cả engines
- **Simulation Engine là read-only** — không sửa file hệ thống
- **Runtime Health < 70** → warning trong report (hệ thống cấu hình đúng nhưng runtime có vấn đề)
