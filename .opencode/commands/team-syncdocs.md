---
description: 'System Evolution Engine — đồng bộ system docs + semantic diff + compatibility check + migration + self-healing + health score + evolution report. Chạy định kỳ để duy trì sức khỏe hệ thống.'
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
- **Health Score** chấm điểm sức khỏe hệ thống
- **Evolution Report** báo cáo tiến hóa hệ thống

**Khi nào chạy:**
- Sau khi thêm agent/command/skill mới
- Sau khi update schema/contract
- Trước khi giới thiệu người mới vào dự án
- Định kỳ (khuyến nghị mỗi tuần) để duy trì sức khỏe hệ thống
- Khi nghi ngờ có compatibility issue giữa các agents

**Cách dùng:** `/team-syncdocs [--flags] [--evolution-mode <mode>]`

**Flags:**
| Flag | Mô tả |
|------|-------|
| `--dry-run` | Chỉ xem trước, không ghi file |
| `--force` | Ghi đè không cần xác nhận + cho phép auto-fix |
| `--evolve` | Chạy đầy đủ System Evolution Engine (7 engines) |
| `--semantic-diff` | Chỉ chạy Semantic Diff Engine |
| `--compatibility` | Chỉ chạy Compatibility Checker |
| `--migration` | Chỉ chạy Migration System |
| `--self-heal` | Chỉ chạy Self Healing Engine |
| `--knowledge-migrate` | Chỉ chạy Knowledge Migration |
| `--health-score` | Chỉ chạy Health Score |
| `--report` | Chỉ chạy Evolution Report |

**Modes:**
| Mode | Mô tả | Engines chạy |
|------|-------|-------------|
| `full` (default) | Toàn bộ pipeline | 1→2→3→4→5→6→7 |
| `scan` | Chỉ scan, không heal | 1, 2, 3, 5 |
| `heal` | Scan + self-heal + migration | 1, 2, 3, 4, 5 |
| `quick` | Scan nhanh + health | 1, 2, 6 |
| `report` | Chỉ tạo report từ cache | 7 |

**Đầu ra:**
- `SYSTEM_MAP.md` — Sơ đồ tổng thể hệ thống
- `SYSTEM_EVOLUTION_REPORT.md` — Báo cáo tiến hóa chi tiết
- Cập nhật cross-reference trong `team.md` và `SKILL.md`
- Báo cáo phát hiện vấn đề, health score

---

## KIẾN TRÚC HỆ THỐNG

```
.opencode/
├── system/
│   └── contracts/           # Contract Registry (YAML)
│       ├── planner.yaml
│       ├── builder.yaml
│       ├── reviewer.yaml
│       ├── tester.yaml
│       └── workflow.yaml
├── scripts/
│   ├── sync-system-docs.ps1  # Orchestrator (nâng cấp)
│   ├── evolution/            # System Evolution Engines
│   │   ├── semantic-diff.ps1         # Nâng cấp #1
│   │   ├── compatibility-checker.ps1 # Nâng cấp #2
│   │   ├── migration-system.ps1      # Nâng cấp #3
│   │   ├── self-healing.ps1          # Nâng cấp #4
│   │   ├── knowledge-migration.ps1   # Nâng cấp #6
│   │   ├── health-score.ps1          # Nâng cấp #8
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
- Output: weighted score 0-100

### Bước 8: Evolution Report
Chạy `evolution-report.ps1`:
- Tổng hợp tất cả kết quả từ bước 2-7
- Tạo `SYSTEM_EVOLUTION_REPORT.md`
- Hiển thị detected changes, auto-fixed, pending, learning, suggestions, health
- Output: Evolution Report Markdown

---

## OUTPUT CONTRACT

```yaml
status: SUCCESS | PARTIAL | FAILED
summary: "System Evolution: X changes, Y compatibility issues, Z auto-fixed, score: W/100"
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
  report: ".opencode/SYSTEM_EVOLUTION_REPORT.md"
issues:
  - type: ORPHAN_AGENT | MISSING_AGENT | COMPATIBILITY_ISSUE | MIGRATION_REQUIRED
    severity: WARNING | ERROR | CRITICAL
    detail: "Mô tả vấn đề"
```

---

## SCRIPT

```powershell
# Quick sync (legacy mode — chỉ sync docs)
& ".opencode\scripts\sync-system-docs.ps1"

# Full System Evolution (sync + all engines)
& ".opencode\scripts\sync-system-docs.ps1" -evolve

# Scan only (no heal)
& ".opencode\scripts\sync-system-docs.ps1" -evolutionMode scan

# Scan + heal
& ".opencode\scripts\sync-system-docs.ps1" -evolutionMode heal -force

# Health score only
& ".opencode\scripts\sync-system-docs.ps1" -healthScore

# Dry run
& ".opencode\scripts\sync-system-docs.ps1" -dryRun -evolve
```

---

## HỆ THỐNG 8 NÂNG CẤP

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
5 contract files:
- `planner.yaml` — Design + Plan phases
- `builder.yaml` — Execution phase
- `reviewer.yaml` — Evaluation phase
- `tester.yaml` — Verification phase
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
Chấm điểm 8 categories:
| Category | Weight | Mô tả |
|----------|--------|-------|
| Workflow | 15% | Workflow contract integrity |
| Skills | 15% | Skills freshness, schema version |
| Knowledge | 10% | Knowledge completeness |
| Compatibility | 15% | Cross-agent compatibility |
| Agents | 15% | Agent health, contract coverage |
| Scripts | 10% | Script quality, documentation |
| Tests | 10% | Test coverage |
| Learning | 10% | Lessons, patterns documentation |

**Overall** = weighted average (0-100)

---

## QUY TẮC

- Backward compatible: `--evolve` flag mới, không phá vỡ sync cũ
- `--dry-run`: chỉ scan, không ghi file, không fix
- `--force`: cho phép auto-fix (self-healing)
- Self-healing luôn backup trước khi fix vào `.opencode/backup/self-heal/`
- Health score < 50 → warning trong report
- Migration tasks CRITICAL → cần user can thiệp
- Contract Registry là single source of truth cho tất cả engines
