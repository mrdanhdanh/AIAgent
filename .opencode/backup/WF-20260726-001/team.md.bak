---
description: Cháº¡y toÃ n bá»™ team workflow: analyze â†’ design/plan â†’ review â†’ backup â†’ build â†’ smoke test â†’ testplan â†’ test â†’ self-improve
agent: general
---

## HELP â€” HÆ°á»›ng dáº«n sá»­ dá»¥ng `/team`

**Má»¥c Ä‘Ã­ch:** Cháº¡y toÃ n bá»™ Dev Agent Team workflow tá»± Ä‘á»™ng â€” Analyze â†’ Design â†’ Plan â†’ Review â†’ Backup â†’ Build â†’ Smoke Test â†’ UI Audit â†’ Test Plan â†’ Test â†’ Self-Improve â†’ Complete.

**CÃ¡ch dÃ¹ng:** `/team <yÃªu cáº§u phÃ¡t triá»ƒn báº±ng ngÃ´n ngá»¯ tá»± nhiÃªn>`

**Äáº§u vÃ o:** MÃ´ táº£ yÃªu cáº§u phÃ¡t triá»ƒn (tiáº¿ng Viá»‡t hoáº·c tiáº¿ng Anh), vÃ­ dá»¥: `/team ThÃªm chá»©c nÄƒng reset password`

**Äáº§u ra:** BÃ¡o cÃ¡o cuá»‘i cÃ¹ng gá»“m phÃ¢n tÃ­ch, káº¿ hoáº¡ch, káº¿t quáº£ build, káº¿t quáº£ test, coverage, self-improvement suggestions.

**CÃ¡c lá»‡nh thÃ nh pháº§n (cháº¡y riÃªng láº»):**
- `/team-analyze` â€” PhÃ¢n tÃ­ch yÃªu cáº§u
- `/team-plan` â€” Thiáº¿t káº¿ + Láº­p káº¿ hoáº¡ch
- `/team-review` â€” ÄÃ¡nh giÃ¡ káº¿ hoáº¡ch
- `/team-build` â€” Thá»±c thi code
- `/team-ui-audit` â€” Kiá»ƒm tra UI
- `/team-testplan` â€” Láº­p káº¿ hoáº¡ch test
- `/team-test` â€” Cháº¡y kiá»ƒm thá»­
- `/team-selfimprove` â€” Äá» xuáº¥t cáº£i tiáº¿n
- `/team-gitguard` â€” Review security trÆ°á»›c push
- `/team-gitpush` â€” Push an toÃ n lÃªn git

**Xem thÃªm:** `.opencode/skills/dev-team/SKILL.md`

---

Báº¡n Ä‘ang váº­n hÃ nh **Dev Agent Team** â€” orchestrator Ä‘iá»u phá»‘i 7 agent chuyÃªn biá»‡t theo 12 bÆ°á»›c.

Äá»c tÃ i liá»‡u Ä‘áº§y Ä‘á»§ táº¡i: `.opencode/skills/dev-team/SKILL.md`
CÃ¡c lá»‡nh thÃ nh pháº§n: `/team-analyze`, `/team-plan`, `/team-review`, `/team-build`, `/team-ui-audit`, `/team-testplan`, `/team-test`

YÃªu cáº§u: $ARGUMENTS

---

## WORKFLOW ID

Táº¡o workflow ID ngay khi báº¯t Ä‘áº§u: `WF-YYYYMMDD-NNN`.
LÆ°u vÃ o biáº¿n `workflow.id` vÃ  dÃ¹ng cho má»i artifact, backup, rollback, logging.

---

## MÃ” HÃŒNH ORCHESTRATOR

Báº¡n lÃ  **General Agent** Ä‘Ã³ng vai trÃ² orchestrator â€” chá»‰ Ä‘áº£m nhiá»‡m orchestration vÃ  state management.

