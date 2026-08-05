---
name: workflow-engine-executor
description: >
  Executor cho Workflow Engine v4 — vong lap 6 buoc chay tung phase theo thu tu
  topological, validate output, luu artifact va update state.
agent: general
---

# Executor

Chay tung phase theo thu tu topological sort (loader.md). Moi phase qua 6 buoc.

## 1. Vong lap 6 buoc (moi phase)

1. **Validate phase** — kiem tra phase node theo validator.md.
   - Loi -> WF-ERR-00x, dung phase.
2. **Resolve dependencies** — tat ca depends_on phai `completed`.
   - Con phase phu thuoc chua completed + `continue_on_error=false`
     -> dung, bao missing dependency.
3. **Run qua phase-runner** — dispatch `agent` | `command` (phase-runner.md).
   - Timeout 120s, retry theo `phase.retry`.
4. **Validate output** theo output contract (status/summary/artifacts).
   - Khong khop -> WF-ERR-008, coi nhu phase fail.
5. **Save artifact** vao `.opencode/workflow/<WF-ID>/artifacts/`.
   - Ten file: `<NN>_<phase>.md` (NN = so thu tu 2 chu so).
6. **Update state** — phase status + workflow status (state-machine.md).

Optional phase fail -> `skipped` (khong block).
`continue_on_error=true` -> log warning + tiep tuc phase ke.

## 2. Pseudocode loop

```text
phases = topological_sort(definition)     # loader.md
for node in phases:
    # 1. validate phase
    err = validate_phase(node)            # validator.md
    if err: report WF-ERR-00x; break

    # 2. resolve dependencies
    deps = node.depends_on
    if any(phase[d].status != "completed" for d in deps):
        if node.continue_on_error: log_warning("missing dep"); continue
        report "MISSING_DEP: deps=<deps>"; break

    # 3. run via phase-runner
    retry_count = 0
    while retry_count <= node.retry:
        output = phase_runner.run(node)   # phase-runner.md
        if output.valid: break
        retry_count += 1
    if not output.valid:
        if node.optional: set_phase_status(node, "skipped"); continue
        if node.continue_on_error: log_warning("phase failed, continue"); set_phase_status(node, "failed"); continue
        set_phase_status(node, "failed"); break

    # 4. validate output contract
    if not validate_output_contract(node, output):
        report WF-ERR-008; set_phase_status(node, "failed"); break

    # 5. save artifact
    save_artifact(workflow_id, order(node), node.id, output)

    # 6. update state
    set_phase_status(node, "completed")
    update_workflow_state(node)
```

## 3. Artifact naming

- `<NN>_<phase>.md` — NN = so thu tu 2 chu so theo execution_order.
- Vi du docs workflow: `01_analyze.md`, `02_write.md`, `03_review.md`,
  `04_validate.md`, `05_complete.md`.
- Artifact JSON/khac (vd backup manifest) giu ten goc.

## 4. Output contract (moi phase)

```yaml
phase_output:
  status: "PASS" | "FAIL"
  summary: string
  artifacts:
    - "01_analyze.md"
  error: string | null
```

## 5. Checklist

- [ ] 6 buoc theo dung thu tu (validate -> deps -> run -> validate output -> save -> update).
- [ ] Deps chua completed + continue_on_error=false -> dung bao missing dep.
- [ ] Optional phase fail -> skipped (khong block).
- [ ] continue_on_error=true -> warning + tiep tuc.
- [ ] Artifact naming `<NN>_<phase>.md` dung.
- [ ] Output khong khop contract -> WF-ERR-008.
- [ ] KHONG viet `#` truoc WF-ID.
