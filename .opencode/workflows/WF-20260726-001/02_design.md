---
step: 2
step_name: design
timestamp: 2026-07-26T00:00:00Z
workflow_id: WF-20260726-001
---

## THIẾT KẾ — NÂNG CẤP HỆ THỐNG AGENT THEO 7 HƯỚNG

### Architecture tổng thể

```
                      ┌─────────────────────────────────────┐
                      │         Base Agent Schema            │
                      │  status / summary / issues /         │
                      │  next_action / artifacts              │
                      └────────────┬────────────────────────┘
                                   │ extends
         ┌─────────────────────────┼─────────────────────────┐
         ▼                         ▼                         ▼
  ┌────────────┐           ┌──────────────┐          ┌──────────────┐
  │ Analyst    │           │  Planner     │          │  Builder     │
  │ Schema     │           │  (Design+    │          │  Schema      │
  │            │           │   Plan)      │          │              │
  └────────────┘           └──────────────┘          └──────────────┘
```

### Components cần tạo/sửa

| Component | File | Hành động |
|-----------|------|-----------|
| Base Agent Schema | SKILL.md (section mới) | THÊM |
| Output Contract section | SKILL.md (sửa 7 agent schemas) | SỬA |
| Error Priority Map | SKILL.md (section mới) | THÊM |
| Diff Mechanism | SKILL.md (tracking variables mới) | SỬA |
| Checkpoint Artifact | SKILL.md (checkpoint section) | SỬA |
| Pre-Build Guardrail | SKILL.md (section mới) | THÊM |
| Design/Plan tách rõ | planner.md | SỬA |
| Final Report Template | SKILL.md (sửa BÁO CÁO KẾT THÚC) | SỬA |

### Data flow

```
1. User request → Analyst (schema: base + analyst fields)
2. Analyst output → Planner Design phase (schema: base + design fields)
3. Planner Design → Planner Plan phase (schema: base + plan fields)
4. Plan → Reviewer (schema: base + review fields)
5. [Pre-Build Guardrail] → Auto-check: test cases? rollback? deps?
6. Build → Builder (schema: base + build fields)
7. [Diff check] → Compare current vs previous build
8. Test → Tester (schema: base + test fields)
9. [Final Report] → 5-section template
```

### Security concerns

- Schema changes có thể break orchestrator parse logic → backward compat mode
- Không lưu secrets trong artifact checkpoint files

### Edge cases

- Agent output schema mới nhưng orchestrator cũ → fallback permissive mode
- Diff mechanism khi không có lịch sử → skip diff
- Guardrail khi plan không có steps → auto-reject
