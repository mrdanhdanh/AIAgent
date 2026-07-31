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
```

**Xem chi tiết:** `.opencode/commands/doctor.md`

**Script:** `.opencode/scripts/doctor.ps1`
