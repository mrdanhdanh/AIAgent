---
description: 'Doctor (alias /team-doctor) — kiểm tra sức khỏe hệ thống AI Agent Framework. Tương đương /doctor: Environment, System, Runtime, Capability, health score, self-repair an toàn.'
agent: general
---

## HELP — Hướng dẫn sử dụng `/team-doctor`

`/team-doctor` là **alias** của `/doctor`. Cú pháp, modes và output hoàn toàn tương đương.

**Cách dùng:**

```bash
/team-doctor            # quick scan (mặc định)
/team-doctor --full     # full scan
/team-doctor --runtime  # runtime simulation
/team-doctor --benchmark
/team-doctor --repair --dry-run
/team-doctor --repair --force
/team-doctor --compatibility   # reuse evolution: compatibility checker
/team-doctor --semanticdiff    # reuse evolution: semantic diff
/team-doctor --migration       # reuse evolution: migration system
/team-doctor --knowledgemigrate
/team-doctor --stress          # stress test (20 fake tasks)
/team-doctor --health          # reuse evolution: health-score
/team-doctor --evolve --markdown   # toàn bộ pipeline + DOCTOR_REPORT.md
```

**Xem chi tiết:** `.opencode/commands/doctor.md`

**Script:** `.opencode/scripts/doctor.ps1` (v2.0.0)

## Flags

**Flags:**

| Flag | Mô tả |
|------|-------|
| `--full` | Scan toàn bộ pipeline (tất cả checks) |
| `--runtime` | Giả lập fake task qua workflow |
| `--repair` | Scan + tự sửa lỗi an toàn |
| `--force` | Mở rộng phạm vi sửa (SYSTEM_MAP sync) |
| `--dry-run` | Xem trước, không sửa |
| `--benchmark` | Benchmark năng lực agent theo domain |

## Output Contract

```yaml
output:
  health_score: { overall: 0 }
  pillars: [...]
  suggestions: { high: [], medium: [], low: [] }
  issues: []
```

