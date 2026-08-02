---
name: context-provider-workflow
description: Workflow Provider — cung cấp Workflow Context từ runtime state.
agent: general
---

# Workflow Provider

## 1. Vai trò

Cung cấp trạng thái workflow hiện tại để agent hiểu context vị trí.

## 2. Nguồn

- `state.json` / `workflow.json` trong `.opencode/workflow/WF-*/` (do Workflow Runtime tạo).
- Stage metadata của workflow definition.

## 3. Interface

- `discover()`: tìm workflow state file hiện tại.
- `resolve()`: đọc name/phase/state/retry/variables.
- `size()`: size small block.
- `validate()`: `state` hợp lệ enum.

## 4. Output

```
workflow:
  name: feature
  phase: implementation
  state: running
  retry: 0
  variables: { task_id: "...", agent: builder }
```

## 5. Lưu ý

- Workflow context thay đổi theo từng phase → cache kém (thay difference).
- Diff theo `phase`/`state` để giảm token giữa các iteration (cache/diff.md).

## 6. Tương tác

- Phase 5 (Artifact Store) thay workflow state bằng artifact reference.
- Resolver đọc trong profile.