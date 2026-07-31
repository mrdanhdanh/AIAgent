---
description: 'Doctor — kiểm tra sức khỏe hệ thống AI Agent Framework: Environment, Agents, Commands, Skills, Knowledge, Workflow, Contracts, Runtime (simulation), Capability (benchmark). Tích hợp health score, self-repair an toàn. Dùng /doctor hoặc /team-doctor.'
agent: general
---

## HELP — Hướng dẫn sử dụng `/doctor`

**Mục đích:** Kiểm tra sức khỏe toàn bộ hệ sinh thái AI Agent Framework (`.opencode/`) — không
chỉ môi trường như `claude doctor`, mà cả Agents, Commands, Skills, Knowledge, Workflow,
Contracts, Runtime (giả lập vận hành) và Capability (benchmark).

**Cách dùng:**

```bash
/doctor                 # mặc định: quick scan
/doctor --quick         # scan nhanh: Environment + Agents + Commands
/doctor --full          # toàn bộ pipeline (tất cả checks)
/doctor --runtime       # giả lập fake task qua workflow
/doctor --workflow      # workflow + knowledge + contracts
/doctor --agent         # chỉ kiểm tra agents
/doctor --skill         # chỉ kiểm tra skills
/doctor --command       # chỉ kiểm tra commands
/doctor --knowledge     # chỉ kiểm tra knowledge base
/doctor --contracts     # chỉ kiểm tra contract registry
/doctor --simulation    # giả lập 6 scenario types
/doctor --benchmark     # benchmark năng lực agent theo domain
/doctor --repair        # scan + tự sửa lỗi an toàn
/doctor --repair --dry-run   # xem trước, không sửa
/doctor --repair --force     # mở rộng phạm vi sửa (cross-references)
/doctor --full --json   # full scan + lưu báo cáo JSON
```

**Alias:** `/team-doctor` tương đương `/doctor`.

**Khi nào chạy:**
- Định kỳ (khuyến nghị mỗi tuần) — duy trì sức khỏe hệ thống
- Sau khi thêm/sửa agent, command, skill, script
- Trước khi chạy `/team` với yêu cầu lớn
- Khi nghi ngờ có lỗi cross-reference, contract mismatch, missing file
- Trước khi `/team-gitpush`

---

## KIẾN TRÚC

```
                Doctor
                   |
    ----------------------------------------
    |             |            |            |
 Environment   System       Runtime      Capability
    |             |            |            |
    ----------------------------------------
                   |
                Report
                   |
                Fix Plan
```

```
.opencode/
├── commands/
│   ├── doctor.md            # Command definition (file này)
│   └── team-doctor.md       # Alias
├── scripts/
│   ├── doctor.ps1           # Orchestrator (entry point)
│   └── doctor/              # Module checks
│       ├── environment.ps1  # Environment pillar
│       ├── agents.ps1       # Agent check
│       ├── commands.ps1     # Command check
│       ├── skills.ps1       # Skill check
│       ├── workflows.ps1    # Workflow + Knowledge + Contracts
│       ├── runtime.ps1      # Runtime check (fake task)
│       ├── simulation.ps1   # 6 scenario simulation
│       ├── benchmark.ps1    # Capability benchmark
│       ├── repair.ps1       # Self repair (safe only)
│       ├── report.ps1       # Health score + report
│       └── reports/         # JSON report output
```

---

## CÁC CHECK

### Environment Check
```
✓ OpenCode version
✓ Agent folders
✓ Command folders
✓ Skill folders
✓ Scripts
✓ PowerShell
✓ Python
✓ Git
✓ Model configuration
✓ API configuration
✓ Permissions
✓ Knowledge folders
✓ Contract registry
```

### Agent Check
```
✓ YAML syntax (frontmatter)
✓ Description
✓ Contract (output schema)
✓ Permissions
✓ Dependencies (orphan refs)
✓ Prompt size
✓ Deprecated fields
✓ Missing fields
✓ Circular dependency
```

### Command Check
```
✓ Syntax (frontmatter)
✓ Agent mapping (frontmatter + opencode.json)
✓ Flags documented
✓ Workflow integration
✓ Output contract
✓ Registration trong opencode.json
```

### Skill Check
```
✓ SKILL.md tồn tại
✓ Schema version
✓ Description
✓ Dependencies (broken file refs)
✓ Compatibility (missing commands)
✓ Deprecated contents
```

### Knowledge Check
```
✓ Knowledge base coverage
✓ Missing topics
✓ Deprecated frameworks
✓ Learning maturity (lessons, patterns, failures)
✓ Pending learning items
```