TrÃ¡ch nhiá»‡m:
1. **Triá»‡u há»“i** Ä‘Ãºng agent theo Ä‘Ãºng bÆ°á»›c
2. **Truyá»n context** â€” output bÆ°á»›c trÆ°á»›c lÃ  input bÆ°á»›c sau
3. **Xá»­ lÃ½ vÃ²ng láº·p** â€” review loop, test-fix loop (tá»‘i Ä‘a 3 láº§n, kiá»ƒm tra same_error_count)
4. **Theo dÃµi tráº¡ng thÃ¡i** â€” biáº¿n step, retry_count, status, error_history
5. **Quyáº¿t Ä‘á»‹nh** â€” tiáº¿p tá»¥c, retry, rollback, dá»«ng, hoáº·c há»i ngÆ°á»i dÃ¹ng

---

## MÃY TRáº NG THÃI (STATE MACHINE)

```
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚  START  â”‚
                    â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
                         â–¼
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚ANALYZE  â”‚ â—„â”€â”€â”€â”€ NEED_MORE_INFO â†’ há»i user
                    â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
                         â–¼
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚ DESIGN  â”‚ â†â”€â”€ Planner má»Ÿ rá»™ng
                    â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
                         â–¼
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚  PLAN   â”‚
                    â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
                         â–¼
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚ REVIEW  â”‚
                    â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
                    â”Œâ”€â”€â”€â”€â”´â”€â”€â”€â”€â”
                    â”‚         â”‚
                    â–¼         â–¼
             â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
             â”‚APPROVED â”‚  â”‚CHANGES_REQ   â”‚
             â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”˜
                  â”‚              â”‚ (retry < 3)
                  â–¼              â–¼
             â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
             â”‚ BACKUP  â”‚   â”‚  PLAN   â”‚
             â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                  â”‚
                  â–¼
             â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
             â”‚  BUILD  â”‚ â—„â”€â”€â”€â”€ náº¿u SMOKE/TEST FAIL
             â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
                  â–¼
             â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
             â”‚SMOKE TEST â”‚ â†â”€â”€ behavioral validation
             â””â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜
                   â–¼
             â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
             â”‚ TESTPLANâ”‚
             â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
                  â–¼
             â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
             â”‚  TEST   â”‚
             â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜
              â”Œâ”€â”€â”€â”´â”€â”€â”€â”
              â”‚       â”‚
              â–¼       â–¼
          â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â” â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”
          â”‚ PASS   â”‚ â”‚ FAIL   â”‚ â”€â”€â”€â–º quay láº¡i BUILD
          â””â”€â”€â”€â”¬â”€â”€â”€â”€â”˜ â””â”€â”€â”€â”€â”€â”€â”€â”€â”˜
              â–¼
         â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
         â”‚SELF_IMPROVE  â”‚ â†â”€â”€ approval gate
         â””â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”˜
                â–¼
         â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
         â”‚ WAITING_APPROVALâ”‚
         â””â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”˜
           â”Œâ”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”
           â”‚           â”‚
           â–¼           â–¼
      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
      â”‚APPROVED â”‚ â”‚ REJECTED â”‚
      â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜ â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜
           â”‚            â”‚
           â–¼            â–¼
      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
      â”‚COMPLETE â”‚ â”‚COMPLETE â”‚ (skip KB)
      â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

---

## BIáº¾N THEO DÃ•I (TRACKING VARIABLES)

```yaml
workflow:
  id: "WF-{YYYYMMDD}-{NNN}"
  created_at: "2026-07-24T00:00:00Z"
  project: "JapaneseLearner"
  branch: "main"
  schema_version: "2.0"
  step: 1-11
  step_name: analyze|design|plan|review|backup|build|smoke_test|testplan|test|self_improve|complete
  status: running|blocked|completed|failed|waiting_user|cancelled|reviewing|building|testing|self_improving|waiting_approval
  retry:
    review_count: 0-3
    test_count: 0-3
    max_review: 3
    max_test: 3
    self_improve_count: 0-1
  user_intervention: false
  backup_done: false
  error_history:
    review: []
    test_failures: []
    build_failures: []
  same_error_count: 0
  coverage:
    thresholds:
      unit: 80
      integration: 60
      e2e: 50
      overall: 70
    mandatory: true
  current_data:
    analysis: null
    design: null
    plan: null
    review_result: null
    build_result: null
    smoke_test_result: null
    test_plan: null
    test_result: null
    self_improve_result: null
    final_report: null
