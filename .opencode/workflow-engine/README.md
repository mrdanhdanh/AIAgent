---
name: workflow-engine
description: >
  Workflow Engine v4 — thay the body 13 buoc trong team.md bang pipeline
  module hoa: loader, validator, executor, phase-runner, state-machine, recovery.
agent: general
---

# Workflow Engine v4

## 1. Muc dich

`/team` truoc day chua body orchestrator 13 buoc ngay trong `team.md` (879 dong).
Workflow Engine v4 tach phan do ra thanh 8 module doc lap duoi `.opencode/workflow-engine/`,
giu `team.md` chi la thin launcher (~100 dong). Cung cap 5 workflow definitions
(default, bugfix, feature, ui, docs) duoc validate boi `workflow-validator.ps1`.

## 2. Kien truc pipeline

```
team.md (thin launcher)
  -> engine.md (controller, decision tree)
    -> loader.md (doc + parse definition YAML)
    -> validator.md (validate schema + agent/command ton tai)
    -> executor.md (vong lap chay tung phase theo thu tu topological)
      -> phase-runner.md (dispatcher agent|command)
        -> state-machine.md (trang thai phase + backward read WF-2026*)
    -> recovery.md (retry / rollback / abort khi catastrophic)
```

Engine KHONG hieu noi dung agent — chi dispatch theo metadata trong definition.

## 3. Phan vai `.opencode/workflow/` (fix #08)

| Thu muc | Vai tro | Duoc sua? |
|---------|---------|-----------|
| `.opencode/workflow/schemas/` | Contract tinh: `workflow.schema.yaml` | KHONG sua tay |
| `.opencode/workflow/definitions/` | Khai bao workflow tinh: 5 file `*.yaml` | Chi sua qua PR / review |
| `.opencode/workflow/WF-*/` | Runtime context do engine tao: `workflow.json`, `state.json`, `context.json`, `artifacts/`, `logs/` | KHONG sua tay, co the xoa khi retry |

`WF_CONTEXT_ROOT` override root cua `WF-*/` (cho smoke-test chay trong `$env:TEMP`).

## 4. Cach dung

```
/team <yeu cau> --workflow <default|bugfix|feature|ui|docs>
```

- Mac dinh: `default` (13 phases day du).
- Khong truyen `--workflow` -> engine dung `default_workflow: default`.
- `--workflow <invalid>` -> WF-ERR-009 + danh sach 5 definitions.

## 5. Definitions

| File | id | Phases |
|------|----|--------|
| `definitions/default.workflow.yaml` | default | 13 (analyze -> complete) |
| `definitions/bugfix.workflow.yaml` | bugfix | 6 (analyze -> root-cause -> plan-fix -> build -> test -> complete) |
| `definitions/feature.workflow.yaml` | feature | 8 (analyze -> design -> plan -> review -> build -> test -> ui_audit -> complete) |
| `definitions/ui.workflow.yaml` | ui | 6 (analyze-ui -> design -> ui-audit -> build-ui -> test -> complete) |
| `definitions/docs.workflow.yaml` | docs | 5 (analyze -> write -> review -> validate -> complete) |

Migrate team.md cu -> engine moi: xem `.opencode/workflow/MIGRATION_GUIDE.md`.

## 6. Quy uoc chung

- YAML/Markdown dung spaces (2-space indent), KHONG tab.
- UTF-8 KHONG BOM (`[System.IO.File]::WriteAllText` + `UTF8Encoding($false)`).
- KHONG viet ky tu `#` dung truoc `WF-2026-*`, `WF-ERR-*`, `BUG-*`.
- Moi file `.md` co frontmatter (name, description, agent) + Procedure + Output contract YAML + Checklist.
- Code block balance: so ``` mo = so ``` dong.

## 7. Tai lieu module

- [engine.md](engine.md) — controller, pipeline 7 buoc, decision tree, timeout 120s.
- [loader.md](loader.md) — doc + parse definition, resolve workflow id.
- [validator.md](validator.md) — checklist validate + bang ma loi WF-ERR-001..009.
- [executor.md](executor.md) — vong lap 6 buoc, artifact `<NN>_<phase>.md`.
- [phase-runner.md](phase-runner.md) — dispatcher agent|command, retry, parse output.
- [state-machine.md](state-machine.md) — states, transitions, backward read WF-2026*.
- [recovery.md](recovery.md) — retry/skip/abort/rollback, restore nhanh team.md.
- [MIGRATION_GUIDE.md](../workflow/MIGRATION_GUIDE.md) — migrate + restore nhanh.

Xem them: `.opencode/skills/dev-team/SKILL.md` (workflow 13 buoc cu, giu de tham khao).