### Workflow Check
```
✓ Contract steps (13 steps)
✓ Transitions
✓ Missing step
✓ Dependency (command/agent tồn tại)
✓ Contract mismatch
✓ Version mismatch
✓ Retry loop
```

### Runtime Check (`--runtime`)
Giả lập 1 fake task chạy qua 13 bước workflow:
```
Fake Task
    ↓
planner → builder → tester → reviewer → ... → complete
```
Kiểm tra: runtime errors, output schema (contracts parse), workflow consistency, missing skill.

### Simulation Check (`--simulation`)
Giả lập 6 scenario types:
- Bug Fix
- New Feature
- Migration
- Review
- Testing
- Refactoring

Output: success rate + failures + common issues.

### Capability Check (`--benchmark`)
Chấm điểm năng lực agent theo domain (heuristic):
```
Builder
Blazor ........95
Oracle .........90
Angular ........70
Testing .......80
```

### Self Repair (`--repair`)
Chỉ sửa các lỗi **an toàn**:

```
Safe Repairs
✓ Folder structure (tạo thư mục chuẩn còn thiếu)
✓ Cross references (SYSTEM_MAP sync — cần --force)
✓ Broken references (báo cáo, không sửa content)
✓ Contract mappings (báo cáo)
```

**Không sửa** (luôn ghi vào manual review):
```
X Agent prompts
X Skills
X Workflows
X Knowledge
```

`--force` mở rộng phạm vi sang cross-reference inconsistencies có fix xác định
(SYSTEM_MAP sync). Mọi fix đều backup trước.

---

## HEALTH SCORE

```
System Health

Environment ....100
Agents ..........95
Commands ........98
Skills ..........90
Knowledge ........85
Workflow .........98
Contracts ........95
Runtime ..........92
Simulation .......90
Benchmark ........85

---------------------------------

OVERALL

92 / 100
```

## SUGGESTED ACTIONS

```
Doctor Suggestions

HIGH PRIORITY
- Builder missing contract.
- FluentUI skill outdated.

---------------------------------

MEDIUM PRIORITY
- Missing Angular knowledge.

---------------------------------

LOW PRIORITY
- SYSTEM_MAP not updated.
```

---

## DOCTOR vs SYNCDOCS

| Command          | Mục đích                                                                                |
| ---------------- | --------------------------------------------------------------------------------------- |
| `/team-syncdocs` | Tiến hóa và đồng bộ hệ thống (semantic diff, migration, learning, health score).        |
| `/doctor`        | Kiểm tra sức khỏe hệ thống hiện tại, giả lập vận hành, benchmark và tự sửa lỗi an toàn. |

Nói cách khác, `/team-syncdocs` trả lời câu hỏi "hệ thống nên được nâng cấp như thế nào?",
còn `/doctor` trả lời câu hỏi "hệ thống hiện tại có đang hoạt động tốt hay không?".
Hai command bổ sung cho nhau.

---

## OUTPUT CONTRACT

```yaml
doctor:
  version: "1.0.0"
  mode: quick|full|runtime|workflow|agent|skill|command|knowledge|contracts|simulation|benchmark|repair
  timestamp: "..."
  pillars:
    environment:
      group: Environment
      score: 0-100
      status: PASS|WARNING|ERROR
      checks: []
      issues: []
    system: []      # Agents, Commands, Skills, Workflow, Knowledge, Contracts
    runtime: {}
    simulation: {}
    capability: {}
  health_score:
    overall: 0-100
    categories:
      - category: Environment
        score: 0-100
        status: PASS|WARNING|ERROR
  suggestions:
    high: []
    medium: []
    low: []
  issues: []
  repair: {}        # chỉ khi --repair
```

---

## SCRIPT

```powershell
# Quick scan (default)
& ".opencode\scripts\doctor.ps1" -Mode quick

# Full scan + JSON report
& ".opencode\scripts\doctor.ps1" -Mode full -Json

# Repair dry-run (xem trước)
& ".opencode\scripts\doctor.ps1" -Mode repair -DryRun

# Repair thực thi (safe fixes + SYSTEM_MAP sync)
& ".opencode\scripts\doctor.ps1" -Mode repair -Force
```

---

## QUY TẮC

- Mọi check **fail-safe**: thiếu tool → WARNING, không bao giờ crash toàn bộ
- `--repair` luôn backup trước khi sửa (backup-utility.ps1)
- Agent prompts, skills, workflows, knowledge content **không bao giờ** bị auto-sửa
- Health score < 50 → cảnh báo HIGH trong suggestions
- Doctor **không tự cập nhật** SYSTEM_MAP khi chạy thường — gợi ý chạy `/team-syncdocs`
- Kết quả JSON lưu tại `.opencode/scripts/doctor/reports/`