```

---

## QUY TRÃŒNH CHI TIáº¾T

### BÆ°á»›c 1: Analyze
**Agent:** `analyst` (qua `/team-analyze`)

**Prompt** (xem `team-analyze.md`)

**Sau output:**
- Parse YAML output theo schema Analyst
- `status: NEED_MORE_INFO` â†’ há»i user, set `user_intervention: true`
- `status: READY` â†’ lÆ°u `current_data.analysis = output`, tÄƒng `step = 2`

---

### BÆ°á»›c 2: Design
**Agent:** `planner` (má»Ÿ rá»™ng â€” qua `/team-plan`)

**Prompt:**
```
Báº¡n lÃ  Planner Agent (má»Ÿ rá»™ng). Dá»±a trÃªn bÃ¡o cÃ¡o phÃ¢n tÃ­ch, thiáº¿t káº¿ giáº£i phÃ¡p chi tiáº¿t.
BÃ¡o cÃ¡o: {current_data.analysis}

YÃªu cáº§u Design:
1. Architecture: MÃ´ táº£ kiáº¿n trÃºc tá»•ng thá»ƒ
2. Components: Liá»‡t kÃª component cáº§n táº¡o/sá»­a
3. Data flow: Luá»“ng dá»¯ liá»‡u giá»¯a cÃ¡c component
4. Security concerns: CÃ¡c rá»§i ro báº£o máº­t
5. Edge cases: CÃ¡c trÆ°á»ng há»£p Ä‘áº·c biá»‡t

Output: Contract YAML theo schema Planner (bao gá»“m design).
```

**Sau output:** LÆ°u `current_data.design = output`, tÄƒng `step = 3`

---

### BÆ°á»›c 3: Plan
**Agent:** `planner` (tiáº¿p â€” cÃ¹ng agent Design, qua `/team-plan`)

**Prompt:**
```
Báº¡n lÃ  Planner Agent. Dá»±a trÃªn thiáº¿t káº¿, láº­p káº¿ hoáº¡ch thá»±c thi chi tiáº¿t tá»«ng bÆ°á»›c.
Thiáº¿t káº¿: {current_data.design}

YÃªu cáº§u:
1. Má»—i bÆ°á»›c cÃ³: MÃ´ táº£, File, Logic, Kiá»ƒm tra, Chunk (1-4)
2. Thá»© tá»±: config â†’ logic â†’ test
3. ThÃªm rollback_strategy
4. Káº¿t thÃºc báº±ng validate tá»•ng thá»ƒ

