---
name: sprint2-capability-registry
description: Sprint 2 — Capability Registry (non-invasive) plan chi tiết.
agent: general
---

# 03 — Plan · WF-20260802-004

## Chiến lược build
Xây thủ công (write explicit) từ hiện trạng thực tế 18 agents/29 skills/53 commands, KHÔNG dùng autogen.
Validator `capability-validator.ps1` tự kiểm chứng mọi tham chiếu. TỔNG: 13 CREATE + 0 MODIFY.

## Steps

| # | Loại | File | Thao tác | Mức |
|---|------|------|------|------|
| 1 | CREATE | `.opencode/registry/README.md` | Overview, taxonomy, graph, usage | HIGH |
| 2 | CREATE | `.opencode/registry/registry.schema.yaml` | contract v4.0 (capability + agent + skill + command) | HIGH |
| 3 | CREATE | `.opencode/registry/capabilities.yaml` | 6 category, ~40 capabilities + profile | HIGH |
| 4 | CREATE | `.opencode/registry/agent-registry.yaml` | 18 agents metadata | HIGH |
| 5 | CREATE | `.opencode/registry/skill-registry.yaml` | 29 skills mapping thủ công | HIGH |
| 6 | CREATE | `.opencode/registry/command-registry.yaml` | commands trọng yếu (32) supports | MEDIUM |
| 7 | CREATE | `.opencode/registry/resolver.md` | intent -> capability | MEDIUM |
| 8 | CREATE | `.opencode/registry/matcher.md` | capability -> agents/skills/commands | MEDIUM |
| 9 | CREATE | `.opencode/registry/scorer.md` | ranking, formula, example | MEDIUM |
| 10 | CREATE | `.opencode/registry/validator.md` | checklist validation + bảng mã CR-001..007 | MEDIUM |
| 11 | CREATE | `.opencode/commands/team-capabilities.md` | command discovery UI | MEDIUM |
| 12 | CREATE | `.opencode/scripts/capability-validator.ps1` | parser YAML subset + validator | HIGH |
| 13 | CREATE | `.opencode/reports/CAPABILITY_COVERAGE.md` | report coverage (generated) | MEDIUM |
| 14 | VERIFY | chạy capability-validator.ps1 | PASS tất cả checks | HIGH |

## Quy ước giống Sprint 1
- UTF-8 no-BOM, spaces 2-indent không tab, frontmatter (name/description/agent) trong mỗi .md
- KHÔNG `#` trước WF-ID/WF-ERR/CR-xx
- levels: debug/info/warning/error

## Error codes (capability-validator.ps1)
- CR-001 duplicate capability id
- CR-002 agent/skill/command ref capability không tồn tại
- CR-003 orphan capability (không agent xử lý) — warning
- CR-004 agent không có capability (empty) — warning
- CR-005 skill/command supports empty
- CR-006 duplicate agent/skill/command id
- CR-007 agent dependency vòng lặp (nếu dùng)

## Tests
- capability-validator.ps1 chạy clean: PASS 0 error, 0 critical, report no-BOM
- Basline scan chạy /team-capabilities output đúng 6 category
- CAPABILITY_COVERAGE tính đúng agent/skill/command coverage

## Rollback
- DELETE registry/, command team-capabilities.md, capability-validator.ps1, CAPABILITY_COVERAGE.md
- repo reset nhanh (không sửa file có before)