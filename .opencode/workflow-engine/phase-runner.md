---
name: workflow-engine-phase-runner
description: >
  Phase Runner cho Workflow Engine v4 — dispatcher agent|command, retry theo
  phase.retry, parse output YAML theo output contract. Engine khong hieu noi
  dung agent, chi dispatch theo metadata.
agent: general
---

# Phase Runner

Chay mot phase (agent hoac command) va parse output.

## 1. Dispatcher

| Dieu kien | Hanh dong |
|-----------|-----------|
| Phase co `command` | Chay command `.opencode/commands/<command>.md` (bo dau '/') |
| Phase chi co `agent` | Trieu hoi agent `.opencode/agents/<agent>.md` |
| Co ca hai | Uu tien `command` |

Engine KHONG hieu noi dung agent/command — chi doc metadata tu definition
va dispatch. Agent tu thuc hien theo file agent md tuong ung.

## 2. Bang dispatch mau

| Phase id | Command | Agent |
|----------|---------|-------|
| analyze | /team-analyze | analyst |
| plan / design | /team-plan | planner |
| review | /team-review | reviewer |
| build | /team-build | builder |
| ui / ui-audit | /team-ui-audit | ui-beautifier |
| testplan | /team-testplan | test-planner |
| test | /team-test | tester |
| failure_analysis / failure-analysis | /team-analyze-failure | failure-agent |
| learning / learn | /team-learn | learning-agent |
| selfimprove / skill_validation | /team-selfimprove | self-improver |
| guard / guardrail | /team-gitguard | guardian |
| syncdocs / validate | /team-syncdocs | general |
| complete | (tu hoan tat) | general |

## 3. Xu ly

- **Timeout**: 120 giay / lan chay.
- **Retry**: theo `phase.retry` (mac dinh 3). Retry chi khi loi co the retry.
- **Output parse**: output phai la YAML hop le theo output contract.
  - Sai format / thieu key -> WF-ERR-008 (coi nhu phase fail).
- **Same error**: `same_error_count` ghi trong state — khi >= 2 -> recovery.md
  xu ly rollback.

## 4. Output contract

```yaml
phase_runner_output:
  phase_id: string
  status: "PASS" | "FAIL"
  summary: string
  artifacts: [string]
  error:
    code: WF-ERR-008
    message: string
  duration_seconds: int
```

## 5. Checklist

- [ ] Dispatcher dung: command -> chay command; agent -> trieu hoi agent; ca hai -> uu tien command.
- [ ] Bang dispatch mau day du 12 dong (bao gom failure_analysis + learning).
- [ ] Timeout 120s, retry theo phase.retry.
- [ ] Output parse YAML theo contract — loi format -> WF-ERR-008.
- [ ] Engine chi dispatch theo metadata, khong hieu noi dung.
- [ ] KHONG viet `#` truoc WF-ERR.
