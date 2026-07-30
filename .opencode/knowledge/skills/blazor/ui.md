---
migrated_from: .opencode/knowledge/ui-audit-pipeline.md
migrated_at: 2026-07-30
category: skills/blazor
skill_ref: impeccable, gitguard, workspace-cleaner
---

# UI Audit Pipeline v3 — Knowledge Base

## Overview

UI Audit pipeline v3 nâng cấp từ single-agent (ui-beautifier v2) lên multi-skill pipeline
gồm 4 phase, tích hợp 3 skills: impeccable (audit, critique), gitguard (security), workspace-cleaner (cleanup).

## Pipeline Architecture

```
Phase 1: UI Audit Core (ui-beautifier + impeccable audit)
    ↓
Phase 2: UI Critique (impeccable critique)
    ↓
Phase 3: Security Check (gitguard)
    ↓
Phase 4: Cleanup (workspace-cleaner)
```

## Mode Matrix

| Mode | Phases | Use Case |
|------|--------|----------|
| quick | Phase 1 (core only) | Scan nhanh CSS/a11y |
| full | Phase 1 + 2 | Audit + UX critique |
| security | Phase 1 + 3 | Audit + security check |
| cleanup | Phase 1 + 4 | Audit + cleanup |
| critique | Phase 2 only | UX review thuần |
| complete | Phase 1→2→3→4 | Toàn bộ pipeline |

## Phase Configuration

### Phase 1: UI Audit Core
- **Agent:** ui-beautifier v3
- **Skills:** core capabilities + impeccable audit
- **Fallback:** Nếu Node.js không available, chạy core only
- **Output:** scores (5 categories), issues, recommendations, applied_changes, diffs, todos

### Phase 2: UI Critique
- **Skill:** impeccable critique
- **Requirements:** Node.js
- **Fallback:** Skip phase, log warning
- **Output:** critique scores (5 UX categories), UX issues, recommendations

### Phase 3: Security Check
- **Skill:** gitguard
- **Checks:** XSS, secret leak, unsafe patterns, dependency risk
- **Fallback:** Skip phase, log warning
- **Output:** security scores (4 categories), security issues with severity

### Phase 4: Cleanup
- **Skill:** workspace-cleaner
- **Target:** build artifacts, temp CSS, old backups, test results
- **Fallback:** Skip phase, log warning
- **Output:** cleanup status, freed_bytes, items_cleaned

## Backward Compatibility

- Output contract v2 fields (`scores`, `issues`, `recommendations`) vẫn được giữ nguyên
- Field mới: `multi_phase_scores`, `pipeline`, `phase_status`, `phase[X]`
- Mode `quick` hoạt động giống v2 (chỉ Phase 1)
- Orchestrator cũ parse được `status` + `scores.overall` như cũ

## Skill Integration Points

```
team-ui-audit command
    → ui-beautifier agent v3 (core orchestration)
        → impeccable/audit (enhanced checks) — Phase 1
        → impeccable/critique (UX scoring) — Phase 2
        → gitguard (security scan) — Phase 3
        → workspace-cleaner (cleanup) — Phase 4
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Impeccable not available | Check Node.js installation; fallback to core audit |
| GitGuard not loaded | Phase 3 skipped; run `/team-gitguard` separately |
| Workspace cleaner permission denied | Run with admin rights; skip phase |
| Output too large | Summary mode; detailed artifacts saved separately |
| Phase 1 CHANGES_NEEDED | CRITICAL issues → back to Build |
| Phase 2 low scores | UX issues — warning only, no block |

## Lessons Learned from v2 → v3 Upgrade

1. Multi-skill pipeline cần fallback cho mỗi phase — không block workflow nếu 1 skill không available
2. Backward compatibility quan trọng — giữ field cũ, thêm field mới
3. UX critique (Phase 2) và Cleanup (Phase 4) không nên block workflow — chỉ warning
4. Security check (Phase 3) CRITICAL issues cần block — ưu tiên cao nhất
5. Mode system linh hoạt giúp user chọn đúng mức audit cần thiết
