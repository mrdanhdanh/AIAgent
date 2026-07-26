# He Thong .opencode - So Do Tong The

> **Tu dong tao luc:** 2026-07-26 09:49:55
> **Workflow ID:** WF-20260726-SYNC
> **Cap nhat:** Toan bo agents, commands, skills, scripts, knowledge

---

- [Muc luc](#Muc-luc
- [Cau truc thu muc](#Cau-truc-thu-muc
- [Agents](#Agents
- [Commands](#Commands
- [Skills](#Skills
- [Scripts](#Scripts
- [Knowledge Base](#Knowledge-Base
- [Ma tran Cross-Reference](#Ma-tran-Cross-Reference
- [Workflow Overview](#Workflow-Overview
- [Phat hien van de](#Phat-hien-van-de

---

## Cau truc thu muc

```
.opencode/
|-- agents/           # 2 agent definitions
|-- commands/         # 0 command templates
|-- skills/           # 0 skill packages
|-- scripts/          # 4 utility scripts
|-- knowledge/        # Knowledge base
|-- backup/           # Backup artifacts tu workflow
|-- workflow/         # Workflow state artifacts
|-- workflows/        # Workflow JSON snapshots
```

---

## Agents

| Agent | Description | Model | Permissions | Commands |
|-------|-------------|-------|-------------|----------|
| guardian | ChuyÃªn gia review source code trÆ°á»›c khi push lÃªn git â€” phÃ¡t hiá»‡n secret, lá»—i convention, lá»— há»•ng báº£o máº­t, vi pháº¡m quy táº¯c dá»± Ã¡n | default |  | --- |
| pusher | ChuyÃªn gia thá»±c hiá»‡n git push an toÃ n â€” auto-commit tá»« diff, safety checks, build, test, confirmation gate, push execution, post-push verify | default |  | --- |

---

## Commands

| Command | Description | Agent | Deprecated |
|---------|-------------|-------|------------|

---

## Skills

| Skill | Name | Description | Schema Version |
|-------|------|-------------|----------------|

---

## Scripts

| Script | Summary | Size |
|--------|---------|------|
| backup-utility | Utility script | 1 KB |
| gitpush-utility | GitPush Utility — thực hiện git push an toàn với auto-commit, safety checks, confirmation gate. | 18 KB |
| rollback-utility | Utility script | 2 KB |
| sync-system-docs | Utility script | 24 KB |

---

## Knowledge Base

| File | Size |
|------|------|
| knowledge/blazor-ref-timing.md | 1 KB |
| knowledge/deployment\blazor-wasm-github-pages.md | 2 KB |
| knowledge/lessons.md | 11 KB |
| knowledge/patterns\common.md | 5 KB |
| knowledge/skills-learned.md | 9 KB |
| knowledge/workflow\validate-github-actions-yaml.md | 1 KB |

---

## Ma tran Cross-Reference

### Command -> Agent Mapping

| Command | Agent | Agent File |
|---------|-------|------------|

### Agent -> Commands

| Agent | Commands |
|-------|----------|
| guardian | Orphaned |
| pusher | Orphaned |

### Skill -> Commands

| Skill | Commands Referencing |
|-------|---------------------|

---

## Workflow Overview

```
                    +---------+
                    |  START  |
                    +----+----+
                         |
                         v
                    +---------+
                    |ANALYZE  |
                    |team-    |
                    |analyze  |
                    +----+----+
                         |
                         v
                    +---------+
                    | DESIGN  |
                    |team-plan|
                    +----+----+
                         |
                         v
                    +---------+
                    |  PLAN   |
                    |team-plan|
                    +----+----+
                         |
                         v
                    +---------+
                    | REVIEW  |
                    |team-    |
                    |review   |
                    +----+----+
                    +----+----+
                    |         |
                    v         v
             +---------+  +--------------+
             |APPROVED |  |CHANGES_REQ   |
             +----+----+  +------+-------+
                  |              |
                  v              v
             +---------+   +---------+
             | BACKUP  |   |  PLAN   |
             +----+----+   +---------+
                  |
                  v
             +---------+
             |  BUILD  |
             |team-    |
             |build    |
             +----+----+
                  |
                  v
             +-----------+
             |SMOKE TEST |
             +-----+-----+
                   |
                   v
             +-----------+
             | UI AUDIT  |
             |team-ui-   |
             |audit      |
             +-----+-----+
                   |
                   v
             +---------+
             | TESTPLAN|
             |team-    |
             |testplan |
             +----+----+
                   |
                   v
             +---------+
             |  TEST   |
             |team-test|
             +----+----+
              +---+---+
              |       |
              v       v
          +--------+ +--------+
          | PASS   | | FAIL   |
          +---+----+ +--------+
              |
         +--------------+
         |SELF_IMPROVE  |
         |team-         |
         |selfimprove   |
         +------+-------+
                |
         +----------------+
         | WAITING_APPROVAL|
         +-------+--------+
                 |
          +-------+-------+
          |               |
          v               v
     +---------+     +----------+
     |APPROVED |     | REJECTED |
     +----+----+     +----+-----+
          |               |
          v               v
     +---------+     +---------+
     |COMPLETE |     |COMPLETE |
     +---------+     +---------+
```

### Buoc theo Command

| Buoc | Command | Agent | File |
|------|---------|-------|------|
| 1 | /team-analyze | analyst | commands/team-analyze.md |
| 2-3 | /team-plan | planner (mo rong) | commands/team-plan.md |
| 4 | /team-review | reviewer | commands/team-review.md |
| 5 | Backup (utility) | --- | scripts/backup-utility.ps1 |
| 6 | /team-build | builder | commands/team-build.md |
| 7 | Smoke Test (orchestrator) | --- | SKILL.md |
| 8 | /team-ui-audit | ui-beautifier | commands/team-ui-audit.md |
| 9 | /team-testplan | test-planner | commands/team-testplan.md |
| 10 | /team-test | tester | commands/team-test.md |
| 11 | /team-selfimprove | self-improver | commands/team-selfimprove.md |
| 12 | /team-gitpush | pusher | commands/team-gitpush.md |

### Pre/Post Steps

| Step | Command | Agent | File |
|------|---------|-------|------|
| Pre-push | /team-gitguard | guardian | commands/team-gitguard.md |
| Cleanup | /team-cleanup | cleaner | skills/workspace-cleaner/SKILL.md |
| Explore | /team-explore (DEPRECATED) | codebase-explorer | commands/team-explore.md |
| Backup | /backup | backup-agent | commands/backup.md |

---

## Phat hien van de

| # | Loai | Chi tiet |
|---|------|----------|
| 1 | ORPHAN_AGENT | agent=guardian |
| 2 | ORPHAN_AGENT | agent=pusher |

---

> **Tong so:** 2 agents . 0 commands . 0 skills . 4 scripts . 6 knowledge files
> **Sinh boi:** sync-system-docs.ps1
