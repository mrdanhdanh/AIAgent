---
lesson_id: LSN-BLZ-003
failure_id: BUG-0001
error_hash: "no_backup"
error_type: "NoBackupBeforeEdit"
rule: "Backup via backup-agent TRƯỚC khi edit bất kỳ file .opencode/ nào (agents, commands, skills). Phase 1 có backup, Phase 2-3 không — inconsistency."
applies_to: ["backup-agent", "orchestrator", "builder"]
tags: ["workflow", "backup", "safety"]
severity: HIGH
created_at: "2026-07-30T23:10:00Z"
---