Output: Contract YAML theo schema Planner (cáº­p nháº­t steps, rollback_strategy, validate).
```

**Sau output:** LÆ°u `current_data.plan = output`, tÄƒng `step = 4`

**Kiá»ƒm tra:** Káº¿ hoáº¡ch pháº£i cÃ³ Ã­t nháº¥t 1 bÆ°á»›c â€” náº¿u khÃ´ng â†’ yÃªu cáº§u lÃ m láº¡i.

---

### BÆ°á»›c 4: Review
**Agent:** `reviewer` (qua `/team-review`)

**Prompt** (xem `team-review.md`)

**Sau output:**
- **APPROVED** â†’ LÆ°u `current_data.review_result = output`, tÄƒng `step = 5`
- **CHANGES_REQUESTED** â†’
  - `retry.review_count++`
  - Náº¿u `retry.review_count < retry.max_review` vÃ  `same_error_count < 2` â†’ Quay láº¡i BÆ°á»›c 3 (Plan)
  - Náº¿u `retry.review_count >= retry.max_review` hoáº·c `same_error_count >= 2` â†’ Dá»«ng, set `status: blocked`
- **REJECTED** â†’ Dá»«ng, set `status: failed`

---

### BÆ°á»›c 5: Backup
**HÃ nh Ä‘á»™ng:** Orchestrator gá»i **Backup Utility** script (khÃ´ng tá»± backup thá»§ cÃ´ng)

**Äiá»u kiá»‡n:** Cháº¡y náº¿u plan cÃ³ `requires_backup: true` hoáº·c cÃ³ file cÅ© cáº§n sá»­a

**CÃ¡ch thá»±c hiá»‡n:**
```powershell
# Gá»i Backup Utility (luÃ´n dÃ¹ng script, KHÃ”NG tá»± copy thá»§ cÃ´ng)
$backupScript = ".opencode\scripts\backup-utility.ps1"
$files = @("path/to/file1.cs", "path/to/file2.razor")  # tá»« plan
& $backupScript -files $files -workflowId "$($workflow.id)"
```

Backup Utility sáº½:
1. Copy tá»«ng file vÃ o `.opencode/backup/<WF-ID>/` (giá»¯ nguyÃªn cáº¥u trÃºc thÆ° má»¥c)
2. TÃ­nh SHA256 hash (12 kÃ½ tá»± Ä‘áº§u) cho má»—i file
3. Ghi manifest `05_backup_manifest.json`
4. Tráº£ vá» bÃ¡o cÃ¡o JSON

**Set:** `backup_done = true`

**Náº¿u chá»‰ táº¡o file má»›i:** Log "ðŸ“ Káº¿ hoáº¡ch chá»‰ táº¡o file má»›i, khÃ´ng cáº§n backup"

---

### Rollback (khi catastrophic failure)
Khi cáº§n rollback, gá»i **Rollback Utility**:
```powershell
$rollbackScript = ".opencode\scripts\rollback-utility.ps1"
& $rollbackScript -workflowId "$($workflow.id)" [-force]
```

---

### BÆ°á»›c 6: Build
**Agent:** `builder` (qua `/team-build`)

**Prompt** (xem `team-build.md`)

**Sau output:**
- **PASS** â†’ tÄƒng `step = 7`
- **FAIL + failure_type == MINOR** â†’ YÃªu cáº§u builder sá»­a
- **FAIL + failure_type == CRITICAL** â†’ Kiá»ƒm tra same_error_count:
  - Náº¿u â‰¥ 2 â†’ Catastrophic failure â†’ ROLLBACK
  - Náº¿u < 2 â†’ há»i user

---

### BÆ°á»›c 7: Smoke Test
**HÃ nh Ä‘á»™ng:** Orchestrator cháº¡y validation (khÃ´ng gá»i agent)

**CÃ¡c bÆ°á»›c:**
1. Parse YAML frontmatter cá»§a SKILL.md â†’ kiá»ƒm tra name, description, schema_version
2. Kiá»ƒm tra táº¥t cáº£ internal links (`#...`) cÃ³ section tÆ°Æ¡ng á»©ng
3. Kiá»ƒm tra code block balance (sá»‘ ``` má»Ÿ = Ä‘Ã³ng)
4. Parse YAML samples trong Output Contract section
5. Simulate 1 workflow cycle: START â†’ ANALYZE â†’ DESIGN â†’ PLAN â†’ REVIEW â†’ ... â†’ COMPLETE

**Sau output:**
- **PASS** â†’ tÄƒng `step = 8`
- **FAIL** â†’ `retry.test_count++`, quay láº¡i BÆ°á»›c 6 náº¿u retry < 3

---

### BÆ°á»›c 8: Test Plan
**Agent:** `test-planner` (qua `/team-testplan`)

**Prompt** (xem `team-testplan.md`)

**Sau output:** LÆ°u `current_data.test_plan = output`, tÄƒng `step = 9`

---

### BÆ°á»›c 9: Test
**Agent:** `tester` (qua `/team-test`)

**Prompt** (xem `team-test.md`)

**Sau output:**
- **APPROVED** (all PASS + coverage >= thresholds) â†’ BÃO CÃO Káº¾T THÃšC
- **NEEDS_FIX** â†’
  - `retry.test_count++`
  - Náº¿u `retry.test_count < retry.max_test` vÃ  `same_error_count < 2` â†’ Quay láº¡i BÆ°á»›c 6
  - Náº¿u `retry.test_count >= retry.max_test` hoáº·c `same_error_count >= 2` â†’ Dá»«ng, set `status: failed`

---

### BÆ°á»›c 10: Self-Improvement
**Agent:** `self-improver`

**Äiá»u kiá»‡n:** Chá»‰ cháº¡y náº¿u workflow PASS

**Prompt** (xem `team-selfimprove.md`)

**Approval Gate:**
- Self-Improver táº¡o suggestions vÃ o artifact
- Set status = `waiting_approval`
- Hiá»ƒn thá»‹ suggestions cho user
- User pháº£n há»“i: APPROVE | REJECT | MODIFY
- Auto-approve náº¿u `impact == LOW && requires_approval == false`

Set `step = 11`

---

### BÆ°á»›c 11: Complete

Káº¿t thÃºc workflow, lÆ°u workflow.json snapshot.

---

## SÆ  Äá»’ QUYáº¾T Äá»ŠNH (DECISION TREE)

```yaml
analyze:
  output.status == NEED_MORE_INFO: â†’ hoi_user
  output.status == READY: â†’ design

design:
  output hop le (co design): â†’ plan
  output rong/thieu: â†’ yeu_cau_lam_lai

plan:
  output hop le (co steps): â†’ review
  output thieu steps: â†’ yeu_cau_lam_lai

review:
  decision == APPROVED: â†’ backup
  decision == CHANGES_REQUESTED (retry < 3 && same_error < 2): â†’ plan
  decision == CHANGES_REQUESTED (retry >= 3 OR same_error >= 2): â†’ hoi_user
  decision == REJECTED: â†’ hoi_user

backup:
  can sua file cu: â†’ backup â†’ build
  chi tao moi: â†’ build

build:
  all PASS: â†’ smoke_test
  FAIL + MINOR (same_error < 2): â†’ sua, build lai
  FAIL + CRITICAL (same_error < 2): â†’ hoi_user
  FAIL + same_error >= 2: â†’ catastrophic â†’ rollback

smoke_test:
  PASS: â†’ testplan
  FAIL (retry < 3): â†’ build
  FAIL (retry >= 3): â†’ hoi_user

test:
  APPROVED (PASS + coverage dat): â†’ report â†’ self_improve
  NEEDS_FIX (retry < 3 && same_error < 2): â†’ build
  NEEDS_FIX (retry >= 3 OR same_error >= 2): â†’ hoi_user

self_improve:
  PASS: â†’ self_improve â†’ waiting_approval
  FAIL: â†’ complete (skip)

waiting_approval:
  user APPROVE: â†’ ghi knowledge â†’ complete
  user REJECT: â†’ skip â†’ complete
  user MODIFY: â†’ ghi knowledge (da sua) â†’ complete

complete:
  â†’ Luu workflow.json â†’ Ket thuc
```

---

## TÃCH Há»¢P Vá»šI COMMANDS RIÃŠNG Láºº

| Buoc | Command | Agent | File command |
|------|---------|-------|-------------|
| Buoc | Command | Agent | File command |
|------|---------|-------|-------------|
| 1 | /team-analyze | analyst | team-analyze.md |
| 2-3 | /team-plan | planner (mo rong) | team-plan.md |
| 4 | /team-review | reviewer | team-review.md |
| 4.5 | /team-gitguard | guardian | team-gitguard.md |
| 6 | /team-build | builder | team-build.md |
| 8 | /team-ui-audit | ui-beautifier | team-ui-audit.md |
| 9 | /team-testplan | test-planner | team-testplan.md |
| 10 | /team-test | tester | team-test.md |
| 11 | (goi tu team.md) | self-improver | .opencode/agents/self-improver.md |
| 12 | /team-gitpush | pusher | team-gitpush.md |
KhÃ´ng cÃ³ command `/team-design` riÃªng â€” Design lÃ  pháº§n má»Ÿ rá»™ng cá»§a Plan.

### GitGuard (Pre-Push Review)

Command `/team-gitguard` dÃ¹ng **Guardian Agent** Ä‘á»ƒ review source code trÆ°á»›c khi push lÃªn git. Kiá»ƒm tra: secret leak, convention violation, security vulnerability, code quality, build/test. Output: PASS | BLOCKED | WARNING.

Xem thÃªm: `.opencode/skills/gitguard/SKILL.md`

### GitPush (Safe Push)

Command `/team-gitpush` dÃ¹ng **Pusher Agent** Ä‘á»ƒ thá»±c hiá»‡n git push an toÃ n vá»›i safety checks vÃ  confirmation gate. Quy trÃ¬nh:

1. **Git status analysis** â€” branch, remote, ahead/behind, staged/unstaged
2. **Safety checks** â€” secret scan, convention, security, code quality (clone GitGuard)
3. **Build validation** â€” `dotnet build`
4. **Test validation** â€” `dotnet test`
5. **Diff summary** â€” file changed, insertions, deletions
6. **Confirmation gate** â€” báº£ng tá»•ng káº¿t, user xÃ¡c nháº­n Y/N
7. **Push execution** â€” `git push origin <branch>`
8. **Post-push verification** â€” xÃ¡c nháº­n remote synced

Flags: `--skip-checks`, `--force`, `--branch <name>`, `--message "<msg>"` (fast path commit+push).

Xem thÃªm: `.opencode/skills/gitpush/SKILL.md`

---

## Xá»¬ LÃ NGOáº I Lá»†

### Timeout
- Má»—i láº§n gá»i agent: tá»‘i Ä‘a 120 giÃ¢y

### User can thiá»‡p
- User gá»­i thÃ´ng tin má»›i: cáº­p nháº­t context, tiáº¿p tá»¥c tá»« bÆ°á»›c hiá»‡n táº¡i
- User yÃªu cáº§u dá»«ng: set `status: cancelled`, bÃ¡o cÃ¡o táº¡m thá»i

### Lá»—i gá»i agent
- KhÃ´ng available: thá»­ láº¡i 1 láº§n sau 10s, váº«n lá»—i â†’ há»i user
- Output sai format: yÃªu cáº§u lÃ m láº¡i

### Same error detection
- `same_error_count >= 2` â†’ STOP, rollback

### Rollback tá»± Ä‘á»™ng
```powershell
$backup_root = ".opencode\backup\$workflow_id"
# Äá»c manifest vÃ  restore tá»«ng file
```

---

## GHI CHÃš

- Táº¡o workflow ID ngay khi báº¯t Ä‘áº§u
- LuÃ´n validate frontmatter YAML sau má»—i láº§n sá»­a file .md
- Design phase do Planner Ä‘áº£m nhiá»‡m vá»›i extended prompt
- Self-Improvement chá»‰ táº¡o suggestions, khÃ´ng ghi trá»±c tiáº¿p knowledge base
- Approval gate báº¯t buá»™c cho suggestion cÃ³ impact MEDIUM/HIGH
- Backup/Rollback do Backup Utility thá»±c hiá»‡n, Orchestrator chá»‰ gá»i lá»‡nh
- Khi workflow hoÃ n táº¥t, output bÃ¡o cÃ¡o Ä‘áº§y Ä‘á»§ vÃ  rÃµ rÃ ng


